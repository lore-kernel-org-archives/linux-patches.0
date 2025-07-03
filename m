Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8AA2E7BD6;
	Thu,  3 Jul 2025 15:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554947; cv=none; b=YjXDBWBdGMYCdXfUqHo8PBkWluxuHuzDIT82hUJfWEbYjxAwuu1+JKlpdHWpOJmJVOR/isYhG2QkIexj2KqS3qzM4QEoLIGpE7uAa5LcGKkYxCn8MxZQkKR+6Hbb+qp5oTBNkUdfIIxfQACrC3ktOIPLnHNDo9tgXpji2xgua7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554947; c=relaxed/simple;
	bh=gEcTyzmUHPViI1Q+7ZtA0iDwgaBX1O2x37Y/ad+KCDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn0NqiE521anp9KPhHB/G6llU3cfQk6U940DtSa5LiziOrRKkyb+0LnDr+RajQJG0J2Tq8DCF0to4J0xO+bfUjptfIMxrpBVD9nFphbfMYmD4lRnZtUSPFreI5hJZJZMZKf8Vbif23vAvXOlx3DMM5HhtW6gz8o/3+mUuXelRJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzwVCtgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzwVCtgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC26C4CEE3;
	Thu,  3 Jul 2025 15:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554947;
	bh=gEcTyzmUHPViI1Q+7ZtA0iDwgaBX1O2x37Y/ad+KCDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzwVCtgWVqhbULlH5FCnGNBgurDDWG30ff23rZJWOmjwxEA32UTGulGp33F+5hTJx
	 rbAqy9FWInbb2Msi4QTwUBkV/yzwB54Yk0VzXbmkd/PWxpzdcWBmzYpoyiUhTg/zs+
	 JKH1YRcYV8TL+/7OPke/PMiVgAYqn3XB7pUiOd3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Kucharczyk <lukasz.kucharczyk@leica-geosystems.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Stefan Eichenberger <eichest@gmail.com>,
	Carlos Song <carlos.song@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 098/263] i2c: imx: fix emulated smbus block read
Date: Thu,  3 Jul 2025 16:40:18 +0200
Message-ID: <20250703144008.230719449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Kucharczyk <lukasz.kucharczyk@leica-geosystems.com>

commit a5d0b9e32745277644cda8d7d334e7080bd339bf upstream.

Acknowledge the byte count submitted by the target.
When I2C_SMBUS_BLOCK_DATA read operation is executed by
i2c_smbus_xfer_emulated(), the length of the second (read) message is set
to 1. Length of the block is supposed to be obtained from the target by the
underlying bus driver.
The i2c_imx_isr_read() function should emit the acknowledge on i2c bus
after reading the first byte (i.e., byte count) while processing such
message (as defined in Section 6.5.7 of System Management Bus
Specification [1]). Without this acknowledge, the target does not submit
subsequent bytes and the controller only reads 0xff's.

In addition, store the length of block data obtained from the target in
the buffer provided by i2c_smbus_xfer_emulated() - otherwise the first
byte of actual data is erroneously interpreted as length of the data
block.

[1] https://smbus.org/specs/SMBus_3_3_20240512.pdf

Fixes: 5f5c2d4579ca ("i2c: imx: prevent rescheduling in non dma mode")
Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@leica-geosystems.com>
Cc: <stable@vger.kernel.org> # v6.13+
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Stefan Eichenberger <eichest@gmail.com>
Reviewed-by: Carlos Song <carlos.song@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250520122252.1475403-1-lukasz.kucharczyk@leica-geosystems.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index e5732b0557fb..205cc132fdec 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1008,7 +1008,7 @@ static inline int i2c_imx_isr_read(struct imx_i2c_struct *i2c_imx)
 	/* setup bus to read data */
 	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
 	temp &= ~I2CR_MTX;
-	if (i2c_imx->msg->len - 1)
+	if ((i2c_imx->msg->len - 1) || (i2c_imx->msg->flags & I2C_M_RECV_LEN))
 		temp &= ~I2CR_TXAK;
 
 	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
@@ -1063,6 +1063,7 @@ static inline void i2c_imx_isr_read_block_data_len(struct imx_i2c_struct *i2c_im
 		wake_up(&i2c_imx->queue);
 	}
 	i2c_imx->msg->len += len;
+	i2c_imx->msg->buf[i2c_imx->msg_buf_idx++] = len;
 }
 
 static irqreturn_t i2c_imx_master_isr(struct imx_i2c_struct *i2c_imx, unsigned int status)
-- 
2.50.0



