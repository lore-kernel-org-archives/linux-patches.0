Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD73E34F49C;
	Wed,  3 Dec 2025 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777935; cv=none; b=q7Ra3JdO21Uhk8BvchNYQmJieSUcvLeYwm+wCY15YHzIRc7mGU4Jv6fiBAeR84sGfuzSPA0Q+UeZhN79vtXtIiXRDULh8WmrjmuV/LYcOMVYHRcHqaFEB1xE4yRmHp4UIKfzB7s04d/YC2Vzfshg5Dtglw/KTSy4ZJLyU/zavoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777935; c=relaxed/simple;
	bh=Aw06kBW+InVUI2Sl91VOGQweAQEbdGV62xIRYtqcIh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHMLmDLRgGmEFbjXVIsxr4QUoE7XJr5c/YcVpnoeItrr15Zvhs6kqTGhbj1GRBI+rXGa7NcDq1ZEeOeWSOk8luutgQ9ZWsNDE3R8k4rcx2nnnxTV7QmfzoTykDVgIp5O3kenORkyYhzzEVBiB3iKuueq9KwmHCEwfnjRH0D8Cr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Knf+bQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Knf+bQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20861C116C6;
	Wed,  3 Dec 2025 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777935;
	bh=Aw06kBW+InVUI2Sl91VOGQweAQEbdGV62xIRYtqcIh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Knf+bQSLmK4YpuDRVPzfY06yiuWoYwTKAcm+vD7CN34rki9WbWYQeM7+Juj8Vy6R
	 sfADq0iwWhwp0aPJLTDRyTCNW8+V2Eejj6VriLDhVsAWTcusuIThbBF+hlEKSUiBFH
	 /ah0Ia75S8UK28nyj7kzAcci8IiYNPln212ROKhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yikang Yue <yikangy2@illinois.edu>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/392] fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink
Date: Wed,  3 Dec 2025 16:25:42 +0100
Message-ID: <20251203152421.140899024@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yikang Yue <yikangy2@illinois.edu>

[ Upstream commit 32058c38d3b79a28963a59ac0353644dc24775cd ]

The function call new_inode() is a primitive for allocating an inode in memory,
rather than planning disk space for it. Therefore, -ENOMEM should be returned
as the error code rather than -ENOSPC.

To be specific, new_inode()'s call path looks like this:
new_inode
  new_inode_pseudo
    alloc_inode
      ops->alloc_inode (hpfs_alloc_inode)
        alloc_inode_sb
          kmem_cache_alloc_lru

Therefore, the failure of new_inode() indicates a memory presure issue (-ENOMEM),
not a lack of disk space. However, the current implementation of
hpfs_mkdir/create/mknod/symlink incorrectly returns -ENOSPC when new_inode() fails.
This patch fix this by set err to -ENOMEM before the goto statement.

BTW, we also noticed that other nested calls within these four functions,
like hpfs_alloc_f/dnode and hpfs_add_dirent, might also fail due to memory presure.
But similarly, only -ENOSPC is returned. Addressing these will involve code
modifications in other functions, and we plan to submit dedicated patches for these
issues in the future. For this patch, we focus on new_inode().

Signed-off-by: Yikang Yue <yikangy2@illinois.edu>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hpfs/namei.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index d73f8a67168e9..c1c53602e4130 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -53,8 +53,10 @@ static int hpfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	dee.fnode = cpu_to_le32(fno);
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail2;
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
@@ -156,9 +158,10 @@ static int hpfs_create(struct user_namespace *mnt_userns, struct inode *dir,
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
-	
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	result->i_mode |= S_IFREG;
@@ -244,9 +247,10 @@ static int hpfs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
-
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
@@ -321,8 +325,10 @@ static int hpfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
+	}
 	result->i_ino = fno;
 	hpfs_init_inode(result);
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
-- 
2.51.0



