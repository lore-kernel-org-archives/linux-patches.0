Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8265617744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FB4C433C8;
	Wed,  9 Aug 2023 11:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580667;
	bh=DjX2+ceV5JVWb8grSZC7dBWZqxSjRqi6AtMhnIfwvYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYfYNOReVxRK7bnMi2YWJ4exlXsTTtU3i6nyBWWy7mcztCwljPPCxfD3PtiJWl86S
	 9MXIXCIlbl0Y7r72UBqVzZv4r+c9V0is6cubizoS7JpCMPWZ9wh1g3ISdyUe35bsgv
	 F7uNsukXFvvLzemu1gBvaF5zq9ahaFP2Ogs0S+GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/154] net: add missing data-race annotation for sk_ll_usec
Date: Wed,  9 Aug 2023 12:42:17 +0200
Message-ID: <20230809103640.468434588@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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
index e1204da609a1b..636427d400d7f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1474,7 +1474,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	case SO_BUSY_POLL:
-		v.val = sk->sk_ll_usec;
+		v.val = READ_ONCE(sk->sk_ll_usec);
 		break;
 #endif
 
-- 
2.40.1



