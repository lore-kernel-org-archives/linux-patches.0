Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C2047ACD7;
	Sat, 12 Sep 2026 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239540; cv=none; b=YDGNFzz+KISzUO4KBpjQYHLqGg9EDTKEW2cwI7FF2WPFn1G0I8+6IwMnduuQbkoL/8eJgwkgPGnWjWbekLPZwLxPumVPxxvg8vxGPR7eBbLCW2OjLfMqWjgUAjVwEHJUWWziMIau29kCNo14j27JSYRR1Vtm2PFSUgKUoK3a7r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239540; c=relaxed/simple;
	bh=KTNT7J5xl5SuiEw/QKeYGAkNEQPLBDEal9vvy8xM5/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fT6p39Hq0lXZraR3QqGiQuiojLoHQY8zXUPflNVYqeVWh3cXh54wKFkgqAU4FkE920HT84oK3ITmecIFeELeYBjt9IfPwHpBEO7ef+CkBRypGZvGeyBy/BN3vXRUY03FZLZt7YkC3YlsNSGXzsrllMTAZrJJkffIDWlaSrIb/1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPCN0I0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPCN0I0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B39B1F000FF;
	Sat, 12 Sep 2026 18:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239539;
	bh=ubs7vfSX5Clx/cEuN22jOwHBFI20Kj0+kTNECztIT/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPCN0I0mt+RPeZ5fFy/FJ1Jnl+J7YXKC6P287r0FifmrrKOfLMi3ovQ1D/hHGKEH4
	 nj9B8MXXz/spIVw7tFzNH3CAXhJGqPt4hkDnxGUqeKSgu18fYHeSkflQ8I3PoCnfEF
	 xq93J3RBi3Jy+TLtIRFyZwtDG1DLXdrihd9KNSF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 686/935] block/blk-stat: drain per-cpu callback stats over possible CPUs
Date: Sat, 12 Sep 2026 09:01:56 +0200
Message-ID: <20260912065542.575890227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



