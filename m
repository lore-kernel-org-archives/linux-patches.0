Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EA876C9C;
	Tue, 20 Feb 2024 21:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463659; cv=none; b=JaQe82QOGSxIDHwxtsTY1JlgpJUAV3YKhWWVq2nf08/cFQPJeKFG3C9hCNHJsk+GqeCX+SWGsySG3Xl5nw7KSJv4CYGwuLg3fShkCiGhb+p82isjZhaHmOMEoUw0zHrSdDLqbjBuSImxVSzyjeK6/kvpKGqh2zMKnAXtF+gfRCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463659; c=relaxed/simple;
	bh=S7d+DhSRq0S3ZSTwJ4MyBahdTCJN8MVc3eevDtzj1GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBBLnD+CTTFX0SQ9vTRcn5yLD58zkbiTD/KEi9D2u0ARNp3njZWEaG+ipGlJbxxNv/zFBX+nkk9QxImgvz5/c0ZDLUSYuLPQNfnFcZcP+McdZrhOEKNyPtYAcYWeVPsq3wtx2TMLMHMwJXUjrLCCmmB5TqIpWg4JCcpJyvqFN64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDoH6kEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDoH6kEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A93C433C7;
	Tue, 20 Feb 2024 21:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463659;
	bh=S7d+DhSRq0S3ZSTwJ4MyBahdTCJN8MVc3eevDtzj1GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDoH6kEgA6uedeDnW4pWWaYpEktkgRzdS3Wa8R3ZLLLdCcvMSdblK6Hakag2upZVI
	 BYk7031AKVMojNf3RnjC9rSfxVMxc3HJ3GGh9iTE7wbEQUbF1OXrBv6HdhMkQN6YE3
	 o6muGg5tzzmFYxKEp87R9w/g4dqRGSMhp3ApRqwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 112/331] mptcp: drop the push_pending field
Date: Tue, 20 Feb 2024 21:53:48 +0100
Message-ID: <20240220205641.132259610@linuxfoundation.org>
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
@@ -1522,8 +1522,11 @@ static void mptcp_update_post_push(struc
 
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
@@ -3134,7 +3137,6 @@ static int mptcp_disconnect(struct sock
 	mptcp_destroy_common(msk, MPTCP_CF_FASTCLOSE);
 	WRITE_ONCE(msk->flags, 0);
 	msk->cb_flags = 0;
-	msk->push_pending = 0;
 	msk->recovery = false;
 	msk->can_ack = false;
 	msk->fully_established = false;
@@ -3359,8 +3361,7 @@ static void mptcp_release_cb(struct sock
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	for (;;) {
-		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED) |
-				      msk->push_pending;
+		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED);
 		struct list_head join_list;
 
 		if (!flags)
@@ -3376,7 +3377,6 @@ static void mptcp_release_cb(struct sock
 		 *    datapath acquires the msk socket spinlock while helding
 		 *    the subflow socket lock
 		 */
-		msk->push_pending = 0;
 		msk->cb_flags &= ~flags;
 		spin_unlock_bh(&sk->sk_lock.slock);
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -283,7 +283,6 @@ struct mptcp_sock {
 	int		rmem_released;
 	unsigned long	flags;
 	unsigned long	cb_flags;
-	unsigned long	push_pending;
 	bool		recovery;		/* closing subflow write queue reinjected */
 	bool		can_ack;
 	bool		fully_established;


