Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D972D4D991D;
	Tue, 21 Jul 2026 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656272; cv=none; b=RGIxqDD3X9qIO/kxzXikgrfEXTF+b2b0BPTFEHs5x1Y1T2HMQDDcaUlcSkNIOuWverVlB/t6qMBsdAk2oT45h0hPqBJbkU9B32c6cWUTh6xcKOwddesxsQZZcFUXDnNZ8Jl1nLQKjARNwLxU7umw3pJfDEJaaPzkkfwnSibZf3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656272; c=relaxed/simple;
	bh=vYIcD0+BsShWCWABq4c2zRvSc2AqGRD4K8+BLEFfDh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+Fu4cJYbOdOmb8SASWh287/9autwqufFHEpreMSyABTbLx+HKdw4+tkkktLfsX8Vm2GCDNmkEFSGBYCIzqn0Ch2Mvu1s4fQueOjqxUxKiuDrqaq/UrDW03tWHA+gI7FsWEHTt/UlEn1ZlefQtq57UVnIorvj4FaYK8MFGGstzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f02Izfg+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f02Izfg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCBA1F000E9;
	Tue, 21 Jul 2026 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656270;
	bh=jdJ5+OAsWAhLxpaLjaoVDSjacY20Dp4zlflUb6Sxx4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f02Izfg+Ld0Mg13zPeMbyJyCo9WMo6MifBl93IY8MBoK9edVIGaEwN0qDWX+R79Co
	 uqed8bUWP2/hpvlZJLSk/6xXexD1OA+97MOANfUBcNsljrVqA9BsHJfNMlXEaj+j0j
	 S5P/fVzkyp+ZE/DTBGs0TXP19kMyzirYgV9YvvzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Li Chen <chenl311@chinatelecom.cn>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0322/1611] ext4: fix fast commit wait/wake bit mapping on 64-bit
Date: Tue, 21 Jul 2026 17:07:18 +0200
Message-ID: <20260721152522.329456394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Li Chen <me@linux.beauty>

[ Upstream commit 8b3bc93fee6771775243665a0cf31857d6659775 ]

On 64-bit, ext4 dynamic inode states live in the upper half of i_flags,
and ext4_test_inode_state() applies the corresponding +32 offset.

The fast-commit wait and wake paths open-coded the wait key with the raw
EXT4_STATE_* value. Add small helpers for the state wait word and bit,
and use them for the FC_COMMITTING and FC_FLUSHING_DATA waits so the wait
key follows the same mapping as the state helpers.

Fixes: 857d32f26181 ("ext4: rework fast commit commit path")
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260513085818.552432-1-me@linux.beauty
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h        | 20 +++++++++++++++++
 fs/ext4/fast_commit.c | 50 ++++++++++++++++---------------------------
 2 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9bf82b568cfe23..54be698b9a1c18 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1990,6 +1990,8 @@ EXT4_INODE_BIT_FNS(flag, flags, 0)
 static inline int ext4_test_inode_state(struct inode *inode, int bit);
 static inline void ext4_set_inode_state(struct inode *inode, int bit);
 static inline void ext4_clear_inode_state(struct inode *inode, int bit);
+static inline unsigned long *ext4_inode_state_wait_word(struct inode *inode);
+static inline int ext4_inode_state_wait_bit(int bit);
 #if (BITS_PER_LONG < 64)
 EXT4_INODE_BIT_FNS(state, state_flags, 0)
 
@@ -2005,6 +2007,24 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 	/* We depend on the fact that callers will set i_flags */
 }
 #endif
+
+static inline unsigned long *ext4_inode_state_wait_word(struct inode *inode)
+{
+#if (BITS_PER_LONG < 64)
+	return &EXT4_I(inode)->i_state_flags;
+#else
+	return &EXT4_I(inode)->i_flags;
+#endif
+}
+
+static inline int ext4_inode_state_wait_bit(int bit)
+{
+#if (BITS_PER_LONG < 64)
+	return bit;
+#else
+	return bit + 32;
+#endif
+}
 #else
 /* Assume that user mode programs are passing in an ext4fs superblock, not
  * a kernel struct super_block.  This will allow us to call the feature-test
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index bab522ca1573df..2c4e628acb8d13 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -233,6 +233,8 @@ void ext4_fc_del(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_dentry_update *fc_dentry;
 	wait_queue_head_t *wq;
+	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
+	int wait_bit = ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
 	int alloc_ctx;
 
 	if (ext4_fc_disabled(inode->i_sb))
@@ -262,17 +264,9 @@ void ext4_fc_del(struct inode *inode)
 	WARN_ON(ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)
 		&& !ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE));
 	while (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
-#if (BITS_PER_LONG < 64)
-		DEFINE_WAIT_BIT(wait, &ei->i_state_flags,
-				EXT4_STATE_FC_FLUSHING_DATA);
-		wq = bit_waitqueue(&ei->i_state_flags,
-				   EXT4_STATE_FC_FLUSHING_DATA);
-#else
-		DEFINE_WAIT_BIT(wait, &ei->i_flags,
-				EXT4_STATE_FC_FLUSHING_DATA);
-		wq = bit_waitqueue(&ei->i_flags,
-				   EXT4_STATE_FC_FLUSHING_DATA);
-#endif
+		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
+
+		wq = bit_waitqueue(wait_word, wait_bit);
 		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
 		if (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
 			ext4_fc_unlock(inode->i_sb, alloc_ctx);
@@ -552,6 +546,8 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	wait_queue_head_t *wq;
+	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
+	int wait_bit = ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
 	int ret;
 
 	if (S_ISDIR(inode->i_mode))
@@ -577,17 +573,9 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 	lockdep_assert_not_held(&ei->i_data_sem);
 
 	while (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)) {
-#if (BITS_PER_LONG < 64)
-		DEFINE_WAIT_BIT(wait, &ei->i_state_flags,
-				EXT4_STATE_FC_COMMITTING);
-		wq = bit_waitqueue(&ei->i_state_flags,
-				   EXT4_STATE_FC_COMMITTING);
-#else
-		DEFINE_WAIT_BIT(wait, &ei->i_flags,
-				EXT4_STATE_FC_COMMITTING);
-		wq = bit_waitqueue(&ei->i_flags,
-				   EXT4_STATE_FC_COMMITTING);
-#endif
+		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
+
+		wq = bit_waitqueue(wait_word, wait_bit);
 		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
 		if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING))
 			schedule();
@@ -1050,6 +1038,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	int ret = 0;
 	u32 crc = 0;
 	int alloc_ctx;
+	int flushing_wait_bit =
+		ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
 
 	/*
 	 * Step 1: Mark all inodes on s_fc_q[MAIN] with
@@ -1075,11 +1065,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		ext4_clear_inode_state(&iter->vfs_inode,
 				       EXT4_STATE_FC_FLUSHING_DATA);
-#if (BITS_PER_LONG < 64)
-		wake_up_bit(&iter->i_state_flags, EXT4_STATE_FC_FLUSHING_DATA);
-#else
-		wake_up_bit(&iter->i_flags, EXT4_STATE_FC_FLUSHING_DATA);
-#endif
+		wake_up_bit(ext4_inode_state_wait_word(&iter->vfs_inode),
+			    flushing_wait_bit);
 	}
 
 	/*
@@ -1295,6 +1282,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 	struct ext4_inode_info *ei;
 	struct ext4_fc_dentry_update *fc_dentry;
 	int alloc_ctx;
+	int committing_wait_bit =
+		ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
 
 	if (full && sbi->s_fc_bh)
 		sbi->s_fc_bh = NULL;
@@ -1331,11 +1320,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 		 * barrier in prepare_to_wait() in ext4_fc_track_inode().
 		 */
 		smp_mb();
-#if (BITS_PER_LONG < 64)
-		wake_up_bit(&ei->i_state_flags, EXT4_STATE_FC_COMMITTING);
-#else
-		wake_up_bit(&ei->i_flags, EXT4_STATE_FC_COMMITTING);
-#endif
+		wake_up_bit(ext4_inode_state_wait_word(&ei->vfs_inode),
+			    committing_wait_bit);
 	}
 
 	while (!list_empty(&sbi->s_fc_dentry_q[FC_Q_MAIN])) {
-- 
2.53.0



