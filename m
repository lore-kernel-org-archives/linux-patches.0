Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F406C30C143;
	Thu, 30 Jul 2026 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426757; cv=none; b=IhjKDniE3w/cvnSVad9qokjqcwXH/V+TaVd2PZC7XFUiSRcRxtEfJyoVcVx4fgpqPvyNVkKLZkSgMYgZQX+xUMQXvti6/2asMvXWtfqJWnKMmwfDOUyyF4F3YXR7WIrbnZ0wNfqE4MSY1Ewv+DVzHC6tLfmP8BdjEpv3Y56JNoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426757; c=relaxed/simple;
	bh=SQbhUY/zZT5I21WRjcbcJdPULTeZMCki02MgOyZffrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxNQFzV3sfqessml9SQovd1BvQ6mEbSXl6AaOd31YnMtM3ivfXRFMxGH1e8NmV1EbPT8uD94c2OZl4rZumlO7Ry1pbMJY9L6ws3b6m8IS9zEqw2rwQ/GN75S/WDIEHXxOjtIwkCt8LFdwCJTcxqyxz98TqpL4w1/9i8p0f0VWT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agTUrlsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agTUrlsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556F01F000E9;
	Thu, 30 Jul 2026 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426755;
	bh=hmkr50KuiSuTl6kikDxwllB2nU6W/U6pm/HGB5Wfyp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agTUrlspJj7wwhi6hJlD53wNq6eJvJzmxSObX6uzMUm8uZ27um2tJKBrAGL79cizQ
	 8d3W0XH3pXibXfR3SWlV/V19jLEaqgSn4mvUMKTLisYdQRpxlb4+SEFgeWLyzFdnB/
	 Yj6dkeiSSHqxMYSacWkMQAHspG5U661fLrRt3VWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 532/602] i2c: imx: separate atomic, dma and non-dma use case
Date: Thu, 30 Jul 2026 16:15:24 +0200
Message-ID: <20260730141447.195306514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

[ Upstream commit b460b15b3cc23ef3639cc51043bf8b2a70ca1878 ]

Separate the atomic, dma and non-dma use case as a preparation step for
moving the non-dma use case to the isr to avoid rescheduling while a
transfer is in progress.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: cb2fc3785769 ("i2c: imx: fix locked bus on SMBus block-read of 0 (atomic)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |  107 ++++++++++++++++++++++++++++---------------
 1 file changed, 70 insertions(+), 37 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1007,6 +1007,43 @@ static int i2c_imx_dma_write(struct imx_
 	return i2c_imx_acked(i2c_imx);
 }
 
+static int i2c_imx_prepare_read(struct imx_i2c_struct *i2c_imx,
+				struct i2c_msg *msgs, bool atomic,
+				bool use_dma)
+{
+	int result;
+	unsigned int temp = 0;
+
+	/* write slave address */
+	imx_i2c_write_reg(i2c_8bit_addr_from_msg(msgs), i2c_imx, IMX_I2C_I2DR);
+	result = i2c_imx_trx_complete(i2c_imx, atomic);
+	if (result)
+		return result;
+	result = i2c_imx_acked(i2c_imx);
+	if (result)
+		return result;
+
+	dev_dbg(&i2c_imx->adapter.dev, "<%s> setup bus\n", __func__);
+
+	/* setup bus to read data */
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp &= ~I2CR_MTX;
+
+	/*
+	 * Reset the I2CR_TXAK flag initially for SMBus block read since the
+	 * length is unknown
+	 */
+	if (msgs->len - 1)
+		temp &= ~I2CR_TXAK;
+	if (use_dma)
+		temp |= I2CR_DMAEN;
+
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+	imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR); /* dummy read */
+
+	return 0;
+}
+
 static int i2c_imx_dma_read(struct imx_i2c_struct *i2c_imx,
 			struct i2c_msg *msgs, bool is_lastmsg)
 {
@@ -1017,6 +1054,11 @@ static int i2c_imx_dma_read(struct imx_i
 	struct imx_i2c_dma *dma = i2c_imx->dma;
 	struct device *dev = &i2c_imx->adapter.dev;
 
+	result = i2c_imx_prepare_read(i2c_imx, msgs, false, true);
+	if (result)
+		return result;
+
+	dev_dbg(&i2c_imx->adapter.dev, "<%s> read data\n", __func__);
 
 	dma->chan_using = dma->chan_rx;
 	dma->dma_transfer_dir = DMA_DEV_TO_MEM;
@@ -1127,50 +1169,24 @@ static int i2c_imx_write(struct imx_i2c_
 	return 0;
 }
 
+static int i2c_imx_atomic_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
+{
+	return i2c_imx_write(i2c_imx, msgs, true);
+}
+
 static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs,
 			bool is_lastmsg, bool atomic)
 {
 	int i, result;
 	unsigned int temp;
 	int block_data = msgs->flags & I2C_M_RECV_LEN;
-	int use_dma = i2c_imx->dma && msgs->flags & I2C_M_DMA_SAFE &&
-		msgs->len >= DMA_THRESHOLD && !block_data;
-
-	dev_dbg(&i2c_imx->adapter.dev,
-		"<%s> write slave address: addr=0x%x\n",
-		__func__, i2c_8bit_addr_from_msg(msgs));
 
-	/* write slave address */
-	imx_i2c_write_reg(i2c_8bit_addr_from_msg(msgs), i2c_imx, IMX_I2C_I2DR);
-	result = i2c_imx_trx_complete(i2c_imx, atomic);
-	if (result)
-		return result;
-	result = i2c_imx_acked(i2c_imx);
+	result = i2c_imx_prepare_read(i2c_imx, msgs, atomic, false);
 	if (result)
 		return result;
 
-	dev_dbg(&i2c_imx->adapter.dev, "<%s> setup bus\n", __func__);
-
-	/* setup bus to read data */
-	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
-	temp &= ~I2CR_MTX;
-
-	/*
-	 * Reset the I2CR_TXAK flag initially for SMBus block read since the
-	 * length is unknown
-	 */
-	if ((msgs->len - 1) || block_data)
-		temp &= ~I2CR_TXAK;
-	if (use_dma)
-		temp |= I2CR_DMAEN;
-	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
-	imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR); /* dummy read */
-
 	dev_dbg(&i2c_imx->adapter.dev, "<%s> read data\n", __func__);
 
-	if (use_dma)
-		return i2c_imx_dma_read(i2c_imx, msgs, is_lastmsg);
-
 	/* read data */
 	for (i = 0; i < msgs->len; i++) {
 		u8 len = 0;
@@ -1237,6 +1253,12 @@ static int i2c_imx_read(struct imx_i2c_s
 	return 0;
 }
 
+static int i2c_imx_atomic_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs,
+			       bool is_lastmsg)
+{
+	return i2c_imx_read(i2c_imx, msgs, is_lastmsg, true);
+}
+
 static int i2c_imx_xfer_common(struct i2c_adapter *adapter,
 			       struct i2c_msg *msgs, int num, bool atomic)
 {
@@ -1244,6 +1266,7 @@ static int i2c_imx_xfer_common(struct i2
 	int result;
 	bool is_lastmsg = false;
 	struct imx_i2c_struct *i2c_imx = i2c_get_adapdata(adapter);
+	int use_dma = 0;
 
 	/* Start I2C transfer */
 	result = i2c_imx_start(i2c_imx, atomic);
@@ -1296,15 +1319,25 @@ static int i2c_imx_xfer_common(struct i2
 			(temp & I2SR_SRW ? 1 : 0), (temp & I2SR_IIF ? 1 : 0),
 			(temp & I2SR_RXAK ? 1 : 0));
 #endif
+
+		use_dma = i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD &&
+			msgs[i].flags & I2C_M_DMA_SAFE;
 		if (msgs[i].flags & I2C_M_RD) {
-			result = i2c_imx_read(i2c_imx, &msgs[i], is_lastmsg, atomic);
+			int block_data = msgs->flags & I2C_M_RECV_LEN;
+
+			if (atomic)
+				result = i2c_imx_atomic_read(i2c_imx, &msgs[i], is_lastmsg);
+			else if (use_dma && !block_data)
+				result = i2c_imx_dma_read(i2c_imx, &msgs[i], is_lastmsg);
+			else
+				result = i2c_imx_read(i2c_imx, &msgs[i], is_lastmsg, false);
 		} else {
-			if (!atomic &&
-			    i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD &&
-				msgs[i].flags & I2C_M_DMA_SAFE)
+			if (atomic)
+				result = i2c_imx_atomic_write(i2c_imx, &msgs[i]);
+			else if (use_dma)
 				result = i2c_imx_dma_write(i2c_imx, &msgs[i]);
 			else
-				result = i2c_imx_write(i2c_imx, &msgs[i], atomic);
+				result = i2c_imx_write(i2c_imx, &msgs[i], false);
 		}
 		if (result)
 			goto fail0;


