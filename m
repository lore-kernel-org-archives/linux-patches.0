Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAB518B00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yclg1+uF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB96DC433C9;
	Mon,  9 Oct 2023 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856922;
	bh=0UxndBLhQUyFwqfmebc67WESfsLSPqgFo1SyiDVVMIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yclg1+uFrZ6o4+5htVg7CivC+bDUj2n32NcbV4G0UB0+FldaLuBiFCqM2XbMuh8Hn
	 kO1Qu0WwXFA8XJVhfTdgb3PYcT4sgSnwPSGKJLV/yFzbOJ8VCmjuJIu4UYv2473tz2
	 cXQe7SuE31NuzKfVP1+Zx9B5goMT4P2J9I8t1pVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 009/163] mptcp: Remove unnecessary test for __mptcp_init_sock()
Date: Mon,  9 Oct 2023 14:59:33 +0200
Message-ID: <20231009130124.277557269@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e263691773cd67d7c824eeee8b802f50c6e0c118 ]

__mptcp_init_sock() always returns 0 because mptcp_init_sock() used
to return the value directly.

But after commit 18b683bff89d ("mptcp: queue data for mptcp level
retransmission"), __mptcp_init_sock() need not return value anymore.

Let's remove the unnecessary test for __mptcp_init_sock() and make
it return void.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 27e5ccc2d5a5 ("mptcp: fix dangling connection hang-up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6947b4b2519c9..0aae76f1465b8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2710,7 +2710,7 @@ static void mptcp_worker(struct work_struct *work)
 	sock_put(sk);
 }
 
-static int __mptcp_init_sock(struct sock *sk)
+static void __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
@@ -2737,8 +2737,6 @@ static int __mptcp_init_sock(struct sock *sk)
 	/* re-use the csk retrans timer for MPTCP-level retrans */
 	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
 	timer_setup(&sk->sk_timer, mptcp_timeout_timer, 0);
-
-	return 0;
 }
 
 static void mptcp_ca_reset(struct sock *sk)
@@ -2756,11 +2754,8 @@ static void mptcp_ca_reset(struct sock *sk)
 static int mptcp_init_sock(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
-	int ret;
 
-	ret = __mptcp_init_sock(sk);
-	if (ret)
-		return ret;
+	__mptcp_init_sock(sk);
 
 	if (!mptcp_is_enabled(net))
 		return -ENOPROTOOPT;
-- 
2.40.1



