Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAD14F30C4;
	Wed, 30 Sep 2026 16:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785630; cv=none; b=fvVhiibKFY2G0p+smiTxISxkkaYBN4EptyUll7DOx+yNNDfsMwyl3AIddi6wRvUFGfECq41//B4StUa0nveVzv8w/eOZZQZnJzKZs/zyXwOQWIRpIsD2PYv8OXqSLEyYX3M02l6DhLIUwTJqIWcBQhi6mA5pToZ5Hf//gxLSSAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785630; c=relaxed/simple;
	bh=5itslhRnRn411j8aMwgMRjX16kJcx+oFl9xEtBS6bG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTLy0uyuoSfVKoFiCW7CUdS2WFAqraEDMPBzwvuoRzb0BXFWKaK3tCIevv2N3Izbd3c7e91+qNFpSdJDAL6gT8euSJOFuxvCsQhhEetLx0ZftQsAtpfEwRUvm7h/Rvy/YBHhLxFw/mIiUf1rfsju77LfJrf0+guzY5EZIVixjNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sblnHhZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sblnHhZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D951F0089A;
	Wed, 30 Sep 2026 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785622;
	bh=vGruGLXUrZwjEpt3/mkmmv4fVkdtDcQsSl6SZFUqibc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sblnHhZpcZvmm5t5l8z8Kz0m9faCPnZXPO9F1sflk6go8FjeU7OaXP05gHGudbovJ
	 Dt/Vk357T+K5l7hGU6lIwqc9imOc9BfmPIBuAZok20oFcGU+oVUaBIEM3ekbDIJZLH
	 KATB4GRTWHosMl0p4T5dQf5QbtI4QsDD2VTQBeoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 573/982] mptcp: consolidate subflow cleanup
Date: Wed, 30 Sep 2026 17:21:49 +0200
Message-ID: <20260930152429.077905134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit c3349a22c2002947d29a98a77bfb36d97cfbfac1 upstream.

Consolidate all the cleanup actions requiring the worker in a single
helper and ensure the dummy data fin creation for fallback socket is
performed only when the tcp rx queue is empty.

There are no functional changes intended, but this will simplify the
next patch, when the tcp rx queue spooling could be delayed at release_cb
time.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250218-net-next-mptcp-rx-path-refactor-v1-1-4a47d90d7998@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2b0f561f21b2 ("mptcp: avoid unneeded actions on subflow reset")
[ Note: also remove struct mptcp_sock *msk from subflow_state_change: it
  is no longer used after this modification. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1159,7 +1159,12 @@ out:
 		subflow->map_valid = 0;
 }
 
-/* sched mptcp worker to remove the subflow if no more data is pending */
+static bool subflow_is_done(const struct sock *sk)
+{
+	return sk->sk_shutdown & RCV_SHUTDOWN || sk->sk_state == TCP_CLOSE;
+}
+
+/* sched mptcp worker for subflow cleanup if no more data is pending */
 static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct sock *sk = (struct sock *)msk;
@@ -1169,8 +1174,18 @@ static void subflow_sched_work_if_closed
 		    inet_sk_state_load(sk) != TCP_ESTABLISHED)))
 		return;
 
-	if (skb_queue_empty(&ssk->sk_receive_queue) &&
-	    !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+	if (!skb_queue_empty(&ssk->sk_receive_queue))
+		return;
+
+	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		mptcp_schedule_work(sk);
+
+	/* when the fallback subflow closes the rx side, trigger a 'dummy'
+	 * ingress data fin, so that the msk state will follow along
+	 */
+	if (__mptcp_check_fallback(msk) && subflow_is_done(ssk) &&
+	    msk->first == ssk &&
+	    mptcp_update_rcv_data_fin(msk, READ_ONCE(msk->ack_seq), true))
 		mptcp_schedule_work(sk);
 }
 
@@ -1688,20 +1703,13 @@ static void __subflow_state_change(struc
 	rcu_read_unlock();
 }
 
-static bool subflow_is_done(const struct sock *sk)
-{
-	return sk->sk_shutdown & RCV_SHUTDOWN || sk->sk_state == TCP_CLOSE;
-}
-
 static void subflow_state_change(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct sock *parent = subflow->conn;
-	struct mptcp_sock *msk;
 
 	__subflow_state_change(sk);
 
-	msk = mptcp_sk(parent);
 	/* as recvmsg() does not acquire the subflow socket for ssk selection
 	 * a fin packet carrying a DSS can be unnoticed if we don't trigger
 	 * the data available machinery here.
@@ -1712,13 +1720,6 @@ static void subflow_state_change(struct
 		subflow_error_report(sk);
 
 	subflow_sched_work_if_closed(mptcp_sk(parent), sk);
-
-	/* when the fallback subflow closes the rx side, trigger a 'dummy'
-	 * ingress data fin, so that the msk state will follow along
-	 */
-	if (__mptcp_check_fallback(msk) && subflow_is_done(sk) && msk->first == sk &&
-	    mptcp_update_rcv_data_fin(msk, READ_ONCE(msk->ack_seq), true))
-		mptcp_schedule_work(parent);
 }
 
 void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)


