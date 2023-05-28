Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D602611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C2FC433EF;
	Sun, 28 May 2023 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302857;
	bh=FOG1jlh5/mfTasHs/EoMvD1t5MehaufanAC6lq7+0zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YinleWNVCRAVfXHNJrev8PP4IdGBK62MEJn8ZvEzvlh5lgK5B8q64B9xJG3Zjq6gN
	 WTO6IxPxlICadryvTt77eW52rPlpOOaT6FtcdQWaT+L7LdJJ4NwImcWnGCS+g6kIwC
	 3WTBc2HeVfWM4iEX0xfEU+Cvhwnk/V7+BEtnxcfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/211] ext4: add mballoc stats proc file
Date: Sun, 28 May 2023 20:09:08 +0100
Message-Id: <20230528190844.193108096@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

[ Upstream commit a6c75eaf11032f4a3d2b3ce2265a194ac6e4a7f0 ]

Add new stats for measuring the performance of mballoc. This patch is
forked from Artem Blagodarenko's work that can be found here:

https://github.com/lustre/lustre-release/blob/master/ldiskfs/kernel_patches/patches/rhel8/ext4-simple-blockalloc.patch

This patch reorganizes the stats by cr level. This is how the output
looks like:

mballoc:
	reqs: 0
	success: 0
	groups_scanned: 0
	cr0_stats:
		hits: 0
		groups_considered: 0
		useless_loops: 0
		bad_suggestions: 0
	cr1_stats:
		hits: 0
		groups_considered: 0
		useless_loops: 0
		bad_suggestions: 0
	cr2_stats:
		hits: 0
		groups_considered: 0
		useless_loops: 0
	cr3_stats:
		hits: 0
		groups_considered: 0
		useless_loops: 0
	extents_scanned: 0
		goal_hits: 0
		2^n_hits: 0
		breaks: 0
		lost: 0
	buddies_generated: 0/40
	buddies_time_used: 0
	preallocated: 0
	discarded: 0

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20210401172129.189766-4-harshadshirwadkar@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    |  5 ++++
 fs/ext4/mballoc.c | 75 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/sysfs.c   |  2 ++
 3 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5efd48d7c9a79..1de55d8e0d354 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1535,9 +1535,13 @@ struct ext4_sb_info {
 	atomic_t s_bal_success;	/* we found long enough chunks */
 	atomic_t s_bal_allocated;	/* in blocks */
 	atomic_t s_bal_ex_scanned;	/* total extents scanned */
+	atomic_t s_bal_groups_scanned;	/* number of groups scanned */
 	atomic_t s_bal_goals;	/* goal hits */
 	atomic_t s_bal_breaks;	/* too long searches */
 	atomic_t s_bal_2orders;	/* 2^order hits */
+	atomic64_t s_bal_cX_groups_considered[4];
+	atomic64_t s_bal_cX_hits[4];
+	atomic64_t s_bal_cX_failed[4];		/* cX loop didn't find blocks */
 	atomic_t s_mb_buddies_generated;	/* number of buddies generated */
 	atomic64_t s_mb_generation_time;
 	atomic_t s_mb_lost_chunks;
@@ -2784,6 +2788,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 extern const struct seq_operations ext4_mb_seq_groups_ops;
 extern long ext4_mb_stats;
 extern long ext4_mb_max_to_scan;
+extern int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset);
 extern int ext4_mb_init(struct super_block *);
 extern int ext4_mb_release(struct super_block *);
 extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index beee54480562a..aa51d1b837274 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2151,6 +2151,8 @@ static int ext4_mb_good_group_nolock(struct ext4_allocation_context *ac,
 	ext4_grpblk_t free;
 	int ret = 0;
 
+	if (sbi->s_mb_stats)
+		atomic64_inc(&sbi->s_bal_cX_groups_considered[ac->ac_criteria]);
 	if (should_lock)
 		ext4_lock_group(sb, group);
 	free = grp->bb_free;
@@ -2425,6 +2427,9 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			if (ac->ac_status != AC_STATUS_CONTINUE)
 				break;
 		}
+		/* Processed all groups and haven't found blocks */
+		if (sbi->s_mb_stats && i == ngroups)
+			atomic64_inc(&sbi->s_bal_cX_failed[cr]);
 	}
 
 	if (ac->ac_b_ex.fe_len > 0 && ac->ac_status != AC_STATUS_FOUND &&
@@ -2454,6 +2459,9 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			goto repeat;
 		}
 	}
+
+	if (sbi->s_mb_stats && ac->ac_status == AC_STATUS_FOUND)
+		atomic64_inc(&sbi->s_bal_cX_hits[ac->ac_criteria]);
 out:
 	if (!err && ac->ac_status != AC_STATUS_FOUND && first_err)
 		err = first_err;
@@ -2553,6 +2561,67 @@ const struct seq_operations ext4_mb_seq_groups_ops = {
 	.show   = ext4_mb_seq_groups_show,
 };
 
+int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
+{
+	struct super_block *sb = (struct super_block *)seq->private;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	seq_puts(seq, "mballoc:\n");
+	if (!sbi->s_mb_stats) {
+		seq_puts(seq, "\tmb stats collection turned off.\n");
+		seq_puts(seq, "\tTo enable, please write \"1\" to sysfs file mb_stats.\n");
+		return 0;
+	}
+	seq_printf(seq, "\treqs: %u\n", atomic_read(&sbi->s_bal_reqs));
+	seq_printf(seq, "\tsuccess: %u\n", atomic_read(&sbi->s_bal_success));
+
+	seq_printf(seq, "\tgroups_scanned: %u\n",  atomic_read(&sbi->s_bal_groups_scanned));
+
+	seq_puts(seq, "\tcr0_stats:\n");
+	seq_printf(seq, "\t\thits: %llu\n", atomic64_read(&sbi->s_bal_cX_hits[0]));
+	seq_printf(seq, "\t\tgroups_considered: %llu\n",
+		   atomic64_read(&sbi->s_bal_cX_groups_considered[0]));
+	seq_printf(seq, "\t\tuseless_loops: %llu\n",
+		   atomic64_read(&sbi->s_bal_cX_failed[0]));
+
+	seq_puts(seq, "\tcr1_stats:\n");
+	seq_printf(seq, "\t\thits: %llu\n", atomic64_read(&sbi->s_bal_cX_hits[1]));
+	seq_printf(seq, "\t\tgroups_considered: %llu\n",
+		   atomic64_read(&sbi->s_bal_cX_groups_considered[1]));
+	seq_printf(seq, "\t\tuseless_loops: %llu\n",
+		   atomic64_read(&sbi->s_bal_cX_failed[1]));
+
+	seq_puts(seq, "\tcr2_stats:\n");
+	seq_printf(seq, "\t\thits: %llu\n", atomic64_read(&sbi->s_bal_cX_hits[2]));
+	seq_printf(seq, "\t\tgroups_considered: %llu\n",
+		   atomic64_read(&sbi->s_bal_cX_groups_considered[2]));
+	seq_printf(seq, "\t\tuseless_loops: %llu\n",
+		   atomic64_read(&sbi->s_bal_cX_failed[2]));
+
+	seq_puts(seq, "\tcr3_stats:\n");
+	seq_printf(seq, "\t\thits: %llu\n", atomic64_read(&sbi->s_bal_cX_hits[3]));
+	seq_printf(seq, "\t\tgroups_considered: %llu\n",
+		   atomic64_read(&sbi->s_bal_cX_groups_considered[3]));
+	seq_printf(seq, "\t\tuseless_loops: %llu\n",
+		   atomic64_read(&sbi->s_bal_cX_failed[3]));
+	seq_printf(seq, "\textents_scanned: %u\n", atomic_read(&sbi->s_bal_ex_scanned));
+	seq_printf(seq, "\t\tgoal_hits: %u\n", atomic_read(&sbi->s_bal_goals));
+	seq_printf(seq, "\t\t2^n_hits: %u\n", atomic_read(&sbi->s_bal_2orders));
+	seq_printf(seq, "\t\tbreaks: %u\n", atomic_read(&sbi->s_bal_breaks));
+	seq_printf(seq, "\t\tlost: %u\n", atomic_read(&sbi->s_mb_lost_chunks));
+
+	seq_printf(seq, "\tbuddies_generated: %u/%u\n",
+		   atomic_read(&sbi->s_mb_buddies_generated),
+		   ext4_get_groups_count(sb));
+	seq_printf(seq, "\tbuddies_time_used: %llu\n",
+		   atomic64_read(&sbi->s_mb_generation_time));
+	seq_printf(seq, "\tpreallocated: %u\n",
+		   atomic_read(&sbi->s_mb_preallocated));
+	seq_printf(seq, "\tdiscarded: %u\n",
+		   atomic_read(&sbi->s_mb_discarded));
+	return 0;
+}
+
 static struct kmem_cache *get_groupinfo_cache(int blocksize_bits)
 {
 	int cache_index = blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
@@ -2980,9 +3049,10 @@ int ext4_mb_release(struct super_block *sb)
 				atomic_read(&sbi->s_bal_reqs),
 				atomic_read(&sbi->s_bal_success));
 		ext4_msg(sb, KERN_INFO,
-		      "mballoc: %u extents scanned, %u goal hits, "
+		      "mballoc: %u extents scanned, %u groups scanned, %u goal hits, "
 				"%u 2^N hits, %u breaks, %u lost",
 				atomic_read(&sbi->s_bal_ex_scanned),
+				atomic_read(&sbi->s_bal_groups_scanned),
 				atomic_read(&sbi->s_bal_goals),
 				atomic_read(&sbi->s_bal_2orders),
 				atomic_read(&sbi->s_bal_breaks),
@@ -3620,12 +3690,13 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
-	if (sbi->s_mb_stats && ac->ac_g_ex.fe_len > 1) {
+	if (sbi->s_mb_stats && ac->ac_g_ex.fe_len >= 1) {
 		atomic_inc(&sbi->s_bal_reqs);
 		atomic_add(ac->ac_b_ex.fe_len, &sbi->s_bal_allocated);
 		if (ac->ac_b_ex.fe_len >= ac->ac_o_ex.fe_len)
 			atomic_inc(&sbi->s_bal_success);
 		atomic_add(ac->ac_found, &sbi->s_bal_ex_scanned);
+		atomic_add(ac->ac_groups_scanned, &sbi->s_bal_groups_scanned);
 		if (ac->ac_g_ex.fe_start == ac->ac_b_ex.fe_start &&
 				ac->ac_g_ex.fe_group == ac->ac_b_ex.fe_group)
 			atomic_inc(&sbi->s_bal_goals);
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index ce74cde6d8faa..b0bb4a92c9c94 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -539,6 +539,8 @@ int ext4_register_sysfs(struct super_block *sb)
 					ext4_fc_info_show, sb);
 		proc_create_seq_data("mb_groups", S_IRUGO, sbi->s_proc,
 				&ext4_mb_seq_groups_ops, sb);
+		proc_create_single_data("mb_stats", 0444, sbi->s_proc,
+				ext4_seq_mb_stats_show, sb);
 	}
 	return 0;
 }
-- 
2.39.2



