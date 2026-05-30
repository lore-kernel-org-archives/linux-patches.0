Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0F42E7390;
	Sat, 30 May 2026 18:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165277; cv=none; b=RWf/bEjltwe3f2RtsZlv4lY5P1yqQMmL6i7HNHyjog751uELdwROwXGznrWi7WV67beZRtT1oMVzbjFU29jvrH/K6VEGE4SiPvpUp96SpfjsNcRCk9HL4sxuw+pSV4CDjF9Lk72n487PnUFVu78umtRnhKrbue9SsVdiIfzPyRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165277; c=relaxed/simple;
	bh=LebFFfE30qX3AYvfwTVTiTZe53jwG2eYUsztAq449bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6KPrmrjx6yt//YLw6+hmY2+Y5QjNKvhrFSD+kjfWsMtooaacymcib8hVmeoS2hX4w8laXLz167ziNaXFM7udmCIew14aYGbeNALyVneDkckvNsLHLb62/IZWWLXWZ73vDjaJwcNWOVlfq3wyDWLpqRQBJOcGdxG5R1AhVaxYkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+vwS9L+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+vwS9L+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8660F1F00893;
	Sat, 30 May 2026 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165276;
	bh=Hz0qjmcnztyeup4vzaNZ7ji1r2MCeN5svdW8RBWT7Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+vwS9L+4wXYilVicU+IfMpiAfmGUUHrR+cD86nVq65hLftCpxHOSa+xGLMtJ70Ou
	 OPtupJpbe1XLkGQ+dg1C+Eh9JWV3xT2SeHSWiWhOBXZ6ktyVz7ggNKTHcJr4V92rTi
	 ftdxaYdag5w9b2kjKjTjIM6iXOLnxTmgwdzO3vK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Husband <artmoty@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/589] ata: ahci: force 32-bit DMA for JMicron JMB582/JMB585
Date: Sat, 30 May 2026 17:58:12 +0200
Message-ID: <20260530160224.874395115@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/ata/ahci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 2bb9555663e75..b3661495906f2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -61,6 +61,7 @@ enum board_ids {
 	/* board IDs for specific chipsets in alphabetical order */
 	board_ahci_al,
 	board_ahci_avn,
+	board_ahci_jmb585,
 	board_ahci_mcp65,
 	board_ahci_mcp77,
 	board_ahci_mcp89,
@@ -200,6 +201,15 @@ static const struct ata_port_info ahci_port_info[] = {
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
@@ -436,6 +446,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Elkhart Lake IDs 0x4b60 & 0x4b62 https://sata-io.org/product/8803 not tested yet */
 	{ PCI_VDEVICE(INTEL, 0x4b63), board_ahci_low_power }, /* Elkhart Lake AHCI */
 
+	/* JMicron JMB582/585: force 32-bit DMA (broken 64-bit implementation) */
+	{ PCI_VDEVICE(JMICRON, 0x0582), board_ahci_jmb585 },
+	{ PCI_VDEVICE(JMICRON, 0x0585), board_ahci_jmb585 },
+
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
-- 
2.53.0



