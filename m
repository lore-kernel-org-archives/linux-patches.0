Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD3247A87A;
	Sat, 12 Sep 2026 13:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220677; cv=none; b=l539m5GnQAxcJPJwe+1CwWqPlIWJRguUXtKrEhW/q0F8HyPYnY6vsQdrgQailv+7HIH6DQjoOrZJijbQW2InoG5P73hwXSP55nbdH38VUNTYpGBHKaqCarYnZjHiyJIUV6+KNQYkUCwBWNAjhzPX3a2hG3PC599TdGVVaRtVvtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220677; c=relaxed/simple;
	bh=un/5m7ga3HWWoV/WuM8PbxM87OSaW4SwZwFAMPJmWsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxBF3uyduhxQ1DPTq+MZrNtH9neWSXHFzwIGqHOryMLGBojCjxERKUCOVuXi/QiJ7pjd487QuyyVxZE6PdSSUwbNAmofk0XRnMd83uOoAbJjMNankcmI6IWTdDPsNO4eGJMj2T+LljgWcBqB2/l63c4yMYn8PJZXvlMsIF3jTw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8Ym0/VR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8Ym0/VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2517E1F000FF;
	Sat, 12 Sep 2026 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220675;
	bh=kCK9hHYJ1mq/VayEcpLcSDmujUlxcJUMkHqsuALmQDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8Ym0/VR2s8tGLxIiOs1q/NvF4xRb5E/9774Nojzouqxt71d+HIUAdUwcOreuDPVi
	 UXQjz0sHVuYmeJq/lRm6RiAorkxaOTMUnzfHD73/umC5uW3y4cxaHvjaoNMFRsM5nA
	 kR9Ikl+nwcL2kUlebWhM1tKVYPXXq7/+quOZENl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 6.6 0226/1424] PCI/MSI: Enable memory decoding before restoring MSI-X messages
Date: Sat, 12 Sep 2026 08:44:18 +0200
Message-ID: <20260912065612.345967267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -858,6 +858,7 @@ void __pci_restore_msix_state(struct pci
 {
 	struct msi_desc *entry;
 	bool write_msg;
+	u16 cmd;
 
 	if (!dev->msix_enabled)
 		return;
@@ -867,6 +868,14 @@ void __pci_restore_msix_state(struct pci
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
@@ -877,6 +886,7 @@ void __pci_restore_msix_state(struct pci
 	}
 	msi_unlock_descs(&dev->dev);
 
+	pci_write_config_word(dev, PCI_COMMAND, cmd);
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
 


