Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C4063B4
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039F9C433C8;
	Wed,  9 Aug 2023 11:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579436;
	bh=JWQjMTpJ1tIlLTo1WO+5Gy92AiwejfnVnZ30v8sNzDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbOLnWbpo2HjFTUQOi3xUVDcrxJ80/nE87ZvBA/fePfN6BeawOiy6axhQyo4RCmqM
	 Y4Om8lBFYhG+EipNfKS71H51ZfKvkuk9MGtlp5VGE/eQ6G3HpgsIsb4mXI8KtWM/9v
	 52a3x+rx3Gxi2KO3hYMESz/Uvez+H7/mKA7ZlK2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 195/204] tcp_metrics: fix data-race in tcpm_suck_dst() vs fastopen
Date: Wed,  9 Aug 2023 12:42:13 +0200
Message-ID: <20230809103649.013752227@linuxfoundation.org>
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
index 14f8b29892c97..11bb9751a799f 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -95,6 +95,7 @@ static struct tcpm_hash_bucket	*tcp_metrics_hash __read_mostly;
 static unsigned int		tcp_metrics_hash_log __read_mostly;
 
 static DEFINE_SPINLOCK(tcp_metrics_lock);
+static DEFINE_SEQLOCK(fastopen_seqlock);
 
 static void tcpm_suck_dst(struct tcp_metrics_block *tm,
 			  const struct dst_entry *dst,
@@ -131,11 +132,13 @@ static void tcpm_suck_dst(struct tcp_metrics_block *tm,
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
 
@@ -196,7 +199,7 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 		}
 		tm = oldest;
 	} else {
-		tm = kmalloc(sizeof(*tm), GFP_ATOMIC);
+		tm = kzalloc(sizeof(*tm), GFP_ATOMIC);
 		if (!tm)
 			goto out_unlock;
 	}
@@ -206,7 +209,7 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 	tm->tcpm_saddr = *saddr;
 	tm->tcpm_daddr = *daddr;
 
-	tcpm_suck_dst(tm, dst, true);
+	tcpm_suck_dst(tm, dst, reclaim);
 
 	if (likely(!reclaim)) {
 		tm->tcpm_next = tcp_metrics_hash[hash].chain;
@@ -564,8 +567,6 @@ bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst)
 	return ret;
 }
 
-static DEFINE_SEQLOCK(fastopen_seqlock);
-
 void tcp_fastopen_cache_get(struct sock *sk, u16 *mss,
 			    struct tcp_fastopen_cookie *cookie,
 			    int *syn_loss, unsigned long *last_syn_loss)
-- 
2.40.1



