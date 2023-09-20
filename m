Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4C15AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08C3C433CC;
	Wed, 20 Sep 2023 12:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212277;
	bh=Tu2UWDV/ZAv5yNO5NhfAC5fCPfoIr1FHv9qhAlcfQLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xmi0XXKKJjIzTNX3RiWbErzaWViGdgAbzRkhCyfw365j/EHKzPrvETdqa/wye04CN
	 PIsC3nki5U5G/kMLGGEpYzOpu12+ikHp+Gc5Uhwz53CjeEjMhU07yakfNf+mmIse/n
	 u0ESZGuZFy9iEAo25r9T56Kk73O+khsyXvn9O3ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/273] af_unix: Fix data race around sk->sk_err.
Date: Wed, 20 Sep 2023 13:30:57 +0200
Message-ID: <20230920112853.148015851@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9a4559b863fb7..e1d0c8c715b87 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2074,7 +2074,7 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
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



