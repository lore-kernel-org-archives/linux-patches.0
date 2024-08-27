Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68521E520;
	Tue, 27 Aug 2024 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771271; cv=none; b=XITlSYuJhKBuvQBR9GJUZWYSKnutZv+0DF1JA0SNS53ok+WZNfYon/ZLBPhQnccSfRUTpFUPqcEU9MnKfz5Glc/EgnFha8Ofel9UDH/JHOP5Pg5JzgMaxSBuRRauHJUi2bh5wbP9dcZZiMhR8Z/1+eeltbhsYLV6k/JCA22hIcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771271; c=relaxed/simple;
	bh=ZZYK5oquDSVx1PaozX5Ttaik3jY7vBdJ5RUZQmrxG7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cj85kdR4ISpQWN+Dg24CUEJe7xZl7uFXMNx+wAiN9hngcXasvbVAkEurOA0+cR3/8vPEPwQoqIZZDGBpTEptb37EdtpsZSYfxg4xbjkZ8Tler+xXPVbKphbnupQEPljBKmmCWDnGXYjveJlPQDzz0dr032pl8Hrxygw4yesKAfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVwyXDu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVwyXDu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD67C61040;
	Tue, 27 Aug 2024 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771271;
	bh=ZZYK5oquDSVx1PaozX5Ttaik3jY7vBdJ5RUZQmrxG7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVwyXDu5uRkYJzhYg9mNUnU1JgZqXTplxjbMTeZUWVxMRju1ObzX9SuLRorxppl+h
	 9NxfvINwJ/jcPESClqBKonNT8IO0ifwDZwB85j48ONvju5zJ2xpgdYUwMpCDOrK8K1
	 854CwvjbAbpPri7lOWTB4yhJ3hDyAiCeSIM1pOSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Peter=20K=C3=A4stle?= <peter@piie.net>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 139/273] thermal: gov_bang_bang: Split bang_bang_control()
Date: Tue, 27 Aug 2024 16:37:43 +0200
Message-ID: <20240827143838.694532728@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 84248e35d9b60e03df7276627e4e91fbaf80f73d ]

Move the setting of the thermal instance target state from
bang_bang_control() into a separate function that will be also called
in a different place going forward.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Peter Kästle <peter@piie.net>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.10+ <stable@vger.kernel.org> # 6.10+
Link: https://patch.msgid.link/3313587.aeNJFYEL58@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_bang_bang.c | 42 ++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
index b9474c6af72b5..87cff3ea77a9d 100644
--- a/drivers/thermal/gov_bang_bang.c
+++ b/drivers/thermal/gov_bang_bang.c
@@ -13,6 +13,27 @@
 
 #include "thermal_core.h"
 
+static void bang_bang_set_instance_target(struct thermal_instance *instance,
+					  unsigned int target)
+{
+	if (instance->target != 0 && instance->target != 1 &&
+	    instance->target != THERMAL_NO_TARGET)
+		pr_debug("Unexpected state %ld of thermal instance %s in bang-bang\n",
+			 instance->target, instance->name);
+
+	/*
+	 * Enable the fan when the trip is crossed on the way up and disable it
+	 * when the trip is crossed on the way down.
+	 */
+	instance->target = target;
+
+	dev_dbg(&instance->cdev->device, "target=%ld\n", instance->target);
+
+	mutex_lock(&instance->cdev->lock);
+	__thermal_cdev_update(instance->cdev);
+	mutex_unlock(&instance->cdev->lock);
+}
+
 /**
  * bang_bang_control - controls devices associated with the given zone
  * @tz: thermal_zone_device
@@ -54,25 +75,8 @@ static void bang_bang_control(struct thermal_zone_device *tz,
 		tz->temperature, trip->hysteresis);
 
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
-		if (instance->trip != trip)
-			continue;
-
-		if (instance->target != 0 && instance->target != 1 &&
-		    instance->target != THERMAL_NO_TARGET)
-			pr_debug("Unexpected state %ld of thermal instance %s in bang-bang\n",
-				 instance->target, instance->name);
-
-		/*
-		 * Enable the fan when the trip is crossed on the way up and
-		 * disable it when the trip is crossed on the way down.
-		 */
-		instance->target = crossed_up;
-
-		dev_dbg(&instance->cdev->device, "target=%ld\n", instance->target);
-
-		mutex_lock(&instance->cdev->lock);
-		__thermal_cdev_update(instance->cdev);
-		mutex_unlock(&instance->cdev->lock);
+		if (instance->trip == trip)
+			bang_bang_set_instance_target(instance, crossed_up);
 	}
 }
 
-- 
2.43.0



