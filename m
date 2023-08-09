Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801A616428
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C61C433C7;
	Wed,  9 Aug 2023 10:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578711;
	bh=iAISaNbSKvMP3GrTxF46yOolk84+g40Ng0d9sAwBC8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXi/eLFCPjDB6AZH2uTNxsqQZE4G3X4xH6K2N2c42d4lEzsmODP90p2Rp4JBd8GAv
	 finmhlJ4/pnDXZgrNom9JOan8vV7J1ArnhDGW044vkbjYAGGAomPUMfBbkAl7UhOPg
	 Q7chb0X8jtETQtgNUNVXo0jfWF3prQfXT6Mj5cMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/92] net: add missing data-race annotation for sk_ll_usec
Date: Wed,  9 Aug 2023 12:41:06 +0200
Message-ID: <20230809103634.665285765@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
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

[ Upstream commit e5f0d2dd3c2faa671711dac6d3ff3cef307bcfe3 ]

In a prior commit I forgot that sk_getsockopt() reads
sk->sk_ll_usec without holding a lock.

Fixes: 0dbffbb5335a ("net: annotate data race around sk_ll_usec")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0cca1ccf14990..1f9401d757cbb 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1673,7 +1673,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	case SO_BUSY_POLL:
-		v.val = sk->sk_ll_usec;
+		v.val = READ_ONCE(sk->sk_ll_usec);
 		break;
 	case SO_PREFER_BUSY_POLL:
 		v.val = READ_ONCE(sk->sk_prefer_busy_poll);
-- 
2.40.1



