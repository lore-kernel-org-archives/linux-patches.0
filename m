Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9F51EC019;
	Wed,  6 Nov 2024 13:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898110; cv=none; b=CJHaRLzvw2GOvlFA7pTfSzQgtLfMAhMaFdM5N6CxcrA1LX4CBokMC+XnyXJjTCF/EkAwufk2j3U4eTP4TYnKyb37j7f3fK5MISraI46RTVBKZ0JzY3XxGBK+EkOvTq38aNa8fcheTRnDy+VHACM4qaWa8jx4A96OF1MiR+gNW7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898110; c=relaxed/simple;
	bh=hB6FbMtr8VuJrqNGqDtJMDAZ1h5UqN0WN2x9brAHFv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaKyqzjjVvMatfe6sL+v2mXwDQw2L5/mo6vz/ypqirTcvtp8XpoVMvBD50WPn5ZGvQh8D2Qt/DUevHeDNqX/DRq9SBomsq4Lar4MOO/DCXiBqJcaskbgB9PuX0ZAFgkbyqpnS8A67i+xhQudJXe+xyawBvAPOU8pYb5jPdi4hps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6Twp/FI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6Twp/FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85331C4CED3;
	Wed,  6 Nov 2024 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898109;
	bh=hB6FbMtr8VuJrqNGqDtJMDAZ1h5UqN0WN2x9brAHFv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6Twp/FISrXHwG3ViEKaRGstASZG9o1wlDFNIRS7ftAZ8mFx6qRBM+WD9s3I96iWe
	 p1GbiYOJGIAMv9crVEyaRuznCITD+XcKfXqmatDvBGweHe2yQyFEqHTojdO3bP+QKr
	 mr8+M34ZOCNCEQAHkkRPjfdYkmdFJtyiceZ1+oOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/462] f2fs: fix to update i_ctime in __f2fs_setxattr()
Date: Wed,  6 Nov 2024 13:00:20 +0100
Message-ID: <20241106120334.644758833@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 8874ad7dae8d91d24cc87c545c0073b3b2da5688 ]

generic/728       - output mismatch (see /media/fstests/results//generic/728.out.bad)
    --- tests/generic/728.out	2023-07-19 07:10:48.362711407 +0000
    +++ /media/fstests/results//generic/728.out.bad	2023-07-19 08:39:57.000000000 +0000
     QA output created by 728
    +Expected ctime to change after setxattr.
    +Expected ctime to change after removexattr.
     Silence is golden
    ...
    (Run 'diff -u /media/fstests/tests/generic/728.out /media/fstests/results//generic/728.out.bad'  to see the entire diff)
generic/729        1s

It needs to update i_ctime after {set,remove}xattr, fix it.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aaf8c0b9ae04 ("f2fs: reduce expensive checkpoint trigger frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 95b2c05a7035d..1e0fc35887f5d 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -737,17 +737,17 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	if (index == F2FS_XATTR_INDEX_ENCRYPTION &&
 			!strcmp(name, F2FS_XATTR_NAME_ENCRYPTION_CONTEXT))
 		f2fs_set_encrypted_inode(inode);
-	f2fs_mark_inode_dirty_sync(inode, true);
 	if (!error && S_ISDIR(inode->i_mode))
 		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_CP);
 
 same:
 	if (is_inode_flag_set(inode, FI_ACL_MODE)) {
 		inode->i_mode = F2FS_I(inode)->i_acl_mode;
-		inode->i_ctime = current_time(inode);
 		clear_inode_flag(inode, FI_ACL_MODE);
 	}
 
+	inode->i_ctime = current_time(inode);
+	f2fs_mark_inode_dirty_sync(inode, true);
 exit:
 	kvfree(base_addr);
 	return error;
-- 
2.43.0



