Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6464233B6C4;
	Sat, 30 May 2026 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162026; cv=none; b=kkbCHizWKeGQ0qO0B+l7LO388j2EJ8IdmjGIhmSHzAaEJ/VH9qhjj3jOkyZU8DOzADak37BisfY05xMxPQ8Yhm56rb7+urebarHcmFoL2eWOK+7U0S2PnLJ2iVv+2RftXJhs+4dpfUbpF4MYjFswXWEL1xm7T4A9yNNRp2gV7iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162026; c=relaxed/simple;
	bh=56ZU0MqOPObcY2HF/fNRn1RAE3iYKk8reoinMcK0lqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDxqVq9tb2TeS8AUYlu5Md3HsFLlwZlL+wxGYUqykb273ihF0mJNGY1CPd/0EBZda4BkSyxAG7TjO/cid/ICW5ong9sdB0bmlDqzIqP23xMaR8XlaV1o5/QZL2Dd7hq3xlNVvwLT5pOu56xdIKjmNd/7PCEyltm6AvMdj8mGJK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9dEYmHJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9dEYmHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A802D1F00893;
	Sat, 30 May 2026 17:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162025;
	bh=uWDMxEXJ+Ti9kReASYNbZ4v30tmIzWF9yVtoECB3eKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9dEYmHJINiB6dqH99Q1hgwTb7w7COAJDU8fArYfKxLW+qddI6iWWUjAbkILf3XbW
	 enVyBJqc66XBqZ11+fXsOsIC294M2yVnnNj/H5TumBVX8M+Zvx5Y1jPG1TIL7a67dU
	 i5ANT9pMWdi1rLFZg8pTA6V8WU2jkewA05IuoVLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 769/969] net/sched: sch_cake: annotate data-races in cake_dump_stats() (V)
Date: Sat, 30 May 2026 18:04:53 +0200
Message-ID: <20260530160321.814115207@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a6c95b833dc17e84d16a8ac0f40fd0931616a52d ]

cake_dump_stats() runs without qdisc spinlock being held.

In this final patch, I add READ_ONCE()/WRITE_ONCE() annotations
for cparams.target and cparams.interval.

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: "Toke Høiland-Jørgensen" <toke@toke.dk>
Link: https://patch.msgid.link/20260427083606.459355-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 204cc04d4c6e8..c6c03f758d0d7 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2313,10 +2313,11 @@ static void cake_set_rate(struct cake_tin_data *b, u64 rate, u32 mtu,
 
 	byte_target_ns = (byte_target * rate_ns) >> rate_shft;
 
-	b->cparams.target = max((byte_target_ns * 3) / 2, target_ns);
-	b->cparams.interval = max(rtt_est_ns +
-				     b->cparams.target - target_ns,
-				     b->cparams.target * 2);
+	WRITE_ONCE(b->cparams.target,
+		   max((byte_target_ns * 3) / 2, target_ns));
+	WRITE_ONCE(b->cparams.interval,
+		   max(rtt_est_ns + b->cparams.target - target_ns,
+		       b->cparams.target * 2));
 	b->cparams.mtu_time = byte_target_ns;
 	b->cparams.p_inc = 1 << 24; /* 1/256 */
 	b->cparams.p_dec = 1 << 20; /* 1/4096 */
@@ -2930,9 +2931,9 @@ static int cake_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		PUT_TSTAT_U32(BACKLOG_BYTES, b->tin_backlog);
 
 		PUT_TSTAT_U32(TARGET_US,
-			      ktime_to_us(ns_to_ktime(b->cparams.target)));
+			      ktime_to_us(ns_to_ktime(READ_ONCE(b->cparams.target))));
 		PUT_TSTAT_U32(INTERVAL_US,
-			      ktime_to_us(ns_to_ktime(b->cparams.interval)));
+			      ktime_to_us(ns_to_ktime(READ_ONCE(b->cparams.interval))));
 
 		PUT_TSTAT_U32(SENT_PACKETS, b->packets);
 		PUT_TSTAT_U32(DROPPED_PACKETS, b->tin_dropped);
-- 
2.53.0



