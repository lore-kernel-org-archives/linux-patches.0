Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E932517A6;
	Tue, 29 Apr 2025 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949221; cv=none; b=DsVFNYq4rtAz76uvLP/7nyam96p3BkQ2EhEA+qahIc4JOyiukaKJ7TjvhP2nnH0klyygTjmq4FLvnUuB/FE38cp/FxUDP6OZ9EgKyYMNjJReVkSSKut7Ds5Nk9MnW4udl+r/5B0s4+JaCUbGHfedz+c+pnc27z2Cyd+ZvcPUoJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949221; c=relaxed/simple;
	bh=0Andh60W6pCeJAR/nQoTcLY7+YBIG0kAw6Vf4aKc+bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0aUmWN5UCo0BkUKzt+QtgSxseYDNoIIZ9IrH7Ffg8NV98kpJUPL9j1viuQeSaiZs/nRcY8X5151E1GWFXY1pehtJWywewKS2jRQOv5HwFz8reuNhP7wuWKWsl2iA4bjEQFGvtuU5uAF4K3n61fo0BajgdDEVvZSU+YRrvT7lAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/pFT5Xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/pFT5Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCD9C4CEE9;
	Tue, 29 Apr 2025 17:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949220;
	bh=0Andh60W6pCeJAR/nQoTcLY7+YBIG0kAw6Vf4aKc+bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/pFT5Xmtwi0hF8IM4TEHIC1+/N1VEdlJH1N+4Esr4HLTwvnWYB5Vqsh0rgsDLb4W
	 aUtkDkckcXC1xdul9mvRRrYHRoBQ9hsvadsJ2xdo5nRcdZUihF7jjd6iIvo4d9Qccm
	 H9lVg15it4DrwPMF4a+Q/SxLTwhSvorjxO1G68jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 221/373] net: make sock_inuse_add() available
Date: Tue, 29 Apr 2025 18:41:38 +0200
Message-ID: <20250429161132.244442340@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

commit d477eb9004845cb2dc92ad5eed79a437738a868a upstream.

MPTCP hard codes it, let us instead provide this helper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
[ cherry-pick from amazon-linux amazon-5.15.y/mainline ]
Link: https://github.com/amazonlinux/linux/commit/7154d8eaac16
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h  |   10 ++++++++++
 net/core/sock.c     |   10 ----------
 net/mptcp/subflow.c |    4 +---
 3 files changed, 11 insertions(+), 13 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1472,6 +1472,12 @@ static inline void sock_prot_inuse_add(c
 {
 	this_cpu_add(net->core.prot_inuse->val[prot->inuse_idx], val);
 }
+
+static inline void sock_inuse_add(const struct net *net, int val)
+{
+	this_cpu_add(*net->core.sock_inuse, val);
+}
+
 int sock_prot_inuse_get(struct net *net, struct proto *proto);
 int sock_inuse_get(struct net *net);
 #else
@@ -1479,6 +1485,10 @@ static inline void sock_prot_inuse_add(c
 				       const struct proto *prot, int val)
 {
 }
+
+static inline void sock_inuse_add(const struct net *net, int val)
+{
+}
 #endif
 
 
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -144,8 +144,6 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
-static void sock_inuse_add(struct net *net, int val);
-
 /**
  * sk_ns_capable - General socket capability test
  * @sk: Socket to use a capability on or through
@@ -3519,11 +3517,6 @@ int sock_prot_inuse_get(struct net *net,
 }
 EXPORT_SYMBOL_GPL(sock_prot_inuse_get);
 
-static void sock_inuse_add(struct net *net, int val)
-{
-	this_cpu_add(*net->core.sock_inuse, val);
-}
-
 int sock_inuse_get(struct net *net)
 {
 	int cpu, res = 0;
@@ -3602,9 +3595,6 @@ static inline void release_proto_idx(str
 {
 }
 
-static void sock_inuse_add(struct net *net, int val)
-{
-}
 #endif
 
 static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot)
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1584,9 +1584,7 @@ int mptcp_subflow_create_socket(struct s
 	 */
 	sf->sk->sk_net_refcnt = 1;
 	get_net(net);
-#ifdef CONFIG_PROC_FS
-	this_cpu_add(*net->core.sock_inuse, 1);
-#endif
+	sock_inuse_add(net, 1);
 	err = tcp_set_ulp(sf->sk, "mptcp");
 	release_sock(sf->sk);
 


