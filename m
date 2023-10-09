Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ECF14013
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeKmyR+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60D9C433C7;
	Mon,  9 Oct 2023 13:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859334;
	bh=/k3d57zmGPUd1S5+T9aSQCgO8Pg3rx/XbaVBBV9SPv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeKmyR+Dsil/v7znD+/TyJnlPWpWDaROmaXE272ApyYAYlaxCVP9Hmjh5Ou4TYwlI
	 gSPgjR5fvQYGQecaL2gWM/596sdkJ/MauCi6xex6eS7Yc/WONVr+ymDATHN5QYJ/ZF
	 pj1tQvHkSHz7rgu1qr8xMvc6dYEoikboM/i2Ov4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/55] ata: ahci: Drop pointless VPRINTK() calls and convert the remaining ones
Date: Mon,  9 Oct 2023 15:06:17 +0200
Message-ID: <20231009130108.405570411@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 93c7711494f47f9c829321e2a8711671b02f6e4c ]

Drop pointless VPRINTK() calls for entering and existing interrupt
routines and convert the remaining calls to dev_dbg().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: 737dd811a3db ("ata: libahci: clear pending interrupt status")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c       |  4 +---
 drivers/ata/ahci_xgene.c |  4 ----
 drivers/ata/libahci.c    | 18 ++++--------------
 3 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 0905c07b8c7eb..70930eb1e3286 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -670,7 +670,7 @@ static void ahci_pci_init_controller(struct ata_host *host)
 
 		/* clear port IRQ */
 		tmp = readl(port_mmio + PORT_IRQ_STAT);
-		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+		dev_dbg(&pdev->dev, "PORT_IRQ_STAT 0x%x\n", tmp);
 		if (tmp)
 			writel(tmp, port_mmio + PORT_IRQ_STAT);
 	}
@@ -1480,7 +1480,6 @@ static irqreturn_t ahci_thunderx_irq_handler(int irq, void *dev_instance)
 	u32 irq_stat, irq_masked;
 	unsigned int handled = 1;
 
-	VPRINTK("ENTER\n");
 	hpriv = host->private_data;
 	mmio = hpriv->mmio;
 	irq_stat = readl(mmio + HOST_IRQ_STAT);
@@ -1497,7 +1496,6 @@ static irqreturn_t ahci_thunderx_irq_handler(int irq, void *dev_instance)
 		irq_stat = readl(mmio + HOST_IRQ_STAT);
 		spin_unlock(&host->lock);
 	} while (irq_stat);
-	VPRINTK("EXIT\n");
 
 	return IRQ_RETVAL(handled);
 }
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index ad58da7c9affd..06826ec47454f 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -601,8 +601,6 @@ static irqreturn_t xgene_ahci_irq_intr(int irq, void *dev_instance)
 	void __iomem *mmio;
 	u32 irq_stat, irq_masked;
 
-	VPRINTK("ENTER\n");
-
 	hpriv = host->private_data;
 	mmio = hpriv->mmio;
 
@@ -625,8 +623,6 @@ static irqreturn_t xgene_ahci_irq_intr(int irq, void *dev_instance)
 
 	spin_unlock(&host->lock);
 
-	VPRINTK("EXIT\n");
-
 	return IRQ_RETVAL(rc);
 }
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 1fe18a4983f0d..3111c649816a2 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1212,12 +1212,12 @@ static void ahci_port_init(struct device *dev, struct ata_port *ap,
 
 	/* clear SError */
 	tmp = readl(port_mmio + PORT_SCR_ERR);
-	VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
+	dev_dbg(dev, "PORT_SCR_ERR 0x%x\n", tmp);
 	writel(tmp, port_mmio + PORT_SCR_ERR);
 
 	/* clear port IRQ */
 	tmp = readl(port_mmio + PORT_IRQ_STAT);
-	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+	dev_dbg(dev, "PORT_IRQ_STAT 0x%x\n", tmp);
 	if (tmp)
 		writel(tmp, port_mmio + PORT_IRQ_STAT);
 
@@ -1248,10 +1248,10 @@ void ahci_init_controller(struct ata_host *host)
 	}
 
 	tmp = readl(mmio + HOST_CTL);
-	VPRINTK("HOST_CTL 0x%x\n", tmp);
+	dev_dbg(host->dev, "HOST_CTL 0x%x\n", tmp);
 	writel(tmp | HOST_IRQ_EN, mmio + HOST_CTL);
 	tmp = readl(mmio + HOST_CTL);
-	VPRINTK("HOST_CTL 0x%x\n", tmp);
+	dev_dbg(host->dev, "HOST_CTL 0x%x\n", tmp);
 }
 EXPORT_SYMBOL_GPL(ahci_init_controller);
 
@@ -1902,8 +1902,6 @@ static irqreturn_t ahci_multi_irqs_intr_hard(int irq, void *dev_instance)
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 status;
 
-	VPRINTK("ENTER\n");
-
 	status = readl(port_mmio + PORT_IRQ_STAT);
 	writel(status, port_mmio + PORT_IRQ_STAT);
 
@@ -1911,8 +1909,6 @@ static irqreturn_t ahci_multi_irqs_intr_hard(int irq, void *dev_instance)
 	ahci_handle_port_interrupt(ap, port_mmio, status);
 	spin_unlock(ap->lock);
 
-	VPRINTK("EXIT\n");
-
 	return IRQ_HANDLED;
 }
 
@@ -1929,9 +1925,7 @@ u32 ahci_handle_port_intr(struct ata_host *host, u32 irq_masked)
 		ap = host->ports[i];
 		if (ap) {
 			ahci_port_intr(ap);
-			VPRINTK("port %u\n", i);
 		} else {
-			VPRINTK("port %u (no irq)\n", i);
 			if (ata_ratelimit())
 				dev_warn(host->dev,
 					 "interrupt on disabled port %u\n", i);
@@ -1952,8 +1946,6 @@ static irqreturn_t ahci_single_level_irq_intr(int irq, void *dev_instance)
 	void __iomem *mmio;
 	u32 irq_stat, irq_masked;
 
-	VPRINTK("ENTER\n");
-
 	hpriv = host->private_data;
 	mmio = hpriv->mmio;
 
@@ -1981,8 +1973,6 @@ static irqreturn_t ahci_single_level_irq_intr(int irq, void *dev_instance)
 
 	spin_unlock(&host->lock);
 
-	VPRINTK("EXIT\n");
-
 	return IRQ_RETVAL(rc);
 }
 
-- 
2.40.1



