Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1035317AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ACFC433C7;
	Wed,  9 Aug 2023 11:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580353;
	bh=9Skas82wgX1XgJWE0u33lrzQI4oiePd3nRtAzWT8SJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tI4J9rH1w3j7NPC7MRo+NyTQ3VEkRp3eZkUwDizC89zTPonlK0BRhZ4lJ2ZNX3Hs3
	 72y8dTVQWUOjB7NKP2L2QtRvcvhZEBuacYiVPvQp9J3ePbw34mG67FGGOknXmkm2K0
	 eLc+Zt1jyZ9mzFVet+3a6ID9mwz/m3gQhxlRUZxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 301/323] tcp_metrics: annotate data-races around tm->tcpm_lock
Date: Wed,  9 Aug 2023 12:42:19 +0200
Message-ID: <20230809103711.833359406@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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

[ Upstream commit 285ce119a3c6c4502585936650143e54c8692788 ]

tm->tcpm_lock can be read or written locklessly.

Add needed READ_ONCE()/WRITE_ONCE() to document this.

Fixes: 51c5d0c4b169 ("tcp: Maintain dynamic metrics in local cache.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230802131500.1478140-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 2d9d95559f5fa..2529b1e6ded0c 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -59,7 +59,8 @@ static inline struct net *tm_net(struct tcp_metrics_block *tm)
 static bool tcp_metric_locked(struct tcp_metrics_block *tm,
 			      enum tcp_metric_index idx)
 {
-	return tm->tcpm_lock & (1 << idx);
+	/* Paired with WRITE_ONCE() in tcpm_suck_dst() */
+	return READ_ONCE(tm->tcpm_lock) & (1 << idx);
 }
 
 static u32 tcp_metric_get(struct tcp_metrics_block *tm,
@@ -110,7 +111,8 @@ static void tcpm_suck_dst(struct tcp_metrics_block *tm,
 		val |= 1 << TCP_METRIC_CWND;
 	if (dst_metric_locked(dst, RTAX_REORDERING))
 		val |= 1 << TCP_METRIC_REORDERING;
-	tm->tcpm_lock = val;
+	/* Paired with READ_ONCE() in tcp_metric_locked() */
+	WRITE_ONCE(tm->tcpm_lock, val);
 
 	msval = dst_metric_raw(dst, RTAX_RTT);
 	tm->tcpm_vals[TCP_METRIC_RTT] = msval * USEC_PER_MSEC;
-- 
2.40.1



