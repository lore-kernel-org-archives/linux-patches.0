Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F4D79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D3DC433C1;
	Wed, 30 Nov 2022 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833565;
	bh=Yl44QzgIoLY8kvdu7Fo5XROW6AuHdFYKOGpEmstkg3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQyyQL50gEs5zqPRRVLlKzRIUMY8+wlWJDTs1wYr4l7VD7evVe3zf9ZfA87kzp75R
	 +GUfRfA5urU8EZ9jYhHe7BxfTBl/8hQglWJHrvr3Ihdn0ybZvH6O7NwQPnRp/4SSrB
	 pERxwUmTFpCk0W7G2tT2tsNiSABASsm9QXzRpHC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/206] tipc: add an extra conn_get in tipc_conn_alloc
Date: Wed, 30 Nov 2022 19:22:37 +0100
Message-Id: <20221130180535.717668187@linuxfoundation.org>
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

[ Upstream commit a7b42969d63f47320853a802efd879fbdc4e010e ]

One extra conn_get() is needed in tipc_conn_alloc(), as after
tipc_conn_alloc() is called, tipc_conn_close() may free this
con before deferencing it in tipc_topsrv_accept():

   tipc_conn_alloc();
   newsk = newsock->sk;
                                 <---- tipc_conn_close();
   write_lock_bh(&sk->sk_callback_lock);
   newsk->sk_data_ready = tipc_conn_data_ready;

Then an uaf issue can be triggered:

  BUG: KASAN: use-after-free in tipc_topsrv_accept+0x1e7/0x370 [tipc]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x33/0x46
   print_report+0x178/0x4b0
   kasan_report+0x8c/0x100
   kasan_check_range+0x179/0x1e0
   tipc_topsrv_accept+0x1e7/0x370 [tipc]
   process_one_work+0x6a3/0x1030
   worker_thread+0x8a/0xdf0

This patch fixes it by holding it in tipc_conn_alloc(), then after
all accessing in tipc_topsrv_accept() releasing it. Note when does
this in tipc_topsrv_kern_subscr(), as tipc_conn_rcv_sub() returns
0 or -1 only, we don't need to check for "> 0".

Fixes: c5fa7b3cf3cb ("tipc: introduce new TIPC server infrastructure")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/topsrv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index b0f9aa521670..e3b427a70398 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -206,6 +206,7 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s, struct socket *s
 	set_bit(CF_CONNECTED, &con->flags);
 	con->server = s;
 	con->sock = sock;
+	conn_get(con);
 	spin_unlock_bh(&s->idr_lock);
 
 	return con;
@@ -484,6 +485,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 
 		/* Wake up receive process in case of 'SYN+' message */
 		newsk->sk_data_ready(newsk);
+		conn_put(con);
 	}
 }
 
@@ -583,10 +585,11 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 
 	*conid = con->conid;
 	rc = tipc_conn_rcv_sub(tipc_topsrv(net), con, &sub);
-	if (rc >= 0)
-		return true;
+	if (rc)
+		conn_put(con);
+
 	conn_put(con);
-	return false;
+	return !rc;
 }
 
 void tipc_topsrv_kern_unsubscr(struct net *net, int conid)
-- 
2.35.1



