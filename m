Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764282AB22
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C25C433CA;
	Wed, 20 Sep 2023 12:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211628;
	bh=Em5IwOWjzHhzHlXzfeNOmEHEJvEVC5V/3xF8vbVWFJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSEwWLUT4WD+FdF9IO3tVAbbEQNuMkSjK3u1hqo6p5i/msgFQi9Kn77vItuGy0DJ8
	 aykg36Z87JiyUyDwMrANDIxzmU8K5g/+RFIyJWVBCCDJE8sQMe7MreNc9izTKEjk24
	 E97/N8dW1Mi3rqr1bqqi65KdKWz5pSZZY64MkrTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 137/186] af_unix: Fix data race around sk->sk_err.
Date: Wed, 20 Sep 2023 13:30:40 +0200
Message-ID: <20230920112841.945456012@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit b192812905e4b134f7b7994b079eb647e9d2d37e ]

As with sk->sk_shutdown shown in the previous patch, sk->sk_err can be
read locklessly by unix_dgram_sendmsg().

Let's use READ_ONCE() for sk_err as well.

Note that the writer side is marked by commit cc04410af7de ("af_unix:
annotate lockless accesses to sk->sk_err").

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 846d4cec79903..5b9f51a27dc0d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2067,7 +2067,7 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
 			break;
 		if (READ_ONCE(sk->sk_shutdown) & SEND_SHUTDOWN)
 			break;
-		if (sk->sk_err)
+		if (READ_ONCE(sk->sk_err))
 			break;
 		timeo = schedule_timeout(timeo);
 	}
-- 
2.40.1



