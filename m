Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755222DD5EF;
	Tue,  8 Jul 2025 16:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992941; cv=none; b=jI7Ldy7oh0wu0EjzyBns8i8F6JgEjaPij9LqSt6V9tFH3z8YxH+jiKAFnCKMLt/Ev85zdJCFUNG6AWiAVabIh+z4L8qP5GII42pr4mFcKxxshZj6Mxg4HFlhTqtniiszU+JUy/oC7i3df0jf87H+V3jxhZ63jimkyMQBRhGEP8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992941; c=relaxed/simple;
	bh=Po/2cdsplhVzvJlPn1yzOfDgSDhBmrRYEGZJ9KF2b88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7hiYsWItoJQTuNnhBfaiFq7aCmDw7KfsBq+Ra+6r2wJou3cw3kg88D5wlt5R13W1Ea6lZcmmh9K8qbl3pZkAjup9lTBk9YDt0WaSWBo1/z520amePRrNnLABsO2MxLgCbp17LpHkL+3B7vj+eScc704RzzrguJ8LN/6bRHgVco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5wuewtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5wuewtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC523C4CEED;
	Tue,  8 Jul 2025 16:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992941;
	bh=Po/2cdsplhVzvJlPn1yzOfDgSDhBmrRYEGZJ9KF2b88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5wuewtDcIRYpvukdRaxF1O2c2EybbM2FccFqJsQfLqUyHdJS246yXYRfI1juw8Uc
	 ZEWNZnq9xTHhYQWnHHyQX3soqmLZ5eRoKTQ6hQMt5NxYFu0BjbwoFK1ez9pimbJrUB
	 ilYlZZFy+d/Au+5tG9iycDPNLvTuNQC2zt1abwBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/232] gfs2: Rename dinode_demise to evict_behavior
Date: Tue,  8 Jul 2025 18:21:39 +0200
Message-ID: <20250708162244.138634871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit c79ba4be351a06e0ac4c51143a83023bb37888d6 ]

Rename enum dinode_demise to evict_behavior and its items
SHOULD_DELETE_DINODE to EVICT_SHOULD_DELETE,
SHOULD_NOT_DELETE_DINODE to EVICT_SHOULD_SKIP_DELETE, and
SHOULD_DEFER_EVICTION to EVICT_SHOULD_DEFER_DELETE.

In gfs2_evict_inode(), add a separate variable of type enum
evict_behavior instead of implicitly casting to int.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 6584fd5e0a5b7..6a0c0f3780b4c 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -44,10 +44,10 @@
 #include "xattr.h"
 #include "lops.h"
 
-enum dinode_demise {
-	SHOULD_DELETE_DINODE,
-	SHOULD_NOT_DELETE_DINODE,
-	SHOULD_DEFER_EVICTION,
+enum evict_behavior {
+	EVICT_SHOULD_DELETE,
+	EVICT_SHOULD_SKIP_DELETE,
+	EVICT_SHOULD_DEFER_DELETE,
 };
 
 /**
@@ -1315,8 +1315,8 @@ static bool gfs2_upgrade_iopen_glock(struct inode *inode)
  *
  * Returns: the fate of the dinode
  */
-static enum dinode_demise evict_should_delete(struct inode *inode,
-					      struct gfs2_holder *gh)
+static enum evict_behavior evict_should_delete(struct inode *inode,
+					       struct gfs2_holder *gh)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct super_block *sb = inode->i_sb;
@@ -1327,11 +1327,11 @@ static enum dinode_demise evict_should_delete(struct inode *inode,
 		goto should_delete;
 
 	if (test_bit(GIF_DEFER_DELETE, &ip->i_flags))
-		return SHOULD_DEFER_EVICTION;
+		return EVICT_SHOULD_DEFER_DELETE;
 
 	/* Deletes should never happen under memory pressure anymore.  */
 	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC))
-		return SHOULD_DEFER_EVICTION;
+		return EVICT_SHOULD_DEFER_DELETE;
 
 	/* Must not read inode block until block type has been verified */
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, gh);
@@ -1339,34 +1339,34 @@ static enum dinode_demise evict_should_delete(struct inode *inode,
 		glock_clear_object(ip->i_iopen_gh.gh_gl, ip);
 		ip->i_iopen_gh.gh_flags |= GL_NOCACHE;
 		gfs2_glock_dq_uninit(&ip->i_iopen_gh);
-		return SHOULD_DEFER_EVICTION;
+		return EVICT_SHOULD_DEFER_DELETE;
 	}
 
 	if (gfs2_inode_already_deleted(ip->i_gl, ip->i_no_formal_ino))
-		return SHOULD_NOT_DELETE_DINODE;
+		return EVICT_SHOULD_SKIP_DELETE;
 	ret = gfs2_check_blk_type(sdp, ip->i_no_addr, GFS2_BLKST_UNLINKED);
 	if (ret)
-		return SHOULD_NOT_DELETE_DINODE;
+		return EVICT_SHOULD_SKIP_DELETE;
 
 	ret = gfs2_instantiate(gh);
 	if (ret)
-		return SHOULD_NOT_DELETE_DINODE;
+		return EVICT_SHOULD_SKIP_DELETE;
 
 	/*
 	 * The inode may have been recreated in the meantime.
 	 */
 	if (inode->i_nlink)
-		return SHOULD_NOT_DELETE_DINODE;
+		return EVICT_SHOULD_SKIP_DELETE;
 
 should_delete:
 	if (gfs2_holder_initialized(&ip->i_iopen_gh) &&
 	    test_bit(HIF_HOLDER, &ip->i_iopen_gh.gh_iflags)) {
 		if (!gfs2_upgrade_iopen_glock(inode)) {
 			gfs2_holder_uninit(&ip->i_iopen_gh);
-			return SHOULD_NOT_DELETE_DINODE;
+			return EVICT_SHOULD_SKIP_DELETE;
 		}
 	}
-	return SHOULD_DELETE_DINODE;
+	return EVICT_SHOULD_DELETE;
 }
 
 /**
@@ -1477,6 +1477,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder gh;
+	enum evict_behavior behavior;
 	int ret;
 
 	if (inode->i_nlink || sb_rdonly(sb) || !ip->i_no_addr)
@@ -1491,10 +1492,10 @@ static void gfs2_evict_inode(struct inode *inode)
 		goto out;
 
 	gfs2_holder_mark_uninitialized(&gh);
-	ret = evict_should_delete(inode, &gh);
-	if (ret == SHOULD_DEFER_EVICTION)
+	behavior = evict_should_delete(inode, &gh);
+	if (behavior == EVICT_SHOULD_DEFER_DELETE)
 		goto out;
-	if (ret == SHOULD_DELETE_DINODE)
+	if (behavior == EVICT_SHOULD_DELETE)
 		ret = evict_unlinked_inode(inode);
 	else
 		ret = evict_linked_inode(inode);
-- 
2.39.5



