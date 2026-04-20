Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8E03A1D10;
	Mon, 20 Apr 2026 13:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691787; cv=none; b=R1m5U4hLDW2aSEucbFbHp2OtCWGUeaXDnXtTWu0NoToJXTlNXjrAOT41klbfSoRAq7Tv2buA6TgFEZzvQGExGMlgljMc8Mbalsv2SLfthQOWrnP9rTtMhRP3n+aqeXv2nmDvu4yAq+l2hzgvyMJijVbsEBM+bgZ9D7CqSpJQ6uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691787; c=relaxed/simple;
	bh=Z9R431ybjLB8AVvYdamQwwbm/eXKJM1LesQH9zAoukU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8gyPs+eTpt8y/pQJ7zGBNCU9azlFDvwcV38M3kwTAcdiJermYhLpkHZOfmS/kqtfeM5HscBde0+it82VZjp2Br33B1d1qbsK2/sdFiiFCWEWf3D97w6dEa/IjAFrYrR/iqzexyKCMBW3/iNDW1FtcgEO0v4y+6juCuBv0WYJ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utQ96oJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utQ96oJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DB3C2BCB9;
	Mon, 20 Apr 2026 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691786;
	bh=Z9R431ybjLB8AVvYdamQwwbm/eXKJM1LesQH9zAoukU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utQ96oJYIud6uQVOcCFPJ2QH5MQ+2v8BczaRpbXWy+A3ZPZQem7KVbiC3jkNVG5oo
	 SoQ/h8vnDPg+b+biuT2Sxx5HPCSXFNzP39zudBXav9eK+tOlER2dfPrhzmAmP/YfgZ
	 UPhl7NJm+2kYN2d9sp1KObQ4W565Tb5cTNgmgoHTti9DPCGhvX7qoEoYJ1+ddrIi1t
	 I7xZdzk4NmOQgdcta9FPXOA3gtY39eDYAlPxVqs60if6juM+jH3bkXanGEQoNZL523
	 IGAQtW1Mu2hYxJNpFI+qtcvNv+rkR/mvTNKtU0W6AEs4vnw6Pgq00Ov15mDi3eqSxE
	 gpgvD7bHf52Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arthur Husband <artmoty@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ata: ahci: force 32-bit DMA for JMicron JMB582/JMB585
Date: Mon, 20 Apr 2026 09:19:47 -0400
Message-ID: <20260420132314.1023554-193-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Arthur Husband <artmoty@gmail.com>

[ Upstream commit 105c42566a550e2d05fc14f763216a8765ee5d0e ]

The JMicron JMB585 (and JMB582) SATA controllers advertise 64-bit DMA
support via the S64A bit in the AHCI CAP register, but their 64-bit DMA
implementation is defective. Under sustained I/O, DMA transfers targeting
addresses above 4GB silently corrupt data -- writes land at incorrect
memory addresses with no errors logged.

The failure pattern is similar to the ASMedia ASM1061
(commit 20730e9b2778 ("ahci: add 43-bit DMA address quirk for ASMedia
ASM1061 controllers")), which also falsely advertised full 64-bit DMA
support. However, the JMB585 requires a stricter 32-bit DMA mask rather
than 43-bit, as corruption occurs with any address above 4GB.

On the Minisforum N5 Pro specifically, the combination of the JMB585's
broken 64-bit DMA with the AMD Family 1Ah (Strix Point) IOMMU causes
silent data corruption that is only detectable via checksumming
filesystems (BTRFS/ZFS scrub). The corruption occurs when 32-bit IOVA
space is exhausted and the kernel transparently switches to 64-bit DMA
addresses.

Add device-specific PCI ID entries for the JMB582 (0x0582) and JMB585
(0x0585) before the generic JMicron class match, using a new board type
that combines AHCI_HFLAG_IGN_IRQ_IF_ERR (preserving existing behavior)
with AHCI_HFLAG_32BIT_ONLY to force 32-bit DMA masks.

Signed-off-by: Arthur Husband <artmoty@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/ata/ahci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 931d0081169b9..1d73a53370cf3 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -68,6 +68,7 @@ enum board_ids {
 	/* board IDs for specific chipsets in alphabetical order */
 	board_ahci_al,
 	board_ahci_avn,
+	board_ahci_jmb585,
 	board_ahci_mcp65,
 	board_ahci_mcp77,
 	board_ahci_mcp89,
@@ -212,6 +213,15 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_avn_ops,
 	},
+	/* JMicron JMB582/585: 64-bit DMA is broken, force 32-bit */
+	[board_ahci_jmb585] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR |
+				 AHCI_HFLAG_32BIT_ONLY),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 	[board_ahci_mcp65] = {
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_FPDMA_AA | AHCI_HFLAG_NO_PMP |
 				 AHCI_HFLAG_YES_NCQ),
@@ -439,6 +449,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Elkhart Lake IDs 0x4b60 & 0x4b62 https://sata-io.org/product/8803 not tested yet */
 	{ PCI_VDEVICE(INTEL, 0x4b63), board_ahci_pcs_quirk }, /* Elkhart Lake AHCI */
 
+	/* JMicron JMB582/585: force 32-bit DMA (broken 64-bit implementation) */
+	{ PCI_VDEVICE(JMICRON, 0x0582), board_ahci_jmb585 },
+	{ PCI_VDEVICE(JMICRON, 0x0585), board_ahci_jmb585 },
+
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
-- 
2.53.0

