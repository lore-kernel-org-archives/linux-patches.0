Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3653A1E92;
	Sat, 17 Oct 2026 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259707; cv=none; b=jn2u0wHEOvnDy8dbAMpJX/V0Qg1sW0Ga5HqDg9nOHBpTRoadHk4sVFg5xocnQ34qhQhAZ3FN/FMomg6on4kIx2cpnPbzHBdk78THLWrYkYDRpBd2jCG74GDw3jrXTAtfUTmdaT2ouGSS+gKV6XscvrkuPXFSk73lKSD1oOcZPhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259707; c=relaxed/simple;
	bh=QyS8Mwdnsk8lg6jAFeuid10UUOquvlqqgtcjZX6yfnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzm62DNA6pyrikG5CAvmWEDg0IfjRUf7rlqxMcrkavE+CJJOrC3XJKfTBnymmtf74huAevt1Cwv25dUQQ3tsVnXAFFsZENHvXbv0AfRHJRAJKo5vPwheFfSfv5qOwuC/XLAfulWT4vjgfQI9upGya7144dgHWy/ZxNHAtmxqmNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p18gN1xY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p18gN1xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F1D1F000C4;
	Sat, 17 Oct 2026 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259706;
	bh=rbR+x6k88XpH6dndEZhLFeFeU00I7cT6tsFZg4MqKnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p18gN1xYx5TQntlRF0tOh3vFNh4US99xAbHJHK2D4eKKEXMZgDh4fum21YWK0GJB/
	 47oZ2cTwzasphA3pzRWgBStaaBty6bgPHZ//UF0fkYgAZNl3h8ZUFBlWr0IL13jxc+
	 UIv/TVgy+9q0+pHsNthUAUi6nXCladWMO2stp+eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1303/1674] ext2: Fix lost inode updates for IS_SYNC inodes
Date: Sat, 17 Oct 2026 17:59:35 +0200
Message-ID: <20261017160504.592614722@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 356984d1a5c32e94810cbb6c8dc7d8ff2d4d919a ]

ext2_setsize() and ext2_xattr_set2() had a construct like:

	if (IS_SYNC(inode)) {
		sync_inode_metadata(inode, 1);
	} else {
		mark_inode_dirty(inode);
	}

which leads to lost inode updates for IS_SYNC inodes because
sync_inode_metadata() does anything only if the inode is already dirty
and hence inode updates may be simply lost. Fix the problem by
unconditionally marking the inode dirty and *then* call
sync_inode_metadata().

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260727104923.3828017-26-jack@suse.cz
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/inode.c | 3 +--
 fs/ext2/xattr.c | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 6eccee0336171..e93db18b14664 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1302,11 +1302,10 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	inode->i_mtime = inode_set_ctime_current(inode);
+	mark_inode_dirty(inode);
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
 		sync_inode_metadata(inode, 1);
-	} else {
-		mark_inode_dirty(inode);
 	}
 
 	return 0;
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 20f741184673f..c9706d61e6dd9 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -777,6 +777,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 	/* Update the inode. */
 	EXT2_I(inode)->i_file_acl = new_bh ? new_bh->b_blocknr : 0;
 	inode_set_ctime_current(inode);
+	mark_inode_dirty(inode);
 	if (IS_SYNC(inode)) {
 		error = sync_inode_metadata(inode, 1);
 		/* In case sync failed due to ENOSPC the inode was actually
@@ -789,8 +790,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			}
 			goto cleanup;
 		}
-	} else
-		mark_inode_dirty(inode);
+	}
 
 	error = 0;
 	if (old_bh && old_bh != new_bh) {
-- 
2.53.0



