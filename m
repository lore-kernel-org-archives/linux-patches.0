Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34B7318EC7;
	Thu, 17 Sep 2026 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664445; cv=none; b=ajSoyIflFtU1rzwX2bXhMbLHbkylMH8YhR/pMW2qMIqM/whcwGtqNxunrxCXH/+LNIOZinqq35qjckxkbquR+7ElQa3dXdF5CjIF7jBxFicz5U1op5lYFHLCUOzknN9M1aY79RrKgphdLgMQ0TV9LHgly4Mq6Fae+mszdRiD+hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664445; c=relaxed/simple;
	bh=taA+9MJI2elW0IgXZF0u34yuHYEFG5G+1QOVpbb/VM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SL+pyq4cWHyUZAKJ0sbjPmE2d0E25zBNEFERNo3rSr4WupD3lefsHpgVv/HiDlWJnxl6b0z5p8D6BjldRHrZZjDCD+4GDLy5TipSFxCIln2N+E+JpTTqfMUu/IDGiI/P7bHtnDNDMTPJIcyMrh7dDlGsFEPHLnlGEjQQkf39CoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyadGuwO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyadGuwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384E71F00893;
	Thu, 17 Sep 2026 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664443;
	bh=uB2Mwomld9j+eaNi+Omgv0NpzilxRmgDEc7QWMSeCwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pyadGuwO6LSpq+MN0XtNYnxw7VuLQeWLXoBUHyibIHRSduQRKFJCuOixfq8kmQCti
	 7pVoox5xIctlFOn1yrUAe7dRO+Ctd33f9TYoHdQD85eb4X6krx8sBfwHQbHFcsJC3K
	 UiiEAyMyQ9todDpspRI7ajDyvuDz6nkwWIzjlDkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Ben Maurer <bmaurer@meta.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0374/1250] btrfs: use lockless read in nr_cached_objects shrinker callback
Date: Thu, 17 Sep 2026 16:02:49 +0100
Message-ID: <20260917151602.192207250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Maurer <bmaurer@meta.com>

[ Upstream commit 1ba72d847c7aa3c0887f749115af5232fd61b598 ]

Under heavy memcg-driven slab reclaim with many memcgs and CPUs,
shrink_slab_memcg() invokes the per-superblock count callback once per
(memcg, NUMA node) tuple. For btrfs that callback reaches
percpu_counter_sum_positive() on fs_info->evictable_extent_maps, which
takes the percpu_counter's raw spinlock with IRQs disabled and walks
every online CPU. With hundreds of memcgs driving reclaim on a host with
dozens of CPUs, this counter lock becomes a global serialization point:
profiles show CPU pinned in the spin_lock_irqsave acquire under
__percpu_counter_sum, with cross-CPU IPIs hitting csd_lock_wait_toolong
while waiting for spinning vCPUs.

The shrinker count is advisory -- super_cache_count() already notes
"counts can change between super_cache_count and super_cache_scan, so we
really don't need locks here." Use percpu_counter_read_positive(), which
is lockless. Worst-case skew is bounded by batch * num_online_cpus (a
few thousand), negligible compared to the millions of extent maps a busy
filesystem accumulates and well within the noise that the shrinker
already tolerates.

Tested-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Ben Maurer <bmaurer@meta.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 157d551344707..105f21759c99f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2410,7 +2410,7 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_control *sc)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-	const s64 nr = percpu_counter_sum_positive(&fs_info->evictable_extent_maps);
+	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
 
 	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
 
-- 
2.53.0



