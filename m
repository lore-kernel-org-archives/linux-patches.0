Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D1E2FDC5E;
	Tue, 31 Mar 2026 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976794; cv=none; b=ERxV0tHpbp/rm2WWzFESfQnhAwHpNzsPHqdELwgz819znalk04kID0l+DGIL879vfAO5gzqNF8Fex/KqEldGt2a3Ye5OO7axOCI0aIvIm5zZoRaCafI/DG4IBtmGaoL+ofMd8tamY71gQJeeXXPY6EpoZ+uqsdUyeeSEm6pcAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976794; c=relaxed/simple;
	bh=YbENCAdOQa2VtMyhTKhW+g/GD15Td8gec94NIap0ebM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhmbEbraPyLRsiFWdVi4oiuJme9N+iCBYRdvNttjNbgBFMDmZd1+xag9F8M36QqbaU1hJsj+w6hUnpjjapNF/vPwWvKfVEeFr5ntvsgkf2htsLXlVUA428YF2lhPX+4mwJ3RHs7UR7ytOuw3Sv+Df5AqPMl+Ub+/5TgIoN4Nv3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VatQ+MRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VatQ+MRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E492C19423;
	Tue, 31 Mar 2026 17:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976794;
	bh=YbENCAdOQa2VtMyhTKhW+g/GD15Td8gec94NIap0ebM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VatQ+MRTJiLOr6mIJHdulv3xqOJFmW2dvElwQyAw+oRejP9VxDTPNcGIUItYsaGVj
	 N/gUCg+Pl+EtZNDVBFPlmU15W4oAQHdM09qiNlX+po0VzN5pP0xy5L2daA0YWJv9jZ
	 jRgZlakulv/6KMVKplg16laoOXDgWQdwmK0Wkq5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 229/309] i2c: imx: ensure no clock is generated after last read
Date: Tue, 31 Mar 2026 18:22:12 +0200
Message-ID: <20260331161802.009654847@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit 13101db735bdb29c5f60e95fb578690bd178b30f upstream.

When reading from the I2DR register, right after releasing the bus by
clearing MSTA and MTX, the I2C controller might still generate an
additional clock cycle which can cause devices to misbehave. Ensure to
only read from I2DR after the bus is not busy anymore. Because this
requires polling, the read of the last byte is moved outside of the
interrupt handler.

An example for such a failing transfer is this:
i2ctransfer -y -a 0 w1@0x00 0x02 r1
Error: Sending messages failed: Connection timed out
It does not happen with every device because not all devices react to
the additional clock cycle.

Fixes: 5f5c2d4579ca ("i2c: imx: prevent rescheduling in non dma mode")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260218150940.131354-3-eichest@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |   51 ++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 19 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1018,8 +1018,9 @@ static inline int i2c_imx_isr_read(struc
 	return 0;
 }
 
-static inline void i2c_imx_isr_read_continue(struct imx_i2c_struct *i2c_imx)
+static inline enum imx_i2c_state i2c_imx_isr_read_continue(struct imx_i2c_struct *i2c_imx)
 {
+	enum imx_i2c_state next_state = IMX_I2C_STATE_READ_CONTINUE;
 	unsigned int temp;
 
 	if ((i2c_imx->msg->len - 1) == i2c_imx->msg_buf_idx) {
@@ -1033,18 +1034,20 @@ static inline void i2c_imx_isr_read_cont
 				i2c_imx->stopped =  1;
 			temp &= ~(I2CR_MSTA | I2CR_MTX);
 			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
-		} else {
-			/*
-			 * For i2c master receiver repeat restart operation like:
-			 * read -> repeat MSTA -> read/write
-			 * The controller must set MTX before read the last byte in
-			 * the first read operation, otherwise the first read cost
-			 * one extra clock cycle.
-			 */
-			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
-			temp |= I2CR_MTX;
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+			return IMX_I2C_STATE_DONE;
 		}
+		/*
+		 * For i2c master receiver repeat restart operation like:
+		 * read -> repeat MSTA -> read/write
+		 * The controller must set MTX before read the last byte in
+		 * the first read operation, otherwise the first read cost
+		 * one extra clock cycle.
+		 */
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp |= I2CR_MTX;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+		next_state = IMX_I2C_STATE_DONE;
 	} else if (i2c_imx->msg_buf_idx == (i2c_imx->msg->len - 2)) {
 		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
 		temp |= I2CR_TXAK;
@@ -1052,6 +1055,7 @@ static inline void i2c_imx_isr_read_cont
 	}
 
 	i2c_imx->msg->buf[i2c_imx->msg_buf_idx++] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+	return next_state;
 }
 
 static inline void i2c_imx_isr_read_block_data_len(struct imx_i2c_struct *i2c_imx)
@@ -1088,11 +1092,9 @@ static irqreturn_t i2c_imx_master_isr(st
 		break;
 
 	case IMX_I2C_STATE_READ_CONTINUE:
-		i2c_imx_isr_read_continue(i2c_imx);
-		if (i2c_imx->msg_buf_idx == i2c_imx->msg->len) {
-			i2c_imx->state = IMX_I2C_STATE_DONE;
+		i2c_imx->state = i2c_imx_isr_read_continue(i2c_imx);
+		if (i2c_imx->state == IMX_I2C_STATE_DONE)
 			wake_up(&i2c_imx->queue);
-		}
 		break;
 
 	case IMX_I2C_STATE_READ_BLOCK_DATA:
@@ -1490,6 +1492,7 @@ static int i2c_imx_read(struct imx_i2c_s
 			bool is_lastmsg)
 {
 	int block_data = msgs->flags & I2C_M_RECV_LEN;
+	int ret = 0;
 
 	dev_dbg(&i2c_imx->adapter.dev,
 		"<%s> write slave address: addr=0x%x\n",
@@ -1522,10 +1525,20 @@ static int i2c_imx_read(struct imx_i2c_s
 		dev_err(&i2c_imx->adapter.dev, "<%s> read timedout\n", __func__);
 		return -ETIMEDOUT;
 	}
-	if (i2c_imx->is_lastmsg && !i2c_imx->stopped)
-		return i2c_imx_bus_busy(i2c_imx, 0, false);
+	if (i2c_imx->is_lastmsg) {
+		if (!i2c_imx->stopped)
+			ret = i2c_imx_bus_busy(i2c_imx, 0, false);
+		/*
+		 * Only read the last byte of the last message after the bus is
+		 * not busy. Else the controller generates another clock which
+		 * might confuse devices.
+		 */
+		if (!ret)
+			i2c_imx->msg->buf[i2c_imx->msg_buf_idx++] = imx_i2c_read_reg(i2c_imx,
+										     IMX_I2C_I2DR);
+	}
 
-	return 0;
+	return ret;
 }
 
 static int i2c_imx_xfer_common(struct i2c_adapter *adapter,


