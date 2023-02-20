Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE95563B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75283C433EF;
	Mon, 20 Feb 2023 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901444;
	bh=UKI7qk1JBJixYFVxGWD0KILYZS8i/mygS2GNMpIlC+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDIPqBGdzbtvQ7DKGHsBfvfrdSgcXm3QlkW8aooCjBwpsUG7aXAemM/RdcCUFe0Am
	 ruAUBe5/ahLfZUnXDaoGxDiBU8M9Q3lhYGswWD6SZ2dRwyDJkj6Mg5U3DpGGRQMhrG
	 C/lh2MlBa67jaX0mw3IJdMb/ranGGfaPM8GF2HT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/118] mptcp: fix locking for setsockopt corner-case
Date: Mon, 20 Feb 2023 14:35:18 +0100
Message-Id: <20230220133600.497450353@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 21e43569685de4ad773fb060c11a15f3fd5e7ac4 ]

We need to call the __mptcp_nmpc_socket(), and later subflow socket
access under the msk socket lock, or e.g. a racing connect() could
change the socket status under the hood, with unexpected results.

Fixes: 54635bd04701 ("mptcp: add TCP_FASTOPEN_CONNECT socket option")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/sockopt.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 8d3b09d75c3ae..696ba398d699a 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -772,14 +772,21 @@ static int mptcp_setsockopt_sol_tcp_defer(struct mptcp_sock *msk, sockptr_t optv
 static int mptcp_setsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
 					  sockptr_t optval, unsigned int optlen)
 {
+	struct sock *sk = (struct sock *)msk;
 	struct socket *sock;
+	int ret = -EINVAL;
 
 	/* Limit to first subflow, before the connection establishment */
+	lock_sock(sk);
 	sock = __mptcp_nmpc_socket(msk);
 	if (!sock)
-		return -EINVAL;
+		goto unlock;
 
-	return tcp_setsockopt(sock->sk, level, optname, optval, optlen);
+	ret = tcp_setsockopt(sock->sk, level, optname, optval, optlen);
+
+unlock:
+	release_sock(sk);
+	return ret;
 }
 
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
-- 
2.39.0



