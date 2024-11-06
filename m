Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FF41DE8A2;
	Wed,  6 Nov 2024 12:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895186; cv=none; b=GJj+ZBLN4oNQJrPMzCJ+xjvDQCeS7/3CDCT65mVKZrbwk8l2j+Xkkfuh8C+99/daLhAq7jv5ah+Ab3Tb7cH7ZJ1hm8gs5lQpoGwe4igdL4sf6LsLNRH4lfMcNXsOWH9TGEqPnznKhpW3ioMyJjJpVWYVEe/CyO4Y5dyjNHJvF4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895186; c=relaxed/simple;
	bh=vONLZgHnqFxSTSwOj91QIsU8+cwHXZOccMMxQQC72Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOE/cY4814oOjWWopa3/9ebYG1z2XeWT4bDLTa9rM3N0SiW4Dap2reQRMGcQqiehg8Mzxw7r53n9Cntc4XEHil/jztqxauwC2mRpc5pZRQ8u0eXGKxeTHTnjHG2mRJCnAzjEUJvLoTQHCj6yFdFA/23DZGUwOlfGRGDtCkMrrMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhWFfQhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhWFfQhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA48DC4CED2;
	Wed,  6 Nov 2024 12:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895186;
	bh=vONLZgHnqFxSTSwOj91QIsU8+cwHXZOccMMxQQC72Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhWFfQhv/FfAFShuB67sCmAFo0k9qtQwtLlEeRmeNnYnorrd8Fnpji8h24Cf7hdwc
	 CVmEz83Ns5IIh4svkE/akSXMC4Bd36HrgCk94G55GSHpfgLRLRxuH7u9ZQ0Pxx/zvt
	 bpW1nLyIoej3UDR3e4GT2aOvL/gBqgrJ7gV5RmBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/350] f2fs: fix to update i_ctime in __f2fs_setxattr()
Date: Wed,  6 Nov 2024 13:00:24 +0100
Message-ID: <20241106120323.272970431@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 496a9e70cb091..00af34ba8561e 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -732,17 +732,17 @@ static int __f2fs_setxattr(struct inode *inode, int index,
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
 	kzfree(base_addr);
 	return error;
-- 
2.43.0



