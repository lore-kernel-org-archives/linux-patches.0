Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7C339EF01;
	Sat, 17 Oct 2026 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257790; cv=none; b=sQk/9wG4JO/lqNq6kouks9keCxrnPA9KV+rbd0ZEPpRRjyzb8SngasLpvbede9b0YCPxpqyHwEoh0M/JR4z05agTU0tisl/hUmt3nTLemnnENlRvJJCPO9AMGYMlWMiGfog9srj63Rou9J3OrdLX9WiRli/UNOG3SmclT2Mdugs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257790; c=relaxed/simple;
	bh=plECTbmYOkj9gKYeaOkvkCC3rQIYMoC1qFA6UDLSEec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJROcDz6czc0gECRqGYc4AmYgzVuLY3vzNtQj8s57TB8dIjVTi7kRm6mxbRJHVUpVczMJGL6ZRBK1enKE6IUpl/SJvnhSy120Yx7oeWhJRVcuP/P/dfQnwgkOotp7xPYcQryFcy8tzPNEIMiU2FUeZocjhaKpQHfJJyydi4QpSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3Rgi5Yk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3Rgi5Yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9424F1F000C5;
	Sat, 17 Oct 2026 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257789;
	bh=bX+4vz4aNwnxMVPhpYRii45ErXg0Y6cgH3gk+BV6cuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3Rgi5YkClZ9gMqwkCCytyRzTZ5wyt6vZqnd4GCxvWjNVdiFg3ztPj+q4M3L7knXm
	 Nf3zyNGd+EGKZMpCVfc+4pbH7V+jx1RB3kTJncjeWLf+3Nn/AXQ+2vAQxBeZ8HULrO
	 +fzKK899dAztZqTazZ3ui+nZbptdVM+J7oHOQ0VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0672/1674] rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using current->nsproxy
Date: Sat, 17 Oct 2026 17:49:04 +0200
Message-ID: <20261017160448.357265155@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 7f5611cbc4871c7fb1ad36c2e5a9edad63dca95c ]

As mentioned in a previous commit of this series, using the 'net'
structure via 'current' is not recommended for different reasons:

- Inconsistency: getting info from the reader's/writer's netns vs only
  from the opener's netns.

- current->nsproxy can be NULL in some cases, resulting in an 'Oops'
  (null-ptr-deref), e.g. when the current task is exiting, as spotted by
  syzbot [1] using acct(2).

The per-netns structure can be obtained from the table->data using
container_of(), then the 'net' one can be retrieved from the listen
socket (if available).

Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on rds-tcp socket")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-9-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 245c4c48c56d7..69ebc4334cc2b 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -53,8 +53,10 @@ static atomic_t rds_tcp_unloading = ATOMIC_INIT(0);
 
 static struct kmem_cache *rds_tcp_conn_slab;
 
-static int rds_tcp_skbuf_handler(struct ctl_table *ctl, int write,
-				 void *buffer, size_t *lenp, loff_t *fpos);
+static int rds_tcp_sndbuf_handler(struct ctl_table *ctl, int write,
+				  void *buffer, size_t *lenp, loff_t *fpos);
+static int rds_tcp_rcvbuf_handler(struct ctl_table *ctl, int write,
+				  void *buffer, size_t *lenp, loff_t *fpos);
 
 static int rds_tcp_min_sndbuf = SOCK_MIN_SNDBUF;
 static int rds_tcp_min_rcvbuf = SOCK_MIN_RCVBUF;
@@ -66,7 +68,7 @@ static struct ctl_table rds_tcp_sysctl_table[] = {
 		/* data is per-net pointer */
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = rds_tcp_skbuf_handler,
+		.proc_handler   = rds_tcp_sndbuf_handler,
 		.extra1		= &rds_tcp_min_sndbuf,
 	},
 #define	RDS_TCP_RCVBUF	1
@@ -75,7 +77,7 @@ static struct ctl_table rds_tcp_sysctl_table[] = {
 		/* data is per-net pointer */
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = rds_tcp_skbuf_handler,
+		.proc_handler   = rds_tcp_rcvbuf_handler,
 		.extra1		= &rds_tcp_min_rcvbuf,
 	},
 	{ }
@@ -758,10 +760,10 @@ static void rds_tcp_sysctl_reset(struct net *net)
 	spin_unlock_irq(&rds_tcp_conn_lock);
 }
 
-static int rds_tcp_skbuf_handler(struct ctl_table *ctl, int write,
+static int rds_tcp_skbuf_handler(struct rds_tcp_net *rtn,
+				 struct ctl_table *ctl, int write,
 				 void *buffer, size_t *lenp, loff_t *fpos)
 {
-	struct net *net = current->nsproxy->net_ns;
 	int err;
 
 	err = proc_dointvec_minmax(ctl, write, buffer, lenp, fpos);
@@ -770,11 +772,34 @@ static int rds_tcp_skbuf_handler(struct ctl_table *ctl, int write,
 			*(int *)(ctl->extra1));
 		return err;
 	}
-	if (write)
+
+	if (write && rtn->rds_tcp_listen_sock && rtn->rds_tcp_listen_sock->sk) {
+		struct net *net = sock_net(rtn->rds_tcp_listen_sock->sk);
+
 		rds_tcp_sysctl_reset(net);
+	}
+
 	return 0;
 }
 
+static int rds_tcp_sndbuf_handler(struct ctl_table *ctl, int write,
+				  void *buffer, size_t *lenp, loff_t *fpos)
+{
+	struct rds_tcp_net *rtn = container_of(ctl->data, struct rds_tcp_net,
+					       sndbuf_size);
+
+	return rds_tcp_skbuf_handler(rtn, ctl, write, buffer, lenp, fpos);
+}
+
+static int rds_tcp_rcvbuf_handler(struct ctl_table *ctl, int write,
+				  void *buffer, size_t *lenp, loff_t *fpos)
+{
+	struct rds_tcp_net *rtn = container_of(ctl->data, struct rds_tcp_net,
+					       rcvbuf_size);
+
+	return rds_tcp_skbuf_handler(rtn, ctl, write, buffer, lenp, fpos);
+}
+
 static void rds_tcp_exit(void)
 {
 	rds_tcp_set_unloading();
-- 
2.53.0



