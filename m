Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F33063B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866B0C433D2;
	Mon, 20 Feb 2023 13:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900380;
	bh=9VEO9pRwOJ9ghSVUE5fqmvAsIdGwV808Rjb7kQnwxFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sR6vxAzRCY529gOFxNUqXnHaMUjL+FIrJawWB63U4uLYGabO0iV+UNvLvcAUUFby
	 GfcDf+Le1Tawz4wmLtIiT5eK+fsa0oktw91ZZSRMpqkNQTPHkr/TgRqyJZJNOILoBl
	 HbeJBLQUy7wuTFdpYum7y9+kbpXSv3tEOUVUtTy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/53] net/rose: Fix to not accept on connected socket
Date: Mon, 20 Feb 2023 14:36:01 +0100
Message-Id: <20230220133549.427725391@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 14caefcf9837a2be765a566005ad82cd0d2a429f ]

If you call listen() and accept() on an already connect()ed
rose socket, accept() can successfully connect.
This is because when the peer socket sends data to sendmsg,
the skb with its own sk stored in the connected socket's
sk->sk_receive_queue is connected, and rose_accept() dequeues
the skb waiting in the sk->sk_receive_queue.

This creates a child socket with the sk of the parent
rose socket, which can cause confusion.

Fix rose_listen() to return -EINVAL if the socket has
already been successfully connected, and add lock_sock
to prevent this issue.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230125105944.GA133314@ubuntu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index b53468edf35a6..ac2ea4ebf7c7c 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -490,6 +490,12 @@ static int rose_listen(struct socket *sock, int backlog)
 {
 	struct sock *sk = sock->sk;
 
+	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		struct rose_sock *rose = rose_sk(sk);
 
@@ -499,8 +505,10 @@ static int rose_listen(struct socket *sock, int backlog)
 		memset(rose->dest_digis, 0, AX25_ADDR_LEN * ROSE_MAX_DIGIS);
 		sk->sk_max_ack_backlog = backlog;
 		sk->sk_state           = TCP_LISTEN;
+		release_sock(sk);
 		return 0;
 	}
+	release_sock(sk);
 
 	return -EOPNOTSUPP;
 }
-- 
2.39.0



