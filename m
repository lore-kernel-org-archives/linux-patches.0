Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042135;
	b=QA+XSMHBX+Y0urxwAUpBq9UrHGa8qE+vuucYGfhwgmcWTzmKqQW3g8fUkmJilYljjRVx
	 Agbe/YGzy5cNH2nuNKuJ/GFX5et1mg35A5K3zxZb3cFNGvkB9clAfvow6zhxpEwoKg4JR
	 E7aqErpwrz8SkHZ6/RRzdvIyuQf98PJyWI50zseQQOsAZ4Yg3s/h5Znk3BO7+ICiM0WRM
	 RslK0k2e1Ev/MylCxy8GznuRGKU+g/5FJk92AlxQXI0OB9Z9bEKRm/Bor8Xy4znJi2rsi
	 NpThxznA1dvBkLXncsNQMhw8rnpYLfaK1mpmDaRxlPH0meceaVZ8GN8mdDjPWpGcn0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/R+bebhEVaOZpntZTgRYqBlFcr0BPRb10i+7OfwArFc=;
	b=LjSUoJf/JHKnTHyi2LKPlu+vQImCNMEL5kaBXQ+0+tz+vfPo/oFy+etLkXsNyuwXJ5U2
	 4++IoWfQjiGSkc1nWf9r0bKpq44Hr5ERYh34+ujOAmYACYfosM4loCQKRllP4gi6WJGsM
	 mXcjZUfr/lJguNcXITmnKhfGsoqO3IxchnTkUwZPx1Ol+APHgEHkI6cnBH3bkH+1O6wi8
	 FONcWp4nvVIKmLQBjWy7ogwLYmYOylTs1hDVf+JboI5JwxO8Jn1/hhGOsigXOUo9DcpxM
	 QbfYrWdjvn/EbTCIiMeHsn63f2WYc0bsbYSXP4NVoQDSmYVEE0nmWSQZJMTWM+X6WmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvWPnOt0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AF9606A325;
	Wed, 18 Nov 2026 22:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvWPnOt0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E393A1F000C4;
	Wed, 18 Nov 2026 22:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042135;
	bh=/R+bebhEVaOZpntZTgRYqBlFcr0BPRb10i+7OfwArFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvWPnOt0T6i+7XGXDzOu4IK+TY3vJ9nADkmfsrHcRva/fFSuzbpsCOcTP1SxyrOui
	 4dWkih2oAtbEx4GF5eh+7WiG6B1wKmIYqDhKQN6v+vNslAfpLMpizTJTKvCz35P2bj
	 nfMiuykGSUhm6vNo3F00y0wQU5hMiTw1gFcgtrZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3061/3318] net: stmmac: avoid duplicate XSK TX completions
Date: Wed, 18 Nov 2026 16:01:23 +0100
Message-ID: <20261118150451.957292476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97c845f85fc29..b46fcb9f23378 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1510,8 +1510,10 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv,
 		tx_q->xdpf[i] = NULL;
 	}
 
-	if (tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_XSK_TX)
+	if (tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_XSK_TX) {
 		tx_q->xsk_frames_done++;
+		tx_q->tx_skbuff_dma[i].buf_type = STMMAC_TXBUF_T_SKB;
+	}
 
 	if (tx_q->tx_skbuff[i] &&
 	    tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_SKB) {
@@ -2627,8 +2629,11 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
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



