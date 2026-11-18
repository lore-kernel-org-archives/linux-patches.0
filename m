Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050241;
	b=qYChTSHZVsYl6ffxI+8f6+0Jm6akww+m3HMfg1imvRs+Gtzp3eFwBc0VRRR2/HgnfsR0
	 XJ0Pwl7OqEoywpLsLkARErC0jzyUASZd59v/8gm4xXRxw74AbjXI0kXlFOoiYVedlIta5
	 ZBxiTwMmlaRDcNl0ounkgIX6ETm5CiINqTv77FApZzML7Dmd77RyEJRvWOmAmuqYFCZBE
	 TYs9uCBXyL/e58H1UO9I2kZKG5F52TxvmuQ6ZHSpvvBxsxoLeypE+buhNdhPxvLdCJRZo
	 NQ5ygxG8px2KAb2w3kiVISuTJil57cBbYfvlXJidxWdMSBtDhjl6UtVtt9f5E05l1uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0x4OCNARc+59fEcX4QBjAf7uyAEtPLuz3Go/J3RO8lE=;
	b=J2TnJKtzDwRMYzpa6AJtVl3cwqbzVEGPAvLuVs3nYcAVmpzkRSIe8g34VMLKaJiHS9+3
	 T3I3mmXcWVAzlKZRf8qWeLXRXP15qMhDTRMI9jcnW6o2uLCZlgHG6XO27x6/Jxdps14jC
	 fWY9Efx7UAG6nODyXbjqXASjwnh0o8k5u1dtk7zWjt1R04nrkmdIDC7OFg8j3XTS+dzJT
	 kJTR20YYDQBHPn/3ffbfA5wt9tvDgyedlwvpTZYUamwrpxRxP1fS1F3HndHSa2lgLmxTi
	 rL66EGz7NrfMSClnT+Zc/igbct6kgVcqxyt/Ihi3N381lOBZ5PMIaLvb2I/hklEO/jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJZbFOeA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68471606A325;
	Thu, 19 Nov 2026 01:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJZbFOeA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADF01F000C4;
	Thu, 19 Nov 2026 01:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050241;
	bh=0x4OCNARc+59fEcX4QBjAf7uyAEtPLuz3Go/J3RO8lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJZbFOeAet8lB64DWaZhrvrBfQgKpQU+YTnGJDP2MGIjgJ7Ktg4RbhGcKhappb0AL
	 SaeFEKnSjMEdrzMkdbBv32GGLL2JzssRPGnBr7aQpNNmLrHsoE46eHXLimgR7Tz+vN
	 UCZtEEnUBwEk8aVvh60YfIflSFUA295OfK1XMS1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2639/2857] net: stmmac: avoid duplicate XSK TX completions
Date: Wed, 18 Nov 2026 16:01:13 +0100
Message-ID: <20261118150336.613835483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 02efc502e139d..281abef609f74 100644
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
@@ -2644,8 +2646,11 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
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



