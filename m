Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F614F12C;
	Tue, 10 Sep 2024 09:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962184; cv=none; b=q3hFbDXED/ec2T6GijhUmUWvZHN3l/daloZrsfCC6KiaAebBJLrXAG1ZRlfYbPYGtP7a6Z+08B6Lg984UVkdVni6xAI+y6hZ1A78k9fH5qIZpNCSeadnZJOoo7Z0wasSBm+Oztz2ivIsaJ28TLaXIq4FRwrX9cSjvWalOJRWrAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962184; c=relaxed/simple;
	bh=6RDvFcTTSA9/48j/6wLfMRVda1DeM6EZEb/GpfXYOA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iO2QsuowXcyQPnwdJVXJLpNmw/DvIfIaA/93BZcTYf8q4ZPf2nfYp+mp62doiNe47iv+bu9IpS/XN33mWymAoSWkTJZ/I/kBbA/R8/gSENJNl7eia+JjTW3OtlpSjR+ENmbw9gh3YW5AW6NqzWFvEK7W3D/3JA7cKb7IyVO8NzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1sLVb8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1sLVb8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116DFC4CEC3;
	Tue, 10 Sep 2024 09:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962184;
	bh=6RDvFcTTSA9/48j/6wLfMRVda1DeM6EZEb/GpfXYOA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1sLVb8ekiBSXR51tGswsZW3i3jYj2kQqEUBVGdFmlmORbYtdoPyjkAkMUc43bgSz
	 4SbAKFzPdcg5sIoWywCmPJvHWx3lZf2S3kt1bb5i7CQfufnpANh+bAT4f2bVo2Bvbz
	 z4HQ0WKPzK3NffWfTFdnWfs4knjqVKpoD4lae+MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20Alth=C3=B6fer?= <Stefan.Althoefer@janztec.com>,
	Thomas Kopp <thomas.kopp@microchip.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 324/375] can: mcp251xfd: rx: add workaround for erratum DS80000789E 6 of mcp2518fd
Date: Tue, 10 Sep 2024 11:32:01 +0200
Message-ID: <20240910092633.450737844@linuxfoundation.org>
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

[ Upstream commit 24436be590c6fbb05f6161b0dfba7d9da60214aa ]

This patch tries to works around erratum DS80000789E 6 of the
mcp2518fd, the other variants of the chip family (mcp2517fd and
mcp251863) are probably also affected.

In the bad case, the driver reads a too large head index. In the
original code, the driver always trusted the read value, which caused
old, already processed CAN frames or new, incompletely written CAN
frames to be (re-)processed.

To work around this issue, keep a per FIFO timestamp [1] of the last
valid received CAN frame and compare against the timestamp of every
received CAN frame. If an old CAN frame is detected, abort the
iteration and mark the number of valid CAN frames as processed in the
chip by incrementing the FIFO's tail index.

Further tests showed that this workaround can recognize old CAN
frames, but a small time window remains in which partially written CAN
frames [2] are not recognized but then processed. These CAN frames
have the correct data and time stamps, but the DLC has not yet been
updated.

[1] As the raw timestamp overflows every 107 seconds (at the usual
    clock rate of 40 MHz) convert it to nanoseconds with the
    timecounter framework and use this to detect stale CAN frames.

Link: https://lore.kernel.org/all/BL3PR11MB64844C1C95CA3BDADAE4D8CCFBC99@BL3PR11MB6484.namprd11.prod.outlook.com [2]
Reported-by: Stefan Althöfer <Stefan.Althoefer@janztec.com>
Closes: https://lore.kernel.org/all/FR0P281MB1966273C216630B120ABB6E197E89@FR0P281MB1966.DEUP281.PROD.OUTLOOK.COM
Tested-by: Stefan Althöfer <Stefan.Althoefer@janztec.com>
Tested-by: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    |  1 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c  | 32 +++++++++++++++++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  3 ++
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 5f92aed62ff9..f72582d4d3e8 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -206,6 +206,7 @@ mcp251xfd_ring_init_rx(struct mcp251xfd_priv *priv, u16 *base, u8 *fifo_nr)
 	int i, j;
 
 	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
+		rx_ring->last_valid = timecounter_read(&priv->tc);
 		rx_ring->head = 0;
 		rx_ring->tail = 0;
 		rx_ring->base = *base;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
index a79e6c661ecc..fe897f3e4c12 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
@@ -159,8 +159,6 @@ mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
 
 	if (!(hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR))
 		memcpy(cfd->data, hw_rx_obj->data, cfd->len);
-
-	mcp251xfd_skb_set_timestamp_raw(priv, skb, hw_rx_obj->ts);
 }
 
 static int
@@ -171,8 +169,26 @@ mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
 	struct net_device_stats *stats = &priv->ndev->stats;
 	struct sk_buff *skb;
 	struct canfd_frame *cfd;
+	u64 timestamp;
 	int err;
 
+	/* According to mcp2518fd erratum DS80000789E 6. the FIFOCI
+	 * bits of a FIFOSTA register, here the RX FIFO head index
+	 * might be corrupted and we might process past the RX FIFO's
+	 * head into old CAN frames.
+	 *
+	 * Compare the timestamp of currently processed CAN frame with
+	 * last valid frame received. Abort with -EBADMSG if an old
+	 * CAN frame is detected.
+	 */
+	timestamp = timecounter_cyc2time(&priv->tc, hw_rx_obj->ts);
+	if (timestamp <= ring->last_valid) {
+		stats->rx_fifo_errors++;
+
+		return -EBADMSG;
+	}
+	ring->last_valid = timestamp;
+
 	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_FDF)
 		skb = alloc_canfd_skb(priv->ndev, &cfd);
 	else
@@ -183,6 +199,7 @@ mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
 		return 0;
 	}
 
+	mcp251xfd_skb_set_timestamp(skb, timestamp);
 	mcp251xfd_hw_rx_obj_to_skb(priv, hw_rx_obj, skb);
 	err = can_rx_offload_queue_timestamp(&priv->offload, skb, hw_rx_obj->ts);
 	if (err)
@@ -265,7 +282,16 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 			err = mcp251xfd_handle_rxif_one(priv, ring,
 							(void *)hw_rx_obj +
 							i * ring->obj_size);
-			if (err)
+
+			/* -EBADMSG means we're affected by mcp2518fd
+			 * erratum DS80000789E 6., i.e. the timestamp
+			 * in the RX object is older that the last
+			 * valid received CAN frame. Don't process any
+			 * further and mark processed frames as good.
+			 */
+			if (err == -EBADMSG)
+				return mcp251xfd_handle_rxif_ring_uinc(priv, ring, i);
+			else if (err)
 				return err;
 		}
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index ae35845d4ce1..991662fbba42 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -554,6 +554,9 @@ struct mcp251xfd_rx_ring {
 	unsigned int head;
 	unsigned int tail;
 
+	/* timestamp of the last valid received CAN frame */
+	u64 last_valid;
+
 	u16 base;
 	u8 nr;
 	u8 fifo_nr;
-- 
2.43.0



