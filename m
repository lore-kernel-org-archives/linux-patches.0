Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3F01C6AB;
	Mon,  4 Mar 2024 21:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589311; cv=none; b=DecKV8luEVNTtK8BgDyWyL/IO5pez0/6/3amIx2RgwyQiizSiU4HH3Odxa/EBPWBNwwD77uca1Cpfa5FKA2VOoUkXcO/aU5rDKi9Ucqtu9qmwOp0Q23ypGxrnVXJCqSI01WXVNhmiWpfMDEsw5afKCRyOz0idoFs10XLbtLObO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589311; c=relaxed/simple;
	bh=YbkC/R/S200rTxdLi8Sn3KUb3pTkPwkqMvMemGqTmkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOtOYmnMBSk0WMH2+yNQeV9sZhGU4uFS+0qpU2rz+nmOlCkvMVTYipLdBFuHm/mgRJUNSk18JumIToBDh3y1aDRiimetL0eZxuOGV4CxxvzSN2KI3QOXzyx5HKMxSSRa/P6sVH7ivR1lwS/86+5G/u4Mr9x46OvaCJuhuIR7gm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRma801x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRma801x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE59C433F1;
	Mon,  4 Mar 2024 21:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589311;
	bh=YbkC/R/S200rTxdLi8Sn3KUb3pTkPwkqMvMemGqTmkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRma801xPH5qiSksTIyn5AqtjcMSZ8AOBAESabVP27I1Lelgw4Gek4/4tPxFPdBng
	 IkjnliK4nuM1ByU9eCzBqRHAUk52OR4NwiSYLahM4b/x/dutx8zc29T4upbOAfrLLL
	 ZCSc5igO43UNUO+rJeppZyzbm8KmuQDyfCLITG/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 61/84] mptcp: move __mptcp_error_report in protocol.c
Date: Mon,  4 Mar 2024 21:24:34 +0000
Message-ID: <20240304211544.421455305@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit d5fbeff1ab812b6c473b6924bee8748469462e2c upstream.

This will simplify the next patch ("mptcp: process pending subflow error
on close").

No functional change intended.

Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   36 ++++++++++++++++++++++++++++++++++++
 net/mptcp/subflow.c  |   36 ------------------------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -688,6 +688,42 @@ static bool __mptcp_ofo_queue(struct mpt
 	return moved;
 }
 
+void __mptcp_error_report(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int err = sock_error(ssk);
+		int ssk_state;
+
+		if (!err)
+			continue;
+
+		/* only propagate errors on fallen-back sockets or
+		 * on MPC connect
+		 */
+		if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(msk))
+			continue;
+
+		/* We need to propagate only transition to CLOSE state.
+		 * Orphaned socket will see such state change via
+		 * subflow_sched_work_if_closed() and that path will properly
+		 * destroy the msk as needed.
+		 */
+		ssk_state = inet_sk_state_load(ssk);
+		if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
+			inet_sk_state_store(sk, ssk_state);
+		WRITE_ONCE(sk->sk_err, -err);
+
+		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
+		smp_wmb();
+		sk_error_report(sk);
+		break;
+	}
+}
+
 /* In most cases we will be able to lock the mptcp socket.  If its already
  * owned, we need to defer to the work queue to avoid ABBA deadlock.
  */
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1269,42 +1269,6 @@ void mptcp_space(const struct sock *ssk,
 	*full_space = tcp_full_space(sk);
 }
 
-void __mptcp_error_report(struct sock *sk)
-{
-	struct mptcp_subflow_context *subflow;
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		int err = sock_error(ssk);
-		int ssk_state;
-
-		if (!err)
-			continue;
-
-		/* only propagate errors on fallen-back sockets or
-		 * on MPC connect
-		 */
-		if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(msk))
-			continue;
-
-		/* We need to propagate only transition to CLOSE state.
-		 * Orphaned socket will see such state change via
-		 * subflow_sched_work_if_closed() and that path will properly
-		 * destroy the msk as needed.
-		 */
-		ssk_state = inet_sk_state_load(ssk);
-		if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
-			inet_sk_state_store(sk, ssk_state);
-		sk->sk_err = -err;
-
-		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
-		smp_wmb();
-		sk_error_report(sk);
-		break;
-	}
-}
-
 static void subflow_error_report(struct sock *ssk)
 {
 	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;


