Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8AE17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F13C433C7;
	Wed,  9 Aug 2023 11:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580376;
	bh=TK3ZmN3Im5PTHrMOUPItLn64AudpaPQVsNNTMjzB7/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cq3jP8pij0WK3zbIuWSUjeM5cVciiA4UJSiBUlIl6qHxTecXDrkObZ+2qjEiPYh+l
	 Z0vZDMci6pmdtKWSoKimuOpsUzjgKSCzFIZcxw/vw27ueY1E4KC071dPvphnrF5pQ2
	 sCKPjqpI966pT/NEuhkvnnNmph8ZWiW0yBe5C37c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 304/323] tcp_metrics: fix data-race in tcpm_suck_dst() vs fastopen
Date: Wed,  9 Aug 2023 12:42:22 +0200
Message-ID: <20230809103711.949463886@linuxfoundation.org>
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

[ Upstream commit ddf251fa2bc1d3699eec0bae6ed0bc373b8fda79 ]

Whenever tcpm_new() reclaims an old entry, tcpm_suck_dst()
would overwrite data that could be read from tcp_fastopen_cache_get()
or tcp_metrics_fill_info().

We need to acquire fastopen_seqlock to maintain consistency.

For newly allocated objects, tcpm_new() can switch to kzalloc()
to avoid an extra fastopen_seqlock acquisition.

Fixes: 1fe4c481ba63 ("net-tcp: Fast Open client - cookie cache")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230802131500.1478140-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index dfd224979cf65..7bbd9125b5000 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -93,6 +93,7 @@ static struct tcpm_hash_bucket	*tcp_metrics_hash __read_mostly;
 static unsigned int		tcp_metrics_hash_log __read_mostly;
 
 static DEFINE_SPINLOCK(tcp_metrics_lock);
+static DEFINE_SEQLOCK(fastopen_seqlock);
 
 static void tcpm_suck_dst(struct tcp_metrics_block *tm,
 			  const struct dst_entry *dst,
@@ -129,11 +130,13 @@ static void tcpm_suck_dst(struct tcp_metrics_block *tm,
 	tcp_metric_set(tm, TCP_METRIC_REORDERING,
 		       dst_metric_raw(dst, RTAX_REORDERING));
 	if (fastopen_clear) {
+		write_seqlock(&fastopen_seqlock);
 		tm->tcpm_fastopen.mss = 0;
 		tm->tcpm_fastopen.syn_loss = 0;
 		tm->tcpm_fastopen.try_exp = 0;
 		tm->tcpm_fastopen.cookie.exp = false;
 		tm->tcpm_fastopen.cookie.len = 0;
+		write_sequnlock(&fastopen_seqlock);
 	}
 }
 
@@ -194,7 +197,7 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 		}
 		tm = oldest;
 	} else {
-		tm = kmalloc(sizeof(*tm), GFP_ATOMIC);
+		tm = kzalloc(sizeof(*tm), GFP_ATOMIC);
 		if (!tm)
 			goto out_unlock;
 	}
@@ -204,7 +207,7 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 	tm->tcpm_saddr = *saddr;
 	tm->tcpm_daddr = *daddr;
 
-	tcpm_suck_dst(tm, dst, true);
+	tcpm_suck_dst(tm, dst, reclaim);
 
 	if (likely(!reclaim)) {
 		tm->tcpm_next = tcp_metrics_hash[hash].chain;
@@ -561,8 +564,6 @@ bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst)
 	return ret;
 }
 
-static DEFINE_SEQLOCK(fastopen_seqlock);
-
 void tcp_fastopen_cache_get(struct sock *sk, u16 *mss,
 			    struct tcp_fastopen_cookie *cookie)
 {
-- 
2.40.1



