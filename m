Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C46C1FFC5C;
	Thu, 13 Feb 2025 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458788; cv=none; b=tNLa5+TGsRls8CAmt8QaynUMj4t6l3PWQJC5W64b8rD5MOxS4HYbW1hywjSWuMJ/cu38hoVDPTmzvsjwlK/JLb8NfNpFJFsoyV458z802U9h2rhtpVB+24NJW54cSO4q08PB7NBrcRd6xqcXTMWd3AIQ2LnCu0wWaG7euNCs2n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458788; c=relaxed/simple;
	bh=FWc9Kn/FNgBDzLdiHtMURNI0FPeKtaD6YDLNgAZB/Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ma9YWPB1ZEFzr41E1C2BJdKbvNecsMuBPHneSQ+8q+sIRptVrU+X2LEoiYnYLeh9YPZ2H5+OV07LYvtRsPjbUyyJoFJM/7PeEq79Io9GbvngzaQmTviai4k8zCj4PyrFHCDUyJ7uEc5CPJdaNotB8UoQv05u0V+c3QbBVzR5FC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TL5gWYKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TL5gWYKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04E5C4CEE4;
	Thu, 13 Feb 2025 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458788;
	bh=FWc9Kn/FNgBDzLdiHtMURNI0FPeKtaD6YDLNgAZB/Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TL5gWYKc1lRPX+vINNHRAnLzNb8PYCYXPhDpnErG/Oa53mUiGUJ7GKZ6M9xn5x6Xh
	 QxKN34RK/6JJEB3WP145LCkgZjeVMrPFlr2vh4jKaI0BjPNX24funCYVvpLL/N3Ig6
	 H46+eZ4qMGWcZyMl5a3mS7NpsVgBaqad0FYY1M38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 079/443] net: wwan: iosm: Fix hibernation by re-binding the driver around it
Date: Thu, 13 Feb 2025 15:24:04 +0100
Message-ID: <20250213142443.661045142@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

[ Upstream commit 0b6f6593aa8c3a05f155c12fd0e7ad33a5149c31 ]

Currently, the driver is seriously broken with respect to the
hibernation (S4): after image restore the device is back into
IPC_MEM_EXEC_STAGE_BOOT (which AFAIK means bootloader stage) and needs
full re-launch of the rest of its firmware, but the driver restore
handler treats the device as merely sleeping and just sends it a
wake-up command.

This wake-up command times out but device nodes (/dev/wwan*) remain
accessible.
However attempting to use them causes the bootloader to crash and
enter IPC_MEM_EXEC_STAGE_CD_READY stage (which apparently means "a crash
dump is ready").

It seems that the device cannot be re-initialized from this crashed
stage without toggling some reset pin (on my test platform that's
apparently what the device _RST ACPI method does).

While it would theoretically be possible to rewrite the driver to tear
down the whole MUX / IPC layers on hibernation (so the bootloader does
not crash from improper access) and then re-launch the device on
restore this would require significant refactoring of the driver
(believe me, I've tried), since there are quite a few assumptions
hard-coded in the driver about the device never being partially
de-initialized (like channels other than devlink cannot be closed,
for example).
Probably this would also need some programming guide for this hardware.

Considering that the driver seems orphaned [1] and other people are
hitting this issue too [2] fix it by simply unbinding the PCI driver
before hibernation and re-binding it after restore, much like
USB_QUIRK_RESET_RESUME does for USB devices that exhibit a similar
problem.

Tested on XMM7360 in HP EliteBook 855 G7 both with s2idle (which uses
the existing suspend / resume handlers) and S4 (which uses the new code).

[1]: https://lore.kernel.org/all/c248f0b4-2114-4c61-905f-466a786bdebb@leemhuis.info/
[2]:
https://github.com/xmm7360/xmm7360-pci/issues/211#issuecomment-1804139413

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Link: https://patch.msgid.link/e60287ebdb0ab54c4075071b72568a40a75d0205.1736372610.git.mail@maciej.szmigiero.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 56 ++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 04517bd3325a2..a066977af0be5 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -6,6 +6,7 @@
 #include <linux/acpi.h>
 #include <linux/bitfield.h>
 #include <linux/module.h>
+#include <linux/suspend.h>
 #include <net/rtnetlink.h>
 
 #include "iosm_ipc_imem.h"
@@ -18,6 +19,7 @@ MODULE_LICENSE("GPL v2");
 /* WWAN GUID */
 static guid_t wwan_acpi_guid = GUID_INIT(0xbad01b75, 0x22a8, 0x4f48, 0x87, 0x92,
 				       0xbd, 0xde, 0x94, 0x67, 0x74, 0x7d);
+static bool pci_registered;
 
 static void ipc_pcie_resources_release(struct iosm_pcie *ipc_pcie)
 {
@@ -448,7 +450,6 @@ static struct pci_driver iosm_ipc_driver = {
 	},
 	.id_table = iosm_ipc_ids,
 };
-module_pci_driver(iosm_ipc_driver);
 
 int ipc_pcie_addr_map(struct iosm_pcie *ipc_pcie, unsigned char *data,
 		      size_t size, dma_addr_t *mapping, int direction)
@@ -530,3 +531,56 @@ void ipc_pcie_kfree_skb(struct iosm_pcie *ipc_pcie, struct sk_buff *skb)
 	IPC_CB(skb)->mapping = 0;
 	dev_kfree_skb(skb);
 }
+
+static int pm_notify(struct notifier_block *nb, unsigned long mode, void *_unused)
+{
+	if (mode == PM_HIBERNATION_PREPARE || mode == PM_RESTORE_PREPARE) {
+		if (pci_registered) {
+			pci_unregister_driver(&iosm_ipc_driver);
+			pci_registered = false;
+		}
+	} else if (mode == PM_POST_HIBERNATION || mode == PM_POST_RESTORE) {
+		if (!pci_registered) {
+			int ret;
+
+			ret = pci_register_driver(&iosm_ipc_driver);
+			if (ret) {
+				pr_err(KBUILD_MODNAME ": unable to re-register PCI driver: %d\n",
+				       ret);
+			} else {
+				pci_registered = true;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static struct notifier_block pm_notifier = {
+	.notifier_call = pm_notify,
+};
+
+static int __init iosm_ipc_driver_init(void)
+{
+	int ret;
+
+	ret = pci_register_driver(&iosm_ipc_driver);
+	if (ret)
+		return ret;
+
+	pci_registered = true;
+
+	register_pm_notifier(&pm_notifier);
+
+	return 0;
+}
+module_init(iosm_ipc_driver_init);
+
+static void __exit iosm_ipc_driver_exit(void)
+{
+	unregister_pm_notifier(&pm_notifier);
+
+	if (pci_registered)
+		pci_unregister_driver(&iosm_ipc_driver);
+}
+module_exit(iosm_ipc_driver_exit);
-- 
2.39.5



