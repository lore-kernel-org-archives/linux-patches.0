Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2640123BD06;
	Sat, 12 Sep 2026 14:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224644; cv=none; b=PszFbEtE08yIb8YKaOTFG1vbm7VrPHpKqIlE9X8y6NqiltJ9/zHuwZlhR5v8VHtwUCsis3FlkIXhk7q1gt8ds7ut6EOZSea02K5JWpz185uzoeRphvaUrhM19aTL5OqYU+CO64zQ+Dlf5hFOf123rVxgZ/WzxD3S/y6Tn7FaLqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224644; c=relaxed/simple;
	bh=XZE9P14kBNOP8MHHQAwMhjerKWP+tlxic0EyqnT2/pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6zYGS0D7rLZ3I6x6orucnNNqmGPRrl7wQc9tKPJOlRu3vzsiogRNrrIWM1CIla1c3MqWwBND69zyeigr0qqDzPKq5z9Dm//8SL88cxO8svypmm8qBN/eCjVEBQZfzCuX/e10FHIYX3CwG2HLtPewRKkf0z6Q41S9T1uyt6po34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBfOj4Cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBfOj4Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA00C1F000FF;
	Sat, 12 Sep 2026 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224642;
	bh=LQG5+KpMN8jENR/C10cHPuoBifhGSLMG/1qQQ0p3/lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBfOj4Cm2rfGbd0bdTtQzdDuNasntQWAQTHZ4ndlYy1QuQvMzSjWPEFdRV0dUt+ke
	 l8Aoe9ob6lJxPnMWSIR0vElIvbP6lo7eK2Pbn2MNdDbd0Gy8ZZSL4og9smUKTH0G+n
	 f+OpPx7pW8u87a2Nnhc2yTNLtWyhtzUBq6k+AipM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1034/1424] block/blk-stat: drain per-cpu callback stats over possible CPUs
Date: Sat, 12 Sep 2026 08:57:46 +0200
Message-ID: <20260912065630.467683827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 9d617828cfc4d9a4d385daa2cd61f9db0592c53f ]

blk_stat_timer_fn() sums and resets a callback's per-cpu buckets using
for_each_online_cpu().  A CPU that goes offline with pending samples is
skipped, so its samples are neither accumulated into the window nor
cleared; they sit in the bucket until the CPU comes back online, at
which point the stale values are flushed into whatever window is then
running.

This silently corrupts the latency picture that consumers (notably
writeback throttling via wbt, and blk-mq latency tracking) base
decisions on around CPU hotplug: under-counting while the CPU is
offline, then a burst of stale data on re-online.

Fixes: 34dbad5d26e2 ("blk-stat: convert to callback-based statistics reporting")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260720093726.28965-2-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index e42c263e53fb9..67ccba824ea93 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -86,7 +86,7 @@ static void blk_stat_timer_fn(struct timer_list *t)
 	for (bucket = 0; bucket < cb->buckets; bucket++)
 		blk_rq_stat_init(&cb->stat[bucket]);
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct blk_rq_stat *cpu_stat;
 
 		cpu_stat = per_cpu_ptr(cb->cpu_stat, cpu);
-- 
2.53.0



