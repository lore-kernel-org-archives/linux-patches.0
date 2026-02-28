Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2CD375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302560; cv=none; b=QY3lYJR/A64WyO3YmnZE7u3Xc8hPZ/HLi5NCg9PmLPWVvx/KQadoaLW6E9/KG+lbDqBdDUHCL1s8Z42a5vEheNUu2XQcHdcB3pgicKOUbSmoA3/mdbQ6e0fykx44KKJxwJMoorZQsfTkNflajNWqP8B7J/RHi/1XqUKPWn9KzzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302560; c=relaxed/simple;
	bh=niydhbNNsZxrKwhLW5+0bPm9qzHi3e1VQVvEZqUHNIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mcvRNiUdN5VJbdvGqahOpjJI6GTFx5D0Maorw3tAh4Kj7DROukaNNVilwTpvXSvIS4iersw64erjUfdlE/e9Lt3F9PtVhNNPOmHyEO2/HCW5aPeD4+/DwQAUrJ/03rXQT6dGe5ymQXCEdcj1U3n7BA5LIbs62Z03BUc8FywzZ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o6PEz2S5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o6PEz2S5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA29C19425;
	Sat, 28 Feb 2026 18:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302560;
	bh=niydhbNNsZxrKwhLW5+0bPm9qzHi3e1VQVvEZqUHNIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6PEz2S5aky0zGRgyEWqSTbo4txSSNVgkgBYGLN2OgRSs/r1ezd5iaq3XoXHZbGOx
	 uSC6FhWyHJA9fprCMTHBkbYkL+mjzzXX2ov9jHRJ1PhpSuVQ73aVBq9/RCdfhX+tHL
	 f60pW1V1qhEk/+QuXhoak+mxXW+S84Sk0ajve+WH3Q+7aiTEAIEd61T1HLSgNJ3qB0
	 dV1eqF9X1YSU1nnPwiiH0vtXQY5mIJ5ygEVOrA/pc1uPICTKPn6CQYK+jcIlKyDsM2
	 cV2hLEvlvAx4XnMuqXq5lHgmFt84Dr1HrddXSZFqgRUi1wPbCWZddxkIXURw2IPDtb
	 bnlDV+OVCa5AQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?J=C3=B6rg=20Wedekind?= <joerg@wedekind.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/164] PCI: Mark 3ware-9650SA Root Port Extended Tags as broken
Date: Sat, 28 Feb 2026 13:13:25 -0500
Message-ID: <20260228181505.1600663-66-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 7597aedc05c37..88922e21d440a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5431,6 +5431,7 @@ static void quirk_no_ext_tags(struct pci_dev *pdev)
 	pci_walk_bus(bridge->bus, pci_configure_extended_tags, NULL);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1004, quirk_no_ext_tags);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1005, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0132, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0140, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0141, quirk_no_ext_tags);
-- 
2.51.0

