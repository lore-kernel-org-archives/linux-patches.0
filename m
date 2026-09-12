Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275543815F8;
	Sat, 12 Sep 2026 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242984; cv=none; b=KIdBQfVgyVUSy3q49C1MnIWHsZaY4xEfpE/D1qNcCY417AqYhqxioEsZZNpOuz6b5JH65zQOP/jYIlDreJgOZWF70LkidTw11N0Jwycs5JSXP77IqEf640N0VEn6cSxmFXRa7BIXodzKXVPdm0J6Wy5NToDq1eRUh8F9Yl1u+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242984; c=relaxed/simple;
	bh=UAqhPJGeRhtExHDQcI4t6BmGm5VoXoHj6T+xWQ0wXu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ac80DSgVKTWrA2z1RUw6pULdjP8+1fHCNw2nFx+47MC6QbkREAxMBvihwle9JWqG85r28RL4kq6Chn25a2VbWKSCAuz7Mrh0CjDRKp4F3fFXI/wpTOoh9tLtl2W6kDiGRka95729sIw9gWgXr4N1SNSI/XS/e8WxFYeiw3degx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmFE0MJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmFE0MJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF321F000FF;
	Sat, 12 Sep 2026 19:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242981;
	bh=ZTgWPEXmASBzhtkC8tI/2zMvnh2qZLrQHwVCjQMmp1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmFE0MJaAVcETk0VnBNWCiaH0VuFw5uBM1bqST/mzVxqL9PdOcawDWYCM2XZEC0n0
	 yxZsgQPf3EuKvySPqwqBDDXNN3aQ4WZyIUjmJaNHVRYZb9E3D9stVnoaHEJinpwDp1
	 Yzi/8BEYGHnr3QQ7AAj1Afw+e1dnc/gzktVp7xBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 594/798] block/blk-stat: drain per-cpu callback stats over possible CPUs
Date: Sat, 12 Sep 2026 09:03:42 +0200
Message-ID: <20260912065530.740678991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e602f9b966e4..7d6258eaaef48 100644
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



