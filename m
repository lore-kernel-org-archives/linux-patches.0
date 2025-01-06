Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B2B1D7E21;
	Mon,  6 Jan 2025 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178622; cv=none; b=mueLvtnzBI5P9TcpeZnQiSoZ3bM+MZ0r9EDUU9e+IQeVHjfDb2nKchNAwFvoADflwhVocuK0Jz8Ab871nfS5/V8k7el//Ox6aUnpRLVozvesaEkyU+neFKUkQXSG5WBtgfrAeFlZqTobJkwI5NmOHWDKHB+jcP/MkHdhjMkx9xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178622; c=relaxed/simple;
	bh=P/+IRlJAN2XZLrJ9Mjcgiy8Hg7489bOGU+q8GyK5yGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKTNrpyWH/r41UHicpeoSrNkvjpplBRzx3WuksCPftOpSJGeQQdswrOWzBUKoZcgGtku+pBTiCUD7ek1raauy2UhiCOQS2aoPpfC2GdMdbWNCbQC6iLOErYB1qrRvJzOIy8RVjzsgc8f6UQS4MRnf3TTYRbWB+GnWP3rJj+584g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtTbTnn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtTbTnn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96C3C4CED2;
	Mon,  6 Jan 2025 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178621;
	bh=P/+IRlJAN2XZLrJ9Mjcgiy8Hg7489bOGU+q8GyK5yGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtTbTnn3i2t1zUiR43EZm0Po8eRQl29mfXTVQd6JzvNns+tPbgdGKOoIEv7/uZ2pY
	 SV+OhvV+qjNzfTPq99N3WhwDAhXA4ryvVYvJeiIA7o9Ei03W71euXQqWQdJ1fIyejP
	 u+ViJo5lyrwfEnHSVA8cmiXQqo3KGdnTJLfOaYC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Gospodarek <gospo@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/168] PCI: Add ACS quirk for Broadcom BCM5760X NIC
Date: Mon,  6 Jan 2025 16:15:16 +0100
Message-ID: <20250106151138.775420424@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajit Khaparde <ajit.khaparde@broadcom.com>

[ Upstream commit 524e057b2d66b61f9b63b6db30467ab7b0bb4796 ]

The Broadcom BCM5760X NIC may be a multi-function device.

While it does not advertise an ACS capability, peer-to-peer transactions
are not possible between the individual functions. So it is ok to treat
them as fully isolated.

Add an ACS quirk for this device so the functions can be in independent
IOMMU groups and attached individually to userspace applications using
VFIO.

[kwilczynski: commit log]
Link: https://lore.kernel.org/linux-pci/20240510204228.73435-1-ajit.khaparde@broadcom.com
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6b76154626e2..24fde99c11a7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4982,6 +4982,10 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_BROADCOM, 0x1750, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0x1751, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0x1752, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1760, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1761, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1762, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1763, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
-- 
2.39.5



