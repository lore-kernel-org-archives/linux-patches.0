Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8079D53B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B0DC433C7;
	Wed,  9 Aug 2023 10:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578452;
	bh=Vus+KXvu5H5osl7xlXrlu4eGgWLpI2j/VgrSuVLkJRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5qmqENBdGirqRjaiuDy895LterywINIswFZi5ayBjU8OqVpKroOABt9f7lQfDU49
	 8GBKGwJi0iRWG+woVbh5HkAStyCBblNShuNshluCX+mjC6AlzZNeEQL+1/0xo0+t+Q
	 2vtdUJc1ic1O0Di/a5uTh3BGVN4SYIMA9DpPN7+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/127] net: annotate data-races around sk->sk_max_pacing_rate
Date: Wed,  9 Aug 2023 12:40:24 +0200
Message-ID: <20230809103637.893942098@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
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

[ Upstream commit ea7f45ef77b39e72244d282e47f6cb1ef4135cd2 ]

sk_getsockopt() runs locklessly. This means sk->sk_max_pacing_rate
can be read while other threads are changing its value.

Fixes: 62748f32d501 ("net: introduce SO_MAX_PACING_RATE")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 77abd69c56dde..86e88de1238b1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1426,7 +1426,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			cmpxchg(&sk->sk_pacing_status,
 				SK_PACING_NONE,
 				SK_PACING_NEEDED);
-		sk->sk_max_pacing_rate = ulval;
+		/* Pairs with READ_ONCE() from sk_getsockopt() */
+		WRITE_ONCE(sk->sk_max_pacing_rate, ulval);
 		sk->sk_pacing_rate = min(sk->sk_pacing_rate, ulval);
 		break;
 		}
@@ -1852,12 +1853,14 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 #endif
 
 	case SO_MAX_PACING_RATE:
+		/* The READ_ONCE() pair with the WRITE_ONCE() in sk_setsockopt() */
 		if (sizeof(v.ulval) != sizeof(v.val) && len >= sizeof(v.ulval)) {
 			lv = sizeof(v.ulval);
-			v.ulval = sk->sk_max_pacing_rate;
+			v.ulval = READ_ONCE(sk->sk_max_pacing_rate);
 		} else {
 			/* 32bit version */
-			v.val = min_t(unsigned long, sk->sk_max_pacing_rate, ~0U);
+			v.val = min_t(unsigned long, ~0U,
+				      READ_ONCE(sk->sk_max_pacing_rate));
 		}
 		break;
 
-- 
2.40.1



