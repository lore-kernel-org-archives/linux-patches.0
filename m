Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1958A34CD3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8552DC433D2;
	Wed,  7 Jun 2023 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170377;
	bh=H+LEfchy+QCSsgLt3J1StEMK1XO0IsiFYVlEegQ9cIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mu5zOOUuX/R4WOk6yuuwkKqO3bBh/5Vgt8TTj6a2IBeMHflJbyIEQZa4sZM2Dqc/j
	 SL1X52RyuJIo53QE7gQfuSjFJ9eUEME/lBjNULekK2WXME7uK29ng7Kdoxr2XsJV+v
	 GiyU/PJy+Jj+rd1Flm7jCqVb1ur8eTa/Y2WMXaPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/225] mptcp: add annotations around msk->subflow accesses
Date: Wed,  7 Jun 2023 22:14:07 +0200
Message-ID: <20230607200916.122919175@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 5b825727d0871b23e8867f6371183e61628b4a26 ]

The MPTCP can access the first subflow socket in a few spots
outside the socket lock scope. That is actually safe, as MPTCP
will delete the socket itself only after the msk sock close().

Still the such accesses causes a few KCSAN splats, as reported
by Christoph. Silence the harmless warning adding a few annotation
around the relevant accesses.

Fixes: 71ba088ce0aa ("mptcp: cleanup accept and poll")
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/402
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 18 ++++++++++--------
 net/mptcp/protocol.h |  6 +++++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index fecee0a850d65..efe372ff389d4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -112,7 +112,7 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 		return err;
 
 	msk->first = ssock->sk;
-	msk->subflow = ssock;
+	WRITE_ONCE(msk->subflow, ssock);
 	subflow = mptcp_subflow_ctx(ssock->sk);
 	list_add(&subflow->node, &msk->conn_list);
 	sock_hold(ssock->sk);
@@ -2269,7 +2269,7 @@ static void mptcp_dispose_initial_subflow(struct mptcp_sock *msk)
 {
 	if (msk->subflow) {
 		iput(SOCK_INODE(msk->subflow));
-		msk->subflow = NULL;
+		WRITE_ONCE(msk->subflow, NULL);
 	}
 }
 
@@ -3115,7 +3115,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk = mptcp_sk(nsk);
 	msk->local_key = subflow_req->local_key;
 	msk->token = subflow_req->token;
-	msk->subflow = NULL;
+	WRITE_ONCE(msk->subflow, NULL);
 	msk->in_accept_queue = 1;
 	WRITE_ONCE(msk->fully_established, false);
 	if (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD)
@@ -3172,7 +3172,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	struct socket *listener;
 	struct sock *newsk;
 
-	listener = msk->subflow;
+	listener = READ_ONCE(msk->subflow);
 	if (WARN_ON_ONCE(!listener)) {
 		*err = -EINVAL;
 		return NULL;
@@ -3746,10 +3746,10 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 
 	pr_debug("msk=%p", msk);
 
-	/* buggy applications can call accept on socket states other then LISTEN
+	/* Buggy applications can call accept on socket states other then LISTEN
 	 * but no need to allocate the first subflow just to error out.
 	 */
-	ssock = msk->subflow;
+	ssock = READ_ONCE(msk->subflow);
 	if (!ssock)
 		return -EINVAL;
 
@@ -3822,10 +3822,12 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	state = inet_sk_state_load(sk);
 	pr_debug("msk=%p state=%d flags=%lx", msk, state, msk->flags);
 	if (state == TCP_LISTEN) {
-		if (WARN_ON_ONCE(!msk->subflow || !msk->subflow->sk))
+		struct socket *ssock = READ_ONCE(msk->subflow);
+
+		if (WARN_ON_ONCE(!ssock || !ssock->sk))
 			return 0;
 
-		return inet_csk_listen_poll(msk->subflow->sk);
+		return inet_csk_listen_poll(ssock->sk);
 	}
 
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 441feeaeb2427..822fd749f5690 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -297,7 +297,11 @@ struct mptcp_sock {
 	struct list_head rtx_queue;
 	struct mptcp_data_frag *first_pending;
 	struct list_head join_list;
-	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
+	struct socket	*subflow; /* outgoing connect/listener/!mp_capable
+				   * The mptcp ops can safely dereference, using suitable
+				   * ONCE annotation, the subflow outside the socket
+				   * lock as such sock is freed after close().
+				   */
 	struct sock	*first;
 	struct mptcp_pm_data	pm;
 	struct {
-- 
2.39.2



