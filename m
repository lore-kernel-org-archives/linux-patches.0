Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137661C57B1;
	Tue, 15 Oct 2024 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993930; cv=none; b=cRkM2J7zXzh7bLezTWbRIV7SdBSJQ89WRc3r3S5sUgVuNjMKe32qwuyXxEq5W+098shqNNOK3dIv1Z8yGuxIvTbMSwO4p0rGj5/gFFOqeCFWNcaxxP5sleKKd29aFboQeH3IeyVD49KeS637G+kiz3gl3zgjj+oErXPRa/dQh68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993930; c=relaxed/simple;
	bh=p6lGES2ENT8YU7cDLEy5awUSUrZ+RlJohadn33+Dn/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT0+wMw3IeAT+7OBw586pm5O+682duAxgqk2hyd4ZYC7QoQx1URkYLLiI1Iqxw5eAY+bwETNf55atD3E+KGz4xwLzFhuBsdbjk0suPzMwI9wFuYFlbxmhC4OtOjRQGgnSOwuWmwzcATdYXlsFZ3b8TQ/Fc5cJhDMLYqGIWQUqf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8sSIhQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8sSIhQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7890AC4CEC6;
	Tue, 15 Oct 2024 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993930;
	bh=p6lGES2ENT8YU7cDLEy5awUSUrZ+RlJohadn33+Dn/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8sSIhQOrtJ4rq1gUjE/ELxlD9whoFohmBPltKPTOkgEm7ogCbatQzXi9FJcacGuT
	 TH8zpitm1fFXX6ab5VhdvplKt/M3dhoyCoBMPMj/QeQQlmQ/PsaSlEVdkWutKTbLro
	 +UFikChyTax+ecsieO2lACRUmehnrEbDuru65LB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 515/691] ext4: use handle to mark fc as ineligible in __track_dentry_update()
Date: Tue, 15 Oct 2024 13:27:43 +0200
Message-ID: <20241015112500.785780442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
@@ -344,7 +344,7 @@ void ext4_fc_mark_ineligible(struct supe
  */
 static int ext4_fc_track_template(
 	handle_t *handle, struct inode *inode,
-	int (*__fc_track_fn)(struct inode *, void *, bool),
+	int (*__fc_track_fn)(handle_t *handle, struct inode *, void *, bool),
 	void *args, int enqueue)
 {
 	bool update = false;
@@ -361,7 +361,7 @@ static int ext4_fc_track_template(
 		ext4_fc_reset_inode(inode);
 		ei->i_sync_tid = tid;
 	}
-	ret = __fc_track_fn(inode, args, update);
+	ret = __fc_track_fn(handle, inode, args, update);
 	mutex_unlock(&ei->i_fc_lock);
 
 	if (!enqueue)
@@ -385,7 +385,8 @@ struct __track_dentry_update_args {
 };
 
 /* __track_fn for directory entry updates. Called with ei->i_fc_lock. */
-static int __track_dentry_update(struct inode *inode, void *arg, bool update)
+static int __track_dentry_update(handle_t *handle, struct inode *inode,
+				 void *arg, bool update)
 {
 	struct ext4_fc_dentry_update *node;
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -400,14 +401,14 @@ static int __track_dentry_update(struct
 
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
@@ -419,7 +420,7 @@ static int __track_dentry_update(struct
 		node->fcd_name.name = kmalloc(dentry->d_name.len, GFP_NOFS);
 		if (!node->fcd_name.name) {
 			kmem_cache_free(ext4_fc_dentry_cachep, node);
-			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, handle);
 			mutex_lock(&ei->i_fc_lock);
 			return -ENOMEM;
 		}
@@ -533,7 +534,8 @@ void ext4_fc_track_create(handle_t *hand
 }
 
 /* __track_fn for inode tracking */
-static int __track_inode(struct inode *inode, void *arg, bool update)
+static int __track_inode(handle_t *handle, struct inode *inode, void *arg,
+			 bool update)
 {
 	if (update)
 		return -EEXIST;
@@ -573,7 +575,8 @@ struct __track_range_args {
 };
 
 /* __track_fn for tracking data updates */
-static int __track_range(struct inode *inode, void *arg, bool update)
+static int __track_range(handle_t *handle, struct inode *inode, void *arg,
+			 bool update)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	ext4_lblk_t oldstart;


