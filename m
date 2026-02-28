Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D79636C9EC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302375; cv=none; b=u8FqHegK9B6j6Oe3X3V6cHpm3oDjqRQiMBjxx4YD8vlNpb5s3v63GEtUq2VXiAteCVaFQoix2CMD3NoyNHTB7+SyXYp7xAU8u2gEx4mjIOEuatSsTrnAdTQOvMEP5X3n7xYlvARH48GzV0kD8tanU+6KCra9cWaRaUeQJ23S5co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302375; c=relaxed/simple;
	bh=iOBdFpxqjEAIIItBaV+TwPLqZ2rOxg8J4A5y6gtYFiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F8Z/Syq8Zek2pFrwb/C85wlxQ+Xr0ChLR6pAWoXknd6tteaNU2Y6azcTjapjCmKjINhGRC2oRLUKm5ylXjsQoR9xLgQITheNrfvv63Gu7AbGE15oHyGu4J2RbZbEYdyl8NT4S3bE4IyZU5U/Sn1dlzROZfItAOwB1/KW8/Ia/MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3NQGPZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3NQGPZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D94BC2BC87;
	Sat, 28 Feb 2026 18:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302374;
	bh=iOBdFpxqjEAIIItBaV+TwPLqZ2rOxg8J4A5y6gtYFiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3NQGPZEcX28EgzgcLNyzvAb64UdyxRNWDRRoxzR/VIaG5e/uDw1ULqcgP7YiANAl
	 sO4wQuxM/JP3FSv6F2EhziahcBAd0cyzuK/k+N6HRvd75OD9oi7ga+cKK07SFm82+I
	 JI4fz/aqTOpkSSUwZDcvy3U+NZnsnz+i7+iA8R4WOEB04Mj0s2V61UVC/x6aanCgL8
	 VwusdPTPR+KQPiqacT06kOFV7mpxQRRiPiFsvw/qt8+Np7Xhu+Iv1mC5xlp1+D0OhI
	 cBSLTXEPUWRNv4nnUhT3PLJc+SKEn/NpVxgqbGyT/5UxVA/Efrsm+IPhap+25ZGmgn
	 pW1iFlbE7K54A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?J=C3=B6rg=20Wedekind?= <joerg@wedekind.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/232] PCI: Mark 3ware-9650SA Root Port Extended Tags as broken
Date: Sat, 28 Feb 2026 13:09:15 -0500
Message-ID: <20260228181127.1592657-102-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jörg Wedekind <joerg@wedekind.de>

[ Upstream commit 959ac08a2c2811305be8c2779779e8b0932e5a99 ]

Per PCIe r7.0, sec 2.2.6.2.1 and 7.5.3.4, a Requester may not use 8-bit Tags
unless its Extended Tag Field Enable is set, but all Receivers/Completers
must handle 8-bit Tags correctly regardless of their Extended Tag Field
Enable.

Some devices do not handle 8-bit Tags as Completers, so add a quirk for
them.  If we find such a device, we disable Extended Tags for the entire
hierarchy to make peer-to-peer DMA possible.

The 3ware 9650SA seems to have issues with handling 8-bit tags. Mark it as
broken.

This fixes PCI Parity Errors like :

  3w-9xxx: scsi0: ERROR: (0x06:0x000C): PCI Parity Error: clearing.
  3w-9xxx: scsi0: ERROR: (0x06:0x000D): PCI Abort: clearing.
  3w-9xxx: scsi0: ERROR: (0x06:0x000E): Controller Queue Error: clearing.
  3w-9xxx: scsi0: ERROR: (0x06:0x0010): Microcontroller Error: clearing.

Fixes: 60db3a4d8cc9 ("PCI: Enable PCIe Extended Tags if supported")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=202425
Signed-off-by: Jörg Wedekind <joerg@wedekind.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260119143114.21948-1-joerg@wedekind.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e8cfae79a47a9..fc793635a3d81 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5465,6 +5465,7 @@ static void quirk_no_ext_tags(struct pci_dev *pdev)
 	pci_walk_bus(bridge->bus, pci_configure_extended_tags, NULL);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1004, quirk_no_ext_tags);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1005, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0132, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0140, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0141, quirk_no_ext_tags);
-- 
2.51.0

