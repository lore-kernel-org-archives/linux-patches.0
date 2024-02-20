Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD00314F9C8;
	Tue, 20 Feb 2024 21:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462994; cv=none; b=cD8fWrGvlRkLz/w0mu2sko5u9WlLyytxAQ3CCciSYi3HwPugktON1XvDqt9owIUTOCw3K8rwpfBdWcHWffZH0My774bG/5Dew+PYLsQ2UJIyqM6DA7d535TTHBfTe6fIv+rWLgB2vjakyaLN13ORfjJsOBHllFAFPBmKsOL9/+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462994; c=relaxed/simple;
	bh=lMYqUAU0H8s5Upai86W7/h4o1qfUzQMIpoQiFBArtV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPwrydyh99/ZuWKubBifyicJLrizoltnMzoRyglPB1RYPt/LX2QhZibKyJV7h8UfS09hQzG1DFyV4cpH3HOKIpnQBFVa5cS5ZWx+2V/6Cul0x1YQOfoGcWY2qaBt1xyO6UVryJGDwbDpAW43hVSTCCDX5QvvP7E+ikWnYaVr6rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwZKzgyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwZKzgyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FB4C433F1;
	Tue, 20 Feb 2024 21:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462993;
	bh=lMYqUAU0H8s5Upai86W7/h4o1qfUzQMIpoQiFBArtV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwZKzgyzHN5lD692JeS2o4qEixN8YEQTBFLfRrU3f0ZL650gEVt/75TXrxtVVBmAy
	 bABlxaxkRlIN1l89dIA4WU/967EVyMboDONJb+KZx52qQGVdhmMKiH61fXNflLZxHI
	 VNbr6DxVH4WVSdk/KaBKAnjOYq3Q2s3Ul9Dza5F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 072/197] mptcp: drop the push_pending field
Date: Tue, 20 Feb 2024 21:50:31 +0100
Message-ID: <20240220204843.235269672@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1582,8 +1582,11 @@ static void mptcp_update_post_push(struc
 
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
 
 void __mptcp_push_pending(struct sock *sk, unsigned int flags)
@@ -3140,7 +3143,6 @@ static int mptcp_disconnect(struct sock
 	msk->last_snd = NULL;
 	WRITE_ONCE(msk->flags, 0);
 	msk->cb_flags = 0;
-	msk->push_pending = 0;
 	msk->recovery = false;
 	msk->can_ack = false;
 	msk->fully_established = false;
@@ -3384,8 +3386,7 @@ static void mptcp_release_cb(struct sock
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	for (;;) {
-		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED) |
-				      msk->push_pending;
+		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED);
 		struct list_head join_list;
 
 		if (!flags)
@@ -3401,7 +3402,6 @@ static void mptcp_release_cb(struct sock
 		 *    datapath acquires the msk socket spinlock while helding
 		 *    the subflow socket lock
 		 */
-		msk->push_pending = 0;
 		msk->cb_flags &= ~flags;
 		spin_unlock_bh(&sk->sk_lock.slock);
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -272,7 +272,6 @@ struct mptcp_sock {
 	int		rmem_released;
 	unsigned long	flags;
 	unsigned long	cb_flags;
-	unsigned long	push_pending;
 	bool		recovery;		/* closing subflow write queue reinjected */
 	bool		can_ack;
 	bool		fully_established;


