Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B234C18C331;
	Tue, 10 Sep 2024 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962178; cv=none; b=ZsEAcRWCJPba+fflc6AaLPPb2vNPh9nz9cmYpqP8ro/iJksB1qMaOsYHfvX8TEyIvjvhp1ypgCRB6EylWG12uUTYQ8/RljQ8Y2aGtCmtPePVH/yvG/dx//Kp4wKf4/R60Ti6pw+kR/oAb/+47x2Q8tt/RICcx9buVLlg+GAyuCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962178; c=relaxed/simple;
	bh=w+y0TLl4MxMWHGP1/CDsmBOzDDrRgODK36w0UsBOtnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RRBUUiPlAlL5TosJq4VFetg2la7QmHAJEQSAv4s6lsM0RhcH/rtRG7Wvr7uINbbZL84O8jnCADFujLoo+B/LqFR7r7c1tbOIjTRYbBoRyWm6DsINZfiTmlV83JsC3aUd9XXaTbit4vTdSKAXhlZCBOznaVTsOoO4AnYE5jP+wtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHWIg3RV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHWIg3RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B59C4CECF;
	Tue, 10 Sep 2024 09:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962178;
	bh=w+y0TLl4MxMWHGP1/CDsmBOzDDrRgODK36w0UsBOtnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHWIg3RV9z5K8pDEn70FAqebup21bJUPI2eBHnFIJW1fQpPTWVPWWBB5f/1c8Z1xf
	 Lh2FazfOLrlcbyY41eSHphxZX1K6q7kfN00ZdVm3SlVp4ryoEKpL1KXnC1ChdvHOV+
	 3i4te0lSAdEDUmdZnUOiQYBU1sIno0lmHHO+sT7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20Alth=C3=B6fer?= <Stefan.Althoefer@janztec.com>,
	Thomas Kopp <thomas.kopp@microchip.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 322/375] can: mcp251xfd: rx: prepare to workaround broken RX FIFO head index erratum
Date: Tue, 10 Sep 2024 11:31:59 +0200
Message-ID: <20240910092633.380447534@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 85505e585637a737e4713c1386c30e37c325b82e ]

This is a preparatory patch to work around erratum DS80000789E 6 of
the mcp2518fd, the other variants of the chip family (mcp2517fd and
mcp251863) are probably also affected.

When handling the RX interrupt, the driver iterates over all pending
FIFOs (which are implemented as ring buffers in hardware) and reads
the FIFO header index from the RX FIFO STA register of the chip.

In the bad case, the driver reads a too large head index. In the
original code, the driver always trusted the read value, which caused
old CAN frames that were already processed, or new, incompletely
written CAN frames to be (re-)processed.

Instead of reading and trusting the head index, read the head index
and calculate the number of CAN frames that were supposedly received -
replace mcp251xfd_rx_ring_update() with mcp251xfd_get_rx_len().

The mcp251xfd_handle_rxif_ring() function reads the received CAN
frames from the chip, iterates over them and pushes them into the
network stack. Prepare that the iteration can be stopped if an old CAN
frame is detected. The actual code to detect old or incomplete frames
and abort will be added in the next patch.

Link: https://lore.kernel.org/all/BL3PR11MB64844C1C95CA3BDADAE4D8CCFBC99@BL3PR11MB6484.namprd11.prod.outlook.com
Reported-by: Stefan Althöfer <Stefan.Althoefer@janztec.com>
Closes: https://lore.kernel.org/all/FR0P281MB1966273C216630B120ABB6E197E89@FR0P281MB1966.DEUP281.PROD.OUTLOOK.COM
Tested-by: Stefan Althöfer <Stefan.Althoefer@janztec.com>
Tested-by: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    |  2 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c  | 89 +++++++++++--------
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     | 12 +--
 3 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 3a941a71c78f..5f92aed62ff9 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -523,6 +523,8 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 		}
 
 		rx_ring->obj_num = rx_obj_num;
+		rx_ring->obj_num_shift_to_u8 = BITS_PER_TYPE(rx_ring->obj_num_shift_to_u8) -
+			ilog2(rx_obj_num);
 		rx_ring->obj_size = rx_obj_size;
 		priv->rx[i] = rx_ring;
 	}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
index 5e2f39de88f3..5d0fb1c454cd 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
@@ -2,7 +2,7 @@
 //
 // mcp251xfd - Microchip MCP251xFD Family CAN controller driver
 //
-// Copyright (c) 2019, 2020, 2021 Pengutronix,
+// Copyright (c) 2019, 2020, 2021, 2023 Pengutronix,
 //               Marc Kleine-Budde <kernel@pengutronix.de>
 //
 // Based on:
@@ -16,23 +16,14 @@
 
 #include "mcp251xfd.h"
 
-static inline int
-mcp251xfd_rx_head_get_from_chip(const struct mcp251xfd_priv *priv,
-				const struct mcp251xfd_rx_ring *ring,
-				u8 *rx_head, bool *fifo_empty)
+static inline bool mcp251xfd_rx_fifo_sta_empty(const u32 fifo_sta)
 {
-	u32 fifo_sta;
-	int err;
-
-	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOSTA(ring->fifo_nr),
-			  &fifo_sta);
-	if (err)
-		return err;
-
-	*rx_head = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
-	*fifo_empty = !(fifo_sta & MCP251XFD_REG_FIFOSTA_TFNRFNIF);
+	return !(fifo_sta & MCP251XFD_REG_FIFOSTA_TFNRFNIF);
+}
 
-	return 0;
+static inline bool mcp251xfd_rx_fifo_sta_full(const u32 fifo_sta)
+{
+	return fifo_sta & MCP251XFD_REG_FIFOSTA_TFERFFIF;
 }
 
 static inline int
@@ -80,29 +71,49 @@ mcp251xfd_check_rx_tail(const struct mcp251xfd_priv *priv,
 }
 
 static int
-mcp251xfd_rx_ring_update(const struct mcp251xfd_priv *priv,
-			 struct mcp251xfd_rx_ring *ring)
+mcp251xfd_get_rx_len(const struct mcp251xfd_priv *priv,
+		     const struct mcp251xfd_rx_ring *ring,
+		     u8 *len_p)
 {
-	u32 new_head;
-	u8 chip_rx_head;
-	bool fifo_empty;
+	const u8 shift = ring->obj_num_shift_to_u8;
+	u8 chip_head, tail, len;
+	u32 fifo_sta;
 	int err;
 
-	err = mcp251xfd_rx_head_get_from_chip(priv, ring, &chip_rx_head,
-					      &fifo_empty);
-	if (err || fifo_empty)
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOSTA(ring->fifo_nr),
+			  &fifo_sta);
+	if (err)
+		return err;
+
+	if (mcp251xfd_rx_fifo_sta_empty(fifo_sta)) {
+		*len_p = 0;
+		return 0;
+	}
+
+	if (mcp251xfd_rx_fifo_sta_full(fifo_sta)) {
+		*len_p = ring->obj_num;
+		return 0;
+	}
+
+	chip_head = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
+
+	err =  mcp251xfd_check_rx_tail(priv, ring);
+	if (err)
 		return err;
+	tail = mcp251xfd_get_rx_tail(ring);
 
-	/* chip_rx_head, is the next RX-Object filled by the HW.
-	 * The new RX head must be >= the old head.
+	/* First shift to full u8. The subtraction works on signed
+	 * values, that keeps the difference steady around the u8
+	 * overflow. The right shift acts on len, which is an u8.
 	 */
-	new_head = round_down(ring->head, ring->obj_num) + chip_rx_head;
-	if (new_head <= ring->head)
-		new_head += ring->obj_num;
+	BUILD_BUG_ON(sizeof(ring->obj_num) != sizeof(chip_head));
+	BUILD_BUG_ON(sizeof(ring->obj_num) != sizeof(tail));
+	BUILD_BUG_ON(sizeof(ring->obj_num) != sizeof(len));
 
-	ring->head = new_head;
+	len = (chip_head << shift) - (tail << shift);
+	*len_p = len >> shift;
 
-	return mcp251xfd_check_rx_tail(priv, ring);
+	return 0;
 }
 
 static void
@@ -208,6 +219,8 @@ mcp251xfd_handle_rxif_ring_uinc(const struct mcp251xfd_priv *priv,
 	if (!len)
 		return 0;
 
+	ring->head += len;
+
 	/* Increment the RX FIFO tail pointer 'len' times in a
 	 * single SPI message.
 	 *
@@ -233,22 +246,22 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 			   struct mcp251xfd_rx_ring *ring)
 {
 	struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj = ring->obj;
-	u8 rx_tail, len;
+	u8 rx_tail, len, l;
 	int err, i;
 
-	err = mcp251xfd_rx_ring_update(priv, ring);
+	err = mcp251xfd_get_rx_len(priv, ring, &len);
 	if (err)
 		return err;
 
-	while ((len = mcp251xfd_get_rx_linear_len(ring))) {
+	while ((l = mcp251xfd_get_rx_linear_len(ring, len))) {
 		rx_tail = mcp251xfd_get_rx_tail(ring);
 
 		err = mcp251xfd_rx_obj_read(priv, ring, hw_rx_obj,
-					    rx_tail, len);
+					    rx_tail, l);
 		if (err)
 			return err;
 
-		for (i = 0; i < len; i++) {
+		for (i = 0; i < l; i++) {
 			err = mcp251xfd_handle_rxif_one(priv, ring,
 							(void *)hw_rx_obj +
 							i * ring->obj_size);
@@ -256,9 +269,11 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 				return err;
 		}
 
-		err = mcp251xfd_handle_rxif_ring_uinc(priv, ring, len);
+		err = mcp251xfd_handle_rxif_ring_uinc(priv, ring, l);
 		if (err)
 			return err;
+
+		len -= l;
 	}
 
 	return 0;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 4628bf847bc9..2e5cee6ad0c4 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -558,6 +558,7 @@ struct mcp251xfd_rx_ring {
 	u8 nr;
 	u8 fifo_nr;
 	u8 obj_num;
+	u8 obj_num_shift_to_u8;
 	u8 obj_size;
 
 	union mcp251xfd_write_reg_buf irq_enable_buf;
@@ -907,18 +908,9 @@ static inline u8 mcp251xfd_get_rx_tail(const struct mcp251xfd_rx_ring *ring)
 	return ring->tail & (ring->obj_num - 1);
 }
 
-static inline u8 mcp251xfd_get_rx_len(const struct mcp251xfd_rx_ring *ring)
-{
-	return ring->head - ring->tail;
-}
-
 static inline u8
-mcp251xfd_get_rx_linear_len(const struct mcp251xfd_rx_ring *ring)
+mcp251xfd_get_rx_linear_len(const struct mcp251xfd_rx_ring *ring, u8 len)
 {
-	u8 len;
-
-	len = mcp251xfd_get_rx_len(ring);
-
 	return min_t(u8, len, ring->obj_num - mcp251xfd_get_rx_tail(ring));
 }
 
-- 
2.43.0



