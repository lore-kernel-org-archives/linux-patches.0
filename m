Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED273446C7;
	Tue, 21 Jul 2026 21:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669637; cv=none; b=PZ6wqGc8t1xkZagzGJDPXEpKEpnIDCUUGrvqB6xVbPZkPHYWUJPVANfuzLgeMJTJ6JUiR9O4u9Qhri2gPgHCxUmdQqTx1BO/DgedHfDSYuGnyGtpW+I//bFmrH3l3idmPiXWSH5dUOnqywnWDp1Yl9KeoFI7m9J/F6IlaYqz/+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669637; c=relaxed/simple;
	bh=IzhxWiXzILgtqJcKd2RexLZxUJaBzuI9pT8ibUaFmns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lra8hR4xB1BQk5avZ6/dC+YOl+2JgW9PpFXekSnrVWhUna5RUtCGW1+iwSoDsBDB0EEFa5l9UZOvN5a5FbeIeT+lcrCmapNSZ0F0+B+Q0SDinR5wv2z6uWMTtpjzEnpoJYt+S5nVn5bgWb4oU1b4XYb7bKtLHZuElekC7ewNCmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFWyAiII; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFWyAiII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F00C1F000E9;
	Tue, 21 Jul 2026 21:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669634;
	bh=t4wzm1n6Y2Mf6vFfZqyLoJ8OXIm1Zlj8MldtZeLvd4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFWyAiIIWOrfTIk5IFbI8YhAvlVXJDaYLz8+GadpRzNYR2XBp92MDndMsoZhOIkaX
	 eZ2RGrPEqCy87Injm3Fii3lK0NLgJEXYbogBNKF5Bd8X9LcshzWMNcpFEDL07RGIKI
	 GR0jEdEnYH7fdhw/RN+Cy1LZzGSgj2GS1fWuIQSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0629/1067] NTB: epf: Fix doorbell bitmask and IRQ vector handling
Date: Tue, 21 Jul 2026 17:20:30 +0200
Message-ID: <20260721152438.667541506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 4fdea8dbb62d746429498e07385a3ba0b0f6d1ab ]

The EPF driver currently stores the incoming doorbell as a vector number
(irq_no + 1) in db_val and db_clear() clears all bits unconditionally.
This breaks db_read()/db_clear() semantics when multiple doorbells are
used.

Store doorbells as a bitmask (BIT_ULL(vector)) and make
db_clear(db_bits) clear only the specified bits. Use atomic64 operations
as db_val is updated from interrupt context.

Once db_val is stored as a bitmask, the ISR's doorbell vector is used
not only for ntb_db_event(), but also as the bit index for BIT_ULL().
The existing ISR derives that vector by subtracting pci_irq_vector(pdev,
0) from the Linux IRQ number passed to the handler, but Linux IRQ
numbers are not guaranteed to be contiguous.

Pass per-vector context as request_irq() dev_id instead, so the ISR gets
the device vector directly.

Validate the doorbell vector before updating db_val or calling
ntb_db_event(), so an unexpected vector cannot create an invalid shift
or be reported to NTB clients.

While at it, read and validate mw_count before requesting interrupt
vectors. An unsupported memory-window count does not need IRQs, and
failing before ntb_epf_init_isr() keeps the probe error path simple.

Fixes: 812ce2f8d14e ("NTB: Add support for EPF PCI Non-Transparent Bridge")
Suggested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260513024923.451765-12-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/epf/ntb_hw_epf.c | 61 +++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/ntb/hw/epf/ntb_hw_epf.c b/drivers/ntb/hw/epf/ntb_hw_epf.c
index 88f37c5c003ad0..39d0d026cf20f8 100644
--- a/drivers/ntb/hw/epf/ntb_hw_epf.c
+++ b/drivers/ntb/hw/epf/ntb_hw_epf.c
@@ -6,6 +6,7 @@
  * Author: Kishon Vijay Abraham I <kishon@ti.com>
  */
 
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -77,6 +78,13 @@ enum epf_irq_slot {
 
 #define NTB_EPF_MAX_MW_COUNT	(NTB_BAR_NUM - BAR_MW1)
 
+struct ntb_epf_dev;
+
+struct ntb_epf_irq_ctx {
+	struct ntb_epf_dev *ndev;
+	unsigned int irq_no;
+};
+
 struct ntb_epf_dev {
 	struct ntb_dev ntb;
 	struct device *dev;
@@ -96,9 +104,9 @@ struct ntb_epf_dev {
 	unsigned int self_spad;
 	unsigned int peer_spad;
 
-	int db_val;
+	atomic64_t db_val;
 	u64 db_valid_mask;
-	int irq_base;
+	struct ntb_epf_irq_ctx irq_ctx[NTB_EPF_MAX_DB_COUNT + 1];
 };
 
 #define ntb_ndev(__ntb) container_of(__ntb, struct ntb_epf_dev, ntb)
@@ -322,11 +330,10 @@ static int ntb_epf_link_disable(struct ntb_dev *ntb)
 
 static irqreturn_t ntb_epf_vec_isr(int irq, void *dev)
 {
-	struct ntb_epf_dev *ndev = dev;
-	int irq_no;
-
-	irq_no = irq - ndev->irq_base;
-	ndev->db_val = irq_no + 1;
+	struct ntb_epf_irq_ctx *ctx = dev;
+	struct ntb_epf_dev *ndev = ctx->ndev;
+	unsigned int db_vector;
+	unsigned int irq_no = ctx->irq_no;
 
 	if (irq_no == EPF_IRQ_LINK) {
 		ntb_link_event(&ndev->ntb);
@@ -334,7 +341,17 @@ static irqreturn_t ntb_epf_vec_isr(int irq, void *dev)
 		dev_warn_ratelimited(ndev->dev,
 				     "Unexpected reserved doorbell slot IRQ received\n");
 	} else {
-		ntb_db_event(&ndev->ntb, irq_no - EPF_IRQ_DB_START);
+		db_vector = irq_no - EPF_IRQ_DB_START;
+		if (ndev->db_count < NTB_EPF_MIN_DB_COUNT ||
+		    db_vector >= ndev->db_count - 1) {
+			dev_warn_ratelimited(ndev->dev,
+					     "Unexpected doorbell vector %u (db_count %u)\n",
+					     db_vector, ndev->db_count);
+			return IRQ_HANDLED;
+		}
+
+		atomic64_or(BIT_ULL(db_vector), &ndev->db_val);
+		ntb_db_event(&ndev->ntb, db_vector);
 	}
 
 	return IRQ_HANDLED;
@@ -361,18 +378,18 @@ static int ntb_epf_init_isr(struct ntb_epf_dev *ndev, int msi_min, int msi_max)
 		argument &= ~MSIX_ENABLE;
 	}
 
-	ndev->irq_base = pci_irq_vector(pdev, 0);
+	ndev->db_count = irq - 1;
 	for (i = 0; i < irq; i++) {
+		ndev->irq_ctx[i].ndev = ndev;
+		ndev->irq_ctx[i].irq_no = i;
 		ret = request_irq(pci_irq_vector(pdev, i), ntb_epf_vec_isr,
-				  0, "ntb_epf", ndev);
+				  0, "ntb_epf", &ndev->irq_ctx[i]);
 		if (ret) {
 			dev_err(dev, "Failed to request irq\n");
 			goto err_free_irq;
 		}
 	}
 
-	ndev->db_count = irq - 1;
-
 	ret = ntb_epf_send_command(ndev, CMD_CONFIGURE_DOORBELL,
 				   argument | irq);
 	if (ret) {
@@ -384,7 +401,7 @@ static int ntb_epf_init_isr(struct ntb_epf_dev *ndev, int msi_min, int msi_max)
 
 err_free_irq:
 	while (i--)
-		free_irq(pci_irq_vector(pdev, i), ndev);
+		free_irq(pci_irq_vector(pdev, i), &ndev->irq_ctx[i]);
 	pci_free_irq_vectors(pdev);
 
 	return ret;
@@ -509,7 +526,7 @@ static u64 ntb_epf_db_read(struct ntb_dev *ntb)
 {
 	struct ntb_epf_dev *ndev = ntb_ndev(ntb);
 
-	return ndev->db_val;
+	return atomic64_read(&ndev->db_val);
 }
 
 static int ntb_epf_db_clear_mask(struct ntb_dev *ntb, u64 db_bits)
@@ -521,7 +538,7 @@ static int ntb_epf_db_clear(struct ntb_dev *ntb, u64 db_bits)
 {
 	struct ntb_epf_dev *ndev = ntb_ndev(ntb);
 
-	ndev->db_val = 0;
+	atomic64_and(~db_bits, &ndev->db_val);
 
 	return 0;
 }
@@ -562,6 +579,12 @@ static int ntb_epf_init_dev(struct ntb_epf_dev *ndev)
 	struct device *dev = ndev->dev;
 	int ret;
 
+	ndev->mw_count = readl(ndev->ctrl_reg + NTB_EPF_MW_COUNT);
+	if (ndev->mw_count > NTB_EPF_MAX_MW_COUNT) {
+		dev_err(dev, "Unsupported MW count: %u\n", ndev->mw_count);
+		return -EINVAL;
+	}
+
 	/* One Link interrupt and rest doorbell interrupt */
 	ret = ntb_epf_init_isr(ndev, NTB_EPF_MIN_DB_COUNT + 1,
 			       NTB_EPF_MAX_DB_COUNT + 1);
@@ -575,14 +598,8 @@ static int ntb_epf_init_dev(struct ntb_epf_dev *ndev)
 	 * doorbell layout, hence -1.
 	 */
 	ndev->db_valid_mask = BIT_ULL(ndev->db_count - 1) - 1;
-	ndev->mw_count = readl(ndev->ctrl_reg + NTB_EPF_MW_COUNT);
 	ndev->spad_count = readl(ndev->ctrl_reg + NTB_EPF_SPAD_COUNT);
 
-	if (ndev->mw_count > NTB_EPF_MAX_MW_COUNT) {
-		dev_err(dev, "Unsupported MW count: %u\n", ndev->mw_count);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -681,7 +698,7 @@ static void ntb_epf_cleanup_isr(struct ntb_epf_dev *ndev)
 	ntb_epf_send_command(ndev, CMD_TEARDOWN_DOORBELL, ndev->db_count + 1);
 
 	for (i = 0; i < ndev->db_count + 1; i++)
-		free_irq(pci_irq_vector(pdev, i), ndev);
+		free_irq(pci_irq_vector(pdev, i), &ndev->irq_ctx[i]);
 	pci_free_irq_vectors(pdev);
 }
 
-- 
2.53.0



