Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170673B71A0;
	Fri,  4 Sep 2026 05:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499758; cv=none; b=IJX7lKfQlTQNSujEgfBEErglHfqrTrrU42HyLL5+3asjKOF6QzaNMqZF6DliFPYbauw9cOcQ1RN61BBlRAkKCGPzNkNiURkwjr176SXH4OLkaSQWX2pIIWmhQIIjyRivoc9SaTc41+rSnIHciSHi6QrNrbBZvr3tM+sNErKPjbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499758; c=relaxed/simple;
	bh=8zRDIBYOICp/Hfs4c0ZoO6u5/cuA9qbhnRWuv8ei77A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDK8Pc/2AMffgijL2imshfnyQul7TvP3AAFyS/U/rCFnZTsDFfwOY3mhZ8brk0Er0kD5Bsbb+3F2DaUc7RH5ywWqIDsI5CUN2XI0cuea0afLiKg54fWeI4kimm9O/DNWpzuO7yLVpEHjG1ViZuNeagITOxpKZsAO5Tk+BOgqz1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFkLYLse; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFkLYLse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D5F1F00A3D;
	Fri,  4 Sep 2026 05:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499757;
	bh=Dine1PVVjDnW2er+eHHnUFV5BJ56pXy+UWxYE2ejkaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFkLYLsezoI1Kk3v7L/MySBsxvAYlmI3+hrkaQ/JC9v1FaKLX4qwtqHiimmr5Nyhl
	 yTpQWsDgPgjpxhkMnH9z+fsja75C8ZL+Zwlmg96SyyK47A9Z637UkHyXAinUpazDCt
	 +INb1ji10Hv14MbnWzLd+AtcVt0z7jwTw3EmZ9Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7.2 529/713] PCI/AER: Emit TLP Log only for unmasked errors
Date: Fri,  4 Sep 2026 06:58:17 +0200
Message-ID: <20260904045815.679093346@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit a8bf2dd750de7d682fdaa2127f4e3217ce9c4a82 upstream.

Per PCIe r7.0 sec 6.2.5, the prefix and header of an offending TLP is only
recorded for unmasked Uncorrectable Errors.  Yet when the AER driver
determines whether a prefix and header has been logged, it does not take
the Uncorrectable Error Mask Register into account.  Fix it.

Fixes: 6c2b374d7485 ("PCI-Express AER implemetation: AER core and aerdriver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v2.6.19+
Link: https://patch.msgid.link/2e712b96ba5bfc729d78bfc23f7fb7d285aa3d6d.1784905909.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -942,7 +942,8 @@ void pci_print_aer(struct pci_dev *dev,
 		status = aer->uncor_status;
 		mask = aer->uncor_mask;
 		info.level = KERN_ERR;
-		tlp_header_valid = tlp_header_logged(status, aer->cap_control);
+		tlp_header_valid = tlp_header_logged(status & ~mask,
+						     aer->cap_control);
 	}
 
 	info.status = status;
@@ -1336,7 +1337,7 @@ int aer_get_device_error_info(struct aer
 		pci_read_config_dword(dev, aer + PCI_ERR_CAP, &aercc);
 		info->first_error = PCI_ERR_CAP_FEP(aercc);
 
-		if (tlp_header_logged(info->status, aercc)) {
+		if (tlp_header_logged(info->status & ~info->mask, aercc)) {
 			info->tlp_header_valid = 1;
 			pcie_read_tlp_log(dev, aer + PCI_ERR_HEADER_LOG,
 					  aer + PCI_ERR_PREFIX_LOG,


