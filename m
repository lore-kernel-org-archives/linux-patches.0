Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9641C07E5;
	Tue, 15 Oct 2024 13:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997458; cv=none; b=NtxpKSl53z/VotJUHselegRy1icWDp+c9TEcSxCE56KkjXlGSl5OyPbnM3hN59VXrbCv8slKvlihTmHe3y+aF/tyV0SA6ZvaeYqqpZttJxy4b7dY3GYNAJamhOG5oqFc8lyDIEtx71UPFCdREupxiFINrtLJSdAZfeVX/8snfTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997458; c=relaxed/simple;
	bh=guQJ1OnY2I4A0w/KNvx4cgdzGiBRYB7JOnqPrthPqKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPZoS+1cX2IjgcdRq3STr9pl/R9D9xClgtUYVX4ljr/L48BduXUQjXalJBiBuiXtQmVd9dkAXS6w5nyo4JbS8bIryovBOF9M/vE35Dv8MTa1H2dSMEmnxR0AuKKtbmLrpHy8A4tuC2oQvqaCYaTadVCCkeAKABovdQK/QAQLW68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmzlfClM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmzlfClM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC430C4CEC6;
	Tue, 15 Oct 2024 13:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997458;
	bh=guQJ1OnY2I4A0w/KNvx4cgdzGiBRYB7JOnqPrthPqKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmzlfClMt/hjX6vnCgVB6gNPTQ6V2KlLJdJpTeQZ/RYJHFVvFcNH22GHVmfw3H843
	 qLBJWHP5NjmyHnJojeYZldBavlWf+oiv00WnFetcHkFqA1BFqOhkFxDzL7FmYj9ztd
	 DXV2jPgwwK2lNc0GheROJXk2LpLE/dznLzzcWjEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/518] f2fs: fix to update i_ctime in __f2fs_setxattr()
Date: Tue, 15 Oct 2024 14:41:32 +0200
Message-ID: <20241015123924.241381074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 4271bcc2738d1..a3a11678d414d 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -756,17 +756,17 @@ static int __f2fs_setxattr(struct inode *inode, int index,
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
 	kfree(base_addr);
 	return error;
-- 
2.43.0



