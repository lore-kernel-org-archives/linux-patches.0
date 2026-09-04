Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C28638E8DD;
	Fri,  4 Sep 2026 05:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499772; cv=none; b=SfTEb7aHieRFlbQSMb5po4UYET3ot7CLJn6F5HDNr160FZ8D6ixUX+Nyp8my/6KEnGgPhdxDKXcb2G8bKDN09mrhDzbliqv8fQmtb68YWH3MT6Cv1U1SSOnLeKiXEGHDBpiChBEYrxUWFxGKCddOAshGFSOKeR/C0lApeqkVHUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499772; c=relaxed/simple;
	bh=NST2Ep4uHIyh7yEXSZbuuTXE6v0qpbXwOvYgJGX7PNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEooRr10pkHi9ONZ2y4bNaSMd4Op1VjF3TgUrlVZN+dvOkjbHnCME7OPKSKMa4rt0oFXwlwx0FLeRsxK8ld//cV9OKlUtczxZwYya9B8l+URYkVzfleO4c5CrhRIgJ/ptn4M5QTMMCYp1kv2wK+bu8iWOdcgjzcW9mCZPtxgPRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixJn+MVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixJn+MVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968871F00A3D;
	Fri,  4 Sep 2026 05:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499771;
	bh=Twkmgu0IoYc4J6srQyf/k/+Oo15/rcusW+qBKInB0tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixJn+MVGSdlt179MFYrKdbvY6PqT75wq/lVCw9eDS3pcF+dQr6xFnj/ITWJfZALE9
	 vODKeQvWjjwUATna+R7lOSSH8YFfY8e/RDXSy9GSXRw97wyNpcIf7xWe6b3Fr5Mb1D
	 gvI5DUYGhjVbnOdM9J6YFg/llIpru19rdPAa28zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 7.2 533/713] PCI/MSI: Enable memory decoding before restoring MSI-X messages
Date: Fri,  4 Sep 2026 06:58:21 +0200
Message-ID: <20260904045815.766249598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -870,6 +870,7 @@ void __pci_restore_msix_state(struct pci
 {
 	struct msi_desc *entry;
 	bool write_msg;
+	u16 cmd;
 
 	if (!dev->msix_enabled)
 		return;
@@ -879,6 +880,14 @@ void __pci_restore_msix_state(struct pci
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
 
 	scoped_guard (msi_descs_lock, &dev->dev) {
@@ -889,6 +898,7 @@ void __pci_restore_msix_state(struct pci
 		}
 	}
 
+	pci_write_config_word(dev, PCI_COMMAND, cmd);
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
 


