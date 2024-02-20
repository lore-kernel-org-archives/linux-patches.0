Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF701509BC;
	Tue, 20 Feb 2024 21:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464749; cv=none; b=OL0jJuACED3huvru14d7iCdj+4Xvoby/hvdZhVQ/MgcYmKXKqbCfL2W3Oacyw1S7KvKNdZ2PpyQBUm2+Ul07ytni5EbqewoUcO6xiIZYJQTDUzXOLP/2UKZhHcFivl+aDUcYI30kS/VYmuLxylgu6AHzyRoyFQA6pZ+PUDQGMX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464749; c=relaxed/simple;
	bh=JL74Fza38qAZvmcvzdnoZ7X1YG9eGeick+R27CCt1Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttAOSdjTytciT3nf4g4rcWVUroQbUVHjmdoYBeEFV6EOxnVLQeJSpCWW9NudcYrIosU0BAR2WZFTlvN8YVbSs++Xh3zBUjrn7DbC1n8gXUwxWPTHFHR54+eOiZ2hur6kCNkavIwJdfKwCpuA7qhce/aOLLLf7y8S8PoO96fWDNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWVLXTJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWVLXTJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCD8C433F1;
	Tue, 20 Feb 2024 21:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464749;
	bh=JL74Fza38qAZvmcvzdnoZ7X1YG9eGeick+R27CCt1Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWVLXTJosKb83WeF5FNGaHtWKQT5fTdIJfF3rdYcqqYu8QmrFWvLNOmB21npolmRa
	 0+39f3QVqUyZqRm0TXhzFz6Wj/BYGsURUTNdounpjGpGSWAqAdHL6jxHODKT3ndREq
	 0FqCq+nMHqOA+8GBnJn2SWSgoQ67hODPZCC31DX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 123/309] mptcp: drop the push_pending field
Date: Tue, 20 Feb 2024 21:54:42 +0100
Message-ID: <20240220205637.015809612@linuxfoundation.org>
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

commit bdd70eb68913c960acb895b00a8c62eb64715b1f upstream.

Such field is there to avoid acquiring the data lock in a few spots,
but it adds complexity to the already non trivial locking schema.

All the relevant call sites (mptcp-level re-injection, set socket
options), are slow-path, drop such field in favor of 'cb_flags', adding
the relevant locking.

This patch could be seen as an improvement, instead of a fix. But it
simplifies the next patch. The 'Fixes' tag has been added to help having
this series backported to stable.

Fixes: e9d09baca676 ("mptcp: avoid atomic bit manipulation when possible")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   12 ++++++------
 net/mptcp/protocol.h |    1 -
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1519,8 +1519,11 @@ static void mptcp_update_post_push(struc
 
 void mptcp_check_and_set_pending(struct sock *sk)
 {
-	if (mptcp_send_head(sk))
-		mptcp_sk(sk)->push_pending |= BIT(MPTCP_PUSH_PENDING);
+	if (mptcp_send_head(sk)) {
+		mptcp_data_lock(sk);
+		mptcp_sk(sk)->cb_flags |= BIT(MPTCP_PUSH_PENDING);
+		mptcp_data_unlock(sk);
+	}
 }
 
 static int __subflow_push_pending(struct sock *sk, struct sock *ssk,
@@ -3138,7 +3141,6 @@ static int mptcp_disconnect(struct sock
 	mptcp_destroy_common(msk, MPTCP_CF_FASTCLOSE);
 	WRITE_ONCE(msk->flags, 0);
 	msk->cb_flags = 0;
-	msk->push_pending = 0;
 	msk->recovery = false;
 	msk->can_ack = false;
 	msk->fully_established = false;
@@ -3364,8 +3366,7 @@ static void mptcp_release_cb(struct sock
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	for (;;) {
-		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED) |
-				      msk->push_pending;
+		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED);
 		struct list_head join_list;
 
 		if (!flags)
@@ -3381,7 +3382,6 @@ static void mptcp_release_cb(struct sock
 		 *    datapath acquires the msk socket spinlock while helding
 		 *    the subflow socket lock
 		 */
-		msk->push_pending = 0;
 		msk->cb_flags &= ~flags;
 		spin_unlock_bh(&sk->sk_lock.slock);
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -286,7 +286,6 @@ struct mptcp_sock {
 	int		rmem_released;
 	unsigned long	flags;
 	unsigned long	cb_flags;
-	unsigned long	push_pending;
 	bool		recovery;		/* closing subflow write queue reinjected */
 	bool		can_ack;
 	bool		fully_established;


