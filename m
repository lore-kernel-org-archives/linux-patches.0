Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C2F3AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7898BC433EF;
	Wed,  7 Jun 2023 20:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169350;
	bh=JuUTVXUx5UxWQN3SXDrSKRdlI6bLh9QI6A6fPVraj0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2GnejrlPEoXZRltGYG/DUiUm+AS7QBIAzqJbchiu2h/jH+yBRja44MqTvHaPDxFi
	 X4ZZ9ehwXkGz7paPDeRp8JiAjqkKkSnUjH1DRARwONeIyo0HdBYNzLQIWCaLW5EkDk
	 p1m5Yd4ctAm5aS+q61mpBtqwE0xY6bQyjuIuI/dI=
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
Subject: [PATCH 6.3 048/286] tcp: Return user_mss for TCP_MAXSEG in CLOSE/LISTEN state if user_mss set
Date: Wed,  7 Jun 2023 22:12:27 +0200
Message-ID: <20230607200924.617586285@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
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
index f4b243cc7f4a5..6bb8eb8031051 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4077,7 +4077,8 @@ int do_tcp_getsockopt(struct sock *sk, int level,
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



