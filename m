Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBBF352022;
	Sat, 12 Sep 2026 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227489; cv=none; b=SZLVSaIbN/Im2Sch7Oz49odDoKAWTqveOJmiKE8EORmtcMKHt+xIboZ9klKy1Dr/BgjU9nAc5OyFIVOGi9xhkucUV41UjhvSmTlPwW7TKsNzwoGdfLnouRGxmbx2B/r4G/x1Pupl3c/L6WzfnMmzapQBkoodTvEh57MXokHYfTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227489; c=relaxed/simple;
	bh=YwW3/pZifYvuBvzkx+RMvapk1qUTYRPUqQKXuL1IhSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uxw2xRe0bywr4GcO/ABBPRvElERpUSqCJIoe6w6ccscLMM/Drnplnrj6qr0Eg8FDnwmnjGNWNLD9KL4vVXBENv7QV9AwNEt0ZPouvgAqQK6BAnSrJQgRnULFNSkAdfAB3oFu0NEH4VJZ2COVTV4DcxvVfXiU4OooEGAOzt+GAto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wehVIx5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wehVIx5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D1F1F000FF;
	Sat, 12 Sep 2026 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227487;
	bh=IS6S80p80D4iW6+LT3TXwUpVLQ3SF2cpwIJd+PGaYX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wehVIx5iKXwW3Ha21dq3ZAnIwVAgJjIjQVsfe7iZCfBSh1jbDOpvacWL4hN+GWdCU
	 31ggrRUskZOtVKUyPe5tFfAwB/zn5GEWNnhNipas5xZJnXnIKbtXAERR/7iM7fBC2x
	 UxqR3w3uLxxTC+YB0+UEMo0cR5CfXRPkTAcNPZyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 6.1 0189/1191] PCI/MSI: Enable memory decoding before restoring MSI-X messages
Date: Sat, 12 Sep 2026 08:48:37 +0200
Message-ID: <20260912065552.458553398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,6 +294,7 @@ static void __pci_restore_msix_state(str
 {
 	struct msi_desc *entry;
 	bool write_msg;
+	u16 cmd;
 
 	if (!dev->msix_enabled)
 		return;
@@ -303,6 +304,14 @@ static void __pci_restore_msix_state(str
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
@@ -313,6 +322,7 @@ static void __pci_restore_msix_state(str
 	}
 	msi_unlock_descs(&dev->dev);
 
+	pci_write_config_word(dev, PCI_COMMAND, cmd);
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
 


