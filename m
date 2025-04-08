Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3C8267F65;
	Tue,  8 Apr 2025 11:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111650; cv=none; b=WM0JNNA6vC+kkfzYrsEnn63uezmAGaY7ve5q8/LYswW6QBPJ3BIe7/Z5gz3R9OTcY2CEo8u7jSqDYyOY3b4C6TPGVF58O9D/t0R6yu5D8sMcFanlUGy9s++WP09eLww0Mfj155bEUvaht6hY4qf1s6dlblS1b0grGYXSVhCoNj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111650; c=relaxed/simple;
	bh=1Wfg5RayJh5yx0fL9MUwMgHi67MftwhIRVFMSgeZNpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTYUD3qQjtUdKPoUnLz0ezCo/kt6xtjtoUg36SXww50J2VUbBDkd8BPLZc67iKXDJC5eUPL5kKdoFcCXaDeq3N4hpJyyXQW0C0ayG77dCJh3bA7Y1PsLTv+wARKoeLtVSHesup0uYsdUM9c5dOHVmqaexqyBmcu2YkiSP9iDEq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxzED42W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxzED42W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDD7C4CEE5;
	Tue,  8 Apr 2025 11:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111649;
	bh=1Wfg5RayJh5yx0fL9MUwMgHi67MftwhIRVFMSgeZNpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxzED42W6JMultlC1OMfW+eiVCvjaBd9dk3Yy+iKLtJ+RqOdXMyvKjR2Vtyd8c+Mo
	 OKKKn4j052Ie86O4KjY/8YZy/qDUUPdAqR2bvxQisp79ZI5axqlsIkxVZaMnxfm3c6
	 R7t2aUX3Fhz4SwZ97y1z8wyHPn2e60h8i7ckbAVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Fabio Estevam <festevam@denx.de>,
	Guenter Roeck <groeck@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Matteo Croce <teknoraver@meta.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Rui Zhang <rui.zhang@intel.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 506/731] reboot: replace __hw_protection_shutdown bool action parameter with an enum
Date: Tue,  8 Apr 2025 12:46:43 +0200
Message-ID: <20250408104926.044752948@linuxfoundation.org>
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

[ Upstream commit 318f05a057157c400a92f17c5f2fa3dd96f57c7e ]

Patch series "reboot: support runtime configuration of emergency
hw_protection action", v3.

We currently leave the decision of whether to shutdown or reboot to
protect hardware in an emergency situation to the individual drivers.

This works out in some cases, where the driver detecting the critical
failure has inside knowledge: It binds to the system management controller
for example or is guided by hardware description that defines what to do.

This is inadequate in the general case though as a driver reporting e.g.
an imminent power failure can't know whether a shutdown or a reboot would
be more appropriate for a given hardware platform.

To address this, this series adds a hw_protection kernel parameter and
sysfs toggle that can be used to change the action from the shutdown
default to reboot.  A new hw_protection_trigger API then makes use of this
default action.

My particular use case is unattended embedded systems that don't have
support for shutdown and that power on automatically when power is
supplied:

  - A brief power cycle gets detected by the driver
  - The kernel powers down the system and SoC goes into shutdown mode
  - Power is restored
  - The system remains oblivious to the restored power
  - System needs to be manually power cycled for a duration long enough
    to drain the capacitors

With this series, such systems can configure the kernel with
hw_protection=reboot to have the boot firmware worry about critical
conditions.

This patch (of 12):

Currently __hw_protection_shutdown() either reboots or shuts down the
system according to its shutdown argument.

To make the logic easier to follow, both inside __hw_protection_shutdown
and at caller sites, lets replace the bool parameter with an enum.

This will be extra useful, when in a later commit, a third action is added
to the enumeration.

No functional change.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-0-e1c09b090c0c@pengutronix.de
Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-1-e1c09b090c0c@pengutronix.de
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Matteo Croce <teknoraver@meta.com>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Rui Zhang <rui.zhang@intel.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: bbf0ec4f57e0 ("reboot: reboot, not shutdown, on hw_protection_reboot timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/reboot.h | 18 +++++++++++++++---
 kernel/reboot.c        | 14 ++++++--------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index abcdde4df6979..e97f6b8e85868 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -177,16 +177,28 @@ void ctrl_alt_del(void);
 
 extern void orderly_poweroff(bool force);
 extern void orderly_reboot(void);
-void __hw_protection_shutdown(const char *reason, int ms_until_forced, bool shutdown);
+
+/**
+ * enum hw_protection_action - Hardware protection action
+ *
+ * @HWPROT_ACT_SHUTDOWN:
+ *	The system should be shut down (powered off) for HW protection.
+ * @HWPROT_ACT_REBOOT:
+ *	The system should be rebooted for HW protection.
+ */
+enum hw_protection_action { HWPROT_ACT_SHUTDOWN, HWPROT_ACT_REBOOT };
+
+void __hw_protection_shutdown(const char *reason, int ms_until_forced,
+			      enum hw_protection_action action);
 
 static inline void hw_protection_reboot(const char *reason, int ms_until_forced)
 {
-	__hw_protection_shutdown(reason, ms_until_forced, false);
+	__hw_protection_shutdown(reason, ms_until_forced, HWPROT_ACT_REBOOT);
 }
 
 static inline void hw_protection_shutdown(const char *reason, int ms_until_forced)
 {
-	__hw_protection_shutdown(reason, ms_until_forced, true);
+	__hw_protection_shutdown(reason, ms_until_forced, HWPROT_ACT_SHUTDOWN);
 }
 
 /*
diff --git a/kernel/reboot.c b/kernel/reboot.c
index b5a8569e5d81f..b20b53f08648d 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -983,10 +983,7 @@ static void hw_failure_emergency_poweroff(int poweroff_delay_ms)
  * @ms_until_forced:	Time to wait for orderly shutdown or reboot before
  *			triggering it. Negative value disables the forced
  *			shutdown or reboot.
- * @shutdown:		If true, indicates that a shutdown will happen
- *			after the critical tempeature is reached.
- *			If false, indicates that a reboot will happen
- *			after the critical tempeature is reached.
+ * @action:		The hardware protection action to be taken.
  *
  * Initiate an emergency system shutdown or reboot in order to protect
  * hardware from further damage. Usage examples include a thermal protection.
@@ -994,7 +991,8 @@ static void hw_failure_emergency_poweroff(int poweroff_delay_ms)
  * pending even if the previous request has given a large timeout for forced
  * shutdown/reboot.
  */
-void __hw_protection_shutdown(const char *reason, int ms_until_forced, bool shutdown)
+void __hw_protection_shutdown(const char *reason, int ms_until_forced,
+			      enum hw_protection_action action)
 {
 	static atomic_t allow_proceed = ATOMIC_INIT(1);
 
@@ -1009,10 +1007,10 @@ void __hw_protection_shutdown(const char *reason, int ms_until_forced, bool shut
 	 * orderly_poweroff failure
 	 */
 	hw_failure_emergency_poweroff(ms_until_forced);
-	if (shutdown)
-		orderly_poweroff(true);
-	else
+	if (action == HWPROT_ACT_REBOOT)
 		orderly_reboot();
+	else
+		orderly_poweroff(true);
 }
 EXPORT_SYMBOL_GPL(__hw_protection_shutdown);
 
-- 
2.39.5



