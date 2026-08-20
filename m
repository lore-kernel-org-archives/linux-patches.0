Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D2D47CC73;
	Thu, 20 Aug 2026 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243522; cv=none; b=EzZzIKIDoRGazeeQibSwODEvmRmSu0E41s5Mv1cll6UZbuN4BMypK3mW/oznuJyh2VfIiXgzC1XjobDdG17wxCFc9QZvMuZ+EBal9nn153MQXONHrWPR5tKzV2dOg1/9zGnt4YDgGPqFqLk/V6RQ5bIupTlSW8V/PPb7SF++fyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243522; c=relaxed/simple;
	bh=ASpEx7eMlHvF4FynHVRBy30IUoXIfDpHyM6eqksOC/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTQGE35QmUEmdwmFx3PabzuQ6WmeUOnfu8cw5wrha3UpyJV7SkKms5caSBUGKpycyCAwGX1GMB4c1ofZfRAvmHXt83mZXqBd6Ihp22iANJyDF74W3Sl8pMK83pg2zUtuY57GBAF+u37zmrMBgziR71o58/eLmmGbdXMnJhqnTWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlO6PQ2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlO6PQ2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEC21F000E9;
	Thu, 20 Aug 2026 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243521;
	bh=89gJ6q+C3dYQcWq4M689YoU6HJFd/2gtuYqDOHJDl54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlO6PQ2yb4Gzjkvjr7mJ6ZD7YEWsZDoHEJOFEkFs3j7A/AijRQ/uiwKbXdnTEDSNG
	 WZvjA5PxG39I0am5GCB8X5xkQABXKEtgIPpfAHtmOBSJfRAxJjL/qeiRbR7CTb38n0
	 e1KK8pYWvj0MWc2RTh8Lf8d2ZZs6Pb3am9ky7AlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Carlos Song <carlos.song@nxp.com>,
	Stefan Eichenberger <eichest@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/272] i2c: imx: fix locked bus on SMBus block-read of 0 (atomic)
Date: Thu, 20 Aug 2026 16:55:08 +0200
Message-ID: <20260820145234.983160460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit cb2fc37857693b55909fb77dc2c87cfbc1cdc476 ]

SMBus 3.1 6.5.7 allows a Block Read byte count of 0, but the atomic
(polling) path rejects it as -EPROTO. Worse, it returns without a
NACK+STOP: the next receive cycle has already started, so the target
keeps holding SDA and the bus stays stuck until a power cycle for
this i2c controller.

Reading I2DR to obtain the count likewise arms the next byte on the
count > I2C_SMBUS_BLOCK_MAX path, which also returned -EPROTO directly
and left the bus held.

Handle both: NACK the in-flight dummy byte (TXAK) and extend msgs->len so
the existing last-byte handling emits STOP; the dummy byte is discarded.
A count of 0 is a valid empty block read; a count above
I2C_SMBUS_BLOCK_MAX is still reported as -EPROTO, but only after the bus
has been released.

The interrupt-driven path has the same flaw from a later commit and is
fixed separately, as it carries a different Fixes: tag and stable range.

Fixes: 8e8782c71595 ("i2c: imx: add SMBus block read support")
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Cc: <stable@vger.kernel.org> # v3.16+
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Stefan Eichenberger <eichest@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260713-for-upstream-i2c-lx2160-fix-v1-v3-1-073ac9e103a5@free.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1152,6 +1152,7 @@ static int i2c_imx_read(struct imx_i2c_s
 	int i, result;
 	unsigned int temp;
 	int block_data = msgs->flags & I2C_M_RECV_LEN;
+	int block_err = 0;
 
 	result = i2c_imx_prepare_read(i2c_imx, msgs, atomic, false);
 	if (result)
@@ -1173,8 +1174,20 @@ static int i2c_imx_read(struct imx_i2c_s
 		 */
 		if ((!i) && block_data) {
 			len = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
-			if ((len == 0) || (len > I2C_SMBUS_BLOCK_MAX))
-				return -EPROTO;
+			if ((len == 0) || (len > I2C_SMBUS_BLOCK_MAX)) {
+				/*
+				 * SMBus 3.1 6.5.7: support count byte of 0.
+				 * I2C_SMBUS_BLOCK_MAX case should not hold the SDA either.
+				 */
+				if (len > I2C_SMBUS_BLOCK_MAX)
+					block_err = -EPROTO;
+				temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+				temp |= I2CR_TXAK;
+				imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+				msgs->buf[0] = 0;
+				msgs->len = 2;
+				continue;
+			}
 			dev_dbg(&i2c_imx->adapter.dev,
 				"<%s> read length: 0x%X\n",
 				__func__, len);
@@ -1222,7 +1235,7 @@ static int i2c_imx_read(struct imx_i2c_s
 			"<%s> read byte: B%d=0x%X\n",
 			__func__, i, msgs->buf[i]);
 	}
-	return 0;
+	return block_err;
 }
 
 static int i2c_imx_atomic_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs,


