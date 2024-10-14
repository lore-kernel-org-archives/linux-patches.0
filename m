Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A5719E98B;
	Mon, 14 Oct 2024 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919251; cv=none; b=k26KdzsKDYnnHhKdLtkwwLlz9Ygzzn5gqH3o1tL6tiskUy7RII4YodBZz4srJ0Qp8mFe9H+GfmKbs0ixW8pmwvB9T5fM/XWnQSMECjtuEj1XMlLa3w8qtnuZ8/OH+Z6ovLDE6xqBIxkMNz8t8W6rcNOofK6mx+e4OYcIvQPb/YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919251; c=relaxed/simple;
	bh=VVLghEOOhk4lPtbrHmO00zqsI+dJZYu7vFf1UKeKH8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRYfGWdXrIZadkQgulJZkgq8qSEnFHlQ2wfgpABbB8/K12RcEBPb+S/MoTU019IsE0+yR2d0IAcH4vkY30SE+uoMO0ub/rjpCic9DN1QaR6CAXXxZN2knwacW3op5/tFVTGg95VccWS1Flj4sKfTdtbE8erQs3tyw08GQVqP5kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLp0xx5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLp0xx5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA519C4CEC3;
	Mon, 14 Oct 2024 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919251;
	bh=VVLghEOOhk4lPtbrHmO00zqsI+dJZYu7vFf1UKeKH8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLp0xx5Gx64jW6lS3VpXOrNIQh7GbpfgxJ8u0OSXp1o2HmFGbklxh8af8yXDsfbLU
	 +hNKHznU7YZZFekhNKkLi66bzrqJLVUc1JfaAhD6yAAcZ1Lz1sjIopM+9IMVJw8eY+
	 tKokxmACP9sDdvazFqyGUnlnhCelnrycS431GrQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 555/798] ext4: use handle to mark fc as ineligible in __track_dentry_update()
Date: Mon, 14 Oct 2024 16:18:29 +0200
Message-ID: <20241014141239.799384733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit faab35a0370fd6e0821c7a8dd213492946fc776f upstream.

Calling ext4_fc_mark_ineligible() with a NULL handle is racy and may result
in a fast-commit being done before the filesystem is effectively marked as
ineligible.  This patch fixes the calls to this function in
__track_dentry_update() by adding an extra parameter to the callback used in
ext4_fc_track_template().

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240923104909.18342-2-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -379,7 +379,7 @@ void ext4_fc_mark_ineligible(struct supe
  */
 static int ext4_fc_track_template(
 	handle_t *handle, struct inode *inode,
-	int (*__fc_track_fn)(struct inode *, void *, bool),
+	int (*__fc_track_fn)(handle_t *handle, struct inode *, void *, bool),
 	void *args, int enqueue)
 {
 	bool update = false;
@@ -396,7 +396,7 @@ static int ext4_fc_track_template(
 		ext4_fc_reset_inode(inode);
 		ei->i_sync_tid = tid;
 	}
-	ret = __fc_track_fn(inode, args, update);
+	ret = __fc_track_fn(handle, inode, args, update);
 	mutex_unlock(&ei->i_fc_lock);
 
 	if (!enqueue)
@@ -420,7 +420,8 @@ struct __track_dentry_update_args {
 };
 
 /* __track_fn for directory entry updates. Called with ei->i_fc_lock. */
-static int __track_dentry_update(struct inode *inode, void *arg, bool update)
+static int __track_dentry_update(handle_t *handle, struct inode *inode,
+				 void *arg, bool update)
 {
 	struct ext4_fc_dentry_update *node;
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -435,14 +436,14 @@ static int __track_dentry_update(struct
 
 	if (IS_ENCRYPTED(dir)) {
 		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_ENCRYPTED_FILENAME,
-					NULL);
+					handle);
 		mutex_lock(&ei->i_fc_lock);
 		return -EOPNOTSUPP;
 	}
 
 	node = kmem_cache_alloc(ext4_fc_dentry_cachep, GFP_NOFS);
 	if (!node) {
-		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, handle);
 		mutex_lock(&ei->i_fc_lock);
 		return -ENOMEM;
 	}
@@ -454,7 +455,7 @@ static int __track_dentry_update(struct
 		node->fcd_name.name = kmalloc(dentry->d_name.len, GFP_NOFS);
 		if (!node->fcd_name.name) {
 			kmem_cache_free(ext4_fc_dentry_cachep, node);
-			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, handle);
 			mutex_lock(&ei->i_fc_lock);
 			return -ENOMEM;
 		}
@@ -576,7 +577,8 @@ void ext4_fc_track_create(handle_t *hand
 }
 
 /* __track_fn for inode tracking */
-static int __track_inode(struct inode *inode, void *arg, bool update)
+static int __track_inode(handle_t *handle, struct inode *inode, void *arg,
+			 bool update)
 {
 	if (update)
 		return -EEXIST;
@@ -614,7 +616,8 @@ struct __track_range_args {
 };
 
 /* __track_fn for tracking data updates */
-static int __track_range(struct inode *inode, void *arg, bool update)
+static int __track_range(handle_t *handle, struct inode *inode, void *arg,
+			 bool update)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	ext4_lblk_t oldstart;


