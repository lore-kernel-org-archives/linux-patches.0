Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6711A1FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC56C433C8;
	Tue,  1 Aug 2023 09:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882377;
	bh=jGhtfD4uoDVbBBJjW7LSXiJwjbmp648vGYJuoyKRpRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYugOcRpbtALlTJPFXN4zzHSUxEAzN48/zw7RihkyjFzfK5ammcN+lf2+evK75IUC
	 1vxXL0tYxtKl6GjJwt79Hf91GZxNardobiXLxBp6LPIKZ8HI5i0FfCKndpB8rNTOOY
	 SqsXam/JBU/GJerVWVeFQ4G8BMPwLAm+PzXG+m2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Menglong Dong <imagedong@tencent.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/228] mptcp: introduce sk to replace sock->sk in mptcp_listen()
Date: Tue,  1 Aug 2023 11:18:33 +0200
Message-ID: <20230801091924.873866539@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit cfdcfeed6449d702825d249cb85346ecf56236fc ]

'sock->sk' is used frequently in mptcp_listen(). Therefore, we can
introduce the 'sk' and replace 'sock->sk' with it.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0226436acf24 ("mptcp: do not rely on implicit state check in mptcp_listen()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4ca61e80f4bb2..208da9a9909c2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3746,12 +3746,13 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 static int mptcp_listen(struct socket *sock, int backlog)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct sock *sk = sock->sk;
 	struct socket *ssock;
 	int err;
 
 	pr_debug("msk=%p", msk);
 
-	lock_sock(sock->sk);
+	lock_sock(sk);
 	ssock = __mptcp_nmpc_socket(msk);
 	if (!ssock) {
 		err = -EINVAL;
@@ -3759,16 +3760,16 @@ static int mptcp_listen(struct socket *sock, int backlog)
 	}
 
 	mptcp_token_destroy(msk);
-	inet_sk_state_store(sock->sk, TCP_LISTEN);
-	sock_set_flag(sock->sk, SOCK_RCU_FREE);
+	inet_sk_state_store(sk, TCP_LISTEN);
+	sock_set_flag(sk, SOCK_RCU_FREE);
 
 	err = ssock->ops->listen(ssock, backlog);
-	inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
+	inet_sk_state_store(sk, inet_sk_state_load(ssock->sk));
 	if (!err)
-		mptcp_copy_inaddrs(sock->sk, ssock->sk);
+		mptcp_copy_inaddrs(sk, ssock->sk);
 
 unlock:
-	release_sock(sock->sk);
+	release_sock(sk);
 	return err;
 }
 
-- 
2.39.2



