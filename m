Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D4535AC33
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302709; cv=none; b=O9GOPfXIuvxZ/XoC9rFDY9x+cZ2a36EFLDt+owSnNTLLwBojpyW/xp/9hTBT08W4zSRYaYRBfUFxauGqsEyXR+4LNXO/MfPZBsFi7j7IO8aZuy+4MRG3QSOdFKmv5jr+JHHs2Eak3DNfKaEc/Lmbva5h9QfwV/lUUoEFM0nAStY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302709; c=relaxed/simple;
	bh=IRI9imtotmZu7oIjoD2tmjcQUbb44cROSDp1h7bJPZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ID4jhayfYrvxEfIRDhhC0xz58n2mtWoznnfBgpBRqHhWrGFP/H3MCyKSaZtMsFSK7pcPRic2A+MzrQOB1cPiyaP8rxmpTrtDMoy4C976C7uo4kVZPo415e6B6IDC9XSk8C1mIcgPaZwuEQQSDRDjW1aWRAQ1OEAiBsZRAqOoAeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4eWNIsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4eWNIsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72958C116D0;
	Sat, 28 Feb 2026 18:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302708;
	bh=IRI9imtotmZu7oIjoD2tmjcQUbb44cROSDp1h7bJPZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4eWNIsm3pW1K2FpBZuZY6wz4cq4YTlQXkCmL8RgBEKQeg35hNbFXW78n6Kz2RSk0
	 EBURpcbqXcQrW1NtJpqbWIdWdkRZDICTF6GF3hcHExaIO4QDmw33l85LMnDyrHMglZ
	 NV1Z/jG5afGOoxhMKF+4TxJHjfXBeHsUz9hczXpbUMMZfiaVttPHLH98+i/LBCBGh7
	 MgDFDnjtsZXOFBwv9bNc4ucvVk8CZW7qLRtzF5DT02dJuEXwbj/ph5bEuBO7aCbJ3t
	 3vE/PrXdlBi+xoa7wZMTGJrhcqOh4EkvZSHIPeJZxifGXbOtkXF+mdw1vNy+GNyewM
	 ywSn7E6BiLtvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?J=C3=B6rg=20Wedekind?= <joerg@wedekind.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/147] PCI: Mark 3ware-9650SA Root Port Extended Tags as broken
Date: Sat, 28 Feb 2026 13:16:15 -0500
Message-ID: <20260228181736.1605592-67-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index ac355ae17bfee..c925e0be5f476 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5405,6 +5405,7 @@ static void quirk_no_ext_tags(struct pci_dev *pdev)
 	pci_walk_bus(bridge->bus, pci_configure_extended_tags, NULL);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1004, quirk_no_ext_tags);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1005, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0132, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0140, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0141, quirk_no_ext_tags);
-- 
2.51.0

