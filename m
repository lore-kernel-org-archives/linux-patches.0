Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1D73E7631;
	Fri,  4 Sep 2026 05:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501530; cv=none; b=lMmUZjM77wkd6bAsnzm3ueM554P/yxJ5bCa15EY93Qihywuost3JYzeAf4dN4U0++9ZmCy/NDaGBlsHK0Qx5SKlgmPRrGpT0WXr7oRgIkOhXN2h/q41WGtFOjYjNcYb5AS4jmyBNbK1z/SDZpVaLpK2iOpzimxODgkmQlUm9DFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501530; c=relaxed/simple;
	bh=PrP5ZxIFQZPONiCjR7Uf6SPThByeTZYVv045kfw88Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG6McjvXG5Ac1iWiyWUHOWVBo2Qx5EwldF2P0MMFW0EiEb3R90I6q4mr88XF/BUeqzIcTDKJNiecwWf887jkYAan8h1q3mtwLSA1TPJ18+TB8cFsR4ZZxHF76rxjAs5YuGyWRiHw/8jJvilm/7KAeNSDoa+KfE9pmyKCpcHxygw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOKPT563; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOKPT563"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31EC1F00A3D;
	Fri,  4 Sep 2026 05:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501529;
	bh=C89OWq8gv8DvVvJE1iqv5HQS73Cmq1ZPZ6zo3nLh/tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOKPT563VXm627uhZdpFzF6KUU6nJ4py+DQ8wRsStjOm1eZighOXMXJ3UZp9GrpNM
	 MCojK2Iom7ebhVJyK8TtSrf9geFRj9ACLgOCqGg787txegqQ+RhExJx8gp5vnl7gMH
	 nkGRF2TzqoHFe5HOR6aYe68wbzuPML7bwb0OUUtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 6.18 398/552] PCI/MSI: Enable memory decoding before restoring MSI-X messages
Date: Fri,  4 Sep 2026 06:59:15 +0200
Message-ID: <20260904045759.405361299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -860,6 +860,7 @@ void __pci_restore_msix_state(struct pci
 {
 	struct msi_desc *entry;
 	bool write_msg;
+	u16 cmd;
 
 	if (!dev->msix_enabled)
 		return;
@@ -869,6 +870,14 @@ void __pci_restore_msix_state(struct pci
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
@@ -879,6 +888,7 @@ void __pci_restore_msix_state(struct pci
 		}
 	}
 
+	pci_write_config_word(dev, PCI_COMMAND, cmd);
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
 


