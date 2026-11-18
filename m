Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028289;
	b=caTcXwkhTHXQ23bzaxs8JUUjbwElrkpQH3Z25Hw07kGI8wwhcgXAKENrVYcf0jHu/X+a
	 iB8AgDgR6AxHKgSwnKAM1x34Sh6gszHc5ao9ePYgc36u2PZ783QR6c3JrAICwwALbkq6o
	 4+RUS7MwmcxsPydXVcwRaUyWgRcBmcaJaGY9e4UNrRun/g/u7gNH36lDrh/cnPG6bvmWc
	 xXvF6PIL3TjgjqQ4HcJLCx2f/c6gAqut56DHd9ciixLZyi/05yarGQiEj5O22Q0Vm8IY1
	 Q2EM/0hjl5UVBDREjpiejv36v9IThoAK0UxDLSNirQWjJP+TGzLMjzv1x4D2xEcHIDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=peRdBoIGZ7FwzIiIakvDgOuQkwXj85uq9u49fzwPxRA=;
	b=3Caii/hTqZryitWwMRrjoprFRhvupWrIoTnnBIYDjJbVsYmK4VQjj3HQ7KFd3alrxU28
	 hsjqXg/tfsgHFxwZqXUWNFk7d+OKQ6jXMsV5vxbdY7JORegE22XqYo4Ql7saqeDHJF09K
	 M+BoSyFpdZACWtdxjB87xKrFuLZqwd9XzY1cQfctalw1zRcZ2xaKVw09PaAO5ZaiIJVzL
	 g+kS/jAlG0BJ31akCwruSvFJdEtRTL3/2sb19O04SkuVqxyXGkJaMjbkPHdGRkGhrd+rO
	 jNng/rrVHPq3D+5xVs6iAvNDzu2uJ2lQXrkvovMJ7nlZZAT2rMLLamyJf2nTXCvpQFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdSgTt9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E711B606A32F;
	Wed, 18 Nov 2026 18:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdSgTt9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E071F000C4;
	Wed, 18 Nov 2026 18:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028288;
	bh=peRdBoIGZ7FwzIiIakvDgOuQkwXj85uq9u49fzwPxRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdSgTt9Ucn/6JJJ+qOI8eVJzd/UQq1tG6wbDtRNCMzgwGAEv8UGC0Zx81KdJo2dHo
	 l/GgxjN05kVLDzfWB1OBNN7Q3n5db9IvVgI+hzkKNki8Hg/Uc40f2/J51ZL4rSKTRT
	 pojewqYpsb54yhcv8qIiH2hHr+fo9O8+Y76KdyGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2050/2151] ice: set in_use only after preparing Tx timestamp index
Date: Wed, 18 Nov 2026 16:03:05 +0100
Message-ID: <20261118150236.398785362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 50870d62116038e6f1e17a6aedcf2a95cec37ec7 ]

The ice_ptp_request_ts() function is used to request a timestamp index for
use with a packet. When reserving an index, it sets the start time and
saves a pointer to the skb into the appropriate index. The function marks
the in_use bit first before doing any of these steps. The IRQ handler which
clears the timestamps reads the in_use bits uses a lockless flow for
reading the in_use bits to determine which ones are in-use. This is
necessary as actually processing a complete timestamp must be able to sleep
so we cannot hold the timestamp tracker lock over the entire sequence.
Additionally, blocking the Tx hotpath with such a lock indefinitely would
be problematic.

However, the existing flow now has a very narrow window where the IRQ
handler could see a timestamp as in-use but read a stale value for its
"start" time.

Fix this by ordering the sequence to mark the in_use bit last, and add a
memory barrier to prevent re-ordering of the previous writes to setup the
index.

This was found and reported by Sashiko while reviewing an unrelated change.

Closes: https://sashiko.dev/#/patchset/20260821-jk-e825c-minimized-fixes-v1-0-9d0731eb4858%40intel.com?part=7
Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261027-reduction-v1-2-81237c67a361@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 7808d583b9ee1..bd45cb07bef7f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -589,6 +589,12 @@ static void ice_ptp_process_tx_tstamp(struct ice_ptp_tx *tx)
 		bool drop_ts = !link_up;
 		struct sk_buff *skb;
 
+		/* Paired with smp_mb__before_atomic() in ice_ptp_request_ts()
+		 * to ensure ordering the in_use bitmap and the indexed fields
+		 * in the tstamps array.
+		 */
+		smp_rmb();
+
 		/* Drop packets which have waited for more than 2 seconds */
 		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
 			drop_ts = true;
@@ -2593,11 +2599,13 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 		 * a reference to the skb and the start time to allow discarding old
 		 * requests.
 		 */
-		set_bit(idx, tx->in_use);
-		clear_bit(idx, tx->stale);
 		tx->tstamps[idx].start = jiffies;
 		tx->tstamps[idx].skb = skb_get(skb);
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		clear_bit(idx, tx->stale);
+		/* Ensure index is setup before marking it as used */
+		smp_mb__before_atomic();
+		set_bit(idx, tx->in_use);
 		ice_trace(tx_tstamp_request, skb, idx);
 	}
 
-- 
2.53.0



