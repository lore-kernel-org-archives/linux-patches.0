Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB661A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XqenppH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB37C433CA;
	Mon,  9 Oct 2023 13:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857452;
	bh=CFMN0qCTVYYvwKb0OvPOggHG2gJF3XysKJeHAztVfZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XqenppHHOC8fAwisnm4opAeR+OK7MstHiDarBv2w7ZidxhW2Q8Sp1MxY61FqpHgt
	 gpzSa8o3ZcP/7oKH3midPWuhvwaGW7aLrILySWLg+b3kWlqN1ko6iy2F2MygnnAVOx
	 dZXmn1UbLK4aNlljgHXU9g9unaiqYsVtEjfvb2Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/162] mptcp: process pending subflow error on close
Date: Mon,  9 Oct 2023 14:59:55 +0200
Message-ID: <20231009130123.343177859@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

[ Upstream commit 9f1a98813b4b686482e5ef3c9d998581cace0ba6 ]

On incoming TCP reset, subflow closing could happen before error
propagation. That in turn could cause the socket error being ignored,
and a missing socket state transition, as reported by Daire-Byrne.

Address the issues explicitly checking for subflow socket error at
close time. To avoid code duplication, factor-out of __mptcp_error_report()
a new helper implementing the relevant bits.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/429
Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 63 ++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 193f2bdc8fe1b..b6e0579e72644 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -765,40 +765,44 @@ static bool __mptcp_ofo_queue(struct mptcp_sock *msk)
 	return moved;
 }
 
-void __mptcp_error_report(struct sock *sk)
+static bool __mptcp_subflow_error_report(struct sock *sk, struct sock *ssk)
 {
-	struct mptcp_subflow_context *subflow;
-	struct mptcp_sock *msk = mptcp_sk(sk);
+	int err = sock_error(ssk);
+	int ssk_state;
 
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		int err = sock_error(ssk);
-		int ssk_state;
+	if (!err)
+		return false;
 
-		if (!err)
-			continue;
+	/* only propagate errors on fallen-back sockets or
+	 * on MPC connect
+	 */
+	if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(mptcp_sk(sk)))
+		return false;
 
-		/* only propagate errors on fallen-back sockets or
-		 * on MPC connect
-		 */
-		if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(msk))
-			continue;
+	/* We need to propagate only transition to CLOSE state.
+	 * Orphaned socket will see such state change via
+	 * subflow_sched_work_if_closed() and that path will properly
+	 * destroy the msk as needed.
+	 */
+	ssk_state = inet_sk_state_load(ssk);
+	if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
+		inet_sk_state_store(sk, ssk_state);
+	WRITE_ONCE(sk->sk_err, -err);
 
-		/* We need to propagate only transition to CLOSE state.
-		 * Orphaned socket will see such state change via
-		 * subflow_sched_work_if_closed() and that path will properly
-		 * destroy the msk as needed.
-		 */
-		ssk_state = inet_sk_state_load(ssk);
-		if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
-			inet_sk_state_store(sk, ssk_state);
-		WRITE_ONCE(sk->sk_err, -err);
-
-		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
-		smp_wmb();
-		sk_error_report(sk);
-		break;
-	}
+	/* This barrier is coupled with smp_rmb() in mptcp_poll() */
+	smp_wmb();
+	sk_error_report(sk);
+	return true;
+}
+
+void __mptcp_error_report(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	mptcp_for_each_subflow(msk, subflow)
+		if (__mptcp_subflow_error_report(sk, mptcp_subflow_tcp_sock(subflow)))
+			break;
 }
 
 /* In most cases we will be able to lock the mptcp socket.  If its already
@@ -2446,6 +2450,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	}
 
 out_release:
+	__mptcp_subflow_error_report(sk, ssk);
 	release_sock(ssk);
 
 	sock_put(ssk);
-- 
2.40.1



