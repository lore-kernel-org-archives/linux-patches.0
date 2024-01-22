Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7E312BF3D;
	Tue, 23 Jan 2024 00:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968939; cv=none; b=bsg8bgtC5ry51s7TT1NzW/a3zEgc0XTpSlU1QcPAfz8RtjUEWoZjmMi/cEKsT+/9oW5FYQIncMvVSIbLPL8QxcisDbPoYT1BZ0VZ7DkXzrtMFhaNuqb2I1L9R3jisT5xMG9fcbR+T7z1Q3xhuor/g/Nv2QlF74/7uxsIAmM8T/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968939; c=relaxed/simple;
	bh=Oh8nBS8EEv3ov9iIKgHgw8wUGg/ueVm4JlRmUuNBQa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTAlArj7JX/fMLbdTfkSMBSugLQSXXBz8DRxMn2rq8rrFEuNmPvZeFavqjprYRgH6qp6s4xRxxsMMOFJeBKkIF3KE44DV1IV0kXGOK9gz7eJAPuKiaJEOPHxEbtPCcOB3YDndtOGsAJO4Wc80kTz2XhK+MiyUYods7fdOBb5XyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmeSGuXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmeSGuXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FABC43390;
	Tue, 23 Jan 2024 00:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968939;
	bh=Oh8nBS8EEv3ov9iIKgHgw8wUGg/ueVm4JlRmUuNBQa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmeSGuXPfI79TAealvGqWLZvn4EcX+UwkFbdn+wEZ2H0Lxkx5LbUfsLLXkEBUBswP
	 XlRrqox0OnxmDDtkvnIAqllHMJ1yADm6VmT8gqIUnbib+slhMZ2RrzNZ2Ay6FZSlHX
	 ammwgX/pohg9DfqjTontQfrDfkSJiyVQ+AfZe6Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/194] f2fs: fix to avoid dirent corruption
Date: Mon, 22 Jan 2024 15:57:22 -0800
Message-ID: <20240122235724.034323853@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

[ Upstream commit 53edb549565f55ccd0bdf43be3d66ce4c2d48b28 ]

As Al reported in link[1]:

f2fs_rename()
...
	if (old_dir != new_dir && !whiteout)
		f2fs_set_link(old_inode, old_dir_entry,
					old_dir_page, new_dir);
	else
		f2fs_put_page(old_dir_page, 0);

You want correct inumber in the ".." link.  And cross-directory
rename does move the source to new parent, even if you'd been asked
to leave a whiteout in the old place.

[1] https://lore.kernel.org/all/20231017055040.GN800259@ZenIV/

With below testcase, it may cause dirent corruption, due to it missed
to call f2fs_set_link() to update ".." link to new directory.
- mkdir -p dir/foo
- renameat2 -w dir/foo bar

[ASSERT] (__chk_dots_dentries:1421)  --> Bad inode number[0x4] for '..', parent parent ino is [0x3]
[FSCK] other corrupted bugs                           [Fail]

Fixes: 7e01e7ad746b ("f2fs: support RENAME_WHITEOUT")
Cc: Jan Kara <jack@suse.cz>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index ed95c27e9302..99a91c746b39 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1009,7 +1009,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	if (old_dir_entry) {
-		if (old_dir != new_dir && !whiteout)
+		if (old_dir != new_dir)
 			f2fs_set_link(old_inode, old_dir_entry,
 						old_dir_page, new_dir);
 		else
-- 
2.43.0



