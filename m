Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C97F1C07CC;
	Tue, 15 Oct 2024 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996905; cv=none; b=h8yCNI+keB92U/ray+EJ0jMAuPgiPaP36be77EaIfQow0QNxqGXyvFJ5Bifk2Lkjw+oBJzyDcNMIBCPWxwql861A38Vi9mGxkdAobhgTKJd4oBBBRycLvFP8PuztB/dwVEjQhOkpINn2xBjke9MPfZ5NiPGkPlxz9eKYHb4B6OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996905; c=relaxed/simple;
	bh=NyZkOZhPkgMsr/VGrNT11Qv1VFHqNKlaAvZWey/Acj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qn4b/eZya2O2SVqYxdMxF2lDJyirETKRsQw+dgEIIZNQN+gLHqCmrdfu9fZ2uUn6yTBKvf8nGWaUA6y3LNHZ80hXxEmuz5t1YmUJiYn7rMSNQdrbIuqHrPoCC+JXQktUBYlPn70bAvD5Hv/eETLS9Zf9euf1E7U3YXeG7snKkRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpYfB2Dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpYfB2Dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D4DC4CEC6;
	Tue, 15 Oct 2024 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996905;
	bh=NyZkOZhPkgMsr/VGrNT11Qv1VFHqNKlaAvZWey/Acj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpYfB2DgQS4a8kRArGcF9SSUYiMGzCotAQ98g8OU9j3Mg5/4mqqsbXQLF2GHCsTIX
	 YmhDQ89BbpPZKl3Bm69yTODf6eVCt6NoTT8Mh+SvcMVJf+O3q19mrQGItGgN2BD9mJ
	 S2uU7t8gykO0zz7Z//lgrbhle3xK7MtWPYcCOSxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/518] btrfs: update target inodes ctime on unlink
Date: Tue, 15 Oct 2024 14:38:32 +0200
Message-ID: <20241015123917.155261442@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 3bc2ac2f8f0b78a13140fc72022771efe0c9b778 ]

Unlink changes the link count on the target inode. POSIX mandates that
the ctime must also change when this occurs.

According to https://pubs.opengroup.org/onlinepubs/9699919799/functions/unlink.html:

"Upon successful completion, unlink() shall mark for update the last data
 modification and last file status change timestamps of the parent
 directory. Also, if the file's link count is not 0, the last file status
 change timestamp of the file shall be marked for update."

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add link to the opengroup docs ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cd3156a9a268..24598acb9a31 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3704,6 +3704,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name_len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
+	inode_set_ctime_current(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode->vfs_inode.i_ctime = dir->vfs_inode.i_mtime =
 		dir->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
-- 
2.43.0



