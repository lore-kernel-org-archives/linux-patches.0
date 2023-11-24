Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272F137170;
	Fri, 24 Nov 2023 19:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEYDAnAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD68C433C7;
	Fri, 24 Nov 2023 19:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853206;
	bh=d/xek6XSGtkmWZB/TBm76u+gEVqDsCdaaKItI7vcRME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEYDAnACA/VfdzA3nsn+uFz8cy6M+T/wQ3jfSU1Bnmu2U1AeqAPe+gFhzn5ojtd08
	 5KQw2kGAAb+3LydJ8ss62aDgMDFron8Fy8tgs/N35GGUM5jXfQnpYbRKe6A+oXjqaG
	 tC6bKEBx+39y94gijvtd3Rq8wV6v5ws5LEQkMQtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/297] mptcp: diag: switch to context structure
Date: Fri, 24 Nov 2023 17:52:18 +0000
Message-ID: <20231124172003.615540987@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6b9ea5c81ea2bed80dc98a38d475124a87e7ab5d ]

Raw access to cb->arg[] is deprecated, use a context structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 871019b22d1b ("net: set SOCK_RCU_FREE before inserting socket into hashtable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/mptcp_diag.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index 292374fb07792..fb98b438b2c90 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -66,20 +66,28 @@ static int mptcp_diag_dump_one(struct netlink_callback *cb,
 	return err;
 }
 
+struct mptcp_diag_ctx {
+	long s_slot;
+	long s_num;
+};
+
 static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *r)
 {
 	bool net_admin = netlink_net_capable(cb->skb, CAP_NET_ADMIN);
+	struct mptcp_diag_ctx *diag_ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	struct inet_diag_dump_data *cb_data;
 	struct mptcp_sock *msk;
 	struct nlattr *bc;
 
+	BUILD_BUG_ON(sizeof(cb->ctx) < sizeof(*diag_ctx));
+
 	cb_data = cb->data;
 	bc = cb_data->inet_diag_nla_bc;
 
-	while ((msk = mptcp_token_iter_next(net, &cb->args[0], &cb->args[1])) !=
-	       NULL) {
+	while ((msk = mptcp_token_iter_next(net, &diag_ctx->s_slot,
+					    &diag_ctx->s_num)) != NULL) {
 		struct inet_sock *inet = (struct inet_sock *)msk;
 		struct sock *sk = (struct sock *)msk;
 		int ret = 0;
@@ -101,7 +109,7 @@ static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		sock_put(sk);
 		if (ret < 0) {
 			/* will retry on the same position */
-			cb->args[1]--;
+			diag_ctx->s_num--;
 			break;
 		}
 		cond_resched();
-- 
2.42.0



