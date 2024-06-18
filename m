Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4F1581F8;
	Tue, 18 Jun 2024 13:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716003; cv=none; b=QyQBkL5zLOAyhv5VM/YVYw2scDLTLf8+MABCdmSVB6nzDLzmnOxhXyfEMX/bGnVwNBmkrXbtyUmEtR37xJPzI7Tm4oVkmbJOi5/82rk1DilCrM0lnXMxkVfzIQCRPSzAhyflp3Bk6Zatg5p+mCFvO/cD92JsgDiKPSQjxm9TB/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716003; c=relaxed/simple;
	bh=oJSdDCQzvVSDgm9U+QU+/7y3rCjPwxSBmafCUWbPsDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWvqQtxl3JsqZdsxSJQxW8ExCEWbKdOfeegYF4qYTrBV27cYRjBsQBQZhYjdlcp+LMtBycu4pVaA0CNggss+capAEs3ykYMXlEtOpzOOwczKG/Mik4b3YbDsIygVzteMIUn2qaWJLiR3609gvX34oX+CMPFZ3NpPdNFxtmAvpeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6s9WlwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6s9WlwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70A6C3277B;
	Tue, 18 Jun 2024 13:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716003;
	bh=oJSdDCQzvVSDgm9U+QU+/7y3rCjPwxSBmafCUWbPsDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6s9WlwPrc51PMFoZffacXhNQXxUaFkGR3G/SX8ijNWYZn3SgysGiNhSf0z4mdXi1
	 C29KzaOjzBSFZGZwQgH0aAuh1Rd4XcXB1CaAdY7KLUYVd4Qx0GCfxazHAWJlSg0wzA
	 fIUSov9MA4FjQDzsKO57DqB7ErTdE3E7XFgoR6Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 499/770] dnotify: use fsnotify group lock helpers
Date: Tue, 18 Jun 2024 14:35:52 +0200
Message-ID: <20240618123426.579348526@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit aabb45fdcb31f00f1e7cae2bce83e83474a87c03 ]

Before commit 9542e6a643fc6 ("nfsd: Containerise filecache laundrette")
nfsd would close open files in direct reclaim context.  There is no
guarantee that others memory shrinkers don't do the same and no
guarantee that future shrinkers won't do that.

For example, if overlayfs implements inode cache of fscache would
keep open files to cached objects, inode shrinkers could end up closing
open files to underlying fs.

Direct reclaim from dnotify mark allocation context may try to close
open files that have dnotify marks of the same group and hit a deadlock
on mark_mutex.

Set the FSNOTIFY_GROUP_NOFS flag to prevent going into direct reclaim
from allocations under dnotify group lock and use the safe group lock
helpers.

Link: https://lore.kernel.org/r/20220422120327.3459282-11-amir73il@gmail.com
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220321112310.vpr7oxro2xkz5llh@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/dnotify/dnotify.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 6c586802c50e6..fa81c59a2ad41 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -150,7 +150,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 		return;
 	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 
-	mutex_lock(&dnotify_group->mark_mutex);
+	fsnotify_group_lock(dnotify_group);
 
 	spin_lock(&fsn_mark->lock);
 	prev = &dn_mark->dn;
@@ -173,7 +173,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 		free = true;
 	}
 
-	mutex_unlock(&dnotify_group->mark_mutex);
+	fsnotify_group_unlock(dnotify_group);
 
 	if (free)
 		fsnotify_free_mark(fsn_mark);
@@ -306,7 +306,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	new_dn_mark->dn = NULL;
 
 	/* this is needed to prevent the fcntl/close race described below */
-	mutex_lock(&dnotify_group->mark_mutex);
+	fsnotify_group_lock(dnotify_group);
 
 	/* add the new_fsn_mark or find an old one. */
 	fsn_mark = fsnotify_find_mark(&inode->i_fsnotify_marks, dnotify_group);
@@ -316,7 +316,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	} else {
 		error = fsnotify_add_inode_mark_locked(new_fsn_mark, inode, 0);
 		if (error) {
-			mutex_unlock(&dnotify_group->mark_mutex);
+			fsnotify_group_unlock(dnotify_group);
 			goto out_err;
 		}
 		spin_lock(&new_fsn_mark->lock);
@@ -365,7 +365,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 
 	if (destroy)
 		fsnotify_detach_mark(fsn_mark);
-	mutex_unlock(&dnotify_group->mark_mutex);
+	fsnotify_group_unlock(dnotify_group);
 	if (destroy)
 		fsnotify_free_mark(fsn_mark);
 	fsnotify_put_mark(fsn_mark);
@@ -383,7 +383,8 @@ static int __init dnotify_init(void)
 					  SLAB_PANIC|SLAB_ACCOUNT);
 	dnotify_mark_cache = KMEM_CACHE(dnotify_mark, SLAB_PANIC|SLAB_ACCOUNT);
 
-	dnotify_group = fsnotify_alloc_group(&dnotify_fsnotify_ops, 0);
+	dnotify_group = fsnotify_alloc_group(&dnotify_fsnotify_ops,
+					     FSNOTIFY_GROUP_NOFS);
 	if (IS_ERR(dnotify_group))
 		panic("unable to allocate fsnotify group for dnotify\n");
 	return 0;
-- 
2.43.0



