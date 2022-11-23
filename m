Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6B41C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46C0C433D6;
	Wed, 23 Nov 2022 09:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195673;
	bh=Ab77b9FjehVwf5YrFmBjpiat2r2j4JIN69PGTQLGXTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTio3unH0tYBYAYGqV+BH6SEGn1+NRS9gflw+cHUAr2iBl6qOYUNtsmtD6ItBs/Ej
	 FuszVEHg6aCEKP5zPtU5Yw8WbbcGHG7UjBYfGp/MmjSRo/hwP6Wp5lbDEzQfrUWm1R
	 NsSFTwa36rCcmbgAX5dJluANxJINjTkHiNn9HTSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Sishuai Gong <sishuai@purdue.edu>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/149] net: fix a concurrency bug in l2tp_tunnel_register()
Date: Wed, 23 Nov 2022 09:51:51 +0100
Message-Id: <20221123084602.525019846@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gong, Sishuai <sishuai@purdue.edu>

[ Upstream commit 69e16d01d1de4f1249869de342915f608feb55d5 ]

l2tp_tunnel_register() registers a tunnel without fully
initializing its attribute. This can allow another kernel thread
running l2tp_xmit_core() to access the uninitialized data and
then cause a kernel NULL pointer dereference error, as shown below.

Thread 1    Thread 2
//l2tp_tunnel_register()
list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
           //pppol2tp_connect()
           tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
           // Fetch the new tunnel
           ...
           //l2tp_xmit_core()
           struct sock *sk = tunnel->sock;
           ...
           bh_lock_sock(sk);
           //Null pointer error happens
tunnel->sock = sk;

Fix this bug by initializing tunnel->sock before adding the
tunnel into l2tp_tunnel_list.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Sishuai Gong <sishuai@purdue.edu>
Reported-by: Sishuai Gong <sishuai@purdue.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b68777d54fac ("l2tp: Serialize access to sk_user_data with sk_callback_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 561b6d67ab8b..dc8987ed08ad 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1480,11 +1480,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
 
+	sk = sock->sk;
+	sock_hold(sk);
+	tunnel->sock = sk;
+
 	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
 	list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
 		if (tunnel_walk->tunnel_id == tunnel->tunnel_id) {
 			spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-
+			sock_put(sk);
 			ret = -EEXIST;
 			goto err_sock;
 		}
@@ -1492,10 +1496,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
 	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
 
-	sk = sock->sk;
-	sock_hold(sk);
-	tunnel->sock = sk;
-
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
 			.sk_user_data = tunnel,
-- 
2.35.1



