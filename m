Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7814ED1AD;
	Thu, 17 Sep 2026 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667950; cv=none; b=mQ+x6MdUYB/pfyCgg/TlXh01kojXy5YYQNSr/enkO8RZ54d8zj2S3blNof26SNbQzOn0TPDnfIoJeipUmkmoHkue432um1z46UnzazlCgT6QFKjgudyLYFajTwVuA56VlnNawazcDePLQuTGAMWXXrh7H2KmoTE58VEuFN980EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667950; c=relaxed/simple;
	bh=fI6brGfXrnKkPkkngeXE1P1blD58ct2afkSCzqw3rmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODvzSgR4QtuV/adU4yqgMQprEsXMeViXDoMkOJg0zqbY7Kd7TICrKFdWgtjo02FjQYa3ftUgc2dv8usUfa7uV9yTcCF7xtIzkTazJLudTV+ZzdYS4I7Z8JE+imI5FLVHwmjNTLKt3a1hwFkSPmg+wSpHiXVbJHnCASVDtfuJtY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQq5SUNF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQq5SUNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704821F000FF;
	Thu, 17 Sep 2026 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667949;
	bh=Yc6DCKTk/oOkyJhAybfKxONkPnI3Egr9Hs8SauFBHsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQq5SUNFH5CSlHzrbOxgYM5/s0yRs/U60I3wjyq65Wn51EXmiI7WypGjkqzP31tHC
	 QVN7j5QD58Ti2FssXBaoLpLWHjhGDL57oL4T7YB32nRRGyuPXrcQAfwPW48rUQyYEI
	 bUsFNAar/idjtAMpw0djJZE9q02ijbMQnemmhGhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0264/1102] PCI: Avoid FLR for MediaTek MT7925 WiFi
Date: Thu, 17 Sep 2026 16:03:27 +0100
Message-ID: <20260917151546.229791019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 9f22b92259bb5ac43e2b9007103787d4418fec56 ]

The MediaTek MT7925 WiFi device advertises FLR capability, but it does not
work correctly. This manifests in VFIO passthrough scenarios. Normal VM
operation works fine, including clean shutdown/reboot. However, when the VM
terminates uncleanly (crash, force-off), VFIO attempts to reset the device
before it can be assigned to another VM. Because FLR is broken, the reset
fails, preventing reuse.

This is similar to its predecessor MT7922 (see 81f64e925c29 ("PCI: Avoid
FLR for Mediatek MT7922 WiFi")), but with different symptoms.  The MT7922
issue manifests as config read failures (returning ~0) after FLR. The
MT7925 shows different behavior: config reads work correctly after FLR, but
firmware communication fails.

First VM start with MT7925 works fine:

  mt7925e 0000:08:00.0: ASIC revision: 79250000
  mt7925e 0000:08:00.0: WM Firmware Version: ____000000, Build Time: 20260106153120

After force reset or VM crash, when VFIO attempts FLR to reset the device
for reassignment, firmware initialization fails:

  mt7925e 0000:08:00.0: ASIC revision: 79250000
  mt7925e 0000:08:00.0: Message 00000010 (seq 1) timeout
  mt7925e 0000:08:00.0: Failed to get patch semaphore
  [Repeats with increasing sequence numbers 2-10]
  mt7925e 0000:08:00.0: hardware init failed

The driver cannot acquire the patch semaphore needed for firmware
initialization, indicating that FLR does not properly reset the firmware
state. The device remains in this broken state until physical power cycle.

Disable FLR for MT7925 so the PCI core falls back to other reset methods,
e.g., Secondary Bus Reset, which successfully resets the device and allows
reinitialization for VFIO passthrough reuse.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260522070646.203115-1-jtornosm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f75f74214389d..db667115b34ed 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5558,6 +5558,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
  * Intel 82579LM Gigabit Ethernet Controller 0x1502
  * Intel 82579V Gigabit Ethernet Controller 0x1503
  * Mediatek MT7922 802.11ax PCI Express Wireless Network Adapter
+ * Mediatek MT7925 802.11be PCI Express Wireless Network Adapter
  */
 static void quirk_no_flr(struct pci_dev *dev)
 {
@@ -5570,6 +5571,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x0616, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x7925, quirk_no_flr);
 
 /* FLR may cause the SolidRun SNET DPU (rev 0x1) to hang */
 static void quirk_no_flr_snet(struct pci_dev *dev)
-- 
2.53.0



