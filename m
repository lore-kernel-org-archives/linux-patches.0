Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6A40960F;
	Wed, 20 May 2026 18:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303035; cv=none; b=sYD2XhWiI4SIgW356idfbVEELRyguFJc+NonQnaoOuT+e+lEUmVBghc5Dh+0Or/RLlt0UbEBNxAJuQnz8l9FMMc7RUSKrNH9VqEGsKYAJvqOHaLAw33EDkDoLAg0M0F7lpyfJCWpwcLqAmersh3XrEcA4TklnU882RBX5ZNe3gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303035; c=relaxed/simple;
	bh=jFO76Ak6UpqUqwz3gyKwgsLE1Udbtbz5X9TXdwIWD+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chtWG/wlDxXc2ikQdpNrcVtWULyILp6IjtpuXvCN4zYfb9NQH7hR2yabtAB+eBHwYnxoZotpe1nppdWKen5xGYsLQydooLPmHJi/HNp5UG+Z/ZK/HU5KgA188yxbpkXifXbcncNHLQ776OJLLMRnMaYq6LUa7z2Skg/iEFJLOtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdMACXNc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdMACXNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEA11F000E9;
	Wed, 20 May 2026 18:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303032;
	bh=vk5SOhoAz13X4RRiua+YT4BWylpKuBLbg+di5nuk0ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdMACXNcu4vxRVDVG3zHGZuZg1qrKS6pakWuy9gaxUxM7i7moJIOIYqlXolXbMcWl
	 bH2zQ/rfrmKYKjUSdOwpRFx2Qmu96QfUWmI9TOET/MgdDZ4qOTTTa5sciEfsIxCCkI
	 vXnQVTNQaa5hfYv525yM7+Lo6Cmh0AD23fcrpRVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 494/508] mptcp: drop __mptcp_fastopen_gen_msk_ackseq()
Date: Wed, 20 May 2026 18:25:17 +0200
Message-ID: <20260520162109.301725817@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit f03afb3aeb9d81f6c5ab728a61a040012923e3b3 ]

When we will move the whole RX path under the msk socket lock, updating
the already queued skb for passive fastopen socket at 3rd ack time will
be extremely painful and race prone

The map_seq for already enqueued skbs is used only to allow correct
coalescing with later data; preventing collapsing to the first skb of
a fastopen connect we can completely remove the
__mptcp_fastopen_gen_msk_ackseq() helper.

Before dropping this helper, a new item had to be added to the
mptcp_skb_cb structure. Because this item will be frequently tested in
the fast path -- almost on every packet -- and because there is free
space there, a single byte is used instead of a bitfield. This micro
optimisation slightly reduces the number of CPU operations to do the
associated check.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250218-net-next-mptcp-rx-path-refactor-v1-2-4a47d90d7998@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6254a16d6f0c ("mptcp: fix rx timestamp corruption on fastopen")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/fastopen.c |   24 ++----------------------
 net/mptcp/protocol.c |    4 +++-
 net/mptcp/protocol.h |    5 ++---
 net/mptcp/subflow.c  |    3 ---
 4 files changed, 7 insertions(+), 29 deletions(-)

--- a/net/mptcp/fastopen.c
+++ b/net/mptcp/fastopen.c
@@ -40,13 +40,12 @@ void mptcp_fastopen_subflow_synack_set_p
 	tp->copied_seq += skb->len;
 	subflow->ssn_offset += skb->len;
 
-	/* initialize a dummy sequence number, we will update it at MPC
-	 * completion, if needed
-	 */
+	/* Only the sequence delta is relevant */
 	MPTCP_SKB_CB(skb)->map_seq = -skb->len;
 	MPTCP_SKB_CB(skb)->end_seq = 0;
 	MPTCP_SKB_CB(skb)->offset = 0;
 	MPTCP_SKB_CB(skb)->has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
+	MPTCP_SKB_CB(skb)->cant_coalesce = 1;
 
 	mptcp_data_lock(sk);
 
@@ -58,22 +57,3 @@ void mptcp_fastopen_subflow_synack_set_p
 
 	mptcp_data_unlock(sk);
 }
-
-void __mptcp_fastopen_gen_msk_ackseq(struct mptcp_sock *msk, struct mptcp_subflow_context *subflow,
-				     const struct mptcp_options_received *mp_opt)
-{
-	struct sock *sk = (struct sock *)msk;
-	struct sk_buff *skb;
-
-	skb = skb_peek_tail(&sk->sk_receive_queue);
-	if (skb) {
-		WARN_ON_ONCE(MPTCP_SKB_CB(skb)->end_seq);
-		pr_debug("msk %p moving seq %llx -> %llx end_seq %llx -> %llx\n", sk,
-			 MPTCP_SKB_CB(skb)->map_seq, MPTCP_SKB_CB(skb)->map_seq + msk->ack_seq,
-			 MPTCP_SKB_CB(skb)->end_seq, MPTCP_SKB_CB(skb)->end_seq + msk->ack_seq);
-		MPTCP_SKB_CB(skb)->map_seq += msk->ack_seq;
-		MPTCP_SKB_CB(skb)->end_seq += msk->ack_seq;
-	}
-
-	pr_debug("msk=%p ack_seq=%llx\n", msk, msk->ack_seq);
-}
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -139,7 +139,8 @@ static bool mptcp_try_coalesce(struct so
 	bool fragstolen;
 	int delta;
 
-	if (MPTCP_SKB_CB(from)->offset ||
+	if (unlikely(MPTCP_SKB_CB(to)->cant_coalesce) ||
+	    MPTCP_SKB_CB(from)->offset ||
 	    ((to->len + from->len) > (sk->sk_rcvbuf >> 3)) ||
 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
 		return false;
@@ -370,6 +371,7 @@ static bool __mptcp_move_skb(struct mptc
 	MPTCP_SKB_CB(skb)->end_seq = MPTCP_SKB_CB(skb)->map_seq + copy_len;
 	MPTCP_SKB_CB(skb)->offset = offset;
 	MPTCP_SKB_CB(skb)->has_rxtstamp = has_rxtstamp;
+	MPTCP_SKB_CB(skb)->cant_coalesce = 0;
 
 	if (MPTCP_SKB_CB(skb)->map_seq == msk->ack_seq) {
 		/* in sequence */
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -129,7 +129,8 @@ struct mptcp_skb_cb {
 	u64 map_seq;
 	u64 end_seq;
 	u32 offset;
-	u8  has_rxtstamp:1;
+	u8  has_rxtstamp;
+	u8  cant_coalesce;
 };
 
 #define MPTCP_SKB_CB(__skb)	((struct mptcp_skb_cb *)&((__skb)->cb[0]))
@@ -988,8 +989,6 @@ void mptcp_event_pm_listener(const struc
 			     enum mptcp_event_type event);
 bool mptcp_userspace_pm_active(const struct mptcp_sock *msk);
 
-void __mptcp_fastopen_gen_msk_ackseq(struct mptcp_sock *msk, struct mptcp_subflow_context *subflow,
-				     const struct mptcp_options_received *mp_opt);
 void mptcp_fastopen_subflow_synack_set_params(struct mptcp_subflow_context *subflow,
 					      struct request_sock *req);
 
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -778,9 +778,6 @@ void __mptcp_subflow_fully_established(s
 	subflow_set_remote_key(msk, subflow, mp_opt);
 	subflow->fully_established = 1;
 	WRITE_ONCE(msk->fully_established, true);
-
-	if (subflow->is_mptfo)
-		__mptcp_fastopen_gen_msk_ackseq(msk, subflow, mp_opt);
 }
 
 static struct sock *subflow_syn_recv_sock(const struct sock *sk,


