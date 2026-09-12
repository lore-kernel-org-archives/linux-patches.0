Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FA53A9D80;
	Sat, 12 Sep 2026 08:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201608; cv=none; b=HhdjVMSELqin3kc7y29U+vuJBhRHfMip7dkmWTJcxJ8bNHyMF6pw9QxXmJZwTwqlshEw+9w7KWl6XvmHhhIpqUr/Zjg3Pr5r7ILxtdfDq+PG7Gqgha2+kr0zXrwLdIjMiU9+aReJ3ZBH8MhrBGmc4O5Kk72EA3g7010x34jwa98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201608; c=relaxed/simple;
	bh=HsXYDGu/eyny5S0fsUTZ895lW1do/I5pDJKUVByNCag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INy7l/mN95+k9jIYhE7BS+vf/kHUrTnqyHjKghRy518CmlM5W4fE+fV0DxidtnlyNTAPzrOVTUn1EF6fRBjY/MpDxtbO7QVuT70gkMqa70Nr6awUoz2ii7QzUgnVlxJtWChYYcJ6gjRC60GhvwNN8j8WAXHIFfmy/LOq6rYzFmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjkYGVsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjkYGVsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C681F000FF;
	Sat, 12 Sep 2026 08:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201605;
	bh=4hhURhtnMV7OgIzOfJcXLjEGP1NYmkrm2CiaS1qFyDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjkYGVsjq0pwht33sl1BWetZtQbxcl2iXSR5HrqWNKpMPn8OLxbnrG+JAHbU97oWF
	 3ok3cp6UpUA9hoz00znmDH1qXv7e/F6Ynr+Ynn2olYELtiv/L1UpXp+nnkvKzZD5xi
	 lfGKq+h6mH40hMhAwbvXyXfKoz+5WEVmumE3PZNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1030/1815] block/blk-stat: drain per-cpu callback stats over possible CPUs
Date: Sat, 12 Sep 2026 08:46:20 +0200
Message-ID: <20260912065713.198755001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index de126e1ea5ac4..d57c2fc6bf064 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -83,7 +83,7 @@ static void blk_stat_timer_fn(struct timer_list *t)
 	for (bucket = 0; bucket < cb->buckets; bucket++)
 		blk_rq_stat_init(&cb->stat[bucket]);
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct blk_rq_stat *cpu_stat;
 
 		cpu_stat = per_cpu_ptr(cb->cpu_stat, cpu);
-- 
2.53.0



