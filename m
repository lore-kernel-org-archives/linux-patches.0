Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050660;
	b=B+Am+Pfmlg2ioom3sVU1QfnW8CbbAkTvgJRr7xKH7et2M8i/9vw8Wec1OMPTQFhs0DcY
	 bac9b5tFonkrK5dZ6Rl98i78zFClWt4XHahZH0rKzsHpvrey/1UtFjJjMquOAJXs0pm4k
	 bWxvKbZq7rOgqXoeEqHqBiPIIclQwW+IOKvqJdSy12gLxmHHU730IspFX+BLoMLdcx5mt
	 Z4+Q+zAq6IULHXeZ7XsZGtM5xZzER953+gVQtZAoM9BUl++dWZllT7BHWyDT79RmYGxox
	 ksCHsled8KdtVCMvI13qNIfPBB8yKVYMtsvVBkxVeKLtAa46VZkc0kRtrOObanp6cNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=soO2opaobh1Ia3kUQz3IMVNk9Dz81eoXpmKEb3/Z41s=;
	b=WtInwkHVg3KF494AyZY78FRDCNx1L5kz1TuTv/m2LR9JbYY9rfux4pdAmu1N0PyroiFy
	 PGxNQB+/0VSx9PNEYtxeVK++UrvJ04VJ2dGnqwO2yGnEgoDJ6BOg+uDzm1f7XS7lKz+9y
	 JfK5/XEYRZ/CiKQX95axINCcYjtUgbZXuU44RpEwCMI6SC1RYkae7u0HGXBSZxv278C/q
	 KnkgQH1X+KfWePTFutKkgzpvMXeJzTmGFOi3tTd3Q6QfWIYNXwGp0UVFGaBikHKZh2L1l
	 dJZQnLgxBamu4F2z/eYtWM9dGb3l8rlMghOldBXWn+liTTDJNTUsZQIQBDDVtxomHIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eP/shZWf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A548606A32A;
	Thu, 19 Nov 2026 01:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eP/shZWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EAF1F000C4;
	Thu, 19 Nov 2026 01:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050660;
	bh=soO2opaobh1Ia3kUQz3IMVNk9Dz81eoXpmKEb3/Z41s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eP/shZWf3A1S9SKnKwhlXFrsn+1Z0j6VqdqNOYO7LSwcuZD9Aq2foKy8wOikg7M7V
	 czmYApLVKBtROStzvM7HNEy0Mqk4tQ3pCknxXeCk/JGAaH30kTC29ir0oS9Uh23Fco
	 8kz/thXjebmxvAxhW4+9mU6XIu1M2xaEvuPK88rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 2786/2857] ice: handle discarding old Tx requests in ice_ptp_tx_tstamp
Date: Wed, 18 Nov 2026 16:03:40 +0100
Message-ID: <20261118150341.916843424@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 0dd9286263923860a1829778e232a501b49c485f ]

Currently the driver uses the PTP kthread to process handling and
discarding of stale Tx timestamp requests. The function
ice_ptp_tx_tstamp_cleanup is used for this.

A separate thread creates complications for the driver as we now have both
the main Tx timestamp processing IRQ checking timestamps as well as the
kthread.

Rather than using the kthread to handle this, simply check for stale
timestamps within the ice_ptp_tx_tstamp function. This function must
already process the timestamps anyways.

If a Tx timestamp has been waiting for 2 seconds we simply clear the bit
and discard the SKB. This avoids the complication of having separate
threads polling, reducing overall CPU work.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 50870d621160 ("ice: set in_use only after preparing Tx timestamp index")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 111 ++++++++++-------------
 1 file changed, 48 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 1b1d1e11a074c..82a41c5744032 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -626,15 +626,32 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
  * Note that we only take the tracking lock when clearing the bit and when
  * checking if we need to re-queue this task. The only place where bits can be
  * set is the hard xmit routine where an SKB has a request flag set. The only
- * places where we clear bits are this work function, or the periodic cleanup
- * thread. If the cleanup thread clears a bit we're processing we catch it
- * when we lock to clear the bit and then grab the SKB pointer. If a Tx thread
- * starts a new timestamp, we might not begin processing it right away but we
- * will notice it at the end when we re-queue the task. If a Tx thread starts
- * a new timestamp just after this function exits without re-queuing,
- * the interrupt when the timestamp finishes should trigger. Avoiding holding
- * the lock for the entire function is important in order to ensure that Tx
- * threads do not get blocked while waiting for the lock.
+ * places where we clear bits are this work function, or when flushing the Tx
+ * timestamp tracker.
+ *
+ * If the Tx tracker gets flushed while we're processing a packet, we catch
+ * this because we grab the SKB pointer under lock. If the SKB is NULL we know
+ * that another thread already discarded the SKB and we can avoid passing it
+ * up to the stack.
+ *
+ * If a Tx thread starts a new timestamp, we might not begin processing it
+ * right away but we will notice it at the end when we re-queue the task.
+ *
+ * If a Tx thread starts a new timestamp just after this function exits, the
+ * interrupt for that timestamp should re-trigger this function once
+ * a timestamp is ready.
+ *
+ * Note that minimizing the time we hold the lock is important. If we held the
+ * lock for the entire function we would unnecessarily block the Tx hot path
+ * which needs to set the timestamp index. Limiting how long we hold the lock
+ * ensures we do not block Tx threads.
+ *
+ * If a Tx packet has been waiting for more than 2 seconds, it is not possible
+ * to correctly extend the timestamp using the cached PHC time. It is
+ * extremely unlikely that a packet will ever take this long to timestamp. If
+ * we detect a Tx timestamp request that has waited for this long we assume
+ * the packet will never be sent by hardware and discard it without reading
+ * the timestamp register.
  */
 static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 {
@@ -652,10 +669,21 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct skb_shared_hwtstamps shhwtstamps = {};
 		u8 phy_idx = idx + tx->offset;
-		u64 raw_tstamp, tstamp;
+		u64 raw_tstamp = 0, tstamp;
+		bool drop_ts = false;
 		struct sk_buff *skb;
 		int err;
 
+		/* Drop packets which have waited for more than 2 seconds */
+		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
+			drop_ts = true;
+
+			/* Count the number of Tx timestamps that timed out */
+			pf->ptp.tx_hwtstamp_timeouts++;
+
+			goto skip_ts_read;
+		}
+
 		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
 
 		err = ice_read_phy_tstamp(&pf->hw, tx->block, phy_idx,
@@ -670,22 +698,26 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		    raw_tstamp == tx->tstamps[idx].cached_tstamp)
 			continue;
 
-		/* The timestamp is valid, so we'll go ahead and clear this
-		 * index and then send the timestamp up to the stack.
-		 */
+skip_ts_read:
 		spin_lock(&tx->lock);
-		tx->tstamps[idx].cached_tstamp = raw_tstamp;
+		if (raw_tstamp)
+			tx->tstamps[idx].cached_tstamp = raw_tstamp;
 		clear_bit(idx, tx->in_use);
 		skb = tx->tstamps[idx].skb;
 		tx->tstamps[idx].skb = NULL;
 		spin_unlock(&tx->lock);
 
-		/* it's (unlikely but) possible we raced with the cleanup
-		 * thread for discarding old timestamp requests.
+		/* It is unlikely but possible that the SKB will have been
+		 * flushed at this point due to link change or teardown.
 		 */
 		if (!skb)
 			continue;
 
+		if (drop_ts) {
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
 		/* Extend the timestamp using cached PHC time */
 		tstamp = ice_ptp_extend_40b_ts(pf, raw_tstamp);
 		if (tstamp) {
@@ -828,51 +860,6 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	return ice_ptp_alloc_tx_tracker(tx);
 }
 
-/**
- * ice_ptp_tx_tstamp_cleanup - Cleanup old timestamp requests that got dropped
- * @pf: pointer to the PF struct
- * @tx: PTP Tx tracker to clean up
- *
- * Loop through the Tx timestamp requests and see if any of them have been
- * waiting for a long time. Discard any SKBs that have been waiting for more
- * than 2 seconds. This is long enough to be reasonably sure that the
- * timestamp will never be captured. This might happen if the packet gets
- * discarded before it reaches the PHY timestamping block.
- */
-static void ice_ptp_tx_tstamp_cleanup(struct ice_pf *pf, struct ice_ptp_tx *tx)
-{
-	struct ice_hw *hw = &pf->hw;
-	u8 idx;
-
-	if (!tx->init)
-		return;
-
-	for_each_set_bit(idx, tx->in_use, tx->len) {
-		struct sk_buff *skb;
-		u64 raw_tstamp;
-
-		/* Check if this SKB has been waiting for too long */
-		if (time_is_after_jiffies(tx->tstamps[idx].start + 2 * HZ))
-			continue;
-
-		/* Read tstamp to be able to use this register again */
-		ice_read_phy_tstamp(hw, tx->block, idx + tx->offset,
-				    &raw_tstamp);
-
-		spin_lock(&tx->lock);
-		skb = tx->tstamps[idx].skb;
-		tx->tstamps[idx].skb = NULL;
-		clear_bit(idx, tx->in_use);
-		spin_unlock(&tx->lock);
-
-		/* Count the number of Tx timestamps which have timed out */
-		pf->ptp.tx_hwtstamp_timeouts++;
-
-		/* Free the SKB after we've cleared the bit */
-		dev_kfree_skb_any(skb);
-	}
-}
-
 /**
  * ice_ptp_update_cached_phctime - Update the cached PHC time values
  * @pf: Board specific private structure
@@ -2428,8 +2415,6 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 
 	err = ice_ptp_update_cached_phctime(pf);
 
-	ice_ptp_tx_tstamp_cleanup(pf, &pf->ptp.port.tx);
-
 	/* Run twice a second or reschedule if phc update failed */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
 				   msecs_to_jiffies(err ? 10 : 500));
-- 
2.53.0



