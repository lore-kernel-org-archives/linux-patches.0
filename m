Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CE31C6AB;
	Mon,  4 Mar 2024 21:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589314; cv=none; b=aaAYhA3ssufsDH+id1icCJQxckrWoR345H+EEr8Ox8iMPii7vRAo698vrpvdToHk9zxEbv+6cRU4Fr2cyHYoJCsWye7fHOkgmPVt0Yv2mJWDVSoX1MvJZJ0ACeYvCikZZWHtyh8yICDkpVKHftfJkhQf8gVwVaYovfZVFMFGUDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589314; c=relaxed/simple;
	bh=T7gaADTT4eo2O41DLS+pOJk22Iz01nFDGH/itpPyJcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJCaGMjHYhxZAyuCiJR3gp2BnGnlujBYXlsaSjYsWNILo581YJ/RWMmGNJMX35yvovwuYSYUHIJFfNfaFVJtRFryZSDcuVR77ZcJBZU9uQ0PN6xoiRzkvarqMumMV68Fdnn7a4fKRT31Kx8zBv6Ko0dTIFEt3HZZhmTxzDfGgIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l87swLaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l87swLaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3DFC433F1;
	Mon,  4 Mar 2024 21:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589314;
	bh=T7gaADTT4eo2O41DLS+pOJk22Iz01nFDGH/itpPyJcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l87swLafH7U5k+Mt/YQzqLORli7u6e3Y833Sbd4tFgdVEn714pBOcyc8t2oDflfX+
	 iz+XRoHVQ22smph1u4qQUaPUOmFnJd/ZUmCOnnAAsdKCBbQUG4Vta0R0IJFiXZLfTn
	 gSi6snFaWCkTHHyDfZ0liR9zSxwf0UbA7DBe/15g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 62/84] mptcp: process pending subflow error on close
Date: Mon,  4 Mar 2024 21:24:35 +0000
Message-ID: <20240304211544.457489273@linuxfoundation.org>
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

commit 9f1a98813b4b686482e5ef3c9d998581cace0ba6 upstream.

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
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   63 +++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -688,40 +688,44 @@ static bool __mptcp_ofo_queue(struct mpt
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
+
+	/* This barrier is coupled with smp_rmb() in mptcp_poll() */
+	smp_wmb();
+	sk_error_report(sk);
+	return true;
+}
 
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
@@ -2309,6 +2313,7 @@ static void __mptcp_close_ssk(struct soc
 		/* close acquired an extra ref */
 		__sock_put(ssk);
 	}
+	__mptcp_subflow_error_report(sk, ssk);
 	release_sock(ssk);
 
 	sock_put(ssk);


