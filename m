Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EF61D2A5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD211C433D2;
	Wed,  7 Jun 2023 20:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170864;
	bh=6xU3bxK06pZcXU5zwEakjhVrfC2z5Re0ERRiqEWHEv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VToMPSHoR1fxN0UK7329zCzHsz4nH8CMQvF34FzFH0/f2/XtuvMIF7UgT1mDjmIYY
	 5nf5kERWCkinNGJVXOIjOW7WH5zY9ow1zlCjcSr82rsuFfmZzqHX1xwKs3GR8k2Udq
	 hbGACJ5mOUWmpuv6pvzAKa/FP2Tv0VIKXmDqLDE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yang <mingliang@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Cambda Zhu <cambda@linux.alibaba.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/120] tcp: Return user_mss for TCP_MAXSEG in CLOSE/LISTEN state if user_mss set
Date: Wed,  7 Jun 2023 22:15:36 +0200
Message-ID: <20230607200901.553700716@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cambda Zhu <cambda@linux.alibaba.com>

[ Upstream commit 34dfde4ad87b84d21278a7e19d92b5b2c68e6c4d ]

This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
it's zero is probably a bug.

With this change, getting TCP_MAXSEG before connecting will return
default MSS normally, and return user_mss if user_mss is set.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Jack Yang <mingliang@linux.alibaba.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3u+UyLBmGmifHA@mail.gmail.com/#t
Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
Link: https://lore.kernel.org/netdev/14D45862-36EA-4076-974C-EA67513C92F6@linux.alibaba.com/
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230527040317.68247-1-cambda@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index edb743bcbc391..82abbf1929851 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3719,7 +3719,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	switch (optname) {
 	case TCP_MAXSEG:
 		val = tp->mss_cache;
-		if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
+		if (tp->rx_opt.user_mss &&
+		    ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
 			val = tp->rx_opt.user_mss;
 		if (tp->repair)
 			val = tp->rx_opt.mss_clamp;
-- 
2.39.2



