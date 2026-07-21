Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270E43F12CE;
	Tue, 21 Jul 2026 17:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654679; cv=none; b=MYDNZGXsANv8RP/IyhXnVdiDRGOhVKdIQ5/EKEAwXwdcaE0WsnFPLDeWFaZHY/MqQDx3jrkM8BNknCpInWNacGj1WjsvBNhDUd9643NU4RMLaH+m34PsX4KjbUFeIbJ5XzA+GHzPW0jhN0FchMyvZ5zjnTRipPp+4EbPhBGmbg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654679; c=relaxed/simple;
	bh=2rjsuYOZrRFMSXD3qE0PYTC+QeZRkSyq6AjS7Qpwip0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2tEsu8TQBY+1iqnoADaKcyUpTjxKXfnMKb4wkGQHzhiG2j2fS88y5CANfVjBcssrhm9cloFRMUHpWPjQriWR4BCIICgXZUcqKLpL2nHZQfVoxT/acEMtA3g7pdJt5eIh/FW8UKqeR/X+4wI/SGm0rtru1vzaAz5artdl6IjzKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iElr1lZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iElr1lZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822481F000E9;
	Tue, 21 Jul 2026 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654678;
	bh=+USbn5e4O4XAMkAIORY5dm73oLk0jAxw8y3PhMYLXKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iElr1lZPhQitcFPnFxDwz+DfYSxGCU8rDF0SgCdd9IY0MYHiW32nD1vwnsxb/3LPX
	 VhyxQSwY3IumPnpEjv/CjpHHJfl8cmc0C+r0IcFwZc+rXmoQc69+HiqqR1XZCFY0tp
	 LotA6TYoOHA8Y5HK7aHS+SCpb9N7QRFfgynJtFJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Carlos Song <carlos.song@nxp.com>,
	Stefan Eichenberger <eichest@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 1794/2077] i2c: imx: fix locked bus on SMBus block-read of 0 (IRQ)
Date: Tue, 21 Jul 2026 17:24:27 +0200
Message-ID: <20260721152635.061133704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Jardin <vjardin@free.fr>

commit 07fd9385f0d87dff4b34f355f68adf701080cb24 upstream.

SMBus 3.1 6.5.7 allows a Block Read byte count of 0, but the
interrupt-driven block-read state machine rejects it as -EPROTO. Worse,
it returns without a NACK+STOP: the next receive cycle has already
started, so the target keeps holding SDA and the bus stays stuck until a
power cycle of this i2c controller.

Accept count=0: NACK the in-flight dummy byte (TXAK) and set msg->len to
2 so i2c_imx_isr_read_continue() emits STOP via its normal last-byte
path. The dummy byte is discarded; block-read callers only consume
buf[0..count-1].

Reading I2DR has likewise already armed the next byte on the
count > I2C_SMBUS_BLOCK_MAX error path, so NACK it (TXAK) before aborting
with -EPROTO; otherwise the failing transfer's STOP cannot complete and
the bus stays held.

The atomic path regressed earlier (v3.16) and is fixed separately; this
patch covers only the v6.13 state-machine rework.

Fixes: 5f5c2d4579ca ("i2c: imx: prevent rescheduling in non dma mode")
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Cc: <stable@vger.kernel.org> # v6.13+
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Stefan Eichenberger <eichest@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260713-for-upstream-i2c-lx2160-fix-v1-v3-2-073ac9e103a5@free.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1061,11 +1061,28 @@ static inline enum imx_i2c_state i2c_imx
 static inline void i2c_imx_isr_read_block_data_len(struct imx_i2c_struct *i2c_imx)
 {
 	u8 len = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+	unsigned int temp;
 
 	if (len == 0 || len > I2C_SMBUS_BLOCK_MAX) {
+		/*
+		 * SMBus 3.1 6.5.7: support count byte of 0.
+		 * I2C_SMBUS_BLOCK_MAX case should not hold the SDA either.
+		 * So NACK it (TXAK) to not hold the bus.
+		 */
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp |= I2CR_TXAK;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+		if (len == 0) {
+			i2c_imx->msg->buf[i2c_imx->msg_buf_idx++] = 0;
+			i2c_imx->msg->len = 2;
+			return;
+		}
+
 		i2c_imx->isr_result = -EPROTO;
 		i2c_imx->state = IMX_I2C_STATE_FAILED;
 		wake_up(&i2c_imx->queue);
+		return;
 	}
 	i2c_imx->msg->len += len;
 	i2c_imx->msg->buf[i2c_imx->msg_buf_idx++] = len;


