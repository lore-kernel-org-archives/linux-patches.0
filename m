Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F48F79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EA4C433C1;
	Wed, 30 Nov 2022 18:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833435;
	bh=qTeA3oofInzsCnXMSbUnfXbnJ++E2L1je2Cb98SZBeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx3uC35OONeMX9twIi0+UPPfEIme8Tva78QsWhsMBiARx4HAl6TbOSPdSF/B2cuk+
	 7ytgRpVaG2LslsEpXezZGQc3pETEVF5JT26S84fa8GHJGS67COOiUiG3x8kEMebL2M
	 KO92xYN7LYlSzvPC1qjZm4gZ4WYVQYQXdzaBsDrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/206] tipc: set con sock in tipc_conn_alloc
Date: Wed, 30 Nov 2022 19:22:36 +0100
Message-Id: <20221130180535.692176705@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 0e5d56c64afcd6fd2d132ea972605b66f8a7d3c4 ]

A crash was reported by Wei Chen:

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  RIP: 0010:tipc_conn_close+0x12/0x100
  Call Trace:
   tipc_topsrv_exit_net+0x139/0x320
   ops_exit_list.isra.9+0x49/0x80
   cleanup_net+0x31a/0x540
   process_one_work+0x3fa/0x9f0
   worker_thread+0x42/0x5c0

It was caused by !con->sock in tipc_conn_close(). In tipc_topsrv_accept(),
con is allocated in conn_idr then its sock is set:

  con = tipc_conn_alloc();
  ...                    <----[1]
  con->sock = newsock;

If tipc_conn_close() is called in anytime of [1], the null-pointer-def
is triggered by con->sock->sk due to con->sock is not yet set.

This patch fixes it by moving the con->sock setting to tipc_conn_alloc()
under s->idr_lock. So that con->sock can never be NULL when getting the
con from s->conn_idr. It will be also safer to move con->server and flag
CF_CONNECTED setting under s->idr_lock, as they should all be set before
tipc_conn_alloc() is called.

Fixes: c5fa7b3cf3cb ("tipc: introduce new TIPC server infrastructure")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/topsrv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index d92ec92f0b71..b0f9aa521670 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -176,7 +176,7 @@ static void tipc_conn_close(struct tipc_conn *con)
 	conn_put(con);
 }
 
-static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
+static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s, struct socket *sock)
 {
 	struct tipc_conn *con;
 	int ret;
@@ -202,10 +202,11 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
 	}
 	con->conid = ret;
 	s->idr_in_use++;
-	spin_unlock_bh(&s->idr_lock);
 
 	set_bit(CF_CONNECTED, &con->flags);
 	con->server = s;
+	con->sock = sock;
+	spin_unlock_bh(&s->idr_lock);
 
 	return con;
 }
@@ -467,7 +468,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
 		if (ret < 0)
 			return;
-		con = tipc_conn_alloc(srv);
+		con = tipc_conn_alloc(srv, newsock);
 		if (IS_ERR(con)) {
 			ret = PTR_ERR(con);
 			sock_release(newsock);
@@ -479,7 +480,6 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		newsk->sk_data_ready = tipc_conn_data_ready;
 		newsk->sk_write_space = tipc_conn_write_space;
 		newsk->sk_user_data = con;
-		con->sock = newsock;
 		write_unlock_bh(&newsk->sk_callback_lock);
 
 		/* Wake up receive process in case of 'SYN+' message */
@@ -577,12 +577,11 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 	sub.filter = filter;
 	*(u64 *)&sub.usr_handle = (u64)port;
 
-	con = tipc_conn_alloc(tipc_topsrv(net));
+	con = tipc_conn_alloc(tipc_topsrv(net), NULL);
 	if (IS_ERR(con))
 		return false;
 
 	*conid = con->conid;
-	con->sock = NULL;
 	rc = tipc_conn_rcv_sub(tipc_topsrv(net), con, &sub);
 	if (rc >= 0)
 		return true;
-- 
2.35.1



