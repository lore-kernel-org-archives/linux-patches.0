Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D92E63B4
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4971C433C7;
	Wed,  9 Aug 2023 11:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579425;
	bh=IofE34BS1yA2zlFAbdqNmzgpGxwg3wU7IPQuXjrcqgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJp3iCNFbY032tteD/Cw0JGC+go7BPGNQatOwOJDjlGL+/X+sL+rb8FttxohhB1VJ
	 kg5y3p6Q7zbn+fREJ9RKH2OlpWHkwsKdpHvAcRvQ0fonNh4sO5AFCWvs0SYdI/pRZy
	 uRkb/1BDPhhvUEUH6j1JXLV/OWRFHQp2LxMTDVWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 191/204] tcp_metrics: annotate data-races around tm->tcpm_stamp
Date: Wed,  9 Aug 2023 12:42:09 +0200
Message-ID: <20230809103648.862758173@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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

[ Upstream commit 949ad62a5d5311d36fce2e14fe5fed3f936da51c ]

tm->tcpm_stamp can be read or written locklessly.

Add needed READ_ONCE()/WRITE_ONCE() to document this.

Also constify tcpm_check_stamp() dst argument.

Fixes: 51c5d0c4b169 ("tcp: Maintain dynamic metrics in local cache.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230802131500.1478140-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 34e3873b31946..a283b0710a7e2 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -99,7 +99,7 @@ static void tcpm_suck_dst(struct tcp_metrics_block *tm,
 	u32 msval;
 	u32 val;
 
-	tm->tcpm_stamp = jiffies;
+	WRITE_ONCE(tm->tcpm_stamp, jiffies);
 
 	val = 0;
 	if (dst_metric_locked(dst, RTAX_RTT))
@@ -133,9 +133,15 @@ static void tcpm_suck_dst(struct tcp_metrics_block *tm,
 
 #define TCP_METRICS_TIMEOUT		(60 * 60 * HZ)
 
-static void tcpm_check_stamp(struct tcp_metrics_block *tm, struct dst_entry *dst)
+static void tcpm_check_stamp(struct tcp_metrics_block *tm,
+			     const struct dst_entry *dst)
 {
-	if (tm && unlikely(time_after(jiffies, tm->tcpm_stamp + TCP_METRICS_TIMEOUT)))
+	unsigned long limit;
+
+	if (!tm)
+		return;
+	limit = READ_ONCE(tm->tcpm_stamp) + TCP_METRICS_TIMEOUT;
+	if (unlikely(time_after(jiffies, limit)))
 		tcpm_suck_dst(tm, dst, false);
 }
 
@@ -176,7 +182,8 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 		oldest = deref_locked(tcp_metrics_hash[hash].chain);
 		for (tm = deref_locked(oldest->tcpm_next); tm;
 		     tm = deref_locked(tm->tcpm_next)) {
-			if (time_before(tm->tcpm_stamp, oldest->tcpm_stamp))
+			if (time_before(READ_ONCE(tm->tcpm_stamp),
+					READ_ONCE(oldest->tcpm_stamp)))
 				oldest = tm;
 		}
 		tm = oldest;
@@ -432,7 +439,7 @@ void tcp_update_metrics(struct sock *sk)
 					       tp->reordering);
 		}
 	}
-	tm->tcpm_stamp = jiffies;
+	WRITE_ONCE(tm->tcpm_stamp, jiffies);
 out_unlock:
 	rcu_read_unlock();
 }
@@ -658,7 +665,7 @@ static int tcp_metrics_fill_info(struct sk_buff *msg,
 	}
 
 	if (nla_put_msecs(msg, TCP_METRICS_ATTR_AGE,
-			  jiffies - tm->tcpm_stamp,
+			  jiffies - READ_ONCE(tm->tcpm_stamp),
 			  TCP_METRICS_ATTR_PAD) < 0)
 		goto nla_put_failure;
 
-- 
2.40.1



