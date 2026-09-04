Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB77419FBB;
	Fri,  4 Sep 2026 06:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502697; cv=none; b=JFzst1m7QbWBGLSBTLj9EfhKTrfYL7QTf3kYne2aFqg1KiIpqC9LcFNJvEhAA9y3nF2SU7Ds8/06Woc8huED/zCffVbdoGSmFXIMoffeCKqYBNbYaVYj1JyFd4eSLNxYYg5QjfyoBdOC1pvbZPQ09xb+BnYfkJJsDTG3srDD9n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502697; c=relaxed/simple;
	bh=7n8qzOz21Tc0Wn65VsE3HpG8uXbkBtyA+vRXdL7l8H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J75lmaFyLIKjhGkDoUaN3sfErK6R9PHDJQyyEz5S0UJFU5bV5IrGuwJYU1XfNDydS6LwxFGl3KQSUqP4M7XWjyvGgA8uievkRC19tFQP/3l8xLtjQRu33T7LA/Yb6DbVJOF5Reqhzbta1uYpPm7o7fzrMW1M6KOXAPQAGvq9V0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVK3AbcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVK3AbcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57B11F00A3D;
	Fri,  4 Sep 2026 06:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502696;
	bh=KPx2EBgt4iHTdsc6YVqDEvzOxKlGL1vVlc4t44qR7Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVK3AbcD3k3Qs/xkmi+IoD3nWen4aomPiUZgkHYzIpep1fmWKpKjQSvhH4zZ1CbYV
	 34JIxSlu5CRoglVYINM0437Puh7hUrQbA5c/fB3Rt/ZqwAjhl0vCSBxSNI24e6mzdr
	 7xWKRmDPmmRul2NY8ENJtt5FmY6cixEr0tytwsJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 6.12 298/403] PCI/MSI: Enable memory decoding before restoring MSI-X messages
Date: Fri,  4 Sep 2026 07:01:41 +0200
Message-ID: <20260904045741.621263481@linuxfoundation.org>
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

From: Farhan Ali <alifm@linux.ibm.com>

commit 231c7a57d19304beb0931e6cbe3a4929daf49747 upstream.

The current MSI-X restoration path assumes the Command register Memory bit
is enabled when writing MSI-X messages. But it's possible the last saved
and restored state of a device may not have the Memory bit enabled, even if
a device driver later enables Memory bit and MSI-X. Attempting to access
Memory space without Memory bit enabled can lead to Unsupported Request
(UR) from the device. Fix this by enabling Memory bit and restore it
afterwards.

Fixes: 41017f0cac92 ("[PATCH] PCI: MSI(X) save/restore for suspend/resume")
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
[bhelgaas: comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260805165518.794-6-alifm@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi/msi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -862,6 +862,7 @@ void __pci_restore_msix_state(struct pci
 {
 	struct msi_desc *entry;
 	bool write_msg;
+	u16 cmd;
 
 	if (!dev->msix_enabled)
 		return;
@@ -871,6 +872,14 @@ void __pci_restore_msix_state(struct pci
 	pci_msix_clear_and_set_ctrl(dev, 0,
 				PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL);
 
+	/*
+	 * The restored device state may not have Memory Space enabled.
+	 * Since the MSI-X Table and PBA are in Memory Space, enable it
+	 * while restoring them.
+	 */
+	pci_read_config_word(dev, PCI_COMMAND, &cmd);
+	pci_write_config_word(dev, PCI_COMMAND, cmd | PCI_COMMAND_MEMORY);
+
 	write_msg = arch_restore_msi_irqs(dev);
 
 	msi_lock_descs(&dev->dev);
@@ -881,6 +890,7 @@ void __pci_restore_msix_state(struct pci
 	}
 	msi_unlock_descs(&dev->dev);
 
+	pci_write_config_word(dev, PCI_COMMAND, cmd);
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
 


