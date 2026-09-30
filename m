Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA964D0CDF;
	Wed, 30 Sep 2026 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783500; cv=none; b=bis1Ijuk8T33BXm6HF8esMN6jOLJ+f3b4DyliEM2TJSUiTkVYckaXYN+LVZBqWzf6tC5VcBmdocA4UIEHfLkYMOx6l/7rHSSTJ/sJL6NZr45AzNWUfvfRytl/zL64Hh15AbPZoMtQkKmQ7HGcvBDPoZXUx4hlq+ICStSMeS6CDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783500; c=relaxed/simple;
	bh=d3cxx9gTHHE6mq9wkoLplWKcn3krhhYBiR421hNdggM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjqPW3KLsKpVu5ocRAJNnSWG3W/sWACvmaLZ/90eZW0IbKWGrYSpLTCLprx+ESq6GyP68ylpGYhdXObowQ9+bDprKmW/HLfiZMLp50X7aQpqQcMs3BQSUmO+9poHe9vQIp9d+O6uDYqAfJsgehSMEBrC851Fhp+dvIygFdx/bFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuB+o1lr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuB+o1lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66FF1F00893;
	Wed, 30 Sep 2026 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783495;
	bh=lwg981E/D1oD0YUOnDJK8mTs184eWwDpKyXHWHE0OjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuB+o1lrhQvw6nwkyoMV7Z2H7hhF9vt+2BsPEhluLWYLI2mokwD3VbAuPKNwP7psN
	 zEb2CjOGzmY+Cf6PyQiUb/9uyZFcjXuJqFIoo7XodqRU+KMLcvAnf4N0wsK4LkFDCX
	 6afbzu4xs3OJvVaYQjK8nhMdIN7SAv04qXffLgPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roland Waltersson <roland.waltersson@netinsight.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 5.10 419/595] ata: libahci: clear PxCLBU and PxFBU for AHCI_HFLAG_32BIT_ONLY
Date: Wed, 30 Sep 2026 17:25:12 +0200
Message-ID: <20260930152356.690721999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

commit 82e47533221d4746947b74d2e79a478c36c6433a upstream.

A user reported that commit 105c42566a55 ("ata: ahci: force 32-bit DMA for
JMicron JMB582/JMB585") made the JMicron JMB585 unusable on his board.

The failure is seen as soon as the ahci driver is probed, and booting with
iommu=off does not solve the problem.

Looking at the AHCI specification, PxCLBU and PxFBU are both read only '0'
for HBAs that do not support 64-bit addressing.

For HBAs that do support 64-bit addressing, the registers are read write,
with a reset value that is Implementation Specific.

When using the AHCI_HFLAG_32BIT_ONLY flag, the HBA does support 64-bit
addressing, and a 32-bit DMA mask is set by simply clearing HOST_CAP_64.
Thus, in this case, we need to explicitly clear the registers to 0.

Fixes: 105c42566a55 ("ata: ahci: force 32-bit DMA for JMicron JMB582/JMB585")
Fixes: c7a42156d99b ("ahci: disable 64bit dma on sb600")
Cc: stable@vger.kernel.org
Reported-by: Roland Waltersson <roland.waltersson@netinsight.net>
Closes: https://lore.kernel.org/linux-ide/IA0PR17MB668730A4ECCD65F7A1DC3EDC9EB62@IA0PR17MB6687.namprd17.prod.outlook.com/
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260904134310.1465051-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libahci.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -688,15 +688,28 @@ void ahci_start_fis_rx(struct ata_port *
 	struct ahci_port_priv *pp = ap->private_data;
 	u32 tmp;
 
-	/* set FIS registers */
+	/*
+	 * On HBAs that only support 32-bit addressing PxCLBU is read only '0'.
+	 * When applying the AHCI_HFLAG_32BIT_ONLY quirk, PxCLBU is RW, and the
+	 * reset value is Implementation Specific, so we need to clear it to 0.
+	 */
 	if (hpriv->cap & HOST_CAP_64)
 		writel((pp->cmd_slot_dma >> 16) >> 16,
 		       port_mmio + PORT_LST_ADDR_HI);
+	else if (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)
+		writel(0, port_mmio + PORT_LST_ADDR_HI);
 	writel(pp->cmd_slot_dma & 0xffffffff, port_mmio + PORT_LST_ADDR);
 
+	/*
+	 * On HBAs that only support 32-bit addressing PxFBU is read only '0'.
+	 * When applying the AHCI_HFLAG_32BIT_ONLY quirk, PxFBU is RW, and the
+	 * reset value is Implementation Specific, so we need to clear it to 0.
+	 */
 	if (hpriv->cap & HOST_CAP_64)
 		writel((pp->rx_fis_dma >> 16) >> 16,
 		       port_mmio + PORT_FIS_ADDR_HI);
+	else if (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)
+		writel(0, port_mmio + PORT_FIS_ADDR_HI);
 	writel(pp->rx_fis_dma & 0xffffffff, port_mmio + PORT_FIS_ADDR);
 
 	/* enable FIS reception */


