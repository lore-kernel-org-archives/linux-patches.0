Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8675932B138;
	Tue, 16 Jun 2026 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630048; cv=none; b=hxFlgnWXwiFID84/YjkuhNqgw8aWaiFtMXQQyBa8m8YGZORJ7kWp1c2L4gT8gjK7UMrpWnzhC9RVzT5xrd5upl0XC9W8FG21egdddkcwhcNCJlymOP+Qw2TsRiP/wc8aUR9XtLWxQAK1vIb/7T70njR1fFSplhtMwBfIcbzGfvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630048; c=relaxed/simple;
	bh=h1OX+LjyAMdZIN+if3Oz2BpBW5ajK4RlkShhVuKT15s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqYVvS8/6DrSeOcMQQiOBC/F8ApKCpXm1vq4Z7+NRLwLHeDG2I442n8p9ZQijhPULe7HQK2pPVse6+yCiqQLRKZrTXaYZrYrH2tiWcfyAvTyyRalNLT5Hg3v3OltZHXUThyR0SGvvZxZ/FbUSpy6oTiT4Zjd99dAWOQFUaqExJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VATQaD6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VATQaD6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F611F000E9;
	Tue, 16 Jun 2026 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630047;
	bh=fCHEZUD+LHFsM8lIeuau1cHdn0CB7MkZhnNT5IsHTXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VATQaD6GwHbos7JROjTu+0fXqS69+sYzAAFApxRU5KpidXkSjiaEXyWvmA4qjh9Ba
	 nPWDmOWR8MpdlCWjiTyhPm0ZsioM8u4mLtAGpLIlxifsCpX89poKBLz1CeQpfoUklz
	 kGHx4CE0bQzF8i5Fzd0nk3GsMaPuAyFqZvk953QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 400/452] mptcp: introduce the mptcp_init_skb helper
Date: Tue, 16 Jun 2026 20:30:27 +0530
Message-ID: <20260616145137.869246842@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

[ Upstream commit 9a0afe0db46720ce1a009c7dac168aa0584bd732 ]

Factor out all the skb initialization step in a new helper and
use it. Note that this change moves the MPTCP CB initialization
earlier: we can do such step as soon as the skb leaves the
subflow socket receive queues.

Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Tested-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250927-net-next-mptcp-rcv-path-imp-v1-4-5da266aa9c1a@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 50c2d91c5dfa ("mptcp: do not drop partial packets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   50 +++++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -323,7 +323,7 @@ end:
 	mptcp_set_owner_r(skb, sk);
 }
 
-static bool mptcp_rmem_schedule(struct sock *sk, struct sock *ssk, int size)
+static bool mptcp_rmem_schedule(struct sock *sk, int size)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	int amt, amount;
@@ -341,27 +341,11 @@ static bool mptcp_rmem_schedule(struct s
 	return true;
 }
 
-static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
-			     struct sk_buff *skb, unsigned int offset,
-			     size_t copy_len)
+static void mptcp_init_skb(struct sock *ssk, struct sk_buff *skb, int offset,
+			   int copy_len)
 {
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
-	struct sock *sk = (struct sock *)msk;
-	struct sk_buff *tail;
-	bool has_rxtstamp;
-
-	__skb_unlink(skb, &ssk->sk_receive_queue);
-
-	skb_ext_reset(skb);
-	skb_orphan(skb);
-
-	/* try to fetch required memory from subflow */
-	if (!mptcp_rmem_schedule(sk, ssk, skb->truesize)) {
-		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
-		goto drop;
-	}
-
-	has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
+	const struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	bool has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
 
 	/* the skb map_seq accounts for the skb offset:
 	 * mptcp_subflow_get_mapped_dsn() is based on the current tp->copied_seq
@@ -373,6 +357,25 @@ static bool __mptcp_move_skb(struct mptc
 	MPTCP_SKB_CB(skb)->has_rxtstamp = has_rxtstamp;
 	MPTCP_SKB_CB(skb)->cant_coalesce = 0;
 
+	__skb_unlink(skb, &ssk->sk_receive_queue);
+
+	skb_ext_reset(skb);
+	skb_dst_drop(skb);
+}
+
+static bool __mptcp_move_skb(struct sock *sk, struct sk_buff *skb)
+{
+	u64 copy_len = MPTCP_SKB_CB(skb)->end_seq - MPTCP_SKB_CB(skb)->map_seq;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct sk_buff *tail;
+
+	/* try to fetch required memory from subflow */
+	if (!mptcp_rmem_schedule(sk, skb->truesize)) {
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
+		mptcp_drop(sk, skb);
+		return false;
+	}
+
 	if (MPTCP_SKB_CB(skb)->map_seq == msk->ack_seq) {
 		/* in sequence */
 		msk->bytes_received += copy_len;
@@ -393,7 +396,6 @@ static bool __mptcp_move_skb(struct mptc
 	 * will retransmit as needed, if needed.
 	 */
 	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
-drop:
 	mptcp_drop(sk, skb);
 	return false;
 }
@@ -720,7 +722,9 @@ static bool __mptcp_move_skbs_from_subfl
 			if (tp->urg_data)
 				done = true;
 
-			if (__mptcp_move_skb(msk, ssk, skb, offset, len))
+			mptcp_init_skb(ssk, skb, offset, len);
+			skb_orphan(skb);
+			if (__mptcp_move_skb(sk, skb))
 				moved += len;
 			seq += len;
 


