Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C01DF25E;
	Tue,  8 Oct 2024 13:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392900; cv=none; b=GRy4gRIBUvRwkCcoWpwPdA82YDKY0BeW8eMG7oO0+vYUlJavrlNGD9ucf1DlgxJ4HLPrwlQGxy0fzu7AN6o0rijfYTT2wgtqwuqh+iDiQ9qPxNuCk6vj016He6cvMqS0mzgEJ9IcSTyrWnPHHwCLBWX8NE82oVzn/E2gt2ZriIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392900; c=relaxed/simple;
	bh=wacx/je/VM8xcHFrmZhvo+TRePSAGnh3jDN0C5bBIMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/gnW6c1tjHhxAAHvcsassYBkxs0XtrZG1Xc+1YfWdPbnRJgyHfPqskcDOQzHopxN1WyRHLoSSg9s640/TBis9DRaVahEdLCLnrkXzRefund5AEVii+tGNEmLUJsk7wOslVwEUEdasCyXy0n+WTJL/UvmyRMotW13V8PUOWFJBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roH30jJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roH30jJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C1FC4CEC7;
	Tue,  8 Oct 2024 13:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392900;
	bh=wacx/je/VM8xcHFrmZhvo+TRePSAGnh3jDN0C5bBIMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roH30jJIPs0QFHE4a4HdP+GmSMfTVR494ufDOaJsCz1jxm3584TaN+zxPJoeoJmsx
	 HoWs+zDsjYtRP8200EXwgL30/DGxk9HtKj3Kb2iyTkUr9Sj5cOH3jGoYEZGbB53Rzj
	 NKMpKmxDDT2ESEgx8EmxknHm/sPxRYyUtsUwqIk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 545/558] ACPI: battery: Fix possible crash when unregistering a battery hook
Date: Tue,  8 Oct 2024 14:09:35 +0200
Message-ID: <20241008115723.681173222@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 76959aff14a0012ad6b984ec7686d163deccdc16 ]

When a battery hook returns an error when adding a new battery, then
the battery hook is automatically unregistered.
However the battery hook provider cannot know that, so it will later
call battery_hook_unregister() on the already unregistered battery
hook, resulting in a crash.

Fix this by using the list head to mark already unregistered battery
hooks as already being unregistered so that they can be ignored by
battery_hook_unregister().

Fixes: fa93854f7a7e ("battery: Add the battery hooking API")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20241001212835.341788-3-W_Armin@gmx.de
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 10e9136897a75..4f1637ed76e5c 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -718,7 +718,7 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 		if (!hook->remove_battery(battery->bat, hook))
 			power_supply_changed(battery->bat);
 	}
-	list_del(&hook->list);
+	list_del_init(&hook->list);
 
 	pr_info("extension unregistered: %s\n", hook->name);
 }
@@ -726,7 +726,14 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 void battery_hook_unregister(struct acpi_battery_hook *hook)
 {
 	mutex_lock(&hook_mutex);
-	battery_hook_unregister_unlocked(hook);
+	/*
+	 * Ignore already unregistered battery hooks. This might happen
+	 * if a battery hook was previously unloaded due to an error when
+	 * adding a new battery.
+	 */
+	if (!list_empty(&hook->list))
+		battery_hook_unregister_unlocked(hook);
+
 	mutex_unlock(&hook_mutex);
 }
 EXPORT_SYMBOL_GPL(battery_hook_unregister);
@@ -736,7 +743,6 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 	struct acpi_battery *battery;
 
 	mutex_lock(&hook_mutex);
-	INIT_LIST_HEAD(&hook->list);
 	list_add(&hook->list, &battery_hook_list);
 	/*
 	 * Now that the driver is registered, we need
-- 
2.43.0



