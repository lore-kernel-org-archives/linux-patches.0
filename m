Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CB31B4F1E;
	Mon, 14 Oct 2024 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917341; cv=none; b=gx/RAAhhcXFor/UMUXdU4Lr2xXApgQiVdRhFzGRUwvkZbMlm/ZDsF1oQGmcdvyUeoFCpltjY7dnelBm/+RH1e1yjWaZM0OnGrJHVdoy7GFLL2sIo0Z43Dg9/z/CaInG+NZU04b9pKfDpKcCsNAiHDxPt3vJAnun7wj7UCJ4cgYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917341; c=relaxed/simple;
	bh=pdGeqseOwnY25MNCoAGWVBcAqpYW9QUYqEaY7E1KILQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQ+5j6CZw2tsrJId7oQg7St06T2Z/T89VbbXop2Yr3LcBLEX8x6kqUKUGEWGaTkHiHsv8pRc0OcTlAgvKmceBtPbMZMp5NdQpYO+Cz7TEwbeWqO1rlnfQ0oTxgV9MI1K7vWrVoLeZ2j6nBrbInFFqhI8FbX912T2eTwhjZH8nnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXxHgZlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXxHgZlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4195FC4CEC3;
	Mon, 14 Oct 2024 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917340;
	bh=pdGeqseOwnY25MNCoAGWVBcAqpYW9QUYqEaY7E1KILQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXxHgZlH9Wam+t1KBqAvKPPrPsJmprbwIsKPIMir1imswoP5iUOQV/bGQXiLOHi0Z
	 BtYlUq9QI3RBPLI+EkBEckurXUs+8HePjXJXb1GAJLt4rj+F6LkQqAXVacrTCM6jKA
	 pWGJx4eHgpTvRS11nPWZavOAripcbeO5o7hDQ9rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/798] EDAC/synopsys: Fix ECC status and IRQ control race condition
Date: Mon, 14 Oct 2024 16:09:15 +0200
Message-ID: <20241014141218.008994249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit 591c946675d88dcc0ae9ff54be9d5caaee8ce1e3 ]

The race condition around the ECCCLR register access happens in the IRQ
disable method called in the device remove() procedure and in the ECC IRQ
handler:

  1. Enable IRQ:
     a. ECCCLR = EN_CE | EN_UE
  2. Disable IRQ:
     a. ECCCLR = 0
  3. IRQ handler:
     a. ECCCLR = CLR_CE | CLR_CE_CNT | CLR_CE | CLR_CE_CNT
     b. ECCCLR = 0
     c. ECCCLR = EN_CE | EN_UE

So if the IRQ disabling procedure is called concurrently with the IRQ
handler method the IRQ might be actually left enabled due to the
statement 3c.

The root cause of the problem is that ECCCLR register (which since
v3.10a has been called as ECCCTL) has intermixed ECC status data clear
flags and the IRQ enable/disable flags. Thus the IRQ disabling (clear EN
flags) and handling (write 1 to clear ECC status data) procedures must
be serialised around the ECCCTL register modification to prevent the
race.

So fix the problem described above by adding the spin-lock around the
ECCCLR modifications and preventing the IRQ-handler from modifying the
IRQs enable flags (there is no point in disabling the IRQ and then
re-enabling it again within a single IRQ handler call, see the
statements 3a/3b and 3c above).

Fixes: f7824ded4149 ("EDAC/synopsys: Add support for version 3 of the Synopsys EDAC DDR")
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240222181324.28242-2-fancer.lancer@gmail.com
Stable-dep-of: 35e6dbfe1846 ("EDAC/synopsys: Fix error injection on Zynq UltraScale+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/synopsys_edac.c | 50 ++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index f7d37c2828199..014a2176c2c18 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -9,6 +9,7 @@
 #include <linux/edac.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -300,6 +301,7 @@ struct synps_ecc_status {
 /**
  * struct synps_edac_priv - DDR memory controller private instance data.
  * @baseaddr:		Base address of the DDR controller.
+ * @reglock:		Concurrent CSRs access lock.
  * @message:		Buffer for framing the event specific info.
  * @stat:		ECC status information.
  * @p_data:		Platform data.
@@ -314,6 +316,7 @@ struct synps_ecc_status {
  */
 struct synps_edac_priv {
 	void __iomem *baseaddr;
+	spinlock_t reglock;
 	char message[SYNPS_EDAC_MSG_SIZE];
 	struct synps_ecc_status stat;
 	const struct synps_platform_data *p_data;
@@ -409,7 +412,8 @@ static int zynq_get_error_info(struct synps_edac_priv *priv)
 static int zynqmp_get_error_info(struct synps_edac_priv *priv)
 {
 	struct synps_ecc_status *p;
-	u32 regval, clearval = 0;
+	u32 regval, clearval;
+	unsigned long flags;
 	void __iomem *base;
 
 	base = priv->baseaddr;
@@ -453,10 +457,14 @@ static int zynqmp_get_error_info(struct synps_edac_priv *priv)
 	p->ueinfo.blknr = (regval & ECC_CEADDR1_BLKNR_MASK);
 	p->ueinfo.data = readl(base + ECC_UESYND0_OFST);
 out:
-	clearval = ECC_CTRL_CLR_CE_ERR | ECC_CTRL_CLR_CE_ERRCNT;
-	clearval |= ECC_CTRL_CLR_UE_ERR | ECC_CTRL_CLR_UE_ERRCNT;
+	spin_lock_irqsave(&priv->reglock, flags);
+
+	clearval = readl(base + ECC_CLR_OFST) |
+		   ECC_CTRL_CLR_CE_ERR | ECC_CTRL_CLR_CE_ERRCNT |
+		   ECC_CTRL_CLR_UE_ERR | ECC_CTRL_CLR_UE_ERRCNT;
 	writel(clearval, base + ECC_CLR_OFST);
-	writel(0x0, base + ECC_CLR_OFST);
+
+	spin_unlock_irqrestore(&priv->reglock, flags);
 
 	return 0;
 }
@@ -516,24 +524,41 @@ static void handle_error(struct mem_ctl_info *mci, struct synps_ecc_status *p)
 
 static void enable_intr(struct synps_edac_priv *priv)
 {
+	unsigned long flags;
+
 	/* Enable UE/CE Interrupts */
-	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
-		writel(DDR_UE_MASK | DDR_CE_MASK,
-		       priv->baseaddr + ECC_CLR_OFST);
-	else
+	if (!(priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)) {
 		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
 		       priv->baseaddr + DDR_QOS_IRQ_EN_OFST);
 
+		return;
+	}
+
+	spin_lock_irqsave(&priv->reglock, flags);
+
+	writel(DDR_UE_MASK | DDR_CE_MASK,
+	       priv->baseaddr + ECC_CLR_OFST);
+
+	spin_unlock_irqrestore(&priv->reglock, flags);
 }
 
 static void disable_intr(struct synps_edac_priv *priv)
 {
+	unsigned long flags;
+
 	/* Disable UE/CE Interrupts */
-	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
-		writel(0x0, priv->baseaddr + ECC_CLR_OFST);
-	else
+	if (!(priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)) {
 		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
 		       priv->baseaddr + DDR_QOS_IRQ_DB_OFST);
+
+		return;
+	}
+
+	spin_lock_irqsave(&priv->reglock, flags);
+
+	writel(0, priv->baseaddr + ECC_CLR_OFST);
+
+	spin_unlock_irqrestore(&priv->reglock, flags);
 }
 
 /**
@@ -577,8 +602,6 @@ static irqreturn_t intr_handler(int irq, void *dev_id)
 	/* v3.0 of the controller does not have this register */
 	if (!(priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR))
 		writel(regval, priv->baseaddr + DDR_QOS_IRQ_STAT_OFST);
-	else
-		enable_intr(priv);
 
 	return IRQ_HANDLED;
 }
@@ -1360,6 +1383,7 @@ static int mc_probe(struct platform_device *pdev)
 	priv = mci->pvt_info;
 	priv->baseaddr = baseaddr;
 	priv->p_data = p_data;
+	spin_lock_init(&priv->reglock);
 
 	mc_init(mci, pdev);
 
-- 
2.43.0



