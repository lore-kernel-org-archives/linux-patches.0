Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A765402BA9;
	Tue, 31 Mar 2026 16:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975344; cv=none; b=FATzvOY4psutOFRi3DC+UP4Kktq3pfY03y75TLo4JXYztXN0zuiz/uC+0t4CUT3cij1x5KIZ6GmC0xHLAKWcc49ea+Y16fX/jmfoaChxTlj+uKLIsuGeVtzylyRCGXj91LbHyUluL+jgKBD+bPY58cCHbYEYCVc7s8c2hD+oM2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975344; c=relaxed/simple;
	bh=zsZ5gYxIt0lNI9kjlshpNVS+P8HOOky5AdD4qf2ASLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgaGH8svoGXDb3lu710GG0/YQVDsycPxYb9I1xzGuQSsoG0bfCkmA0mkVvKFejcBhC8dZWiHFJQme9LlQAr4dGQP3v7HKqgwgg58Khywyuqzh5Z/Lm4xBbj2XT/AoQhtu1sX14ShYKEnQV5Zz34JgLLfh6O2OaF5hYA1ULTS2Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOq4603B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOq4603B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13105C19423;
	Tue, 31 Mar 2026 16:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975344;
	bh=zsZ5gYxIt0lNI9kjlshpNVS+P8HOOky5AdD4qf2ASLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOq4603BhmFXn6r5gC3F5Ra4LKNm4vomKrlmPB4SKhGEuyR1iE1ztDcdc14aTWt2R
	 MMds6/QNXTCrK6p1X4hk/UL+xYwnjx6Q8jzX9UFootXwaBOkvC2UGvq909pW0Z8DHX
	 dHd/Ch6++O5C+M0bYWmCAY8ylZ1rY8id+xP2TnwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.19 258/342] i2c: imx: ensure no clock is generated after last read
Date: Tue, 31 Mar 2026 18:21:31 +0200
Message-ID: <20260331161808.448264029@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


