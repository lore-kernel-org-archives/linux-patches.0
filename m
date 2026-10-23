Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774187;
	b=kyKkYs46brl37nA1w/CEDdzFPLSMWS24+Wa2ey0p2wJiz5jVFtnjto009lS03g46Rt2F
	 JVarApk70mFKp3ljrKnqi0mnCsHqdXZUp5G/iGPCTPYXsT71RsiLAmdqqOLnLbu8ZgBE1
	 saJ89Ib0VT0OAIh+mh8n9aApsNRqc5bW5pnNvaCTc4UBU/BEu+dP0rCAeuWovFDW6jVqZ
	 8P9GsKGVh6PcmnMeQPPpfm1hdAA3x41kr/4WN8Sr+n3BAePa+MtyTbEyb99vEjPaCI/Og
	 KkqetstdxJtkUYNf49bskN9aldatnmtUDbSMlWFyzgn1Jkjft+MZOy+6G+W3D1/DbZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m3ke85kFoDIvt+1g5tHl5257lecs1Li9VdGvqYA6Zd0=;
	b=s6oAny1J4hM1Ecgk5X8Sq9625wmZFAY+M4PnsDjTJIXMgwiUQsZEfcbQ0rIXOZEyQcKK
	 RTw6cxXY4c9jh0ph6IHqXf6zKBazM+2W0z7fyIfb5dnpY8B1AEyun5toqCjcAWxxh6mbS
	 mAslZFu3UuqaFAcohOT5+vd8iY9W8UfJl2oMCFhQv8Yy/hqCm4b8ZunYOQwBsDPRtIURN
	 c9BNmFySvGnL5/t7N8bKYXontrLJxBpw4GSQ1XGkD2ZLnIyN8sa8qI1Ay6Tjtp7GMZZ7b
	 UnS2H4xiebwEeg8c23IUlN+QZd4nNeaWV4Vwdigw9O7qk+x/NSyiys+qlSgeUlMXS6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uI7Zgxrf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3922F60A2618;
	Fri, 23 Oct 2026 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uI7Zgxrf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889FA1F031E0;
	Fri, 23 Oct 2026 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774187;
	bh=m3ke85kFoDIvt+1g5tHl5257lecs1Li9VdGvqYA6Zd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uI7ZgxrfDJjS7u5Wrq1HJoP8xT3EVXx7XDZuo2DgEvIYM9dZwV5AoXyLlvH/lwMox
	 ROTDE0b1UVPDH7BrAQOB0h8VfjQLqk3MXGUIPVYuWTMxF2HSIT1SkSbDXf94C3DgaP
	 dIRxpp26XtS210cZ8Jqr7LZkwifqZDFKYah9eZRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/193] ext4: free the sbi after a grace period
Date: Fri, 23 Oct 2026 18:37:08 +0200
Message-ID: <20261023163717.783788425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit c17b44266a1f9fcb49b894d4611d1254bf1aa313 ]

ext4_get_link() follows a symlink that keeps its target in a data block
in rcu pathwalk mode with ext4_getblk(EXT4_GET_BLOCKS_CACHED_NOWAIT).
That reads s_mount_state in the ASSERT() of ext4_getblk() and again in
ext4_es_lookup_extent(), and the lookup bumps the extent status hit or
miss counter, all through sb->s_fs_info.

ext4_put_super() destroys those counters, clears sb->s_fs_info and frees
the sbi without waiting for a grace period. A pathwalk that is still in
ext4_get_link() when the last reference to the mount goes away then
dereferences a NULL s_fs_info, the freed sbi or the destroyed percpu
counters.

With a pathwalk held up in ext4_get_link() while the last reference
goes away:

  KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
  RIP: 0010:ext4_getblk+0xf0/0x640
  Call Trace:
   <TASK>
   ext4_get_link+0x26c/0x410
   pick_link+0xf96/0x1780
   step_into_slowpath+0x9b8/0x1250
   path_lookupat+0x484/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
   vfs_fstatat+0x4d/0x90
   __do_sys_newfstatat+0xa0/0x100
   do_syscall_64+0x10e/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

So far that has been hard to hit. umount(2) waits for a grace period in
namespace_unlock() before it drops the mount, so only a mount whose last
reference goes away elsewhere, like the close of a file or a chdir out of
a lazily unmounted directory, can race a walker.

Keep sb->s_fs_info and free the sbi together with the extent status
counters after a grace period. Split the counters out of
ext4_es_unregister_shrinker() for that. The shrinker still gets wasted
in ext4_put_super(), the counters go with the sbi.

Fixes: 6493792d3299 ("ext4: convert symlink external data block mapping to bdev")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-1-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Omitted changes tied to absent extent KUnit tests. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h           |    2 ++
 fs/ext4/extents_status.c |    7 ++++++-
 fs/ext4/extents_status.h |    1 +
 fs/ext4/super.c          |   13 +++++++++++--
 4 files changed, 20 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1694,6 +1694,8 @@ struct ext4_sb_info {
 	struct list_head s_es_list;	/* List of inodes with reclaimable extents */
 	long s_es_nr_inode;
 	struct ext4_es_stats s_es_stats;
+	/* ext4_get_link() reads the sbi in rcu pathwalk */
+	struct rcu_head s_rcu;
 	struct mb_cache *s_ea_block_cache;
 	struct mb_cache *s_ea_inode_cache;
 	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1797,11 +1797,16 @@ err1:
 
 void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 {
+	shrinker_free(sbi->s_es_shrinker);
+}
+
+/* ext4_get_link() bumps the hit and miss counters in rcu pathwalk */
+void ext4_es_destroy_stats(struct ext4_sb_info *sbi)
+{
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_hits);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_misses);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
-	shrinker_free(sbi->s_es_shrinker);
 }
 
 /*
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -238,6 +238,7 @@ static inline void ext4_es_store_pblock_
 
 extern int ext4_es_register_shrinker(struct ext4_sb_info *sbi);
 extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
+extern void ext4_es_destroy_stats(struct ext4_sb_info *sbi);
 
 extern int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v);
 
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1268,6 +1268,14 @@ static void ext4_flex_groups_free(struct
 	}
 }
 
+static void ext4_put_sbi_rcu(struct rcu_head *head)
+{
+	struct ext4_sb_info *sbi = container_of(head, struct ext4_sb_info, s_rcu);
+
+	ext4_es_destroy_stats(sbi);
+	kfree(sbi);
+}
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1361,7 +1369,6 @@ static void ext4_put_super(struct super_
 	ext4_stop_mmpd(sbi);
 
 	brelse(sbi->s_sbh);
-	sb->s_fs_info = NULL;
 	/*
 	 * Now that we are completely done shutting down the
 	 * superblock, we need to actually destroy the kobject.
@@ -1374,7 +1381,8 @@ static void ext4_put_super(struct super_
 #if IS_ENABLED(CONFIG_UNICODE)
 	utf8_unload(sb->s_encoding);
 #endif
-	kfree(sbi);
+	/* ext4_get_link() reads the sbi and the counters in rcu pathwalk */
+	call_rcu(&sbi->s_rcu, ext4_put_sbi_rcu);
 }
 
 static struct kmem_cache *ext4_inode_cachep;
@@ -5692,6 +5700,7 @@ failed_mount_wq:
 	}
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
+	ext4_es_destroy_stats(sbi);
 failed_mount3:
 	/* flush s_sb_upd_work before sbi destroy */
 	flush_work(&sbi->s_sb_upd_work);


