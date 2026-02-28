Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4627B3451CC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301787; cv=none; b=cRtZvxS7lsWVdYC+tkfk6SdW+xswUXma55DxWE32xUk3Fn/Lx1RuG687r68NBxuJ9uMeRgRVa1uw8zWPDZVHKoKB9okK/ThJa3BMa2twp6GD40V491Joa+9YJOr1tF8W6xtUfvQMHMOKLA/HL7n6n+rXXVJog5uSr2IDBw7AOoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301787; c=relaxed/simple;
	bh=mPWymd1vShG5EO4bKt9vCoSSlcF+1gJDAinEBt/8KX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TNuYLxDgOgz5kca1og/hRPyeFMX472EZ58mR0EeiZ/Litq6nrXgSvjjcB7S2eCTaLr9zN5ITL7TsHVm+sb/YvkFKWKkzFy/4sIhbXH7dOr+KQcUiRZrIvxS84n78AnHnkhBfZf5lHyJwQ+0/uLO6x9sPjbCSQTuuefy6IQaIagI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+nakZku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+nakZku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF17C2BC9E;
	Sat, 28 Feb 2026 18:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301787;
	bh=mPWymd1vShG5EO4bKt9vCoSSlcF+1gJDAinEBt/8KX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+nakZku2Wk/MUqrqbWUVZU+DuEXAOylVtC7SJGhQQ1iNnMoVknbARHb8/u6rOD+0
	 lZk/kgRVC4mD5QqWRgUkSHkb+6vJuJQv9dy3zsvDMegQ7K/vF3zlz2L0og9y26atxc
	 dTaXpzEySuR9ZuPl0nwdXuZuWEpC5XijivIo0l4+yIklya6WiDmBdUGTyOgciibUEa
	 rH2CRvEuh9d3adZ9zWhACJU9SEvEgg29SM6fdzx0PIRh6yXq9hoqJnLWFKO79p7v9a
	 9i9Uy9ujjqrXMxZT82GrSpDe5lRdINuhNmCOq3431IMugjm48ODU4Wd+OnK3ygExtG
	 nKDNHD9RLfV4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?J=C3=B6rg=20Wedekind?= <joerg@wedekind.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/385] PCI: Mark 3ware-9650SA Root Port Extended Tags as broken
Date: Sat, 28 Feb 2026 12:56:58 -0500
Message-ID: <20260228180011.1568201-196-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 18fa918b4e537..49a2d6858b4b7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5581,6 +5581,7 @@ static void quirk_no_ext_tags(struct pci_dev *pdev)
 	pci_walk_bus(bridge->bus, pci_configure_extended_tags, NULL);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1004, quirk_no_ext_tags);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1005, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0132, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0140, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0141, quirk_no_ext_tags);
-- 
2.51.0

