Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5159732E15D;
	Fri, 17 Oct 2025 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714256; cv=none; b=PjlTMUiKQzA8WGPuKx98Nqk0onxfPBVTYHdMQ6XYaqe1BoVmZ2dj8tSeTP+BzSqXdcDPIgm148eyuYM4XGZ4YqSO/OzM1OtthaSU6ykuvEgPi421s3186ghDbWjRMcJmkxbnLdtpr587fVREF2AIWvyGSOVKX4H56lqHVx+LTQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714256; c=relaxed/simple;
	bh=a3YoWmr1ZMUMiCm9DBzi4zZSqwe/Wx9t9MRqt9V2HWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMkTFMDhXUzTvDMy/FW90w4R8W/GmvpzpvmO4+eGZkiXEHzFTHgRQub/NNHHXqZPFUnFcD3YxzojQpnakfh2pOl/lCBG+WXD4FDFldnr7SfQeiXpUu69fmIeCsdA1eE+gt778Nmfk8W0dHLAFY3bbPLyApSx1VEKwrJYhd1+ETU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtlC6JzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtlC6JzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26CDC4CEF9;
	Fri, 17 Oct 2025 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714256;
	bh=a3YoWmr1ZMUMiCm9DBzi4zZSqwe/Wx9t9MRqt9V2HWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtlC6JzTUbglXAwECqt5E9Z80z6OM1Rjz/AmO6w5HQ5PoR1cdEU0dE7ebVpugBdvc
	 6GCiqJjMlYGih883rtC/ApEZLIFIeiS9aeYOuGILJHw+s00qlZ0jH6r8p+dOvZ0f1D
	 Pw30iD7qbCaeL2t1gCMUiJBSDIoa64SI8ssCNQ90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/277] mailbox: zynqmp-ipi: Fix SGI cleanup on unbind
Date: Fri, 17 Oct 2025 16:51:11 +0200
Message-ID: <20251017145149.481095604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit bb160e791ab15b89188a7a19589b8e11f681bef3 ]

The driver incorrectly determines SGI vs SPI interrupts by checking IRQ
number < 16, which fails with dynamic IRQ allocation. During unbind,
this causes improper SGI cleanup leading to kernel crash.

Add explicit irq_type field to pdata for reliable identification of SGI
interrupts (type-2) and only clean up SGI resources when appropriate.

Fixes: 6ffb1635341b ("mailbox: zynqmp: handle SGI for shared IPI")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index fab897b5724c1..5bf81b60e9e67 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -62,7 +62,8 @@
 #define DST_BIT_POS	9U
 #define SRC_BITMASK	GENMASK(11, 8)
 
-#define MAX_SGI 16
+/* Macro to represent SGI type for IPI IRQs */
+#define IPI_IRQ_TYPE_SGI	2
 
 /*
  * Module parameters
@@ -121,6 +122,7 @@ struct zynqmp_ipi_mbox {
  * @dev:                  device pointer corresponding to the Xilinx ZynqMP
  *                        IPI agent
  * @irq:                  IPI agent interrupt ID
+ * @irq_type:             IPI SGI or SPI IRQ type
  * @method:               IPI SMC or HVC is going to be used
  * @local_id:             local IPI agent ID
  * @virq_sgi:             IRQ number mapped to SGI
@@ -130,6 +132,7 @@ struct zynqmp_ipi_mbox {
 struct zynqmp_ipi_pdata {
 	struct device *dev;
 	int irq;
+	unsigned int irq_type;
 	unsigned int method;
 	u32 local_id;
 	int virq_sgi;
@@ -887,7 +890,7 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	struct zynqmp_ipi_mbox *ipi_mbox;
 	int i;
 
-	if (pdata->irq < MAX_SGI)
+	if (pdata->irq_type == IPI_IRQ_TYPE_SGI)
 		xlnx_mbox_cleanup_sgi(pdata);
 
 	i = pdata->num_mboxes - 1;
@@ -956,14 +959,16 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 		dev_err(dev, "failed to parse interrupts\n");
 		goto free_mbox_dev;
 	}
-	ret = out_irq.args[1];
+
+	/* Use interrupt type to distinguish SGI and SPI interrupts */
+	pdata->irq_type = out_irq.args[0];
 
 	/*
 	 * If Interrupt number is in SGI range, then request SGI else request
 	 * IPI system IRQ.
 	 */
-	if (ret < MAX_SGI) {
-		pdata->irq = ret;
+	if (pdata->irq_type == IPI_IRQ_TYPE_SGI) {
+		pdata->irq = out_irq.args[1];
 		ret = xlnx_mbox_init_sgi(pdev, pdata->irq, pdata);
 		if (ret)
 			goto free_mbox_dev;
-- 
2.51.0



