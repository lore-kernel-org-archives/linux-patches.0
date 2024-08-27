Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB42B1C6881;
	Tue, 27 Aug 2024 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772680; cv=none; b=ZoAiUZvAk1IEcAyK4aQQm5+Ctq3j7UxFYwI2GG5BiY0g35QtunxhVdgHXq/Qn+GxlTn6prXDzPnTryj1CqsbIeC0kRpvrl+PPfT+mqvdGa4TXuB/FbaY3LE1A/N7pXnTv+a/MndnAZaP2p2Y2HkYSuJvUjdLH7ONQAd8oUH2oQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772680; c=relaxed/simple;
	bh=1qyc5WdDaIFC9Lr7UdkrACLqEBsddlNhQu3FlM7VUDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xnh1arWGaBuSt3sYOaH3ST+nks6uVIqvnrOY22PY4DYLPYVIEvfjRI8GIrnwlyGHGuIb7Q/kaWxfmO/d0VVoRW6jH44YdKmjSEcGQ21hL3NiP9suwztspMcO/dZpeUbSiMBWxwQKvsBup+6J90tcs1qtdfUTngKtnjFWKZUp/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI0g75Z5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI0g75Z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCD8C4DDF0;
	Tue, 27 Aug 2024 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772680;
	bh=1qyc5WdDaIFC9Lr7UdkrACLqEBsddlNhQu3FlM7VUDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI0g75Z5yZuqTWQ1EGUTPGSnkdYuNY5Yid6m9YMpyFwCS2CfPVhehvtnyCRAm5Q6o
	 H2Bs9cU4J66mQqZKcuEgsQkxsS8jmDmcXHO2NVDn2bNddDA+qbxoZ9mfktyu/Ja6l5
	 XwJQyuQJKcytCutO78VjnxQW86z1kugzH5dufhwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 270/321] Input: i8042 - add forcenorestore quirk to leave controller untouched even on s3
Date: Tue, 27 Aug 2024 16:39:38 +0200
Message-ID: <20240827143848.529874755@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 3d765ae2daccc570b3f4fbcb57eb321b12cdded2 upstream.

On s3 resume the i8042 driver tries to restore the controller to a known
state by reinitializing things, however this can confuse the controller
with different effects. Mostly occasionally unresponsive keyboards after
resume.

These issues do not rise on s0ix resume as here the controller is assumed
to preserved its state from before suspend.

This patch adds a quirk for devices where the reinitialization on s3 resume
is not needed and might be harmful as described above. It does this by
using the s0ix resume code path at selected locations.

This new quirk goes beyond what the preexisting reset=never quirk does,
which only skips some reinitialization steps.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240104183118.779778-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   10 +++++++---
 drivers/input/serio/i8042.c           |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -83,6 +83,7 @@ static inline void i8042_write_command(i
 #define SERIO_QUIRK_KBDRESET		BIT(12)
 #define SERIO_QUIRK_DRITEK		BIT(13)
 #define SERIO_QUIRK_NOPNP		BIT(14)
+#define SERIO_QUIRK_FORCENORESTORE	BIT(15)
 
 /* Quirk table for different mainboards. Options similar or identical to i8042
  * module parameters.
@@ -1685,6 +1686,8 @@ static void __init i8042_check_quirks(vo
 	if (quirks & SERIO_QUIRK_NOPNP)
 		i8042_nopnp = true;
 #endif
+	if (quirks & SERIO_QUIRK_FORCENORESTORE)
+		i8042_forcenorestore = true;
 }
 #else
 static inline void i8042_check_quirks(void) {}
@@ -1718,7 +1721,7 @@ static int __init i8042_platform_init(vo
 
 	i8042_check_quirks();
 
-	pr_debug("Active quirks (empty means none):%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	pr_debug("Active quirks (empty means none):%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 		i8042_nokbd ? " nokbd" : "",
 		i8042_noaux ? " noaux" : "",
 		i8042_nomux ? " nomux" : "",
@@ -1738,10 +1741,11 @@ static int __init i8042_platform_init(vo
 		"",
 #endif
 #ifdef CONFIG_PNP
-		i8042_nopnp ? " nopnp" : "");
+		i8042_nopnp ? " nopnp" : "",
 #else
-		"");
+		"",
 #endif
+		i8042_forcenorestore ? " forcenorestore" : "");
 
 	retval = i8042_pnp_init();
 	if (retval)
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -115,6 +115,10 @@ module_param_named(nopnp, i8042_nopnp, b
 MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
 #endif
 
+static bool i8042_forcenorestore;
+module_param_named(forcenorestore, i8042_forcenorestore, bool, 0);
+MODULE_PARM_DESC(forcenorestore, "Force no restore on s3 resume, copying s2idle behaviour");
+
 #define DEBUG
 #ifdef DEBUG
 static bool i8042_debug;
@@ -1232,7 +1236,7 @@ static int i8042_pm_suspend(struct devic
 {
 	int i;
 
-	if (pm_suspend_via_firmware())
+	if (!i8042_forcenorestore && pm_suspend_via_firmware())
 		i8042_controller_reset(true);
 
 	/* Set up serio interrupts for system wakeup. */
@@ -1248,7 +1252,7 @@ static int i8042_pm_suspend(struct devic
 
 static int i8042_pm_resume_noirq(struct device *dev)
 {
-	if (!pm_resume_via_firmware())
+	if (i8042_forcenorestore || !pm_resume_via_firmware())
 		i8042_interrupt(0, NULL);
 
 	return 0;
@@ -1271,7 +1275,7 @@ static int i8042_pm_resume(struct device
 	 * not restore the controller state to whatever it had been at boot
 	 * time, so we do not need to do anything.
 	 */
-	if (!pm_suspend_via_firmware())
+	if (i8042_forcenorestore || !pm_suspend_via_firmware())
 		return 0;
 
 	/*


