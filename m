Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0157012AAED;
	Mon,  8 Apr 2024 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583859; cv=none; b=p5ZwL1NXVz28A8ARANq3Mmewyr6+shPZSKBOObje5rrG8VUgMFwwMh9LZrmhJD26XOxEbVdd1Zzan1Hy63W277FgKtpNvSZwGoLsH10Qxol2KxZtzk5S8ngKZHqSP365uYkqcz1Jb/SDBUy9NgAB4TPoMh+D44d3LsrPIpdcaW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583859; c=relaxed/simple;
	bh=cZvfZ41iEFayFTGYTu5ZcdquDMNod32E4ykETtYwCEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpsZoVBXK7/jEkyzm8yx90wx9QodUwtx27+HDIe18zhpxPEsDRaiKNlhVYVTaduM4oQao46GjrefzKF1ATZ6xewAfWqcrp5anOewngjkDtRS2jw/wsUd6teVNhIKvdd8nbUnZwvLDK9rt8UOAEncoOcJ1jo34RzrpSz5hpBg8KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kc8x4eZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kc8x4eZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA08C433C7;
	Mon,  8 Apr 2024 13:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583858;
	bh=cZvfZ41iEFayFTGYTu5ZcdquDMNod32E4ykETtYwCEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kc8x4eZAsN66og5E8pdrt62vJOIxnBXfloKIYTtw2t7k4p0LOpk3CLp/k86iID39b
	 uxjMGF/k5cfLQlEQEc3Uaims3xXwF115DgvvIQ5uOzrugCL6+MqHH2bZ+Ui8LsVF1S
	 +R1VunU8RiyexHs6YxdgcNYhQhPZLkb90VlYE/pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 296/690] dnotify: use fsnotify group lock helpers
Date: Mon,  8 Apr 2024 14:52:42 +0200
Message-ID: <20240408125410.331594101@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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



