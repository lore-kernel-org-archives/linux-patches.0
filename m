Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8526937170;
	Fri, 24 Nov 2023 19:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/Z+tzfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1048BC433C7;
	Fri, 24 Nov 2023 19:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853209;
	bh=GfAMth16Z9BnZS7IpwD3DsvxXgJXA05BO2i2ysCw63M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/Z+tzfVLMMUp4dLsoWv1DiNDTUkwGilJxwXd1vP8HsQW/aV7GZom347naYTFdBbw
	 bL+Ktmi2K8OI1IR7wLy+RQxn87il9eVRH9hcpxfEe6tG5EpPQkJ2UL/mrymjT4IPDZ
	 iwpwuqEbJ6q+5Dt1BQ0xeNjX7XzIww5wEODFWWvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/297] mptcp: listen diag dump support
Date: Fri, 24 Nov 2023 17:52:19 +0000
Message-ID: <20231124172003.653478552@linuxfoundation.org>
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

[ Upstream commit 4fa39b701ce9be7ec2169f7fba4f8dc1a3b92aac ]

makes 'ss -Ml' show mptcp listen sockets.

Iterate over the tcp listen sockets and pick those that have mptcp ulp
info attached.

mptcp_diag_get_info() is modified to prefer msk->first for mptcp sockets
in listen state.  This reports accurate number for recv and send queue
(pending / max connection backlog counters).

Sample output:
ss -Mil
State        Recv-Q Send-Q Local Address:Port  Peer Address:Port
LISTEN       0      20     127.0.0.1:12000     0.0.0.0:*
         subflows_max:2

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 871019b22d1b ("net: set SOCK_RCU_FREE before inserting socket into hashtable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/mptcp_diag.c | 91 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index fb98b438b2c90..4d8625d0b179a 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -69,8 +69,83 @@ static int mptcp_diag_dump_one(struct netlink_callback *cb,
 struct mptcp_diag_ctx {
 	long s_slot;
 	long s_num;
+	unsigned int l_slot;
+	unsigned int l_num;
 };
 
+static void mptcp_diag_dump_listeners(struct sk_buff *skb, struct netlink_callback *cb,
+				      const struct inet_diag_req_v2 *r,
+				      bool net_admin)
+{
+	struct inet_diag_dump_data *cb_data = cb->data;
+	struct mptcp_diag_ctx *diag_ctx = (void *)cb->ctx;
+	struct nlattr *bc = cb_data->inet_diag_nla_bc;
+	struct net *net = sock_net(skb->sk);
+	int i;
+
+	for (i = diag_ctx->l_slot; i < INET_LHTABLE_SIZE; i++) {
+		struct inet_listen_hashbucket *ilb;
+		struct hlist_nulls_node *node;
+		struct sock *sk;
+		int num = 0;
+
+		ilb = &tcp_hashinfo.listening_hash[i];
+
+		rcu_read_lock();
+		spin_lock(&ilb->lock);
+		sk_nulls_for_each(sk, node, &ilb->nulls_head) {
+			const struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(sk);
+			struct inet_sock *inet = inet_sk(sk);
+			int ret;
+
+			if (num < diag_ctx->l_num)
+				goto next_listen;
+
+			if (!ctx || strcmp(inet_csk(sk)->icsk_ulp_ops->name, "mptcp"))
+				goto next_listen;
+
+			sk = ctx->conn;
+			if (!sk || !net_eq(sock_net(sk), net))
+				goto next_listen;
+
+			if (r->sdiag_family != AF_UNSPEC &&
+			    sk->sk_family != r->sdiag_family)
+				goto next_listen;
+
+			if (r->id.idiag_sport != inet->inet_sport &&
+			    r->id.idiag_sport)
+				goto next_listen;
+
+			if (!refcount_inc_not_zero(&sk->sk_refcnt))
+				goto next_listen;
+
+			ret = sk_diag_dump(sk, skb, cb, r, bc, net_admin);
+
+			sock_put(sk);
+
+			if (ret < 0) {
+				spin_unlock(&ilb->lock);
+				rcu_read_unlock();
+				diag_ctx->l_slot = i;
+				diag_ctx->l_num = num;
+				return;
+			}
+			diag_ctx->l_num = num + 1;
+			num = 0;
+next_listen:
+			++num;
+		}
+		spin_unlock(&ilb->lock);
+		rcu_read_unlock();
+
+		cond_resched();
+		diag_ctx->l_num = 0;
+	}
+
+	diag_ctx->l_num = 0;
+	diag_ctx->l_slot = i;
+}
+
 static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *r)
 {
@@ -114,6 +189,9 @@ static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		}
 		cond_resched();
 	}
+
+	if ((r->idiag_states & TCPF_LISTEN) && r->id.idiag_dport == 0)
+		mptcp_diag_dump_listeners(skb, cb, r, net_admin);
 }
 
 static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
@@ -127,6 +205,19 @@ static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 
 	r->idiag_rqueue = sk_rmem_alloc_get(sk);
 	r->idiag_wqueue = sk_wmem_alloc_get(sk);
+
+	if (inet_sk_state_load(sk) == TCP_LISTEN) {
+		struct sock *lsk = READ_ONCE(msk->first);
+
+		if (lsk) {
+			/* override with settings from tcp listener,
+			 * so Send-Q will show accept queue.
+			 */
+			r->idiag_rqueue = READ_ONCE(lsk->sk_ack_backlog);
+			r->idiag_wqueue = READ_ONCE(lsk->sk_max_ack_backlog);
+		}
+	}
+
 	if (!info)
 		return;
 
-- 
2.42.0



