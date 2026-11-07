Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062620;
	b=S07W0i/+XWhiZAsQmbwWdiwh7ihfjaztlBUmJGNxOzPnkdT84ycYzlnG0RQXXd12ob6G
	 pewCzB46bcVXR9sZ+bsTm98Cj7sSu2S2PpU2+0DKg+R7/ocDW1tjXYZuuVlpf+WY02tgN
	 Gj4Oeq5oas2CxcKfdgqbY4aIdrHtqQVgqdWDDBB8iZZlEccgPnmbpiamS8wOlW7KDp91w
	 uG6vTiHDZZKGdvtwpOHMFNdB+pQmukYZ0ympt1nmA6QPXtyEt+nXhQJ5G532txSci+y/3
	 SARm0Q/USCcbqmjOd2XTCdpXq0B4xZkKVMJw5gDti7NYUr4CCVvUMWGcdufA5V0vxmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bY0G4kTcd2g0Pi8ccWtu9hHwhztqclNM9gnyvXfmIug=;
	b=mfV1VPGpOZQor1qo7MvrTy0Pw7yNff+yYAHr21MLllovqoMLZ801FLnkiGoXZHSH0xjM
	 teZa20rq6aymAeHvps4ESWc81DT9tYnTA1qBlvnl/b813OP6vBDCpFKRP1+tUaHsssaxD
	 1B7R3D7ZfYzjW9ePwA6ItMXWtrCMrrd2pExspJTyaCHEocQOJPATBDXz+qM/KuRL0q6H4
	 HEhFvzFirRUKARa6jcOo1lgrZrSDWXxYLLgdTSGUsUM3ofd+ls+LPv/CBcNYITuYS+g06
	 nQLFumV014U/p2swdgeXTKcLr0cwuGwofBwMRCnIywv5RB/sxhAEd7VpnbBLT/aTcgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtMyL0Gd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3EC606A659;
	Sat,  7 Nov 2026 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtMyL0Gd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1EF1F0089F;
	Sat,  7 Nov 2026 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062619;
	bh=bY0G4kTcd2g0Pi8ccWtu9hHwhztqclNM9gnyvXfmIug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtMyL0Gdp+mXMA5RGFTEh7/6iWO44j8Zka5ugrJfJeY/1IZczmXIMzjlmr/UDxlQ9
	 V6zF9Q5Jm7UgWHCKtdhunqQW/uCxIwRuBm3dtGzut59wovwluNBvyHlAkyqJeP1Op4
	 HDI/kPuCdvNyN5cscSHZhMOgxtQlUTN+hwigNxk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1484/1536] ixgbe: reserve TX timestamp after skb preparation
Date: Sat,  7 Nov 2026 08:58:20 -0500
Message-ID: <20261107135039.535823011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit f75062536e2d45ee182828f0e47e0124be2fdc8d ]

ixgbe_xmit_frame_ring() takes an extra skb reference with skb_get()
for the pending TX timestamp before preparing the skb for transmit.
Several of the following steps may need to reallocate the skb head:

- ixgbe_tso() calls skb_cow_head(), which reaches pskb_expand_head()
  when the header is cloned (e.g. a packet tap holds a clone).
- ixgbe_tx_csum() falls back to skb_checksum_help() for unsupported
  checksum offsets, which can call pskb_expand_head() through
  skb_ensure_writable().
- With DCB and a software VLAN tag, skb_cow_head() is called to
  rewrite the VLAN priority.

pskb_expand_head() used to BUG() on shared skbs. Since commit
c7d8bc3dd511 ("net: skbuff: don't BUG() on bad arguments to
pskb_expand_head()") it returns -EINVAL instead, so these packets
are dropped (TSO, DCB) or sent with an unfinished checksum
(skb_checksum_help() errors are ignored by ixgbe_tx_csum()).

Reserve the TX timestamp right before ixgbe_tx_map(), after all skb
preparation, as i40e and ice already do. The timestamp request
remains covered on the FCoE path, and the cleanup on ixgbe_tx_map()
failure is unchanged.

Fixes: 891dc0821d20 ("ixgbe: Add ptp work item to poll for the Tx timestamp")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20261026082035.335770-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 40 +++++++++++--------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index aef70cf119bb3..303743e9c5367 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8788,23 +8788,6 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 	}
 	protocol = vlan_get_protocol(skb);
 
-	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-	    adapter->ptp_clock) {
-		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
-		    !test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
-					   &adapter->state)) {
-			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-			tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
-
-			/* schedule check for Tx timestamp */
-			adapter->ptp_tx_skb = skb_get(skb);
-			adapter->ptp_tx_start = jiffies;
-			schedule_work(&adapter->ptp_tx_work);
-		} else {
-			adapter->tx_hwtstamp_skipped++;
-		}
-	}
-
 #ifdef CONFIG_PCI_IOV
 	/*
 	 * Use the l2switch_enable flag - would be false if the DMA
@@ -8869,6 +8852,29 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 #ifdef IXGBE_FCOE
 xmit_fcoe:
 #endif /* IXGBE_FCOE */
+	/* Reserve the Tx timestamp only after all skb preparation:
+	 * skb_get() makes the skb shared, and pskb_expand_head()
+	 * (reached from skb_cow_head() or skb_checksum_help())
+	 * refuses shared skbs.
+	 */
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    adapter->ptp_clock) {
+		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
+		    !test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
+					   &adapter->state)) {
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
+			first->tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
+
+			/* schedule check for Tx timestamp */
+			adapter->ptp_tx_skb = skb_get(skb);
+			adapter->ptp_tx_start = jiffies;
+			schedule_work(&adapter->ptp_tx_work);
+		} else {
+			adapter->tx_hwtstamp_skipped++;
+		}
+	}
+
 	if (ixgbe_tx_map(tx_ring, first, hdr_len))
 		goto cleanup_tx_timestamp;
 
-- 
2.53.0



