Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF5D3EDE49;
	Tue, 12 May 2026 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608711; cv=none; b=Ewv3YR/jBBTosLtuZcOcsI80QfT6+R6rraCXSYoy+NV8USN29YEmVus8NStwajBWZxF6dqIk6BKEdTxmfcrO7yuw/lsoVp7yPZKCsvUGM9Rb2lLAvnws7lPJWD9ZX2JKD3UMHinstdTpARrecVLJkEXRx/y5RxE89Mcq1YVx09E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608711; c=relaxed/simple;
	bh=UMoi2F4ogsC26P/EupL2QINGkoazul/nZiGye03LqnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHCbQWSrm2XQoH+L2SN+M2geMfelIqGrnDBWgrc4fRznHdEI+DhbwQ9HhqevVMUw0GoRyMjr4nwGcZ/K8b1dNDnDBkC1aOns9Tum/L7Q6TnnLkvT2jPz59XWH1WgbTNcYD2ek5hifof/fs8Qah09luFtc2xJVVGvDU5GUC2Z3x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iv3AxiAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iv3AxiAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB59FC2BCB0;
	Tue, 12 May 2026 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608711;
	bh=UMoi2F4ogsC26P/EupL2QINGkoazul/nZiGye03LqnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iv3AxiAVq6sSPbLBTMPFWKxOX7TFFaKC45tas7kcL+DNTsbb0JYV0779S9ApkjMmz
	 CFWaZmB0ymOFvhHaidbM/rfs8081PD8kdswvzbDE/+p7ShC6BNDULtfhjbciFX6Pxj
	 KDkIxAzH4GF0dMSuChJgXg5HBNguKKQla+797Sf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schumacher <bernd@bschu.de>,
	"Alexandre N." <an.tech@mailo.com>,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.18 185/270] PCI: Update saved_config_space upon resource assignment
Date: Tue, 12 May 2026 19:39:46 +0200
Message-ID: <20260512173942.342989601@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 909f7bf9b080c10df3c3b38533906dbf09ff1d8b upstream.

Bernd reports passthrough failure of a Digital Devices Cine S2 V6 DVB
adapter plugged into an ASRock X570S PG Riptide board with BIOS version
P5.41 (09/07/2023):

  ddbridge 0000:05:00.0: detected Digital Devices Cine S2 V6 DVB adapter
  ddbridge 0000:05:00.0: cannot read registers
  ddbridge 0000:05:00.0: fail

BIOS assigns an incorrect BAR to the DVB adapter which doesn't fit into the
upstream bridge window.  The kernel corrects the BAR assignment:

  pci 0000:07:00.0: BAR 0 [mem 0xfffffffffc500000-0xfffffffffc50ffff 64bit]: can't claim; no compatible bridge window
  pci 0000:07:00.0: BAR 0 [mem 0xfc500000-0xfc50ffff 64bit]: assigned

Correction of the BAR assignment happens in an x86-specific fs_initcall,
pcibios_assign_resources(), after device enumeration in a subsys_initcall.
This order was introduced at the behest of Linus in 2004:

  https://git.kernel.org/tglx/history/c/a06a30144bbc

No other architecture performs such a late BAR correction.

Bernd bisected the issue to commit a2f1e22390ac ("PCI/ERR: Ensure error
recoverability at all times"), but it only occurs in the absence of commit
4d4c10f763d7 ("PCI: Explicitly put devices into D0 when initializing").
This combination exists in stable kernel v6.12.70, but not in mainline,
hence Bernd cannot reproduce the issue with mainline.

Since a2f1e22390ac, config space is saved on enumeration, prior to BAR
correction.  Upon passthrough, the corrected BAR is overwritten with the
incorrect saved value by:

  vfio_pci_core_register_device()
    vfio_pci_set_power_state()
      pci_restore_state()

But only if the device's current_state is PCI_UNKNOWN, as it was prior to
commit 4d4c10f763d7.  Since the commit, it is PCI_D0, which changes the
behavior of vfio_pci_set_power_state() to no longer restore the state
without saving it first.

Alexandre is reporting the same issue as Bernd, but in his case, mainline
is affected as well.  The difference is that on Alexandre's system, the
host kernel binds a driver to the device which is unbound prior to
passthrough, whereas on Bernd's system no driver gets bound by the host
kernel.

Unbinding sets current_state to PCI_UNKNOWN in pci_device_remove(), so when
vfio-pci is subsequently bound to the device, pci_restore_state() is once
again called without invoking pci_save_state() first.

To robustly fix the issue, always update saved_config_space upon resource
assignment.

Reported-by: Bernd Schumacher <bernd@bschu.de>
Closes: https://lore.kernel.org/r/acfZrlP0Ua_5D3U4@eldamar.lan/
Reported-by: Alexandre N. <an.tech@mailo.com>
Closes: https://lore.kernel.org/r/dd3c3358-de0f-4a56-9c81-04aceaab4058@mailo.com/
Fixes: a2f1e22390ac ("PCI/ERR: Ensure error recoverability at all times")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Bernd Schumacher <bernd@bschu.de>
Tested-by: Alexandre N. <an.tech@mailo.com>
Cc: stable@vger.kernel.org # v6.12+
Link: https://patch.msgid.link/febc3f354e0c1f5a9f5b3ee9ffddaa44caccf651.1776268054.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-res.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -102,6 +102,7 @@ static void pci_std_update_resource(stru
 	}
 
 	pci_write_config_dword(dev, reg, new);
+	dev->saved_config_space[reg / 4] = new;
 	pci_read_config_dword(dev, reg, &check);
 
 	if ((new ^ check) & mask) {
@@ -112,6 +113,7 @@ static void pci_std_update_resource(stru
 	if (res->flags & IORESOURCE_MEM_64) {
 		new = region.start >> 16 >> 16;
 		pci_write_config_dword(dev, reg + 4, new);
+		dev->saved_config_space[(reg + 4) / 4] = new;
 		pci_read_config_dword(dev, reg + 4, &check);
 		if (check != new) {
 			pci_err(dev, "%s: error updating (high %#010x != %#010x)\n",


