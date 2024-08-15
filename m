Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2C619E7F5;
	Thu, 15 Aug 2024 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729495; cv=none; b=dnqfFDVhRkFLx7m5BrbbQIWQJZsc5y1DBY/pBJjRAR+ffnRQh0lDD/80nadFazyR7xWvDwzcPm4rNvRFwXOuSqbWMKIwdxAr8VMrRjJ3MZ2bO+hZN3rGu4Rv5rWgYTi1R8KMchGBIF3dSBUKPFJjq72LKBmSJQsZRPH40ObfB2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729495; c=relaxed/simple;
	bh=5qcV8SMpjCNqPONjJsxCpj5Bo8niZG7Dzy4pCIjpQ90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlCqW7Vcc7CaEVfYqm28ViM+b8zciveQ9RHblEqfHk/PR4JSx4GsKXa+IdP1OWStgguMYOYZ/l5YoxxUPT9fEbwdw3stOR1BipM47hPZMDTaJXmtYQHfRkG8tlQg8fNlTI/xQyw9DHgUsn3lL/xGnxfZfMPWPLyb4PJ7lbBrnv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+cF89pB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+cF89pB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801AAC4AF0A;
	Thu, 15 Aug 2024 13:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729495;
	bh=5qcV8SMpjCNqPONjJsxCpj5Bo8niZG7Dzy4pCIjpQ90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+cF89pBoC9BSYPO0kVDIl4+YKzjCu7St0GcmPSKkkBuh2M0xkGagYJcyqxTJU0Je
	 VmHDsEObsmJK2oMTBLt6MLS1+KGFwGuxvq9E4Gz0ZVvNsnzUST7G6KpmVmDTQAuPYg
	 3t9uxX3XtPzSxqv9WPGrUWzdb3Ci6qqJzj6AF0iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritesh Harjani <riteshh@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/484] ext4: return early for non-eligible fast_commit track events
Date: Thu, 15 Aug 2024 15:19:33 +0200
Message-ID: <20240815131945.734121705@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ritesh Harjani <riteshh@linux.ibm.com>

[ Upstream commit 78be0471da4e9fff874307d73d68f0173fa6a154 ]

Currently ext4_fc_track_template() checks, whether the trace event
path belongs to replay or does sb has ineligible set, if yes it simply
returns. This patch pulls those checks before calling
ext4_fc_track_template() in the callers of ext4_fc_track_template().

[ Add checks to ext4_rename() which calls the __ext4_fc_track_*()
  functions directly. -- TYT ]

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/3cd025d9c490218a92e6d8fb30b6123e693373e3.1647057583.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 7882b0187bbe ("ext4: don't track ranges in fast_commit if inode has inlined data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fast_commit.c | 59 +++++++++++++++++++++++++++++++++++--------
 fs/ext4/namei.c       | 15 ++++++++---
 2 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 2660c34c770e3..c6814edf0ce0a 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -353,13 +353,6 @@ static int ext4_fc_track_template(
 	tid_t tid = 0;
 	int ret;
 
-	if (!test_opt2(inode->i_sb, JOURNAL_FAST_COMMIT) ||
-	    (sbi->s_mount_state & EXT4_FC_REPLAY))
-		return -EOPNOTSUPP;
-
-	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
-		return -EINVAL;
-
 	tid = handle->h_transaction->t_tid;
 	mutex_lock(&ei->i_fc_lock);
 	if (tid == ei->i_sync_tid) {
@@ -468,7 +461,17 @@ void __ext4_fc_track_unlink(handle_t *handle,
 
 void ext4_fc_track_unlink(handle_t *handle, struct dentry *dentry)
 {
-	__ext4_fc_track_unlink(handle, d_inode(dentry), dentry);
+	struct inode *inode = d_inode(dentry);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	if (!test_opt2(inode->i_sb, JOURNAL_FAST_COMMIT) ||
+	    (sbi->s_mount_state & EXT4_FC_REPLAY))
+		return;
+
+	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
+		return;
+
+	__ext4_fc_track_unlink(handle, inode, dentry);
 }
 
 void __ext4_fc_track_link(handle_t *handle,
@@ -487,7 +490,17 @@ void __ext4_fc_track_link(handle_t *handle,
 
 void ext4_fc_track_link(handle_t *handle, struct dentry *dentry)
 {
-	__ext4_fc_track_link(handle, d_inode(dentry), dentry);
+	struct inode *inode = d_inode(dentry);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	if (!test_opt2(inode->i_sb, JOURNAL_FAST_COMMIT) ||
+	    (sbi->s_mount_state & EXT4_FC_REPLAY))
+		return;
+
+	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
+		return;
+
+	__ext4_fc_track_link(handle, inode, dentry);
 }
 
 void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
@@ -506,7 +519,17 @@ void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
 
 void ext4_fc_track_create(handle_t *handle, struct dentry *dentry)
 {
-	__ext4_fc_track_create(handle, d_inode(dentry), dentry);
+	struct inode *inode = d_inode(dentry);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	if (!test_opt2(inode->i_sb, JOURNAL_FAST_COMMIT) ||
+	    (sbi->s_mount_state & EXT4_FC_REPLAY))
+		return;
+
+	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
+		return;
+
+	__ext4_fc_track_create(handle, inode, dentry);
 }
 
 /* __track_fn for inode tracking */
@@ -522,6 +545,7 @@ static int __track_inode(struct inode *inode, void *arg, bool update)
 
 void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int ret;
 
 	if (S_ISDIR(inode->i_mode))
@@ -533,6 +557,13 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 		return;
 	}
 
+	if (!test_opt2(inode->i_sb, JOURNAL_FAST_COMMIT) ||
+	    (sbi->s_mount_state & EXT4_FC_REPLAY))
+		return;
+
+	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
+		return;
+
 	ret = ext4_fc_track_template(handle, inode, __track_inode, NULL, 1);
 	trace_ext4_fc_track_inode(inode, ret);
 }
@@ -572,12 +603,20 @@ static int __track_range(struct inode *inode, void *arg, bool update)
 void ext4_fc_track_range(handle_t *handle, struct inode *inode, ext4_lblk_t start,
 			 ext4_lblk_t end)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct __track_range_args args;
 	int ret;
 
 	if (S_ISDIR(inode->i_mode))
 		return;
 
+	if (!test_opt2(inode->i_sb, JOURNAL_FAST_COMMIT) ||
+	    (sbi->s_mount_state & EXT4_FC_REPLAY))
+		return;
+
+	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
+		return;
+
 	args.start = start;
 	args.end = end;
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e9501fb28477b..eb32cd1e74773 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -4011,12 +4011,19 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		ext4_fc_mark_ineligible(old.inode->i_sb,
 			EXT4_FC_REASON_RENAME_DIR, handle);
 	} else {
+		struct super_block *sb = old.inode->i_sb;
+
 		if (new.inode)
 			ext4_fc_track_unlink(handle, new.dentry);
-		__ext4_fc_track_link(handle, old.inode, new.dentry);
-		__ext4_fc_track_unlink(handle, old.inode, old.dentry);
-		if (whiteout)
-			__ext4_fc_track_create(handle, whiteout, old.dentry);
+		if (test_opt2(sb, JOURNAL_FAST_COMMIT) &&
+		    !(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY) &&
+		    !(ext4_test_mount_flag(sb, EXT4_MF_FC_INELIGIBLE))) {
+			__ext4_fc_track_link(handle, old.inode, new.dentry);
+			__ext4_fc_track_unlink(handle, old.inode, old.dentry);
+			if (whiteout)
+				__ext4_fc_track_create(handle, whiteout,
+						       old.dentry);
+		}
 	}
 
 	if (new.inode) {
-- 
2.43.0



