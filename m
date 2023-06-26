Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07530134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD77C433C0;
	Mon, 26 Jun 2023 18:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803468;
	bh=9XQ75qTCHuyTEWT9kHLdwDthCuAwmopEsfZNSVOD+zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVC31IyhC/iWUOSB2O2pqPY2Pj8Q/Y6DahHuUSArhppsLZK+YdaBM/Fv8LTaGJKNv
	 YbxkBoYwJUlcDp/hSH3XfTd1ZAb/M+W+6aOXBwLaGWJclC5JDJLd6H3QzGA1nTt+uL
	 VF/wn3xjedbsVWWBLZiM01i3fV5PMt/f0iOnorUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 072/199] mptcp: fix possible list corruption on passive MPJ
Date: Mon, 26 Jun 2023 20:09:38 +0200
Message-ID: <20230626180808.689587589@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

commit 56a666c48b038e91b76471289e2cf60c79d326b9 upstream.

At passive MPJ time, if the msk socket lock is held by the user,
the new subflow is appended to the msk->join_list under the msk
data lock.

In mptcp_release_cb()/__mptcp_flush_join_list(), the subflows in
that list are moved from the join_list into the conn_list under the
msk socket lock.

Append and removal could race, possibly corrupting such list.
Address the issue splicing the join list into a temporary one while
still under the msk data lock.

Found by code inspection, the race itself should be almost impossible
to trigger in practice.

Fixes: 3e5014909b56 ("mptcp: cleanup MPJ subflow list handling")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -837,12 +837,12 @@ static bool __mptcp_finish_join(struct m
 	return true;
 }
 
-static void __mptcp_flush_join_list(struct sock *sk)
+static void __mptcp_flush_join_list(struct sock *sk, struct list_head *join_list)
 {
 	struct mptcp_subflow_context *tmp, *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	list_for_each_entry_safe(subflow, tmp, &msk->join_list, node) {
+	list_for_each_entry_safe(subflow, tmp, join_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast(ssk);
 
@@ -3314,9 +3314,14 @@ static void mptcp_release_cb(struct sock
 	for (;;) {
 		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED) |
 				      msk->push_pending;
+		struct list_head join_list;
+
 		if (!flags)
 			break;
 
+		INIT_LIST_HEAD(&join_list);
+		list_splice_init(&msk->join_list, &join_list);
+
 		/* the following actions acquire the subflow socket lock
 		 *
 		 * 1) can't be invoked in atomic scope
@@ -3327,8 +3332,9 @@ static void mptcp_release_cb(struct sock
 		msk->push_pending = 0;
 		msk->cb_flags &= ~flags;
 		spin_unlock_bh(&sk->sk_lock.slock);
+
 		if (flags & BIT(MPTCP_FLUSH_JOIN_LIST))
-			__mptcp_flush_join_list(sk);
+			__mptcp_flush_join_list(sk, &join_list);
 		if (flags & BIT(MPTCP_PUSH_PENDING))
 			__mptcp_push_pending(sk, 0);
 		if (flags & BIT(MPTCP_RETRANSMIT))


