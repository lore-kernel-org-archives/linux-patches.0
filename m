Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE072187339;
	Mon, 12 Aug 2024 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478767; cv=none; b=LCPFrJWdkCtpzEwbcHLBSUVGKQckRBn5KXQnxskgvCF72ou4Cw8ZyGdTNT7BT+gaK07Xc7m3LNZ2rdBWzUoG8nAk8mE6rk+BMt/bbWUpqdCFVPoCkYBaPJHqaxvIKl9MnhU/ZhnFVKpUs3Xo2b0d3rGOMg5ly9RY5OI4tzlzUtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478767; c=relaxed/simple;
	bh=+sy5nQ8F/+cbLQ/95P9GzFAhIZNk3VvssAMxwAUW8hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FXAfFlqb5Ntz27+pLA+Ykh9r/lnGF8YKDolk6g1sXWVV11Gn35pvRknQEnqzuCG+banSg7DavpxHfwnKHm7RQSdNkycS4q0HR/qIsBrSyXcbK9HyXzLBZaioq4wMOo5qJwx0DmIsJL8ckOSp6MdnQejeoFMkFtC6sSv3ZiNGJzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlzoSeiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlzoSeiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAB6C32782;
	Mon, 12 Aug 2024 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478766;
	bh=+sy5nQ8F/+cbLQ/95P9GzFAhIZNk3VvssAMxwAUW8hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlzoSeiFt7TXQWl78KlYyn2en5WBMX7a9ccmjGx1Bbh66SffBNZX/P/PPLEqNwRPQ
	 EOSeYenb5rCONZPPXlKCQuqjF9ZNc+gh97mmk1TfLtU6B0FNMWU9GWDZQxQrw4xi6E
	 A02Oeg+7bxSzYvLQEpvU/6f7plQeK8gq+QGmlkck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20Alth=C3=B6fer?= <Stefan.Althoefer@janztec.com>,
	Thomas Kopp <thomas.kopp@microchip.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/150] can: mcp251xfd: tef: prepare to workaround broken TEF FIFO tail index erratum
Date: Mon, 12 Aug 2024 18:01:52 +0200
Message-ID: <20240812160126.366688377@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit b8e0ddd36ce9536ad7478dd27df06c9ae92370ba ]

This is a preparatory patch to work around a problem similar to
erratum DS80000789E 6 of the mcp2518fd, the other variants of the chip
family (mcp2517fd and mcp251863) are probably also affected.

Erratum DS80000789E 6 says "reading of the FIFOCI bits in the FIFOSTA
register for an RX FIFO may be corrupted". However observation shows
that this problem is not limited to RX FIFOs but also effects the TEF
FIFO.

When handling the TEF interrupt, the driver reads the FIFO header
index from the TEF FIFO STA register of the chip.

In the bad case, the driver reads a too large head index. In the
original code, the driver always trusted the read value, which caused
old CAN transmit complete events that were already processed to be
re-processed.

Instead of reading and trusting the head index, read the head index
and calculate the number of CAN frames that were supposedly received -
replace mcp251xfd_tef_ring_update() with mcp251xfd_get_tef_len().

The mcp251xfd_handle_tefif() function reads the CAN transmit complete
events from the chip, iterates over them and pushes them into the
network stack. The original driver already contains code to detect old
CAN transmit complete events, that will be updated in the next patch.

Cc: Stefan Althöfer <Stefan.Althoefer@janztec.com>
Cc: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    |  2 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c | 54 +++++++++++++------
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     | 13 ++---
 3 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index bf3f0f150199d..4d0246a0779a6 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -475,6 +475,8 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 		clear_bit(MCP251XFD_FLAGS_FD_MODE, priv->flags);
 	}
 
+	tx_ring->obj_num_shift_to_u8 = BITS_PER_TYPE(tx_ring->obj_num) -
+		ilog2(tx_ring->obj_num);
 	tx_ring->obj_size = tx_obj_size;
 
 	rem = priv->rx_obj_num;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
index 237617b0c125f..b33192964cf7d 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
@@ -2,7 +2,7 @@
 //
 // mcp251xfd - Microchip MCP251xFD Family CAN controller driver
 //
-// Copyright (c) 2019, 2020, 2021 Pengutronix,
+// Copyright (c) 2019, 2020, 2021, 2023 Pengutronix,
 //               Marc Kleine-Budde <kernel@pengutronix.de>
 //
 // Based on:
@@ -16,6 +16,11 @@
 
 #include "mcp251xfd.h"
 
+static inline bool mcp251xfd_tx_fifo_sta_full(u32 fifo_sta)
+{
+	return !(fifo_sta & MCP251XFD_REG_FIFOSTA_TFNRFNIF);
+}
+
 static inline int
 mcp251xfd_tef_tail_get_from_chip(const struct mcp251xfd_priv *priv,
 				 u8 *tef_tail)
@@ -120,28 +125,44 @@ mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
 	return 0;
 }
 
-static int mcp251xfd_tef_ring_update(struct mcp251xfd_priv *priv)
+static int
+mcp251xfd_get_tef_len(struct mcp251xfd_priv *priv, u8 *len_p)
 {
 	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
-	unsigned int new_head;
-	u8 chip_tx_tail;
+	const u8 shift = tx_ring->obj_num_shift_to_u8;
+	u8 chip_tx_tail, tail, len;
+	u32 fifo_sta;
 	int err;
 
-	err = mcp251xfd_tx_tail_get_from_chip(priv, &chip_tx_tail);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOSTA(priv->tx->fifo_nr),
+			  &fifo_sta);
 	if (err)
 		return err;
 
-	/* chip_tx_tail, is the next TX-Object send by the HW.
-	 * The new TEF head must be >= the old head, ...
+	if (mcp251xfd_tx_fifo_sta_full(fifo_sta)) {
+		*len_p = tx_ring->obj_num;
+		return 0;
+	}
+
+	chip_tx_tail = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
+
+	err =  mcp251xfd_check_tef_tail(priv);
+	if (err)
+		return err;
+	tail = mcp251xfd_get_tef_tail(priv);
+
+	/* First shift to full u8. The subtraction works on signed
+	 * values, that keeps the difference steady around the u8
+	 * overflow. The right shift acts on len, which is an u8.
 	 */
-	new_head = round_down(priv->tef->head, tx_ring->obj_num) + chip_tx_tail;
-	if (new_head <= priv->tef->head)
-		new_head += tx_ring->obj_num;
+	BUILD_BUG_ON(sizeof(tx_ring->obj_num) != sizeof(chip_tx_tail));
+	BUILD_BUG_ON(sizeof(tx_ring->obj_num) != sizeof(tail));
+	BUILD_BUG_ON(sizeof(tx_ring->obj_num) != sizeof(len));
 
-	/* ... but it cannot exceed the TX head. */
-	priv->tef->head = min(new_head, tx_ring->head);
+	len = (chip_tx_tail << shift) - (tail << shift);
+	*len_p = len >> shift;
 
-	return mcp251xfd_check_tef_tail(priv);
+	return 0;
 }
 
 static inline int
@@ -182,13 +203,12 @@ int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 	u8 tef_tail, len, l;
 	int err, i;
 
-	err = mcp251xfd_tef_ring_update(priv);
+	err = mcp251xfd_get_tef_len(priv, &len);
 	if (err)
 		return err;
 
 	tef_tail = mcp251xfd_get_tef_tail(priv);
-	len = mcp251xfd_get_tef_len(priv);
-	l = mcp251xfd_get_tef_linear_len(priv);
+	l = mcp251xfd_get_tef_linear_len(priv, len);
 	err = mcp251xfd_tef_obj_read(priv, hw_tef_obj, tef_tail, l);
 	if (err)
 		return err;
@@ -223,6 +243,8 @@ int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 		struct mcp251xfd_tx_ring *tx_ring = priv->tx;
 		int offset;
 
+		ring->head += len;
+
 		/* Increment the TEF FIFO tail pointer 'len' times in
 		 * a single SPI message.
 		 *
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index b98ded7098a5a..78d12dda08a05 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -519,6 +519,7 @@ struct mcp251xfd_tef_ring {
 
 	/* u8 obj_num equals tx_ring->obj_num */
 	/* u8 obj_size equals sizeof(struct mcp251xfd_hw_tef_obj) */
+	/* u8 obj_num_shift_to_u8 equals tx_ring->obj_num_shift_to_u8 */
 
 	union mcp251xfd_write_reg_buf irq_enable_buf;
 	struct spi_transfer irq_enable_xfer;
@@ -537,6 +538,7 @@ struct mcp251xfd_tx_ring {
 	u8 nr;
 	u8 fifo_nr;
 	u8 obj_num;
+	u8 obj_num_shift_to_u8;
 	u8 obj_size;
 
 	struct mcp251xfd_tx_obj obj[MCP251XFD_TX_OBJ_NUM_MAX];
@@ -843,17 +845,8 @@ static inline u8 mcp251xfd_get_tef_tail(const struct mcp251xfd_priv *priv)
 	return priv->tef->tail & (priv->tx->obj_num - 1);
 }
 
-static inline u8 mcp251xfd_get_tef_len(const struct mcp251xfd_priv *priv)
+static inline u8 mcp251xfd_get_tef_linear_len(const struct mcp251xfd_priv *priv, u8 len)
 {
-	return priv->tef->head - priv->tef->tail;
-}
-
-static inline u8 mcp251xfd_get_tef_linear_len(const struct mcp251xfd_priv *priv)
-{
-	u8 len;
-
-	len = mcp251xfd_get_tef_len(priv);
-
 	return min_t(u8, len, priv->tx->obj_num - mcp251xfd_get_tef_tail(priv));
 }
 
-- 
2.43.0



