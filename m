Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7D5340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301125; cv=none; b=HqnhSqD/qnXtVHfphv7PbIswv89qfu5Wy5XjnzR0sGnnAQaLesEe7NUjC/U4jkkSOv9TpMpQInK7A2Ow2AL7gPLt2JfNagAfzLRDcfHLC5iGDM39F3r9tV0/3LMSJeDU54id1TjpvNW/ZvtXwJbWn16lh2tUTcytpobXc5vb4Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301125; c=relaxed/simple;
	bh=nqBfQ2Y2Nm4bSX0ZnklbWYblVGiOeektzk4kKoB/Oss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htnnkPC9XG7ITpzMTFZBns5x/4gYvwHixNVsCF0tcCzckdGzYGgYH/bit2xvWzzqSiw34LpMOHvneUGYJT9sYZWr81X3iSBCIB0UXyQRV4LFgJxFcN4Vric9mlvbGfE5mWgpUUIG3lidMpH2odJ913XjQX3Y53w9U6+PG1X9VnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWN+LK40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWN+LK40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2964FC19423;
	Sat, 28 Feb 2026 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301124;
	bh=nqBfQ2Y2Nm4bSX0ZnklbWYblVGiOeektzk4kKoB/Oss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWN+LK40HE2kMum209NDS3LwWcXfdQlGSUIezYBPTMNuN6U4nr4BnL9OH9NsNoPlZ
	 toW/ObVIVSNVicExgTRKWWPuFLwsJI3KTYiIHRnI5Ig7vIwCua6fds9mPEjZfc39bS
	 bQVAZfqGnWBadUQNjZxCSD4bazb6jWe5F6TfjKwjvrYFuqgEcKx+g+Xh89gtuv0l8l
	 f5dUHYqJktJdyZJFSk/bBJAcOUuuujyiGQCHGY4zg1jBhRJE5eAX4bcUUv+ddJAkPe
	 G9NVLKs440UWOctN7qUJtbDBIrdzwGsvB3zxWaEReQ+LUvDvkmCsEEs8PAzjWd0pys
	 0/x1xtdrP822Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 283/752] wifi: ath10k: fix lock protection in ath10k_wmi_event_peer_sta_ps_state_chg()
Date: Sat, 28 Feb 2026 12:39:54 -0500
Message-ID: <20260228174750.1542406-283-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 820ba7dd6859ef8b1eaf6014897e7aa4756fc65d ]

ath10k_wmi_event_peer_sta_ps_state_chg() uses lockdep_assert_held() to
assert that ar->data_lock should be held by the caller, but neither
ath10k_wmi_10_2_op_rx() nor ath10k_wmi_10_4_op_rx() acquire this lock
before calling this function.

The field arsta->peer_ps_state is documented as protected by
ar->data_lock in core.h, and other accessors (ath10k_peer_ps_state_disable,
ath10k_dbg_sta_read_peer_ps_state) properly acquire this lock.

Add spin_lock_bh()/spin_unlock_bh() around the peer_ps_state update,
and remove the lockdep_assert_held() to be aligned with new locking,
following the pattern used by other WMI event handlers in the driver.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260123175611.767731-1-n7l8m4@u.northwestern.edu
[removed excess blank line]
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b4aad6604d6d9..ce22141e5efd9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5289,8 +5289,6 @@ ath10k_wmi_event_peer_sta_ps_state_chg(struct ath10k *ar, struct sk_buff *skb)
 	struct ath10k_sta *arsta;
 	u8 peer_addr[ETH_ALEN];
 
-	lockdep_assert_held(&ar->data_lock);
-
 	ev = (struct wmi_peer_sta_ps_state_chg_event *)skb->data;
 	ether_addr_copy(peer_addr, ev->peer_macaddr.addr);
 
@@ -5305,7 +5303,9 @@ ath10k_wmi_event_peer_sta_ps_state_chg(struct ath10k *ar, struct sk_buff *skb)
 	}
 
 	arsta = (struct ath10k_sta *)sta->drv_priv;
+	spin_lock_bh(&ar->data_lock);
 	arsta->peer_ps_state = __le32_to_cpu(ev->peer_ps_state);
+	spin_unlock_bh(&ar->data_lock);
 
 exit:
 	rcu_read_unlock();
-- 
2.51.0

