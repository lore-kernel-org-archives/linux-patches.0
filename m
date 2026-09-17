Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2204E4C4F;
	Thu, 17 Sep 2026 15:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660731; cv=none; b=iJu0IOSUoMFCOCguF3c9xm2ATeiGkEXhoFVazfOGdAX568wCNa9cBI9CKjgIe6L329zCRPBxfMYqQ5yLeT7r+LQsrylmdhOsHIcmr7k6bT3aXUhPnhwNXhN2IwF7lyCImW9cvDPvvSWSte0AzpdtzZLXCQwu2y81Px6t0WsXQ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660731; c=relaxed/simple;
	bh=AsSduXDsXiWsYmmLBuhWwVZSzwzosM8rCMLrGKmMzQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt7WhWC3M+YnIZtgqWcMFsFrz4ztTiZhMfc5u83uJvcrkWiVV4CZPeDIMwUijLxuccl1CHGkbirQtf5DKLeGCmVw1KSB46DvGtwQEoVxsAhGann/Za7wVFpglvqbx5kE4KqZc4AZ7r2z17jOFmBeMB5ORgI7czqwCVw9GkDGNRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWilrqi0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWilrqi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42E01F000FF;
	Thu, 17 Sep 2026 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660730;
	bh=X8cUb9a4m6YzSujTQn7gX/vCmNR9xmJfCLQ7aHVvYzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWilrqi0dyhhdWLAWiFmw3RSD2djVHAMLmZBM+jxa9naYsmEBuuW4KhWM/UppXkCl
	 nKpsN1tuVo8iT66/GSGz/PhIZf+rMvQsyW7+UG7ulVGNB00bP+BNt/xauh60P6me/O
	 Q30TtSeVgZ96R0MbXC9s9vK/wOk8huE22R9tqPII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 689/733] ASoC: cs35l56: Fix race between kexec and snd_soc_register_component()
Date: Thu, 17 Sep 2026 16:16:37 +0100
Message-ID: <20260917151409.973879537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit 883e78c9e6007c91be96e99a36c35baf41bc8ed5 upstream.

Use a reboot notifier and a mutex to prevent snd_soc_register_component()
from racing with a kexec reboot. This prevents snd_soc_register_component()
from manipulating device lists while device_shutdown() is walking them.

Commit 1d80a4792f1de ("ASoC: cs35l56: Fix probe deadlock waiting for
SoundWire enumeration") moved snd_soc_register_component() out of probe()
into a workqueue item. See the description in that commit for a
detailed explanation.

That change introduces a race between snd_soc_register_component() and
kexec. The reboot notifier and mutex prevent the shutdown race.

There is one remaining race with KEXEC_JUMP because it does not invoke
reboot notifiers or freeze freezable workqueues. But KEXEC_JUMP is
rarely used and is supported on only two architectures (x86 and SuperH).
It does not appear to be enabled by default in any distro. It is also
unlikely there will be a KEXEC_JUMP before snd_soc_register_component()
has had the opportunity to execute. Fixing this can be deferred to a
future patch.

Fixes: 1d80a4792f1de ("ASoC: cs35l56: Fix probe deadlock waiting for SoundWire enumeration")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260907093645.27407-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l56.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -18,9 +18,11 @@
 #include <linux/interrupt.h>
 #include <linux/math.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/property.h>
+#include <linux/reboot.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
@@ -37,6 +39,13 @@
 #include "wm_adsp.h"
 #include "cs35l56.h"
 
+/*
+ * snd_soc_register_component() can call component_probe() on all instances
+ * in a card, so deferred registration must be protected across all instances.
+ */
+static DEFINE_MUTEX(cs35l56_component_register_lock);
+static bool cs35l56_shutting_down;
+
 void cs35l56_mask_soundwire_interrupts(struct sdw_slave *peripheral)
 {
 	 /*
@@ -1959,6 +1968,11 @@ static void cs35l56_component_register_w
 						       component_register_work);
 	int ret;
 
+	guard(mutex)(&cs35l56_component_register_lock);
+
+	if (cs35l56_shutting_down)
+		return;
+
 	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(cs35l56->base.dev, pm_err);
 	ret = PM_RUNTIME_ACQUIRE_ERR(&pm_err);
 	if (ret) {
@@ -2219,6 +2233,37 @@ EXPORT_NS_GPL_DEV_PM_OPS(cs35l56_pm_ops_
 };
 #endif
 
+static int cs35l56_reboot_notify(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	guard(mutex)(&cs35l56_component_register_lock);
+	cs35l56_shutting_down = true;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block cs35l56_reboot_notifier = {
+	.notifier_call = cs35l56_reboot_notify,
+};
+
+static int __init cs35l56_modinit(void)
+{
+	/*
+	 * Use reboot notifier to prevent race between shutdown and
+	 * snd_soc_register_component(). Driver shutdown() callback would
+	 * run too late, after device_shutdown() is already walking the
+	 * device list that component registration can modify.
+	 */
+	return register_reboot_notifier(&cs35l56_reboot_notifier);
+}
+module_init(cs35l56_modinit);
+
+static void __exit cs35l56_modexit(void)
+{
+	unregister_reboot_notifier(&cs35l56_reboot_notifier);
+}
+module_exit(cs35l56_modexit);
+
 MODULE_DESCRIPTION("ASoC CS35L56 driver");
 MODULE_IMPORT_NS("SND_SOC_CS35L56_SHARED");
 MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");


