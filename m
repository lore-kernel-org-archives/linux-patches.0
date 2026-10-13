Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EF23E557D;
	Tue, 13 Oct 2026 12:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893915; cv=none; b=jUY2xt1nPVsNMBjeIIExjGfHKdCN09SpmXfyMHseKf2d0FCwdufeIBo1l5YvmdsCVrXcRtyP9MG3SqW2fZ9VpAMR03D23Ei9NHBwY2ENzEzNsXpGSoL+fTJI010uFVl1qxMsV6aRXpgExEnIsiUJG4ummdcKHIR5Blj+rGLDc2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893915; c=relaxed/simple;
	bh=nNpkPAVC+0xwLR4oUF1vgYGaDGYodmVqRde7GphTK4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmgfuB6NLrsSbIjkZ5FF7x9/yHgHpbJuc0uGCbVFP66MthSGFtiR4pa/hOOf2R/HiEH5fkyXdR9b0NEuK+GYZB99Q+bBYNLBz1chb6K58AJ/Kpz3GMGUl6BpfGIFR5reLw3cBakyxKTMHiVJce9x2Bs0kIoSBvZiS5W5ecSHWV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwU4hDDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwU4hDDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437B21F000FF;
	Tue, 13 Oct 2026 12:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893914;
	bh=hovg89+FDLTCIwgpL0Frs0/+5Xlf1s9VhRE3+3+O+2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwU4hDDJ1KidVjvxGCWLYMRbX3wIzTMp98VTbC8FDROXC/1YIW83UQm64EOu1JvP8
	 aX/aNkyIhNmZeeQ5UjoU43Hd4uhPFfaen6rkRjT7S/qpJIWl0sN2w0GytdFftlwecz
	 lL/IHl6ZMDvIE8YQrfebln9JyOP40RNr5DrxRyho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 383/621] ext2: Fix lost inode updates for IS_SYNC inodes
Date: Tue, 13 Oct 2026 13:36:18 +0200
Message-ID: <20261013112929.932601313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 4aac18942eccd..50d431949fd4b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1301,11 +1301,10 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	mark_inode_dirty(inode);
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
 		sync_inode_metadata(inode, 1);
-	} else {
-		mark_inode_dirty(inode);
 	}
 
 	return 0;
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index c885dcc3bd0d1..5574b601ae09c 100644
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



