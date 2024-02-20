Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF3314F9C8;
	Tue, 20 Feb 2024 21:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464875; cv=none; b=b/wCtCVXGJEziKVLoSrMDwXnJwpxbkmZcMjru18NUrcheQOFGH4g/PoyLH+43G5VmcR5Ksx5llvDc389sOFKT8EUUTxMi6ItTDbteffxdRjvxEMWpg/ZExYd9gTlBT/YZmjidrzRfEDMdUqA90yrU1YPAVJnGJSyOOuWBIhdN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464875; c=relaxed/simple;
	bh=bwEEXl8PIEN030VYvXpfD5VTrPthOhBvxEoGvyt+aE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCuLAF6znPo9FQPTLo2IqaczkQZmakMg02YCC5vlfRIxTIY/jDoueQUbW45QTQysatL0T1IlQ1FMTWyXt5w4C/rwvckrdlZfXiQ71To1OvxBrBjD+Hr1v9WPfS5v51B63OVauPp0TKsKW1WErITiyacWh0ecUQxunStSVT8tNg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjTFDUJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjTFDUJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE88C433F1;
	Tue, 20 Feb 2024 21:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464875;
	bh=bwEEXl8PIEN030VYvXpfD5VTrPthOhBvxEoGvyt+aE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjTFDUJ8uzterIMzYciL85Dmq7GhpT+mpxwsDL7b0cxCqzIIvn3BMvhQuXI+sPPaj
	 JwBGeY32oIY1pP2f2gLClBw6QKSWgzbMC+peTsYKW+97t5a5U8cmu8y3REmns4+kpH
	 ds0BEB28ekMGr7fWvjqKHNWXhHzR+NBDB/4Ylb5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 124/309] mptcp: fix rcv space initialization
Date: Tue, 20 Feb 2024 21:54:43 +0100
Message-ID: <20240220205637.044426504@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1977,6 +1977,9 @@ static void mptcp_rcv_space_adjust(struc
 	if (copied <= 0)
 		return;
 
+	if (!msk->rcvspace_init)
+		mptcp_rcv_space_init(msk, msk->first);
+
 	msk->rcvq_space.copied += copied;
 
 	mstamp = div_u64(tcp_clock_ns(), NSEC_PER_USEC);
@@ -3156,6 +3159,7 @@ static int mptcp_disconnect(struct sock
 	msk->bytes_received = 0;
 	msk->bytes_sent = 0;
 	msk->bytes_retrans = 0;
+	msk->rcvspace_init = 0;
 
 	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);
@@ -3243,6 +3247,7 @@ void mptcp_rcv_space_init(struct mptcp_s
 {
 	const struct tcp_sock *tp = tcp_sk(ssk);
 
+	msk->rcvspace_init = 1;
 	msk->rcvq_space.copied = 0;
 	msk->rcvq_space.rtt_us = 0;
 
@@ -3253,8 +3258,6 @@ void mptcp_rcv_space_init(struct mptcp_s
 				      TCP_INIT_CWND * tp->advmss);
 	if (msk->rcvq_space.space == 0)
 		msk->rcvq_space.space = TCP_INIT_CWND * TCP_MSS_DEFAULT;
-
-	WRITE_ONCE(msk->wnd_end, msk->snd_nxt + tcp_sk(ssk)->snd_wnd);
 }
 
 static struct sock *mptcp_accept(struct sock *ssk, int flags, int *err,
@@ -3512,10 +3515,9 @@ void mptcp_finish_connect(struct sock *s
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
@@ -304,7 +304,8 @@ struct mptcp_sock {
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
@@ -1744,7 +1745,6 @@ static void subflow_state_change(struct
 	msk = mptcp_sk(parent);
 	if (subflow_simultaneous_connect(sk)) {
 		mptcp_do_fallback(sk);
-		mptcp_rcv_space_init(msk, sk);
 		pr_fallback(msk);
 		subflow->conn_finished = 1;
 		mptcp_propagate_state(parent, sk);


