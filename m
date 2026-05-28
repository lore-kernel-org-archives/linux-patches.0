Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D464E2C11F9;
	Thu, 28 May 2026 20:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999575; cv=none; b=r4jA3ZvZsFyVnXfQ2DYehniALegegjDCxPT40rRy55hO3fvOoC3CpxUtwU+Er5iKEwHMxeebbZLqw6yLGZRyHYJxzDE7vKsAfFT2Fw5NNjenbSXEYFDdFDCRSwWxxMix22jwBf7m7ipotgBRcrW7LPdKrf7/sZunFXwzV1kVAoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999575; c=relaxed/simple;
	bh=SF8DqkoQZ0nzo416vBx7kyjxbGBmxpnfLnhn2JMqb7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pja/XH4Q261JfxyN3fDusHKGcRVkq7DKwR+LVs3dIzFSq/ZTe+0RQQnT1o95sOUpr0sA4ETsHQWwrvZrKI5W3+8ft4vRWOR43UFzToxrzAg5t6Ae+x+fSBojTOyuOfZLBflk8V/5iKvZEnEmY5UfTJjPac9Pj2D12AOLOVvSde4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjiePxFF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjiePxFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AD91F000E9;
	Thu, 28 May 2026 20:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999574;
	bh=/TPC9Jmq72JGDqdK7wEvY17iil1TZXBVweQU1Cls9u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjiePxFFTmo+yW24P52m78sb3EHvTrE7vjgch2wfsMLeXc8ctmYofrPafZm4Bhlva
	 ZZj3tUhyRkJ/cnif/2wDtDYZYR7nv1KHDp3WHw7vEZTztg8v2oGeizCsLrM+H1mT3P
	 XxL1rroQjL/dTLjLz8Fr4TouXjWoTTpB1OgCFc04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.18 078/377] fs/ntfs3: handle attr_set_size() errors when truncating files
Date: Thu, 28 May 2026 21:45:16 +0200
Message-ID: <20260528194640.631084376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 576248a34b927e93b2fd3fff7df735ba73ad7d01 ]

If attr_set_size() fails while truncating down, the error is silently
ignored and the inode may be left in an inconsistent state.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
[ Minor context conflict resolved. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/file.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -458,8 +458,8 @@ static int ntfs_truncate(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_inode *ni = ntfs_i(inode);
-	int err, dirty = 0;
 	u64 new_valid;
+	int err;
 
 	if (!S_ISREG(inode->i_mode))
 		return 0;
@@ -475,7 +475,6 @@ static int ntfs_truncate(struct inode *i
 	}
 
 	new_valid = ntfs_up_block(sb, min_t(u64, ni->i_valid, new_size));
-
 	truncate_setsize(inode, new_size);
 
 	ni_lock(ni);
@@ -489,22 +488,19 @@ static int ntfs_truncate(struct inode *i
 		ni->i_valid = new_valid;
 
 	ni_unlock(ni);
+	if (unlikely(err))
+		return err;
 
 	ni->std_fa |= FILE_ATTRIBUTE_ARCHIVE;
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	if (!IS_DIRSYNC(inode)) {
-		dirty = 1;
+		mark_inode_dirty(inode);
 	} else {
 		err = ntfs_sync_inode(inode);
 		if (err)
 			return err;
 	}
 
-	if (dirty)
-		mark_inode_dirty(inode);
-
-	/*ntfs_flush_inodes(inode->i_sb, inode, NULL);*/
-
 	return 0;
 }
 


