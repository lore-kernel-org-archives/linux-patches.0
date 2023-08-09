Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ECF15AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2A6C433C7;
	Wed,  9 Aug 2023 10:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577970;
	bh=/OL+7b9O51R6gLno+CJqBnpZY6cmS+YLOb6oAzKVM6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOAknKoHxqAVaGw27fUgXNGssr7rh5Fq0KOAP/ODLA4kSc4O+22OgCngyTwma5Ixb
	 lgnHXVDCq0FC8vvvPy+umMQewleeS+8QrRyTcekLPUbJs6tSuFVk0JRu9VbCdz3/nj
	 DJls2aei8Y2+ynKSVuVUuecznniXFe6Avd39eJfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 059/165] net: add missing data-race annotation for sk_ll_usec
Date: Wed,  9 Aug 2023 12:39:50 +0200
Message-ID: <20230809103644.748199443@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
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
index f9fc2a0130a9f..c0c495e0a474e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1848,7 +1848,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	case SO_BUSY_POLL:
-		v.val = sk->sk_ll_usec;
+		v.val = READ_ONCE(sk->sk_ll_usec);
 		break;
 	case SO_PREFER_BUSY_POLL:
 		v.val = READ_ONCE(sk->sk_prefer_busy_poll);
-- 
2.40.1



