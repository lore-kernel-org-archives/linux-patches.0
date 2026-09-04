Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9214A41D104;
	Fri,  4 Sep 2026 06:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502691; cv=none; b=TeG21ZW/mr9AjQdDggBVoTe93QD1U+yzUPBh2RHVlOq1q+LItEnNv2oocv2G7p9CWEFq8mIuGPPgOutrdGbon1lccqaaM2uV7Kvpaw2wzFrQrsnQFwy3Y5t+W981NKgb8TZK5itFJ86d1pZRCHpeKGpXOX9X+aQvcHYpzxi9S/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502691; c=relaxed/simple;
	bh=oZliYkjz411yAZ1SJAsBnF9ooG81QryFE9MieY4/M58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6bU0R+CzSLFJiwZCMAwn/wCLWP5HmMQNPf8TxmlXnNLqA0dAR3q1gWtcaS8mUGXgzMvEygemnJLQ6kbMHZR8iuj5RhP5wqTlrSOzBAiZHzO3uRinYKhuGPcf8pScspsJxnnZ74b7pbZ5giXQCCB+v3MuFFYr8Q6nu1HExRzhyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Via2XOBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Via2XOBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84541F00A3D;
	Fri,  4 Sep 2026 06:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502690;
	bh=7+gd6ByXvB/GVDtQ/tZlk/+7cLnDlz1yrXvDBe8VLHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Via2XOBzMShlECc6Oi4D+Sb5OUp1RKWSZtZ4ey2kL0UHgFjVpfdPoXjmwjK9uKT9W
	 xyQ3y6CNZx7ljXfTwzh60cai47gGHrzyR7tWlMNxekijSq7CHGBMfk2GSk1qh9xIJM
	 gFYA7VhxSA/M+prWSC4OhJY8FWMjTB8bdSFvPQUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Lee <max.lee@canonical.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.12 296/403] PCI/ASPM: Avoid L0s for Realtek RTS525A
Date: Fri,  4 Sep 2026 07:01:39 +0200
Message-ID: <20260904045741.576327723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Max Lee <max.lee@canonical.com>

commit ec3d987fcaf92516d13ee18c305c82281557046d upstream.

The Realtek RTS525A PCIe card reader reports an AER Correctable Replay
Timer Timeout storm when ASPM L0s is enabled on its link.  On an affected
HP ZBook Power 16 inch G11, the Root Port received tens of millions of AER
interrupts from the RTS525A even when the rtsx_pci driver was blacklisted
and the endpoint was not enabled by a driver.

For example:

  pcieport 0000:00:1c.6: AER: Multiple Correctable error message received from 0000:58:00.0
  rtsx_pci 0000:58:00.0: PCIe Bus Error: severity=Correctable, type=Data Link Layer, (Transmitter ID)
  rtsx_pci 0000:58:00.0:   device [10ec:525a] error status/mask=00001000/00006000
  rtsx_pci 0000:58:00.0:    [12] Timeout
  pcieport 0000:00:1c.6: AER: Correctable error message received from 0000:58:00.0

Testing with OS-native AER control showed that disabling only L0s on the
RTS525A link stops new AER interrupt and counter growth while leaving L1
enabled.  Disabling L1, L1 substates, or Clock PM alone did not stop the
storm.

Prevent the broken L0s configuration by removing L0s from the RTS525A
advertised ASPM capability.  This avoids enabling the non-working ASPM
state instead of masking the resulting AER Replay Timer Timeout reports.

Signed-off-by: Max Lee <max.lee@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260707021527.639611-1-max.lee@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2503,6 +2503,9 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f4, quirk_disable_aspm_l0s);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1508, quirk_disable_aspm_l0s);
 
+/* Realtek RTS525A generates a Replay Timer Timeout storm when L0s is enabled. */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_REALTEK, 0x525a, quirk_disable_aspm_l0s);
+
 static void quirk_disable_aspm_l0s_l1(struct pci_dev *dev)
 {
 	pci_info(dev, "Disabling ASPM L0s/L1\n");


