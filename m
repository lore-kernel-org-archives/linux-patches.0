Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4F9174EE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38B1C433C9;
	Wed,  9 Aug 2023 10:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578778;
	bh=yIStkz2+wEnO/epR+Ne1Y6jCWk38flZ48WhmKayWWio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yE5lz1+MPnLGvMc7prGz7Ao5fGVcB9zWftWTZkXWRDMZpymKJG4clIlXxlJORDM/F
	 hoYFxcmuCgKOQVytYY2MUXhC1YR2FpIkWJu9yEEMJ6sIiuUX8zC5YnGRfyWwYTTN0k
	 /PYJkBzr6JzpGf3g1IcfhTxAaweY5FQQ34eVqkXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/92] net: annotate data-races around sk->sk_max_pacing_rate
Date: Wed,  9 Aug 2023 12:41:01 +0200
Message-ID: <20230809103634.483622631@linuxfoundation.org>
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
index cf1e437ae4875..d392efa0d9551 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1297,7 +1297,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			cmpxchg(&sk->sk_pacing_status,
 				SK_PACING_NONE,
 				SK_PACING_NEEDED);
-		sk->sk_max_pacing_rate = ulval;
+		/* Pairs with READ_ONCE() from sk_getsockopt() */
+		WRITE_ONCE(sk->sk_max_pacing_rate, ulval);
 		sk->sk_pacing_rate = min(sk->sk_pacing_rate, ulval);
 		break;
 		}
@@ -1680,12 +1681,14 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
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



