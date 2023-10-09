Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE634199CC
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rR1eSPiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2970AC433C7;
	Mon,  9 Oct 2023 13:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857334;
	bh=jBxDDrlaBkf3CcDTJupWd28Qrm7SgIOyNj1RZqkKkgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rR1eSPiDscR3WtrVjc7dWkzr7PTFZpVKyqIOAAHdMyayyUWReBDB4RFd/gnlt+8xH
	 8gagUSv6SULv5YRzOT7CM5sMTK0cTsgs2i49slrrGpsLy66vOiD87aW9t17In5SJ27
	 +vOMRkKeBXWgbFbbPsDws8H7Nh5aCPqRRIWKhwzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/162] mptcp: annotate lockless accesses to sk->sk_err
Date: Mon,  9 Oct 2023 14:59:53 +0200
Message-ID: <20231009130123.289550362@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9ae8e5ad99b8ebcd3d3dd46075f3825e6f08f063 ]

mptcp_poll() reads sk->sk_err without socket lock held/owned.

Add READ_ONCE() and WRITE_ONCE() to avoid load/store tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d5fbeff1ab81 ("mptcp: move __mptcp_error_report in protocol.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 2 +-
 net/mptcp/protocol.c   | 8 ++++----
 net/mptcp/subflow.c    | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9127a7fd5269c..5d845fcf3d09e 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2047,7 +2047,7 @@ static int mptcp_event_put_token_and_ssk(struct sk_buff *skb,
 	    nla_put_s32(skb, MPTCP_ATTR_IF_IDX, ssk->sk_bound_dev_if))
 		return -EMSGSIZE;
 
-	sk_err = ssk->sk_err;
+	sk_err = READ_ONCE(ssk->sk_err);
 	if (sk_err && sk->sk_state == TCP_ESTABLISHED &&
 	    nla_put_u8(skb, MPTCP_ATTR_ERROR, sk_err))
 		return -EMSGSIZE;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 60e65f6325c3c..84f107854eac9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2517,15 +2517,15 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 	/* Mirror the tcp_reset() error propagation */
 	switch (sk->sk_state) {
 	case TCP_SYN_SENT:
-		sk->sk_err = ECONNREFUSED;
+		WRITE_ONCE(sk->sk_err, ECONNREFUSED);
 		break;
 	case TCP_CLOSE_WAIT:
-		sk->sk_err = EPIPE;
+		WRITE_ONCE(sk->sk_err, EPIPE);
 		break;
 	case TCP_CLOSE:
 		return;
 	default:
-		sk->sk_err = ECONNRESET;
+		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	}
 
 	inet_sk_state_store(sk, TCP_CLOSE);
@@ -3893,7 +3893,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 
 	/* This barrier is coupled with smp_wmb() in __mptcp_error_report() */
 	smp_rmb();
-	if (sk->sk_err)
+	if (READ_ONCE(sk->sk_err))
 		mask |= EPOLLERR;
 
 	return mask;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 168dced2434b3..032661c8273f2 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1248,7 +1248,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 			subflow->reset_reason = MPTCP_RST_EMPTCP;
 
 reset:
-			ssk->sk_err = EBADMSG;
+			WRITE_ONCE(ssk->sk_err, EBADMSG);
 			tcp_set_state(ssk, TCP_CLOSE);
 			while ((skb = skb_peek(&ssk->sk_receive_queue)))
 				sk_eat_skb(ssk, skb);
@@ -1332,7 +1332,7 @@ void __mptcp_error_report(struct sock *sk)
 		ssk_state = inet_sk_state_load(ssk);
 		if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
 			inet_sk_state_store(sk, ssk_state);
-		sk->sk_err = -err;
+		WRITE_ONCE(sk->sk_err, -err);
 
 		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
 		smp_wmb();
-- 
2.40.1



