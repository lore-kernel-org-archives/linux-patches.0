Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93930389118;
	Sat, 17 Oct 2026 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253725; cv=none; b=nwKRljT3BTQMMZzuzuuJSVQ3r0aUsNG7i+FPYDhp3MpdLkxuXaHafo+qB6y6PXcX7MC0oN5q/YAAhyrIq8FfFdJ3mAZjlPawSs8PjjAmPHzj4iImM0BNlq92/hV5UmWYkZzpxZDUJaOq/lzq7oK3epACkGEggScBMM+M9SfOEO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253725; c=relaxed/simple;
	bh=VZI0ER4wyTniFWkcopeSB/ADI+VE/CWl13wohg25CKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WglHexsDNwvRIQ9k7X+QCUKCvpYyXQEKe08fuOScSzgUGbaWfBw8cBEGtUTnbytYQ3twEQKc6j2xRYY/yBkLt1LHzkrfoG7qP2YDOSaDnMQysznD8zZuR4ue4Hu+qSeP6//oLyulXH2S/GgEe8JMWkG3mINt8m5c//ZHwMllj70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNMwpR+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNMwpR+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30F21F000C4;
	Sat, 17 Oct 2026 16:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253724;
	bh=UaO/y/oZgl5Jo9snrYAjvRiJMHbCa3Z/Ib/aHOOlt0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNMwpR+uiaD8Fj3eMEiFkxefo4srJFqKhlMtYNcVFZSUh7NqLa/+tVcc9KMQ0qNDj
	 n8kf67sCN85s+hLJsuOi88fYJ2X+kroNu6T26W/1661A0J5pB+oIxOtrVv7+5ZPiZD
	 jIXesuNzQ6Kzr/GVy3Gv3kThPt9HKQVNkyk8FpAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/869] mptcp: cleanup mem accounting
Date: Sat, 17 Oct 2026 17:50:54 +0200
Message-ID: <20261017160042.514469539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 6639498ed85fdb135dfb0dfbcc0f540b2d4ad6a6 ]

After the previous patch, updating sk_forward_memory is cheap and
we can drop a lot of complexity from the MPTCP memory accounting,
removing the custom fwd mem allocations for rmem.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250218-net-next-mptcp-rx-path-refactor-v1-4-4a47d90d7998@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5dd8025a49c2 ("mptcp: fix soft lockup in mptcp_recvmsg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/fastopen.c |   2 +-
 net/mptcp/protocol.c | 115 +++----------------------------------------
 net/mptcp/protocol.h |   4 +-
 3 files changed, 10 insertions(+), 111 deletions(-)

diff --git a/net/mptcp/fastopen.c b/net/mptcp/fastopen.c
index 40ca9aa21a626..3db79f3a52bac 100644
--- a/net/mptcp/fastopen.c
+++ b/net/mptcp/fastopen.c
@@ -53,7 +53,7 @@ void mptcp_fastopen_subflow_synack_set_params(struct mptcp_subflow_context *subf
 	mptcp_data_lock(sk);
 	DEBUG_NET_WARN_ON_ONCE(sock_owned_by_user_nocheck(sk));
 
-	mptcp_set_owner_r(skb, sk);
+	skb_set_owner_r(skb, sk);
 	__skb_queue_tail(&sk->sk_receive_queue, skb);
 	mptcp_sk(sk)->bytes_received += skb->len;
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6106c561026d6..5e094c72dcbb7 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -141,17 +141,6 @@ static void mptcp_drop(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
-static void mptcp_rmem_fwd_alloc_add(struct sock *sk, int size)
-{
-	WRITE_ONCE(mptcp_sk(sk)->rmem_fwd_alloc,
-		   mptcp_sk(sk)->rmem_fwd_alloc + size);
-}
-
-static void mptcp_rmem_charge(struct sock *sk, int size)
-{
-	mptcp_rmem_fwd_alloc_add(sk, -size);
-}
-
 static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
 			       struct sk_buff *from)
 {
@@ -174,7 +163,7 @@ static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
 	 * negative one
 	 */
 	atomic_add(delta, &sk->sk_rmem_alloc);
-	mptcp_rmem_charge(sk, delta);
+	sk_mem_charge(sk, delta);
 	kfree_skb_partial(from, fragstolen);
 
 	return true;
@@ -189,44 +178,6 @@ static bool mptcp_ooo_try_coalesce(struct mptcp_sock *msk, struct sk_buff *to,
 	return mptcp_try_coalesce((struct sock *)msk, to, from);
 }
 
-static void __mptcp_rmem_reclaim(struct sock *sk, int amount)
-{
-	amount >>= PAGE_SHIFT;
-	mptcp_rmem_charge(sk, amount << PAGE_SHIFT);
-	__sk_mem_reduce_allocated(sk, amount);
-}
-
-static void mptcp_rmem_uncharge(struct sock *sk, int size)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-	int reclaimable;
-
-	mptcp_rmem_fwd_alloc_add(sk, size);
-	reclaimable = msk->rmem_fwd_alloc - sk_unused_reserved_mem(sk);
-
-	/* see sk_mem_uncharge() for the rationale behind the following schema */
-	if (unlikely(reclaimable >= PAGE_SIZE))
-		__mptcp_rmem_reclaim(sk, reclaimable);
-}
-
-static void mptcp_rfree(struct sk_buff *skb)
-{
-	unsigned int len = skb->truesize;
-	struct sock *sk = skb->sk;
-
-	atomic_sub(len, &sk->sk_rmem_alloc);
-	mptcp_rmem_uncharge(sk, len);
-}
-
-void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk)
-{
-	skb_orphan(skb);
-	skb->sk = sk;
-	skb->destructor = mptcp_rfree;
-	atomic_add(skb->truesize, &sk->sk_rmem_alloc);
-	mptcp_rmem_charge(sk, skb->truesize);
-}
-
 /* "inspired" by tcp_data_queue_ofo(), main differences:
  * - use mptcp seqs
  * - don't cope with sacks
@@ -339,25 +290,7 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
 
 end:
 	skb_condense(skb);
-	mptcp_set_owner_r(skb, sk);
-}
-
-static bool mptcp_rmem_schedule(struct sock *sk, int size)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-	int amt, amount;
-
-	if (size <= msk->rmem_fwd_alloc)
-		return true;
-
-	size -= msk->rmem_fwd_alloc;
-	amt = sk_mem_pages(size);
-	amount = amt << PAGE_SHIFT;
-	if (!__sk_mem_raise_allocated(sk, size, amt, SK_MEM_RECV))
-		return false;
-
-	mptcp_rmem_fwd_alloc_add(sk, amount);
-	return true;
+	skb_set_owner_r(skb, sk);
 }
 
 static void mptcp_init_skb(struct sock *ssk, struct sk_buff *skb, int offset,
@@ -389,7 +322,7 @@ static bool __mptcp_move_skb(struct sock *sk, struct sk_buff *skb)
 	struct sk_buff *tail;
 
 	/* try to fetch required memory from subflow */
-	if (!mptcp_rmem_schedule(sk, skb->truesize)) {
+	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
 		mptcp_drop(sk, skb);
 		return false;
@@ -403,7 +336,7 @@ static bool __mptcp_move_skb(struct sock *sk, struct sk_buff *skb)
 		if (tail && mptcp_try_coalesce(sk, tail, skb))
 			return true;
 
-		mptcp_set_owner_r(skb, sk);
+		skb_set_owner_r(skb, sk);
 		__skb_queue_tail(&sk->sk_receive_queue, skb);
 		return true;
 	} else if (after64(MPTCP_SKB_CB(skb)->map_seq, msk->ack_seq)) {
@@ -2087,9 +2020,10 @@ static int __mptcp_recvmsg_mskq(struct sock *sk,
 				break;
 			}
 
-			/* we will bulk release the skb memory later */
+			/* avoid the indirect call, we know the destructor is sock_wfree */
 			skb->destructor = NULL;
-			WRITE_ONCE(msk->rmem_released, msk->rmem_released + skb->truesize);
+			atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
+			sk_mem_uncharge(sk, skb->truesize);
 			__skb_unlink(skb, &sk->sk_receive_queue);
 			__kfree_skb(skb);
 		}
@@ -2202,18 +2136,6 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 	msk->rcvq_space.time = mstamp;
 }
 
-static void __mptcp_update_rmem(struct sock *sk)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	if (!msk->rmem_released)
-		return;
-
-	atomic_sub(msk->rmem_released, &sk->sk_rmem_alloc);
-	mptcp_rmem_uncharge(sk, msk->rmem_released);
-	WRITE_ONCE(msk->rmem_released, 0);
-}
-
 static bool __mptcp_move_skbs(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -2237,7 +2159,6 @@ static bool __mptcp_move_skbs(struct sock *sk)
 			break;
 
 		slowpath = lock_sock_fast(ssk);
-		__mptcp_update_rmem(sk);
 		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 
 		if (unlikely(ssk->sk_err))
@@ -2245,12 +2166,7 @@ static bool __mptcp_move_skbs(struct sock *sk)
 		unlock_sock_fast(ssk, slowpath);
 	} while (!done);
 
-	ret = moved > 0;
-	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue) ||
-	    !skb_queue_empty(&sk->sk_receive_queue)) {
-		__mptcp_update_rmem(sk);
-		ret |= __mptcp_ofo_queue(msk);
-	}
+	ret = moved > 0 || __mptcp_ofo_queue(msk);
 	if (ret)
 		mptcp_check_data_fin((struct sock *)msk);
 
@@ -2974,8 +2890,6 @@ static void __mptcp_init_sock(struct sock *sk)
 	INIT_WORK(&msk->work, mptcp_worker);
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
-	WRITE_ONCE(msk->rmem_fwd_alloc, 0);
-	WRITE_ONCE(msk->rmem_released, 0);
 	msk->timer_ival = TCP_RTO_MIN;
 	msk->scaling_ratio = TCP_DEFAULT_SCALING_RATIO;
 
@@ -3205,8 +3119,6 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	sk->sk_prot->destroy(sk);
 
-	WARN_ON_ONCE(READ_ONCE(msk->rmem_fwd_alloc));
-	WARN_ON_ONCE(msk->rmem_released);
 	sk_stream_kill_queues(sk);
 	xfrm_sk_free_policy(sk);
 
@@ -3586,8 +3498,6 @@ void mptcp_destroy_common(struct mptcp_sock *msk)
 	/* move all the rx fwd alloc into the sk_mem_reclaim_final in
 	 * inet_sock_destruct() will dispose it
 	 */
-	sk_forward_alloc_add(sk, msk->rmem_fwd_alloc);
-	WRITE_ONCE(msk->rmem_fwd_alloc, 0);
 	mptcp_token_destroy(msk);
 
 	spin_lock_bh(&msk->pm.lock);
@@ -3689,8 +3599,6 @@ static void mptcp_release_cb(struct sock *sk)
 		if (__test_and_clear_bit(MPTCP_SYNC_SNDBUF, &msk->cb_flags))
 			__mptcp_sync_sndbuf(sk);
 	}
-
-	__mptcp_update_rmem(sk);
 }
 
 /* MP_JOIN client subflow must wait for 4th ack before sending any data:
@@ -3868,12 +3776,6 @@ static void mptcp_shutdown(struct sock *sk, int how)
 		__mptcp_wr_shutdown(sk);
 }
 
-static int mptcp_forward_alloc_get(const struct sock *sk)
-{
-	return READ_ONCE(sk->sk_forward_alloc) +
-	       READ_ONCE(mptcp_sk(sk)->rmem_fwd_alloc);
-}
-
 static int mptcp_ioctl_outq(const struct mptcp_sock *msk, u64 v)
 {
 	const struct sock *sk = (void *)msk;
@@ -4032,7 +3934,6 @@ static struct proto mptcp_prot = {
 	.hash		= mptcp_hash,
 	.unhash		= mptcp_unhash,
 	.get_port	= mptcp_get_port,
-	.forward_alloc_get	= mptcp_forward_alloc_get,
 	.stream_memory_free	= mptcp_stream_memory_free,
 	.sockets_allocated	= &mptcp_sockets_allocated,
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2f298250d575c..f3955c06be671 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -284,7 +284,6 @@ struct mptcp_sock {
 	u64		rcv_data_fin_seq;
 	u64		bytes_retrans;
 	u64		bytes_consumed;
-	int		rmem_fwd_alloc;
 	int		snd_burst;
 	int		old_wspace;
 	u64		recovery_snd_nxt;	/* in recovery mode accept up to this seq;
@@ -299,7 +298,6 @@ struct mptcp_sock {
 	u32		last_ack_recv;
 	unsigned long	timer_ival;
 	u32		token;
-	int		rmem_released;
 	unsigned long	flags;
 	unsigned long	cb_flags;
 	bool		recovery;		/* closing subflow write queue reinjected */
@@ -397,7 +395,7 @@ static inline void msk_owned_by_me(const struct mptcp_sock *msk)
  */
 static inline int __mptcp_rmem(const struct sock *sk)
 {
-	return atomic_read(&sk->sk_rmem_alloc) - READ_ONCE(mptcp_sk(sk)->rmem_released);
+	return atomic_read(&sk->sk_rmem_alloc);
 }
 
 static inline int mptcp_win_from_space(const struct sock *sk, int space)
-- 
2.53.0



