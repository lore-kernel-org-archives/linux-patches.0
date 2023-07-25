Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CEF1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6C1C433C8;
	Tue, 25 Jul 2023 11:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284205;
	bh=neXo0v0cGxR63c/qsEXbe2WxdyEwBcl+iSv9aHsv4vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8m4XeZBvAwKVPmJSqWVA4nH5ZMvt/w6CArXIERHay5KoWuQwXb77kXO/QEZCCT+r
	 Gpd4d5CUEwML1Q5s3euj9rBDpNqod4CueQzzSYthKO9XUQ8l5ZDBos3R7ZruWn7vMC
	 ZtnUx+xHVEF2qy48i8vvQOOeKw/qyS+g6pRWjiVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/509] pptp: Fix fib lookup calls.
Date: Tue, 25 Jul 2023 12:43:31 +0200
Message-ID: <20230725104606.208990723@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 84bef5b6037c15180ef88ac4216dc621d16df1a6 ]

PPTP uses pppox sockets (struct pppox_sock). These sockets don't embed
an inet_sock structure, so it's invalid to call inet_sk() on them.

Therefore, the ip_route_output_ports() call in pptp_connect() has two
problems:

  * The tos variable is set with RT_CONN_FLAGS(sk), which calls
    inet_sk() on the pppox socket.

  * ip_route_output_ports() tries to retrieve routing flags using
    inet_sk_flowi_flags(), which is also going to call inet_sk() on the
    pppox socket.

While PPTP doesn't use inet sockets, it's actually really layered on
top of IP and therefore needs a proper way to do fib lookups. So let's
define pptp_route_output() to get a struct rtable from a pptp socket.
Let's also replace the ip_route_output_ports() call of pptp_xmit() for
consistency.

In practice, this means that:

  * pptp_connect() sets ->flowi4_tos and ->flowi4_flags to zero instead
    of using bits of unrelated struct pppox_sock fields.

  * pptp_xmit() now respects ->sk_mark and ->sk_uid.

  * pptp_xmit() now calls the security_sk_classify_flow() security
    hook, thus allowing to set ->flowic_secid.

  * pptp_xmit() now passes the pppox socket to xfrm_lookup_route().

Found by code inspection.

Fixes: 00959ade36ac ("PPTP: PPP over IPv4 (Point-to-Point Tunneling Protocol)")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pptp.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index ee5058445d06e..05a75b5a8b680 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -24,6 +24,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/rcupdate.h>
+#include <linux/security.h>
 #include <linux/spinlock.h>
 
 #include <net/sock.h>
@@ -128,6 +129,23 @@ static void del_chan(struct pppox_sock *sock)
 	spin_unlock(&chan_lock);
 }
 
+static struct rtable *pptp_route_output(struct pppox_sock *po,
+					struct flowi4 *fl4)
+{
+	struct sock *sk = &po->sk;
+	struct net *net;
+
+	net = sock_net(sk);
+	flowi4_init_output(fl4, sk->sk_bound_dev_if, sk->sk_mark, 0,
+			   RT_SCOPE_UNIVERSE, IPPROTO_GRE, 0,
+			   po->proto.pptp.dst_addr.sin_addr.s_addr,
+			   po->proto.pptp.src_addr.sin_addr.s_addr,
+			   0, 0, sock_net_uid(net, sk));
+	security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
+
+	return ip_route_output_flow(net, fl4, sk);
+}
+
 static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 {
 	struct sock *sk = (struct sock *) chan->private;
@@ -151,11 +169,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	if (sk_pppox(po)->sk_state & PPPOX_DEAD)
 		goto tx_error;
 
-	rt = ip_route_output_ports(net, &fl4, NULL,
-				   opt->dst_addr.sin_addr.s_addr,
-				   opt->src_addr.sin_addr.s_addr,
-				   0, 0, IPPROTO_GRE,
-				   RT_TOS(0), sk->sk_bound_dev_if);
+	rt = pptp_route_output(po, &fl4);
 	if (IS_ERR(rt))
 		goto tx_error;
 
@@ -440,12 +454,7 @@ static int pptp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	po->chan.private = sk;
 	po->chan.ops = &pptp_chan_ops;
 
-	rt = ip_route_output_ports(sock_net(sk), &fl4, sk,
-				   opt->dst_addr.sin_addr.s_addr,
-				   opt->src_addr.sin_addr.s_addr,
-				   0, 0,
-				   IPPROTO_GRE, RT_CONN_FLAGS(sk),
-				   sk->sk_bound_dev_if);
+	rt = pptp_route_output(po, &fl4);
 	if (IS_ERR(rt)) {
 		error = -EHOSTUNREACH;
 		goto end;
-- 
2.39.2



