Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217086;
	b=gM9QrpxJluhJLHZ5nSHqHvTqQ0QnKba99AHkY/1+MxKpAG+fqTCv1mYY/2uOLQNGiBJO
	 IWeN3UUlTmYZBN6OcsOIDq4SzjzCb/2HcAn3QwcAq08HjjLjtWYQtThxXmj4w8jA3wE2j
	 OQf8zpxOpjNIZw/Oqk3pOL4jMBOV+U4L3udspL0bbS7Hez5e4tZyNac8AF0FOiUVoHu9E
	 CF/q/i9JpHaNLX+jVdWo0RMNfjJGlpxV19vSzvsBcfBRRpI37H3hJeP2WK5a34F9XDgsY
	 WOqWVOEURLI2fbU0sev4Lsrp3yIG61kBXjJjsfrhsHoM3AWzzkNg43sVxQcBG2TQqWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Qk2oyYCdrzeAFTcQMX81uIvqteiFrxUrZx1TqboQCs=;
	b=RNj8HIStmU+W9ALDDBFJzhlNJ9c+4OId4CPQNrcUk/Cqe2l8hNcw1F+Pkn/jxq4CDg0h
	 fsvxlEoT858NQ+q8b9yEiNvkH1EETtyFWT9GUWoLgI/+QdXjKt5fvke7GiymMVejeHulu
	 pVzLioMT6tFuvAq7xD3B6JGUEy1uDSaTRLmah+RICrjz+Pfd2mnzguT0LJz0JA/C3U7Mj
	 YiFORwVT844HedpYJxVfPLdaQ4CDssxuV0hOTVA1ddQt75rtFgt59DUeuskCPTjdDievI
	 F7bmhjVwmC/qEkW6Pb4bpycJq3ZnbE/hB9hpxVIOfXSSrcambsBP0/OH/fCfe5EHwkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Eu3WN+/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE1C606A323;
	Wed, 28 Oct 2026 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eu3WN+/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02CD1F01828;
	Wed, 28 Oct 2026 19:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217085;
	bh=7Qk2oyYCdrzeAFTcQMX81uIvqteiFrxUrZx1TqboQCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eu3WN+/BdahlNwUZaAvuq95fm0l3QeFMBkApS9mOChYDC73m+K1RZBNQ03j3M6ChS
	 0XI520nKtU88SeCJp+WMtnPK7RFLp1DdtVzkgLr1rGXlxQrcjvsuHDI29jDA/jXIpf
	 hKp4JTV0QzSwLGN1m1OnmxcZv8sgIX0oCKuorDcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1781/1887] ext4: free the sbi after a grace period
Date: Wed, 28 Oct 2026 18:04:37 +0100
Message-ID: <20261028170539.979829101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced shrinker_free() with unregister_shrinker() for the embedded shrinker ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h           |  2 ++
 fs/ext4/extents_status.c |  7 ++++++-
 fs/ext4/extents_status.h |  1 +
 fs/ext4/super.c          | 13 +++++++++++--
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5ef489c9e73af..ae786abecc9a2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1688,6 +1688,8 @@ struct ext4_sb_info {
 	struct list_head s_es_list;	/* List of inodes with reclaimable extents */
 	long s_es_nr_inode;
 	struct ext4_es_stats s_es_stats;
+	/* ext4_get_link() reads the sbi in rcu pathwalk */
+	struct rcu_head s_rcu;
 	struct mb_cache *s_ea_block_cache;
 	struct mb_cache *s_ea_inode_cache;
 	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 592229027af72..3744d49ef2856 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1751,12 +1751,17 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 }
 
 void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
+{
+	unregister_shrinker(&sbi->s_es_shrinker);
+}
+
+/* ext4_get_link() bumps the hit and miss counters in rcu pathwalk */
+void ext4_es_destroy_stats(struct ext4_sb_info *sbi)
 {
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_hits);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_misses);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
-	unregister_shrinker(&sbi->s_es_shrinker);
 }
 
 /*
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 481ec4381bee6..8a03771269b69 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -241,6 +241,7 @@ static inline void ext4_es_store_pblock_status(struct extent_status *es,
 
 extern int ext4_es_register_shrinker(struct ext4_sb_info *sbi);
 extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
+extern void ext4_es_destroy_stats(struct ext4_sb_info *sbi);
 
 extern int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 828cbf2da05cb..fa6d9260030aa 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1260,6 +1260,14 @@ static void ext4_flex_groups_free(struct ext4_sb_info *sbi)
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
@@ -1344,7 +1352,6 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_stop_mmpd(sbi);
 
 	brelse(sbi->s_sbh);
-	sb->s_fs_info = NULL;
 	/*
 	 * Now that we are completely done shutting down the
 	 * superblock, we need to actually destroy the kobject.
@@ -1359,7 +1366,8 @@ static void ext4_put_super(struct super_block *sb)
 #if IS_ENABLED(CONFIG_UNICODE)
 	utf8_unload(sb->s_encoding);
 #endif
-	kfree(sbi);
+	/* ext4_get_link() reads the sbi and the counters in rcu pathwalk */
+	call_rcu(&sbi->s_rcu, ext4_put_sbi_rcu);
 }
 
 static struct kmem_cache *ext4_inode_cachep;
@@ -5640,6 +5648,7 @@ failed_mount8: __maybe_unused
 	}
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
+	ext4_es_destroy_stats(sbi);
 failed_mount3:
 	/* flush s_error_work before sbi destroy */
 	flush_work(&sbi->s_error_work);
-- 
2.53.0



