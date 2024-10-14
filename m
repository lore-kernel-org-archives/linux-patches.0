Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14AD19F40B;
	Mon, 14 Oct 2024 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918135; cv=none; b=AgJTqHhI9ncpAg2H6yM+4aqKFwhQkUL1Ouz00Cmch3pHf/sVDpeojFalzuUStQMKOCU2bUDpA85hiQRj955gX9wBbPPj5ir/fanaATJhcIwkvBEijKJGYkpfqrKCDZ/Xvp4CgRozhgoSUhPjwEVPzQw+lBhH6rZuhV9luGo7/dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918135; c=relaxed/simple;
	bh=ZBe9CMPhXY3l/AsanMp3VKLL/s0Ya4Z3xniqp6DfYSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHsGcYSEaOCjQHc3hL5lIemmQ7Llh5eU0URMwmKeCx38cHflPWRJGIFKNBq7T8B9my9r3UID47ZWz7CsZBA5SIiCYssNbD/pXIBfcudUWlQ8vX8TJRc6KytPlE2u6Xgujl+HqOWKWO4bFvGswxWzIjRpMmoJS/qrOlf+R7BDdNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3Jsn+1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3Jsn+1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43816C4CEC3;
	Mon, 14 Oct 2024 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918135;
	bh=ZBe9CMPhXY3l/AsanMp3VKLL/s0Ya4Z3xniqp6DfYSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3Jsn+1Bc0JqJByi1ctXddfFQVQ2jgglGbWUVydvZTA7tRTXlJQeTD2XFXPUWkA1y
	 a2473s97i86BGTtpqyk49pr97xQVDxlUWSubsL/dRgwkTRIIkgkpVfvFzdQe8wL6mh
	 9JwLtLN0fLh7ftraGS5Z6PWowyNjWOv94j6ZlirA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/798] f2fs: fix to update i_ctime in __f2fs_setxattr()
Date: Mon, 14 Oct 2024 16:13:08 +0200
Message-ID: <20241014141227.114361267@linuxfoundation.org>
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
index 0631b383e21f4..0862dfbe6a5d6 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -772,17 +772,17 @@ static int __f2fs_setxattr(struct inode *inode, int index,
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



