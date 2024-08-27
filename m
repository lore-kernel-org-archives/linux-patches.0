Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739F31C3F19;
	Tue, 27 Aug 2024 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771278; cv=none; b=T323Irp2FqVwNVzMGRYe/UMnMHJdCei4HL+E0O20iWvgyknu3KuzWOFJDKQJ+rspviQHp0811BrEOpqjeXj5WHdkjP7dtOJG6oyNacrAlbAz+2flXVoa91WIresT1+lQEc/0hAKdp5TjgtCYxjnBurNfPy07e1UbjUHSXHcQLuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771278; c=relaxed/simple;
	bh=28R6Te5TEwDicyezPWZaAqbxkH9pMqTI8tOyYV4TGyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpLNGenE5lYDy6pz2lMfu15ehP/n3IPCMj4mof6JuqYFQe/L82sMhmaPSgeUmnlFFx+7rzQyWYGcllhHTqKzLFYrHfo58ccYOnwbIQxBcaDgRP5Rkd9uxvIYj9ND3uGONAz5zgD60ssV5cBwc5oErzkk/pED6I2x27HwfF8Oxi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltgkKRPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltgkKRPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B60C61044;
	Tue, 27 Aug 2024 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771278;
	bh=28R6Te5TEwDicyezPWZaAqbxkH9pMqTI8tOyYV4TGyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltgkKRPqLY9xt33U2l0uhFm6ZQ6/biZUzLYbcsaR/KKvNKwvl2ugeq4sEqwcsWlvb
	 Mdy5feI1AKrspjtvxuFQJbBVyUvSU7LDvmKvra2lFz4U9rQVGoI7Rr0sA2aXf7lfFy
	 8gBo7FQ5qEhGSItIHUmGXw0zyHUnqSXkZa4/6Eo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Peter=20K=C3=A4stle?= <peter@piie.net>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 141/273] thermal: gov_bang_bang: Use governor_data to reduce overhead
Date: Tue, 27 Aug 2024 16:37:45 +0200
Message-ID: <20240827143838.772446120@linuxfoundation.org>
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

[ Upstream commit 6e6f58a170ea98e44075b761f2da42a5aec47dfb ]

After running once, the for_each_trip_desc() loop in
bang_bang_manage() is pure needless overhead because it is not going to
make any changes unless a new cooling device has been bound to one of
the trips in the thermal zone or the system is resuming from sleep.

For this reason, make bang_bang_manage() set governor_data for the
thermal zone and check it upfront to decide whether or not it needs to
do anything.

However, governor_data needs to be reset in some cases to let
bang_bang_manage() know that it should walk the trips again, so add an
.update_tz() callback to the governor and make the core additionally
invoke it during system resume.

To avoid affecting the other users of that callback unnecessarily, add
a special notification reason for system resume, THERMAL_TZ_RESUME, and
also pass it to __thermal_zone_device_update() called during system
resume for consistency.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Peter Kästle <peter@piie.net>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.10+ <stable@vger.kernel.org> # 6.10+
Link: https://patch.msgid.link/2285575.iZASKD2KPV@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_bang_bang.c | 18 ++++++++++++++++++
 drivers/thermal/thermal_core.c  |  3 ++-
 include/linux/thermal.h         |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
index bc55e0698bfa8..daed67d19efb8 100644
--- a/drivers/thermal/gov_bang_bang.c
+++ b/drivers/thermal/gov_bang_bang.c
@@ -86,6 +86,10 @@ static void bang_bang_manage(struct thermal_zone_device *tz)
 	const struct thermal_trip_desc *td;
 	struct thermal_instance *instance;
 
+	/* If the code below has run already, nothing needs to be done. */
+	if (tz->governor_data)
+		return;
+
 	for_each_trip_desc(tz, td) {
 		const struct thermal_trip *trip = &td->trip;
 
@@ -107,11 +111,25 @@ static void bang_bang_manage(struct thermal_zone_device *tz)
 				bang_bang_set_instance_target(instance, 0);
 		}
 	}
+
+	tz->governor_data = (void *)true;
+}
+
+static void bang_bang_update_tz(struct thermal_zone_device *tz,
+				enum thermal_notify_event reason)
+{
+	/*
+	 * Let bang_bang_manage() know that it needs to walk trips after binding
+	 * a new cdev and after system resume.
+	 */
+	if (reason == THERMAL_TZ_BIND_CDEV || reason == THERMAL_TZ_RESUME)
+		tz->governor_data = NULL;
 }
 
 static struct thermal_governor thermal_gov_bang_bang = {
 	.name		= "bang_bang",
 	.trip_crossed	= bang_bang_control,
 	.manage		= bang_bang_manage,
+	.update_tz	= bang_bang_update_tz,
 };
 THERMAL_GOVERNOR_DECLARE(thermal_gov_bang_bang);
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index f2d31bc48f529..b8d889ef4fa5e 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1715,7 +1715,8 @@ static void thermal_zone_device_resume(struct work_struct *work)
 	tz->suspended = false;
 
 	thermal_zone_device_init(tz);
-	__thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
+	thermal_governor_update_tz(tz, THERMAL_TZ_RESUME);
+	__thermal_zone_device_update(tz, THERMAL_TZ_RESUME);
 
 	complete(&tz->resume);
 	tz->resuming = false;
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f1155c0439c4b..13f88317b81bf 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -55,6 +55,7 @@ enum thermal_notify_event {
 	THERMAL_TZ_BIND_CDEV, /* Cooling dev is bind to the thermal zone */
 	THERMAL_TZ_UNBIND_CDEV, /* Cooling dev is unbind from the thermal zone */
 	THERMAL_INSTANCE_WEIGHT_CHANGED, /* Thermal instance weight changed */
+	THERMAL_TZ_RESUME, /* Thermal zone is resuming after system sleep */
 };
 
 /**
-- 
2.43.0



