Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021345;
	b=rmYGmuNNn2dURQmegby89Gwz22CL68cZo9iWFhPlNaBYQOLRrdFOHZNS6tXs56CdcT0o
	 puUel80hzqz9orfs/VJZ/InrFIaAYHF9PJ5Bm/ASHD/mMA4FTAGUZpCer6lF7yyjul4Yv
	 zTN6dNTn/SrB3Eyjc6qWx3H3EidDS86MLYgt40692F6aIKOSgcfr0dC93Ka/0MJ2TlsVB
	 kPdbHhSHc9mXg+ug/34HggufvoAW89aZGDaD82YctZ3eFeHgS7csu+kpJTNdYXaMuJSiu
	 XRoD61SbKwYid0hclhoam3VUj78Au4xH/wpbaUJyHke+yHVYkEfBj6U0WGSDbFytfXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1dp5ydihjnwfRqjrXMkH2Bm3Ow8My4nvMn4L68FEukU=;
	b=mXf9gkYRzbw3aQVhjuNQvJLNVKnwlNACRMeReqbtj6wLzv7+9EowJNT2VhXJNof6h65C
	 97A2b1JHqSzy0aarqUF7vee4McB/5Rhj8Kuenc2Kr1FPGWTEAEvl+gBIap7QaZfFMBDMP
	 iTzTGkJNXx7lrNr4FXMcTMRW2jHrvS+WWRJsc+WnmmC80KcM0mds2c4ksJmF9mFU1zVM6
	 3FGVXvGw4FoW4J120KlOjFrk6aT1or4x5xUuOKPE2rA2VK/6zkfuddzvtCmS0TwUv7Lz4
	 zo+wgGpIEYYV0f6nhAt9VF5/5AkCkZcoCYNx5fGVuoeHUJuI+CZosp49/COLjGAYmKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOQbiioA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100DD606A320;
	Wed, 18 Nov 2026 17:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOQbiioA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205CB1F000C5;
	Wed, 18 Nov 2026 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021344;
	bh=1dp5ydihjnwfRqjrXMkH2Bm3Ow8My4nvMn4L68FEukU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOQbiioAztr+9n4hYOyzWisOvxuSwAgQ40zKA1CS7TYZ/xzogUeBXJ2oYP7fTBIQW
	 R/juHPykBEGyQpkwryYStv7TEp7O/HVZCp2ocu2MVRJVpFO5SZvtunUm4slyy6j98T
	 PmYGmL1fPPRfvnX15jkb7TnvqVa6ht5RoqTrco0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2233/2651] net: stmmac: avoid duplicate XSK TX completions
Date: Wed, 18 Nov 2026 15:57:53 +0100
Message-ID: <20261118150405.911618790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 300e898e21993..388575cf588ad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1742,8 +1742,10 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv,
 		tx_q->xdpf[i] = NULL;
 	}
 
-	if (tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_XSK_TX)
+	if (tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_XSK_TX) {
 		tx_q->xsk_frames_done++;
+		tx_q->tx_skbuff_dma[i].buf_type = STMMAC_TXBUF_T_SKB;
+	}
 
 	if (tx_q->tx_skbuff[i] &&
 	    tx_q->tx_skbuff_dma[i].buf_type == STMMAC_TXBUF_T_SKB) {
@@ -2924,8 +2926,11 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue,
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



