Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3875628EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A23C433D2;
	Mon, 30 Jan 2023 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087157;
	bh=HvsOvFku05vbibpHjbQYPdT6PjZTPZiRjTZ98e5WCaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qjck3D8KaLhrMQyzCljJAgmYSFZiscp/29Y3N1JoET+yIl2kBwg/KFgB227/kyBtb
	 4nbOdro1rDr7lo03HuuApixqF0YDsrYoGUJO1npuEl1C1H0QnktqCwk8+zbOHCeG5k
	 6FkovwBInpe4XC3XTYwI9i1XKP78dxLef6FqIF1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/313] l2tp: prevent lockdep issue in l2tp_tunnel_register()
Date: Mon, 30 Jan 2023 14:49:11 +0100
Message-Id: <20230130134342.067891244@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b9fb10d131b8c84af9bb14e2078d5c63600c7dea ]

lockdep complains with the following lock/unlock sequence:

     lock_sock(sk);
     write_lock_bh(&sk->sk_callback_lock);
[1]  release_sock(sk);
[2]  write_unlock_bh(&sk->sk_callback_lock);

We need to swap [1] and [2] to fix this issue.

Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
Reported-by: syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/20230114030137.672706-1-xiyou.wangcong@gmail.com/T/#m1164ff20628671b0f326a24cb106ab3239c70ce3
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index b6554e32bb12..03608d3ded4b 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1483,10 +1483,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	lock_sock(sk);
 	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
-	if (ret < 0) {
-		release_sock(sk);
+	if (ret < 0)
 		goto err_inval_sock;
-	}
 	rcu_assign_sk_user_data(sk, tunnel);
 	write_unlock_bh(&sk->sk_callback_lock);
 
@@ -1523,6 +1521,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 err_inval_sock:
 	write_unlock_bh(&sk->sk_callback_lock);
+	release_sock(sk);
 
 	if (tunnel->fd < 0)
 		sock_release(sock);
-- 
2.39.0



