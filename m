Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E062217AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1EEC433C8;
	Wed,  9 Aug 2023 11:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581201;
	bh=dkS9YoxsD0MTKpj+A9Q/Pmtf+6QWvC886+H0ocqd7A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9jlsLSfHa1zuKV3Xlr/dP9tyzq1OZwL22d8GyIG9wuhnva3BxS4UC+GrKSNzju0a
	 tpBQMZk3s2hZ7UazCbHKJdsrGGgAOEoRAanncr33QmYGwcDz/ZrKb6Pf4PVY+kJ0cl
	 zww5YmyT6fYaWS4vTrhbMoaYlfXeknS/B7gDRuaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/201] net: add missing data-race annotations around sk->sk_peek_off
Date: Wed,  9 Aug 2023 12:42:23 +0200
Message-ID: <20230809103648.449114442@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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

[ Upstream commit 11695c6e966b0ec7ed1d16777d294cef865a5c91 ]

sk_getsockopt() runs locklessly, thus we need to annotate the read
of sk->sk_peek_off.

While we are at it, add corresponding annotations to sk_set_peek_off()
and unix_set_peek_off().

Fixes: b9bb53f3836f ("sock: convert sk_peek_offset functions to WRITE_ONCE")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c    | 4 ++--
 net/unix/af_unix.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 708018b58e906..a241734b10240 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1517,7 +1517,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		if (!sock->ops->set_peek_off)
 			return -EOPNOTSUPP;
 
-		v.val = sk->sk_peek_off;
+		v.val = READ_ONCE(sk->sk_peek_off);
 		break;
 	case SO_NOFCS:
 		v.val = sock_flag(sk, SOCK_NOFCS);
@@ -2745,7 +2745,7 @@ EXPORT_SYMBOL(__sk_mem_reclaim);
 
 int sk_set_peek_off(struct sock *sk, int val)
 {
-	sk->sk_peek_off = val;
+	WRITE_ONCE(sk->sk_peek_off, val);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sk_set_peek_off);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2fe0efcbfed16..3aa783a23c5f6 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -697,7 +697,7 @@ static int unix_set_peek_off(struct sock *sk, int val)
 	if (mutex_lock_interruptible(&u->iolock))
 		return -EINTR;
 
-	sk->sk_peek_off = val;
+	WRITE_ONCE(sk->sk_peek_off, val);
 	mutex_unlock(&u->iolock);
 
 	return 0;
-- 
2.40.1



