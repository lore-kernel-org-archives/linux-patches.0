Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056641;
	b=Ok4FJKhrPdkHOP2hkVdO6BhpKDQD7U5u4VZwD5r69zrMsDFKssfHPxWGmM2BGrRQMCHc
	 mq+WQ447LrckYTHwq4IuIkIB077fKWMHcI4q2TPUVempy2Jr1yTVuBEyjQKCdmBr08El7
	 JWA3fKIUhw0m94XjY4JwvbvM3LGHsTncuL5CL35FkEJbAvR/2FYGiDk3/OGN3/YGTI+ub
	 1qe1ws0cXgZJE27aN2zDIYmiV8w/leYzoVzZXTnelYwFzp/IB8TNHoxYV8BqAnPwJX0ee
	 CmBNy7sF5mJH9ut82XdkJvUp5KDlDQIj6VocP6kuEbtEjGO8dRJG1EPtkDVcCJGA5rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/HRzWCtFDKqpZ8CleBrDMwYiTPlaJc1NV7aKoFJCPTU=;
	b=s0S6sFwSwAiCbGozIQmm/Y2VxYodpPg20wwzNj43wuvHbDpWHjFBScN43ZOBGnSLgodM
	 yQnyTNiBBFgqURPVoOUonduhtt2TMJyJRqKoMP/J+0YANeyG+XBDt3AybAk62Swy3/jA6
	 b30Y+v3Sjz984WCriIApXFkdfkENtu9B0To76f/mEutIebV2QJraM/shRYeQKBqRnFCvJ
	 B8FfVjawLXe6ZuqnV2NPQ+vVmBP/Q3myNQcAJJuzQVo+ZnhSf4z32v5RiiC+mNC8HRFc0
	 4cmaWLHK715I2zPd4e6PbdgCfnm/MIGCOkazxVlcJ+ZPy60AmmBdfT8fd/a+T+9dNrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FsTLzSVX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C3606A31C;
	Thu, 19 Nov 2026 02:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FsTLzSVX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083931F000C5;
	Thu, 19 Nov 2026 02:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056641;
	bh=/HRzWCtFDKqpZ8CleBrDMwYiTPlaJc1NV7aKoFJCPTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsTLzSVXqsiHgIB6JJWN4Jbh0RacRDnwwlfeTJWLzCw8Ek5H2rX9OfvAnoJp46QF7
	 iJdu6FHorjMu+IipxIKCYywx+pGzHN3LpYkmgwaEeb52CO6OtF9CP7eGGlev+eRFXk
	 /UM/YFQUNngtc7dUbkGRLyoAOij0Z7aK7MfGVnC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2060/2214] net: stmmac: avoid duplicate XSK TX completions
Date: Wed, 18 Nov 2026 16:02:16 +0100
Message-ID: <20261118150133.076261348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ceb582ca67beb..a7347cd844b73 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1553,8 +1553,10 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 		tx_q->xdpf[i] = NULL;
 	}
 
-	if (tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_XSK_TX)
+	if (tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_XSK_TX) {
 		tx_q->xsk_frames_done++;
+		tx_q->tx_skbuff_dma[i].buf_type = STMMAC_TXBUF_T_SKB;
+	}
 
 	if (tx_q->tx_skbuff[i] &&
 	    tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_SKB) {
@@ -2611,8 +2613,11 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
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



