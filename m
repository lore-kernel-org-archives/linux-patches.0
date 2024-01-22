Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E91A634F8;
	Tue, 23 Jan 2024 01:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975041; cv=none; b=aFCR5jhBAQ61sJbdzbzrlJWvm3ZBySjmOV5x4W3LChmUbCZX35CFaFaTRgrw+55PAlXnPgECTLSKuxpKaP9+WtOsa6y6ztUeWOdjSia+sH1qXqpGpCdpxLGA3P5erQ4MB/V8MjrUfXJ58hXcpNuQocnHgGzo6Yuq6hjr111wOyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975041; c=relaxed/simple;
	bh=FU6NHire4A+yS/0yNZBhHXgZtXL6ekuYio97YL9LIZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqKNNE0mep7ydvT0qjijZimT+2X8QFvApjVWXa0HIoMl/bJF6xxB5OeCN67wvGcYaM/PKIN8vutp9w2Zy4rHAshvoJMtOTI7gbKLeAxJvDGHqdglNsJr9+PPQZ+j1rOHScWhNP+zsJ36sasrF1wQr65LuT9sMyvF3KHc0MGEWD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KISwYqYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KISwYqYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78FBC433C7;
	Tue, 23 Jan 2024 01:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975040;
	bh=FU6NHire4A+yS/0yNZBhHXgZtXL6ekuYio97YL9LIZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KISwYqYzPdAnSYOVl5n1R2BfbF77PLR+fjLttSO3xq9sN8e8luaEamb+/8Nnsnyxu
	 AVzA4/KBt8rv3/Zf6IXV8mEtkDQUoAl1mQl8GubAFFIvsC3BnBLlpM9cgTo4nP2c23
	 1xkzqY+8OrKEPLFeVTPiqYhDA7AaWbM1J/zHz/Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@suse.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/374] mptcp: drop unused sk in mptcp_get_options
Date: Mon, 22 Jan 2024 15:59:52 -0800
Message-ID: <20240122235756.596413735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit 0799e21b5a76d9f14d8a8f024d0b6b9847ad1a03 ]

The parameter 'sk' became useless since the code using it was dropped
from mptcp_get_options() in the commit 8d548ea1dd15 ("mptcp: do not set
unconditionally csum_reqd on incoming opt"). Let's drop it.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c1665273bdc7 ("mptcp: strict validation before using mp_opt->hmac")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  |  5 ++---
 net/mptcp/protocol.h |  3 +--
 net/mptcp/subflow.c  | 10 +++++-----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index c7d6997b31c8..3b4ce8a06f99 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -354,8 +354,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 	}
 }
 
-void mptcp_get_options(const struct sock *sk,
-		       const struct sk_buff *skb,
+void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
@@ -1091,7 +1090,7 @@ bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 		return true;
 	}
 
-	mptcp_get_options(sk, skb, &mp_opt);
+	mptcp_get_options(skb, &mp_opt);
 
 	/* The subflow can be in close state only if check_fully_established()
 	 * just sent a reset. If so, tell the caller to ignore the current packet.
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e193b710b471..78aa6125eafb 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -636,8 +636,7 @@ int __init mptcp_proto_v6_init(void);
 struct sock *mptcp_sk_clone(const struct sock *sk,
 			    const struct mptcp_options_received *mp_opt,
 			    struct request_sock *req);
-void mptcp_get_options(const struct sock *sk,
-		       const struct sk_buff *skb,
+void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt);
 
 void mptcp_finish_connect(struct sock *sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 666f6720db76..a1349c6eda46 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -152,7 +152,7 @@ static int subflow_check_req(struct request_sock *req,
 		return -EINVAL;
 #endif
 
-	mptcp_get_options(sk_listener, skb, &mp_opt);
+	mptcp_get_options(skb, &mp_opt);
 
 	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
 	opt_mp_join = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ);
@@ -249,7 +249,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	int err;
 
 	subflow_init_req(req, sk_listener);
-	mptcp_get_options(sk_listener, skb, &mp_opt);
+	mptcp_get_options(skb, &mp_opt);
 
 	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
 	opt_mp_join = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ);
@@ -407,7 +407,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
 	pr_debug("subflow=%p synack seq=%x", subflow, subflow->ssn_offset);
 
-	mptcp_get_options(sk, skb, &mp_opt);
+	mptcp_get_options(skb, &mp_opt);
 	if (subflow->request_mptcp) {
 		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC)) {
 			MPTCP_INC_STATS(sock_net(sk),
@@ -687,7 +687,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 * reordered MPC will cause fallback, but we don't have other
 		 * options.
 		 */
-		mptcp_get_options(sk, skb, &mp_opt);
+		mptcp_get_options(skb, &mp_opt);
 		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC)) {
 			fallback = true;
 			goto create_child;
@@ -697,7 +697,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		if (!new_msk)
 			fallback = true;
 	} else if (subflow_req->mp_join) {
-		mptcp_get_options(sk, skb, &mp_opt);
+		mptcp_get_options(skb, &mp_opt);
 		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ) ||
 		    !subflow_hmac_valid(req, &mp_opt) ||
 		    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
-- 
2.43.0



