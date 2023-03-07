Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0868BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BB9C433A4;
	Tue,  7 Mar 2023 17:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209576;
	bh=8VzJnpP/vL8Hm15qv9EuWG9UjYcoPmucC/2RrPSwafs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jF2uzowHyaPDMzmDi04sw7q9WAe9SM+gLxTG+txWn+OrbXkl2U+2hnbZJNIJaW1V+
	 eGrV16DdmrSazKnl1VNzPorRcmSJr10AE9lCWPALHPhbNB+dt2X5BY9JjGa++teg0K
	 l7I7wO1iFHVXATlm3N9Q20uaLpJZIsvukAgfStjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0264/1001] net: add sock_init_data_uid()
Date: Tue,  7 Mar 2023 17:50:36 +0100
Message-Id: <20230307170033.197562037@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 584f3742890e966d2f0a1f3c418c9ead70b2d99e ]

Add sock_init_data_uid() to explicitly initialize the socket uid.
To initialise the socket uid, sock_init_data() assumes a the struct
socket* sock is always embedded in a struct socket_alloc, used to
access the corresponding inode uid. This may not be true.
Examples are sockets created in tun_chr_open() and tap_open().

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  7 ++++++-
 net/core/sock.c    | 15 ++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5562097276336..c6584a3524638 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1956,7 +1956,12 @@ void sk_common_release(struct sock *sk);
  *	Default socket callbacks and setup code
  */
 
-/* Initialise core socket variables */
+/* Initialise core socket variables using an explicit uid. */
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid);
+
+/* Initialise core socket variables.
+ * Assumes struct socket *sock is embedded in a struct socket_alloc.
+ */
 void sock_init_data(struct socket *sock, struct sock *sk);
 
 /*
diff --git a/net/core/sock.c b/net/core/sock.c
index 6f27c24016fee..63680f999bf6d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3381,7 +3381,7 @@ void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
 }
 EXPORT_SYMBOL(sk_stop_timer_sync);
 
-void sock_init_data(struct socket *sock, struct sock *sk)
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 {
 	sk_init_common(sk);
 	sk->sk_send_head	=	NULL;
@@ -3401,11 +3401,10 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 		sk->sk_type	=	sock->type;
 		RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
 		sock->sk	=	sk;
-		sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
 	} else {
 		RCU_INIT_POINTER(sk->sk_wq, NULL);
-		sk->sk_uid	=	make_kuid(sock_net(sk)->user_ns, 0);
 	}
+	sk->sk_uid	=	uid;
 
 	rwlock_init(&sk->sk_callback_lock);
 	if (sk->sk_kern_sock)
@@ -3463,6 +3462,16 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	refcount_set(&sk->sk_refcnt, 1);
 	atomic_set(&sk->sk_drops, 0);
 }
+EXPORT_SYMBOL(sock_init_data_uid);
+
+void sock_init_data(struct socket *sock, struct sock *sk)
+{
+	kuid_t uid = sock ?
+		SOCK_INODE(sock)->i_uid :
+		make_kuid(sock_net(sk)->user_ns, 0);
+
+	sock_init_data_uid(sock, sk, uid);
+}
 EXPORT_SYMBOL(sock_init_data);
 
 void lock_sock_nested(struct sock *sk, int subclass)
-- 
2.39.2



