Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B763B14A9;
	Sat, 17 Oct 2026 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256227; cv=none; b=ELpl1utSthI2+gVH4CLfJZpINBJewFvUOOq4C/agxTsxXnXna1NnowG7RUoIjK46OIKiCdMtt4gW+2HrQHrB2gZjHE4nmbSiKULgjvgE8EB33Xx7GhVKg/aRnwO5j6eMiI9oISvZ5QRMxSi5jPeyfJx6g7O6QgbLjQTe3GckhLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256227; c=relaxed/simple;
	bh=zFqlyNbxnmLwcteaqU3BNNdCTCnr0zjESs00/xWRzg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t20po81GhAZT2ob8mkgFxrOWysmmDZfNGq/hGXW83Z6ZWzjAr+xTlYmq+cJ6OOhXIAr5vkzhfFh4NFzS/sbLv71ZlSculrhCVfkGo9CNQoqnrIUd3DmeZ7R19n372PwOmt3d8ulO1V9igUqXTGncsMO+uO/EUy7oMNZ4Lzlz3aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bmm27FXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bmm27FXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C9E1F000C4;
	Sat, 17 Oct 2026 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256225;
	bh=R2pwFXquamsPr/COBMAFuCWmoNnvsXEB3ZdMnmJjPhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bmm27FXDfvtdTOpXAf85DQn9XIwazq+i/SM5ntmkFr+LmiRQuCGq2YBF+PJfOlVq+
	 FIK9rxMuIwDIx6aQh6PjrvPcqE2OamOp/jjSfuRfRRptnontuB4XmvEdLEZI2tuWtK
	 25Ld6puwJ+k3tyg2027V602oJRU2fWa3uC5uYUmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0114/1674] mptcp: do not reschedule the RTX timer for fallback sockets
Date: Sat, 17 Oct 2026 17:39:46 +0200
Message-ID: <20261017160434.076171401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit e2ab913f68c7d11e2561b8a8ad0b87ffefcad667 ]

On fallback socket the retrans timer is a quite convoluted no-op, but
currently nothing prevents the MPTCP core to keep rescheduling it.

Additionally gate RTX timer reset to the msk not being fallen back to
TCP yet. To avoid adding multiple tests in fast-path, use a new flags
bit for such condition.

The RTX enable bit is clear at close time and set before the msk could
start retransmitting, with a couple of caveats:

- passive sockets inherit the bit from the listener msk; set the bit on
  such socket to avoid flipping it in the fast-path, even if the
  listener will obviously never retransmit.

- while fastopening (MPTFO), mptcp_sendmsg_fastopen still ends-up
  calling mptcp_connect via tcp_sendmsg_fastopen ->
  __inet_stream_connect(ssk->sk_socket), and the first subflow's
  sk_socket points to the msk one.

Fixes: b51f9b80c032 ("mptcp: introduce MPTCP retransmission timer")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-1-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ changed MPTCP_RTX_ENABLED from bit 4 to unused bit 6 to avoid conflicting with MPTCP_FALLBACK_DONE. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 12 +++++++++---
 net/mptcp/protocol.h |  2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 48b6e9ed04ee9..d1c0a529f8ffe 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -977,13 +977,14 @@ static bool mptcp_rtx_timer_pending(struct sock *sk)
 static void mptcp_reset_rtx_timer(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct mptcp_sock *msk = mptcp_sk(sk);
 	unsigned long tout;
 
-	/* prevent rescheduling on close */
-	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
+	/* Prevent rescheduling on close and in case of fallback. */
+	if (!test_bit(MPTCP_RTX_ENABLED, &msk->flags))
 		return;
 
-	tout = mptcp_sk(sk)->timer_ival;
+	tout = msk->timer_ival;
 	sk_reset_timer(sk, &icsk->icsk_retransmit_timer, jiffies + tout);
 }
 
@@ -3067,6 +3068,9 @@ void mptcp_set_state(struct sock *sk, int state)
 		 * transition from TCP_SYN_RECV to TCP_CLOSE_WAIT.
 		 */
 		break;
+	case TCP_CLOSE:
+		clear_bit(MPTCP_RTX_ENABLED, &mptcp_sk(sk)->flags);
+		fallthrough;
 	default:
 		if (oldstate == TCP_ESTABLISHED || oldstate == TCP_CLOSE_WAIT)
 			MPTCP_DEC_STATS(sock_net(sk), MPTCP_MIB_CURRESTAB);
@@ -3900,6 +3904,7 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(ssk))
 		return PTR_ERR(ssk);
 
+	set_bit(MPTCP_RTX_ENABLED, &msk->flags);
 	mptcp_set_state(sk, TCP_SYN_SENT);
 	subflow = mptcp_subflow_ctx(ssk);
 #ifdef CONFIG_TCP_MD5SIG
@@ -4043,6 +4048,7 @@ static int mptcp_listen(struct socket *sock, int backlog)
 		goto unlock;
 	}
 
+	set_bit(MPTCP_RTX_ENABLED, &msk->flags);
 	mptcp_set_state(sk, TCP_LISTEN);
 	sock_set_flag(sk, SOCK_RCU_FREE);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 825f770190929..f1cc099f476e4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -116,6 +116,7 @@
 #define MPTCP_WORK_RTX		2
 #define MPTCP_FALLBACK_DONE	4
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
+#define MPTCP_RTX_ENABLED	6
 
 /* MPTCP socket release cb flags */
 #define MPTCP_PUSH_PENDING	1
@@ -1134,6 +1135,7 @@ static inline bool __mptcp_try_fallback(struct mptcp_sock *msk)
 
 	msk->allow_subflows = false;
 	set_bit(MPTCP_FALLBACK_DONE, &msk->flags);
+	clear_bit(MPTCP_RTX_ENABLED, &msk->flags);
 	spin_unlock_bh(&msk->fallback_lock);
 	return true;
 }
-- 
2.53.0



