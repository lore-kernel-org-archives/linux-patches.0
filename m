Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEEB268C79;
	Tue,  8 Apr 2025 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111778; cv=none; b=DNPPvyrjW+iWjPDtuSJXEIk9uKoK7vFlVzKxaXb0YzRefllmzlQm8SYwAemAvkkI9Aqfa0SP/kG2RwOtZxf0OaJQUF0q+D7hi1xJ/Xn4IaMN06Krpbl5UzTPr8GMckDabkiX8x0k0DwDP0IeJ7H7wN0o3r8vcv0kyZEocCpI2Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111778; c=relaxed/simple;
	bh=Wl/YpjQ4fYZ873SmvnFmiOBOjo/VtxqAHwg4NaExbO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCMvMlrTHhNsztWrRY84sTcxlI6W1waozzQZz3Dw7aT8xJLMPRl9p3lF8kiLjLY8e+gWIIX8s7lJgSVHRs9i9Asq2SQ+I0DKiABhNgQKO7NHNRnp6e1OMpDM6OGCH4jsF4IWBgx9pV2Ey/hVd9xSFWwP0yq5OLcRALOvs4YDTYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6NeRG2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6NeRG2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E273C4CEE5;
	Tue,  8 Apr 2025 11:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111778;
	bh=Wl/YpjQ4fYZ873SmvnFmiOBOjo/VtxqAHwg4NaExbO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6NeRG2Yg5cG+Ixb/GWBOmp4ILMN9ZDyS2n/q388mVX7GK7TnxLHOxqJUAFPvqd7P
	 TJmlzSr2tk7Y53OJTo98Yu3g+mC4NR8Y+3Fw3SqD+8B98EFEKnY41ac7c4JZjwHltK
	 9a39TpBelRCjG5aYWXhyyzlBowPhivaHDzqdq9cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Benson Leung <bleung@chromium.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Fabio Estevam <festevam@denx.de>,
	Guenter Roeck <groeck@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Matteo Croce <teknoraver@meta.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Rui Zhang <rui.zhang@intel.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 507/731] reboot: reboot, not shutdown, on hw_protection_reboot timeout
Date: Tue,  8 Apr 2025 12:46:44 +0200
Message-ID: <20250408104926.068566057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit bbf0ec4f57e0a34983ca25f00ec90f4765572d78 ]

hw_protection_shutdown() will kick off an orderly shutdown and if that
takes longer than a configurable amount of time, an emergency shutdown
will occur.

Recently, hw_protection_reboot() was added for those systems that don't
implement a proper shutdown and are better served by rebooting and having
the boot firmware worry about doing something about the critical
condition.

On timeout of the orderly reboot of hw_protection_reboot(), the system
would go into shutdown, instead of reboot.  This is not a good idea, as
going into shutdown was explicitly not asked for.

Fix this by always doing an emergency reboot if hw_protection_reboot() is
called and the orderly reboot takes too long.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-2-e1c09b090c0c@pengutronix.de
Fixes: 79fa723ba84c ("reboot: Introduce thermal_zone_device_critical_reboot()")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Benson Leung <bleung@chromium.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matteo Croce <teknoraver@meta.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Rui Zhang <rui.zhang@intel.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/reboot.c | 70 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index b20b53f08648d..f348f1ba9e226 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -932,48 +932,76 @@ void orderly_reboot(void)
 }
 EXPORT_SYMBOL_GPL(orderly_reboot);
 
+static const char *hw_protection_action_str(enum hw_protection_action action)
+{
+	switch (action) {
+	case HWPROT_ACT_SHUTDOWN:
+		return "shutdown";
+	case HWPROT_ACT_REBOOT:
+		return "reboot";
+	default:
+		return "undefined";
+	}
+}
+
+static enum hw_protection_action hw_failure_emergency_action;
+
 /**
- * hw_failure_emergency_poweroff_func - emergency poweroff work after a known delay
- * @work: work_struct associated with the emergency poweroff function
+ * hw_failure_emergency_action_func - emergency action work after a known delay
+ * @work: work_struct associated with the emergency action function
  *
  * This function is called in very critical situations to force
- * a kernel poweroff after a configurable timeout value.
+ * a kernel poweroff or reboot after a configurable timeout value.
  */
-static void hw_failure_emergency_poweroff_func(struct work_struct *work)
+static void hw_failure_emergency_action_func(struct work_struct *work)
 {
+	const char *action_str = hw_protection_action_str(hw_failure_emergency_action);
+
+	pr_emerg("Hardware protection timed-out. Trying forced %s\n",
+		 action_str);
+
 	/*
-	 * We have reached here after the emergency shutdown waiting period has
-	 * expired. This means orderly_poweroff has not been able to shut off
-	 * the system for some reason.
+	 * We have reached here after the emergency action waiting period has
+	 * expired. This means orderly_poweroff/reboot has not been able to
+	 * shut off the system for some reason.
 	 *
-	 * Try to shut down the system immediately using kernel_power_off
-	 * if populated
+	 * Try to shut off the system immediately if possible
 	 */
-	pr_emerg("Hardware protection timed-out. Trying forced poweroff\n");
-	kernel_power_off();
+
+	if (hw_failure_emergency_action == HWPROT_ACT_REBOOT)
+		kernel_restart(NULL);
+	else
+		kernel_power_off();
 
 	/*
 	 * Worst of the worst case trigger emergency restart
 	 */
-	pr_emerg("Hardware protection shutdown failed. Trying emergency restart\n");
+	pr_emerg("Hardware protection %s failed. Trying emergency restart\n",
+		 action_str);
 	emergency_restart();
 }
 
-static DECLARE_DELAYED_WORK(hw_failure_emergency_poweroff_work,
-			    hw_failure_emergency_poweroff_func);
+static DECLARE_DELAYED_WORK(hw_failure_emergency_action_work,
+			    hw_failure_emergency_action_func);
 
 /**
- * hw_failure_emergency_poweroff - Trigger an emergency system poweroff
+ * hw_failure_emergency_schedule - Schedule an emergency system shutdown or reboot
+ *
+ * @action:		The hardware protection action to be taken
+ * @action_delay_ms:	Time in milliseconds to elapse before triggering action
  *
  * This may be called from any critical situation to trigger a system shutdown
- * after a given period of time. If time is negative this is not scheduled.
+ * or reboot after a given period of time.
+ * If time is negative this is not scheduled.
  */
-static void hw_failure_emergency_poweroff(int poweroff_delay_ms)
+static void hw_failure_emergency_schedule(enum hw_protection_action action,
+					  int action_delay_ms)
 {
-	if (poweroff_delay_ms <= 0)
+	if (action_delay_ms <= 0)
 		return;
-	schedule_delayed_work(&hw_failure_emergency_poweroff_work,
-			      msecs_to_jiffies(poweroff_delay_ms));
+	hw_failure_emergency_action = action;
+	schedule_delayed_work(&hw_failure_emergency_action_work,
+			      msecs_to_jiffies(action_delay_ms));
 }
 
 /**
@@ -1006,7 +1034,7 @@ void __hw_protection_shutdown(const char *reason, int ms_until_forced,
 	 * Queue a backup emergency shutdown in the event of
 	 * orderly_poweroff failure
 	 */
-	hw_failure_emergency_poweroff(ms_until_forced);
+	hw_failure_emergency_schedule(action, ms_until_forced);
 	if (action == HWPROT_ACT_REBOOT)
 		orderly_reboot();
 	else
-- 
2.39.5



