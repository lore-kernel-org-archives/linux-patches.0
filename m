Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191E550B8A8;
	Wed, 30 Sep 2026 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792051; cv=none; b=TO9Im9QnJZ9JcmVtK201PePGPsQIJT039nGcbfHsShfjFwbZSN8o8Wp3zhJy78YyGOYM0upk98ZafS+397YKM7lRdO4wuNWeqewKqee/dckJMCJ0FePK8bMNtyhXHYQHzhBCshT1u3n+aHqgCeSdbn0VlGK6EGtXRtV5odLVSOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792051; c=relaxed/simple;
	bh=gSDnVHxa97fJOAMJJ99BZrEg1duL05hQ3P1HjLwSGzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exZLxtjYctibu0PpSgOj75wv5ppZzmqOQLkHozbfo1fALtQfPypYt148wkleBKD21xwIyVz0AgpWn5HxxY3MIuclXDiGvYubhTXaNEO+PQ2I8p+I/Of+1wGex22fIz6Oj59XZGxkkm/QGdPZN8qUGZCPje6wPED6sX9mjfsEMxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpVmDvkQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpVmDvkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FEE1F000FF;
	Wed, 30 Sep 2026 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792050;
	bh=LJT23VEmhTu7OhUBZ2a0CmMbTEd6ybI+/5ssknTup3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpVmDvkQYATS8dhhnpomAEb9xgvSlhfV+Yc1nf17oNjk8KcIgNgERIdYa7jfeA/ey
	 mvyBUBzjAXd+5M8YdVZjgD23c0OEmNCh4IUOOPLO5q2u0297zOu71lWsG6iwiqFMIa
	 CH28VFs1S1sTFBtphnsnrpJhQcBECNfHsC9omkRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roland Waltersson <roland.waltersson@netinsight.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 5.15 519/752] ata: libahci: clear PxCLBU and PxFBU for AHCI_HFLAG_32BIT_ONLY
Date: Wed, 30 Sep 2026 17:26:29 +0200
Message-ID: <20260930152409.485998457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -689,15 +689,28 @@ void ahci_start_fis_rx(struct ata_port *
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


