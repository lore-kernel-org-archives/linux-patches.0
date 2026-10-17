Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD663515CE;
	Sat, 17 Oct 2026 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257881; cv=none; b=KSNBXwIVvDvvCIvi7Zq0uSzA39luhw4sGxqjJvlHVII8kZpM2L5ZM5I9XtG53KwxIoJDxA3RxJ0aHK8kOQja632BfjAjVu4rYDfzdEqzDCbT8UtS13jo0Vnq7/R9u64a/FLRJkPbnEGmzKsMajtgRGtfEc6JBNfrxzHT5xxgg08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257881; c=relaxed/simple;
	bh=Ife3BqrW+VE/5E+E+ClWcm83XeCqD+Q5e4YZV/kMRJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQ9kqJQLLThmwdn1XAon+lSyaS5H1E535BPzTkBBYOEoOqygghToWZn6g6lIBkZ8eCpmtrZ+mQYvdc9tAdEi6eMXuK6n2vdS6kzZZvCoh4STfoBYrWuE1Ngw39eCPvI94imlgs4wiI9A5afYbT2yy35icNU+qt9Pw6WiUIXVJoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlNBLlun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlNBLlun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9921F000C4;
	Sat, 17 Oct 2026 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257879;
	bh=u3OPYEaVHMiQ6ZRmxLAQ6fBW2hbZMw8tjw6jBTEXbaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlNBLlunZdvfPgLVdPeopudYRLujAxZRpRs0+Z2uhEsYq97VCFzAU+eoxAiOktRol
	 azsiydGjuP2xzKenB5bnrmdgrOnJ0YRBUr4Xj0ckBbEKPa6E617B3z2S682vulSmkf
	 eLYVjnSQ61tVo1gVEi8Vrjhp17OEUfZPwU+SIaHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Kumar <maheshkumar657g@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0698/1674] ext4: avoid journaling sb update on error if journal is destroying
Date: Sat, 17 Oct 2026 17:49:30 +0200
Message-ID: <20261017160449.020029874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit ce2f26e73783b4a7c46a86e3af5b5c8de0971790 ]

Presently we always BUG_ON if trying to start a transaction on a journal marked
with JBD2_UNMOUNT, since this should never happen. However, while ltp running
stress tests, it was observed that in case of some error handling paths, it is
possible for update_super_work to start a transaction after the journal is
destroyed eg:

(umount)
ext4_kill_sb
  kill_block_super
    generic_shutdown_super
      sync_filesystem /* commits all txns */
      evict_inodes
        /* might start a new txn */
      ext4_put_super
	flush_work(&sbi->s_sb_upd_work) /* flush the workqueue */
        jbd2_journal_destroy
          journal_kill_thread
            journal->j_flags |= JBD2_UNMOUNT;
          jbd2_journal_commit_transaction
            jbd2_journal_get_descriptor_buffer
              jbd2_journal_bmap
                ext4_journal_bmap
                  ext4_map_blocks
                    ...
                    ext4_inode_error
                      ext4_handle_error
                        schedule_work(&sbi->s_sb_upd_work)

                                               /* work queue kicks in */
                                               update_super_work
                                                 jbd2_journal_start
                                                   start_this_handle
                                                     BUG_ON(journal->j_flags &
                                                            JBD2_UNMOUNT)

Hence, introduce a new mount flag to indicate journal is destroying and only do
a journaled (and deferred) update of sb if this flag is not set. Otherwise, just
fallback to an un-journaled commit.

Further, in the journal destroy path, we have the following sequence:

  1. Set mount flag indicating journal is destroying
  2. force a commit and wait for it
  3. flush pending sb updates

This sequence is important as it ensures that, after this point, there is no sb
update that might be journaled so it is safe to update the sb outside the
journal. (To avoid race discussed in 2d01ddc86606)

Also, we don't need a similar check in ext4_grp_locked_error since it is only
called from mballoc and AFAICT it would be always valid to schedule work here.

Fixes: 2d01ddc86606 ("ext4: save error info to sb through journal if available")
Reported-by: Mahesh Kumar <maheshkumar657g@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/9613c465d6ff00cd315602f99283d5f24018c3f7.1742279837.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h      |  3 ++-
 fs/ext4/ext4_jbd2.h | 15 +++++++++++++++
 fs/ext4/super.c     | 16 ++++++++--------
 3 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 387509da86a2a..d167cfb05dfc0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1816,7 +1816,8 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
  */
 enum {
 	EXT4_MF_MNTDIR_SAMPLED,
-	EXT4_MF_FC_INELIGIBLE	/* Fast commit ineligible */
+	EXT4_MF_FC_INELIGIBLE,	/* Fast commit ineligible */
+	EXT4_MF_JOURNAL_DESTROY	/* Journal is in process of destroying */
 };
 
 static inline void ext4_set_mount_flag(struct super_block *sb, int bit)
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 930778e507cc4..ada46189b0860 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -521,6 +521,21 @@ static inline int ext4_journal_destroy(struct ext4_sb_info *sbi, journal_t *jour
 {
 	int err = 0;
 
+	/*
+	 * At this point only two things can be operating on the journal.
+	 * JBD2 thread performing transaction commit and s_sb_upd_work
+	 * issuing sb update through the journal. Once we set
+	 * EXT4_JOURNAL_DESTROY, new ext4_handle_error() calls will not
+	 * queue s_sb_upd_work and ext4_force_commit() makes sure any
+	 * ext4_handle_error() calls from the running transaction commit are
+	 * finished. Hence no new s_sb_upd_work can be queued after we
+	 * flush it here.
+	 */
+	ext4_set_mount_flag(sbi->s_sb, EXT4_MF_JOURNAL_DESTROY);
+
+	ext4_force_commit(sbi->s_sb);
+	flush_work(&sbi->s_sb_upd_work);
+
 	err = jbd2_journal_destroy(journal);
 	sbi->s_journal = NULL;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32ee4c317583a..5d3b14744eeb0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -728,9 +728,13 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 		 * In case the fs should keep running, we need to writeout
 		 * superblock through the journal. Due to lock ordering
 		 * constraints, it may not be safe to do it right here so we
-		 * defer superblock flushing to a workqueue.
+		 * defer superblock flushing to a workqueue. We just need to be
+		 * careful when the journal is already shutting down. If we get
+		 * here in that case, just update the sb directly as the last
+		 * transaction won't commit anyway.
 		 */
-		if (continue_fs && journal)
+		if (continue_fs && journal &&
+		    !ext4_test_mount_flag(sb, EXT4_MF_JOURNAL_DESTROY))
 			schedule_work(&EXT4_SB(sb)->s_sb_upd_work);
 		else
 			ext4_commit_super(sb);
@@ -1311,7 +1315,6 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_unregister_li_request(sb);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 
-	flush_work(&sbi->s_sb_upd_work);
 	destroy_workqueue(sbi->rsv_conversion_wq);
 	ext4_release_orphan_info(sb);
 
@@ -1321,7 +1324,8 @@ static void ext4_put_super(struct super_block *sb)
 		if ((err < 0) && !aborted) {
 			ext4_abort(sb, -err, "Couldn't clean up the journal");
 		}
-	}
+	} else
+		flush_work(&sbi->s_sb_upd_work);
 
 	ext4_es_unregister_shrinker(sbi);
 	timer_shutdown_sync(&sbi->s_err_report);
@@ -4992,8 +4996,6 @@ static int ext4_load_and_init_journal(struct super_block *sb,
 	return 0;
 
 out:
-	/* flush s_sb_upd_work before destroying the journal. */
-	flush_work(&sbi->s_sb_upd_work);
 	ext4_journal_destroy(sbi, sbi->s_journal);
 	return -EINVAL;
 }
@@ -5682,8 +5684,6 @@ failed_mount8: __maybe_unused
 	sbi->s_ea_block_cache = NULL;
 
 	if (sbi->s_journal) {
-		/* flush s_sb_upd_work before journal destroy. */
-		flush_work(&sbi->s_sb_upd_work);
 		ext4_journal_destroy(sbi, sbi->s_journal);
 	}
 failed_mount3a:
-- 
2.53.0



