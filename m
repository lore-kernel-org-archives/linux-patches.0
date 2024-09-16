Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C4415A86A;
	Mon, 16 Sep 2024 12:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488328; cv=none; b=KTH2PT8ck2077srarV7/e2CkKZyK0x6T6DWw4bABXzyr72/PGzeTxOC8GXhsd5ix4ruuG0WVbibNay7+ktAd9LThfCWC8AazqF6yeMPhjC7J2ea5iInpFyMk/9PybKbFpf921KbuSMwg7mPuaxU6StX6eMGcOijAIFfmIP2HbXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488328; c=relaxed/simple;
	bh=tqwguJXeFpkTbCVCMnp6MAU6diPo8dZBFYH4iwq0OGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpWgW9DX5xvKxUydvb9L/7QZyN6XNIEhfDCKJwcVgzX7EMerwLgKvGguT8+0qXG5wbSca03YPjrXd8JyCIHXwlmuhmgZndbhXzayt6cT2KS9086VlJjKXOzu5QkuPNOT/lAL6IHbnhGaz5KGg3cUgrHGJ2YVE9jDarmRvutq5Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XW9T6x4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XW9T6x4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CF6C4CEC4;
	Mon, 16 Sep 2024 12:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488327;
	bh=tqwguJXeFpkTbCVCMnp6MAU6diPo8dZBFYH4iwq0OGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XW9T6x4Q4SyAWnqtdh6jcgc4FMP7vaCIFe6sjfsCI0BB/7QDDJMNAiRSsVaqF4Myf
	 s9plCrGgEqX9Pzkhi2xJO2udph69c0xOhQR87YqiTppSCQB/azNC/p0iwFgr77bHWf
	 JdRCVxV44idwzGAyLIRFwM576DN2aGGFO4eSuUDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 075/121] igb: Always call igb_xdp_ring_update_tail() under Tx lock
Date: Mon, 16 Sep 2024 13:44:09 +0200
Message-ID: <20240916114231.644604896@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

[ Upstream commit 27717f8b17c098c4373ddb8fe89e1a1899c7779d ]

Always call igb_xdp_ring_update_tail() under __netif_tx_lock, add a comment
and lockdep assert to indicate that. This is needed to share the same TX
ring between XDP, XSK and slow paths. Furthermore, the current XDP
implementation is racy on tail updates.

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
[Kurt: Add lockdep assert and fixes tag]
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a27d0a4d3d9c..6dc5c11aebbd 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -33,6 +33,7 @@
 #include <linux/bpf_trace.h>
 #include <linux/pm_runtime.h>
 #include <linux/etherdevice.h>
+#include <linux/lockdep.h>
 #ifdef CONFIG_IGB_DCA
 #include <linux/dca.h>
 #endif
@@ -2915,8 +2916,11 @@ static int igb_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+/* This function assumes __netif_tx_lock is held by the caller. */
 static void igb_xdp_ring_update_tail(struct igb_ring *ring)
 {
+	lockdep_assert_held(&txring_txq(ring)->_xmit_lock);
+
 	/* Force memory writes to complete before letting h/w know there
 	 * are new descriptors to fetch.
 	 */
@@ -3001,11 +3005,11 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
 		nxmit++;
 	}
 
-	__netif_tx_unlock(nq);
-
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		igb_xdp_ring_update_tail(tx_ring);
 
+	__netif_tx_unlock(nq);
+
 	return nxmit;
 }
 
@@ -8865,12 +8869,14 @@ static void igb_put_rx_buffer(struct igb_ring *rx_ring,
 
 static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 {
+	unsigned int total_bytes = 0, total_packets = 0;
 	struct igb_adapter *adapter = q_vector->adapter;
 	struct igb_ring *rx_ring = q_vector->rx.ring;
-	struct sk_buff *skb = rx_ring->skb;
-	unsigned int total_bytes = 0, total_packets = 0;
 	u16 cleaned_count = igb_desc_unused(rx_ring);
+	struct sk_buff *skb = rx_ring->skb;
+	int cpu = smp_processor_id();
 	unsigned int xdp_xmit = 0;
+	struct netdev_queue *nq;
 	struct xdp_buff xdp;
 	u32 frame_sz = 0;
 	int rx_buf_pgcnt;
@@ -8998,7 +9004,10 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	if (xdp_xmit & IGB_XDP_TX) {
 		struct igb_ring *tx_ring = igb_xdp_tx_queue_mapping(adapter);
 
+		nq = txring_txq(tx_ring);
+		__netif_tx_lock(nq, cpu);
 		igb_xdp_ring_update_tail(tx_ring);
+		__netif_tx_unlock(nq);
 	}
 
 	u64_stats_update_begin(&rx_ring->rx_syncp);
-- 
2.43.0



