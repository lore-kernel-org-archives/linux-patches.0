Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF1E76C9C;
	Tue, 20 Feb 2024 21:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463666; cv=none; b=hf4qJ718C61HVTe7sAZFzwr3Xdy6T2GJE/uq7k4fFUn7EO8qjat3oBxQgqBTYTMH+ER+959L8gW+zdG3r6NHDYnZ96kALTt+woq/ZZ9prY+8rWaLE07kSzmR0vWf1E3g85my4HPkbSUdrqQW2LcL9NDic+nsQ9PoSbrzNTfj7aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463666; c=relaxed/simple;
	bh=yitDAIZqi0M8ing2xbIJzJ/mxWc5MJ5m2Ayz2q3nisw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqXfnZ5hmnyjfzMKGK9aILLQLq+XvFqE13iQXKsRfRT2wJGBu5ARhnUJZkXRYJ0TBzAU9iqEdBcO3bTSR7BPa1r6OKHfHdM6LOI2hTMYC9OPZwWezaqWR02ZYtws0xDCAacZS4FZ4qSpWZp1GH0Vn51/OgRlHciG8ukT1wIcPB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV6dsaiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV6dsaiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E35C433C7;
	Tue, 20 Feb 2024 21:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463665;
	bh=yitDAIZqi0M8ing2xbIJzJ/mxWc5MJ5m2Ayz2q3nisw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV6dsaiZ4asuE7DKB47fD/6fxsOnM0F1j93YSdPZlZhc5aDe3dofdPQbns2WxYJh3
	 nUqTTQZmSSMf9A7VaRVflhwdP0Jlh12pLtq51Tq9wt3z62M2bk+r1BQGC0snuXpoGZ
	 BlNpMpfml9iTKGQWgfY2wCt80q/xJaFv1Dt1YvZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 113/331] mptcp: fix rcv space initialization
Date: Tue, 20 Feb 2024 21:53:49 +0100
Message-ID: <20240220205641.168562748@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 013e3179dbd2bc756ce1dd90354abac62f65b739 upstream.

mptcp_rcv_space_init() is supposed to happen under the msk socket
lock, but active msk socket does that without such protection.

Leverage the existing mptcp_propagate_state() helper to that extent.
We need to ensure mptcp_rcv_space_init will happen before
mptcp_rcv_space_adjust(), and the release_cb does not assure that:
explicitly check for such condition.

While at it, move the wnd_end initialization out of mptcp_rcv_space_init(),
it never belonged there.

Note that the race does not produce ill effect in practice, but
change allows cleaning-up and defying better the locking model.

Fixes: a6b118febbab ("mptcp: add receive buffer auto-tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   10 ++++++----
 net/mptcp/protocol.h |    3 ++-
 net/mptcp/subflow.c  |    4 ++--
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1967,6 +1967,9 @@ static void mptcp_rcv_space_adjust(struc
 	if (copied <= 0)
 		return;
 
+	if (!msk->rcvspace_init)
+		mptcp_rcv_space_init(msk, msk->first);
+
 	msk->rcvq_space.copied += copied;
 
 	mstamp = div_u64(tcp_clock_ns(), NSEC_PER_USEC);
@@ -3151,6 +3154,7 @@ static int mptcp_disconnect(struct sock
 	msk->bytes_received = 0;
 	msk->bytes_sent = 0;
 	msk->bytes_retrans = 0;
+	msk->rcvspace_init = 0;
 
 	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);
@@ -3238,6 +3242,7 @@ void mptcp_rcv_space_init(struct mptcp_s
 {
 	const struct tcp_sock *tp = tcp_sk(ssk);
 
+	msk->rcvspace_init = 1;
 	msk->rcvq_space.copied = 0;
 	msk->rcvq_space.rtt_us = 0;
 
@@ -3248,8 +3253,6 @@ void mptcp_rcv_space_init(struct mptcp_s
 				      TCP_INIT_CWND * tp->advmss);
 	if (msk->rcvq_space.space == 0)
 		msk->rcvq_space.space = TCP_INIT_CWND * TCP_MSS_DEFAULT;
-
-	WRITE_ONCE(msk->wnd_end, msk->snd_nxt + tcp_sk(ssk)->snd_wnd);
 }
 
 static struct sock *mptcp_accept(struct sock *ssk, int flags, int *err,
@@ -3507,10 +3510,9 @@ void mptcp_finish_connect(struct sock *s
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
 	WRITE_ONCE(msk->snd_nxt, msk->write_seq);
 	WRITE_ONCE(msk->snd_una, msk->write_seq);
+	WRITE_ONCE(msk->wnd_end, msk->snd_nxt + tcp_sk(ssk)->snd_wnd);
 
 	mptcp_pm_new_connection(msk, ssk, 0);
-
-	mptcp_rcv_space_init(msk, ssk);
 }
 
 void mptcp_sock_graft(struct sock *sk, struct socket *parent)
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -301,7 +301,8 @@ struct mptcp_sock {
 			nodelay:1,
 			fastopening:1,
 			in_accept_queue:1,
-			free_first:1;
+			free_first:1,
+			rcvspace_init:1;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -424,6 +424,8 @@ void __mptcp_sync_state(struct sock *sk,
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	__mptcp_propagate_sndbuf(sk, msk->first);
+	if (!msk->rcvspace_init)
+		mptcp_rcv_space_init(msk, msk->first);
 	if (sk->sk_state == TCP_SYN_SENT) {
 		inet_sk_state_store(sk, state);
 		sk->sk_state_change(sk);
@@ -545,7 +547,6 @@ static void subflow_finish_connect(struc
 		}
 	} else if (mptcp_check_fallback(sk)) {
 fallback:
-		mptcp_rcv_space_init(msk, sk);
 		mptcp_propagate_state(parent, sk);
 	}
 	return;
@@ -1736,7 +1737,6 @@ static void subflow_state_change(struct
 	msk = mptcp_sk(parent);
 	if (subflow_simultaneous_connect(sk)) {
 		mptcp_do_fallback(sk);
-		mptcp_rcv_space_init(msk, sk);
 		pr_fallback(msk);
 		subflow->conn_finished = 1;
 		mptcp_propagate_state(parent, sk);


