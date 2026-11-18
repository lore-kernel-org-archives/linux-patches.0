Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032484;
	b=jgVn+qOnuqCbraY7VVHiMmpThL/BBliDZvTaIRQCmJHrkFuTxFou9Gbk3RuuRRQNbYZS
	 1PNkB5/w1cdHKa8LOShtwAbL310REB28wgveS6Z8a/LV7H3dY1ybMfLuLiLV25IjZqyK/
	 qy4aUk53FHu3gO1yYw8loyN+w23stBDPBZ/hrLV1Js6Cw2KiT5A6J3UTVDhcVAxmNJSJ6
	 MeU8E9JLgv8AlvCuLwchphxl9N5QbOTpCzidtWjYrz/xL+3Ao6dqF1DIk6aQ4+EZPJK4/
	 +vMhFrgGF1tHQHRYIgu97kGE4WxuwJcD1cb8KUeSEJQWwqF1CxhYs35zayl0i73P2BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3JxVrcSs+Dh/ksK522gmb1TeTpBE3Ep/g3LryODkKbc=;
	b=iP8P18XEjDibOh2xcNo+VesiL1387uoA/gJWdlLoVgDbOhqta9JGhnwx73fK1C8bUmvD
	 Ac4SWFwvH9GKV3QyI/ZacOBikKeiL2VbAqMlKLeNcHuRpK5Cbp7r8uwRhBr8WDSNcOISF
	 TN99Ptdf9rdi4zSzv9jloQMwfiGjxePQNnUY9PO0ny1rJXlYohfCvIVcoyB7AUrS22t05
	 UnB5zGz3cGjyNg9sfIxDOPfzFn2gUW23JkUAn6pio2K1ruH4YogARIdkHI4/BrpqsWmoO
	 XthmeI3r+l7OBWBDVelq8NXS9YUKmWV5BhBc9eCX2gqQo0OGmioWBlhbmP76JrS/vxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVhF3YfS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F12606A849;
	Wed, 18 Nov 2026 20:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVhF3YfS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520E81F000C4;
	Wed, 18 Nov 2026 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032483;
	bh=3JxVrcSs+Dh/ksK522gmb1TeTpBE3Ep/g3LryODkKbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVhF3YfSmQtDUj9Gn9Ysg6DupX2PUlbvWTGT8SfZWtYH/6tVGiRhMIjuDzn/J1bmH
	 1dYfFgRxLqcMMqWdPAwzPXR0Q8Yiqjp0LdyC2M4NwRQi9BwpdjA+YjTjJYDPtUuWoI
	 ie5jdrecH0l5dbadSAatKZpDrOK1Maw4wqLUT4l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1429/1756] net: stmmac: avoid duplicate XSK TX completions
Date: Wed, 18 Nov 2026 15:59:16 +0100
Message-ID: <20261118150106.091388092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit daac93975b8ff0a0a036a5e3562236c0b40c3e36 ]

stmmac_tx_clean() reports completed AF_XDP TX descriptors through
xsk_tx_completed(), but leaves their buffer type as STMMAC_TXBUF_T_XSK_TX.
The slots retain that type until they are reused for another buffer type.

On interface close or XDP teardown, dma_free_tx_skbufs() walks the entire
TX ring, not just the dirty_tx..cur_tx range. stmmac_free_tx_buffer()
counts the stale XSK_TX slots again, causing xsk_tx_completed() to advance
the completion-ring producer for buffers that have already been returned.
This publishes completion entries without matching outstanding TX
reservations and corrupts completion accounting for a socket which stays
bound across the teardown.

Reset the XSK buffer type after counting the completion in both
stmmac_tx_clean() and stmmac_free_tx_buffer(). XSK TX slots have a NULL
skb pointer and no per-slot DMA mapping, so the SKB type represents an
empty slot. Pending XSK descriptors keep their type until they are
completed or released, and a released slot can no longer be counted
again by a later cleanup.

Fixes: 132c32ee5bc0 ("net: stmmac: Add TX via XDP zero-copy socket")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261013-submit-stmmac-xsk-tx-completion-v1-v1-1-f21b9d098e62@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 84c146eb3df2b..a05a6ebb15433 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1534,8 +1534,10 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv,
 		tx_q->xdpf[i] = NULL;
 	}
 
-	if (tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_XSK_TX)
+	if (tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_XSK_TX) {
 		tx_q->xsk_frames_done++;
+		tx_q->tx_skbuff_dma[i].buf_type = STMMAC_TXBUF_T_SKB;
+	}
 
 	if (tx_q->tx_skbuff[i] &&
 	    tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_SKB) {
@@ -2728,8 +2730,11 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue,
 			tx_q->xdpf[entry] = NULL;
 		}
 
-		if (tx_q->tx_skbuff_dma[entry].buf_type == STMMAC_TXBUF_T_XSK_TX)
+		if (tx_q->tx_skbuff_dma[entry].buf_type == STMMAC_TXBUF_T_XSK_TX) {
 			tx_q->xsk_frames_done++;
+			/* Teardown must not count this slot again. */
+			tx_q->tx_skbuff_dma[entry].buf_type = STMMAC_TXBUF_T_SKB;
+		}
 
 		if (tx_q->tx_skbuff_dma[entry].buf_type == STMMAC_TXBUF_T_SKB) {
 			if (likely(skb)) {
-- 
2.53.0



