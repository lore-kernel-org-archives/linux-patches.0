Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C2D7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF99C433C1;
	Wed,  2 Nov 2022 02:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357566;
	bh=IB9nHlp5NaBUpWijDnIvj8ocAokvB56HHPDdRFAu7VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOJwO5WnAR3UoniiCYxo12Uxmtw1tXXIoxIcObPwU1VByme4cbvch6PzF+fjeO0c9
	 sTpo7E95J2s8QH05BmrZDqSUMpN2LDFSGeSdLooYMApdmjgoGLO8D8uvyQVYgyTioF
	 3x8gE4LtU+UvkUxlTuaKqXaAnYDXQilQCmAf3pI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 192/240] mptcp: set msk local address earlier
Date: Wed,  2 Nov 2022 03:32:47 +0100
Message-Id: <20221102022115.736219594@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

[ Upstream commit e72e4032637f4646554794ac28a3abecc6c2416d ]

The mptcp_pm_nl_get_local_id() code assumes that the msk local address
is available at that point. For passive sockets, we initialize such
address at accept() time.

Depending on the running configuration and the user-space timing, a
passive MPJ subflow can join the msk socket before accept() completes.

In such case, the PM assigns a wrong local id to the MPJ subflow
and later PM netlink operations will end-up touching the wrong/unexpected
subflow.

All the above causes sporadic self-tests failures, especially when
the host is heavy loaded.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/308
Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Fixes: d045b9eb95a9 ("mptcp: introduce implicit endpoints")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 3 +--
 net/mptcp/protocol.h | 1 +
 net/mptcp/subflow.c  | 7 +++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f8897a70c11d..b568f55998f3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2867,7 +2867,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sock_put(sk);
 }
 
-static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
+void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	const struct ipv6_pinfo *ssk6 = inet6_sk(ssk);
@@ -3613,7 +3613,6 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		if (mptcp_is_fully_established(newsk))
 			mptcp_pm_fully_established(msk, msk->first, GFP_KERNEL);
 
-		mptcp_copy_inaddrs(newsk, msk->first);
 		mptcp_rcv_space_init(msk, msk->first);
 		mptcp_propagate_sndbuf(newsk, msk->first);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8f372b8f059c..c1eaa1685592 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -597,6 +597,7 @@ int mptcp_is_checksum_enabled(const struct net *net);
 int mptcp_allow_join_id0(const struct net *net);
 unsigned int mptcp_stale_loss_cnt(const struct net *net);
 int mptcp_get_pm_type(const struct net *net);
+void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool __mptcp_retransmit_pending_data(struct sock *sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 07dd23d0fe04..02a54d59697b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -723,6 +723,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				goto dispose_child;
 			}
 
+			if (new_msk)
+				mptcp_copy_inaddrs(new_msk, child);
 			subflow_drop_ctx(child);
 			goto out;
 		}
@@ -750,6 +752,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			ctx->conn = new_msk;
 			new_msk = NULL;
 
+			/* set msk addresses early to ensure mptcp_pm_get_local_id()
+			 * uses the correct data
+			 */
+			mptcp_copy_inaddrs(ctx->conn, child);
+
 			/* with OoO packets we can reach here without ingress
 			 * mpc option
 			 */
-- 
2.35.1



