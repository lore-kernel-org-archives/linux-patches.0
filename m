Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369A423ED5B;
	Fri,  9 Jan 2026 12:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960613; cv=none; b=a+c0Meg/Jz2pXFGSFdSPpTzDUT4QJVmQD+08GD6lXTqWT5WXcD2vGDaEWbombIt7GYraPrsHBoY+PjCJw144pjf24m7rwYXVTe92/EhjbSurmCRSdpJnMlxJHqEglHUV6O6CclXa9Ga7VDs/luHFOv+9bNT+B0DIBE//IvBq7Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960613; c=relaxed/simple;
	bh=3eEeBDSxO1aVoTFC8CNPiEMGACSMUPvErnXEcd8J++Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q06j+QMDeRC830ijEjBAk+HUffvX3UMmKiw8qZ9206SPPe5NUG2VKUorSlfLl2tqYYwwufm08loyauCg0uthQrIvfGy+G/ZX8bJueBg0s1dfR74+BvvHBOlhEBWrmkKFn+ibAlVXeBTpCU6qhZcXqmUniqVoNExW7Y+1fjPDNns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaiOMzF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaiOMzF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3AEC4CEF1;
	Fri,  9 Jan 2026 12:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960612;
	bh=3eEeBDSxO1aVoTFC8CNPiEMGACSMUPvErnXEcd8J++Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaiOMzF7/DPcKpOOEh6mrQMAigr+hj+nnUJLlWuLfOoY5eilci5ItjP9b1SlsNJ4Q
	 l5CNmgDQTQK713vFWiS2dUJRIqito+1/2DtOazt7i1k/p0BgbikxUeX1v+TykEjXri
	 MkrcZyZNRgjBBOHbSw4u66V4UbdwmrB8+8WH1IQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 423/737] ext4: clear i_state_flags when alloc inode
Date: Fri,  9 Jan 2026 12:39:22 +0100
Message-ID: <20260109112149.907485573@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

commit 4091c8206cfd2e3bb529ef260887296b90d9b6a2 upstream.

i_state_flags used on 32-bit archs, need to clear this flag when
alloc inode.
Find this issue when umount ext4, sometimes track the inode as orphan
accidently, cause ext4 mesg dump.

Fixes: acf943e9768e ("ext4: fix checks for orphan inodes")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251104-ext4-v1-1-73691a0800f9@nxp.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |    1 -
 fs/ext4/inode.c  |    1 -
 fs/ext4/super.c  |    1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1299,7 +1299,6 @@ got:
 					      sizeof(gen));
 	}
 
-	ext4_clear_state_flags(ei); /* Only relevant on 32-bit archs */
 	ext4_set_inode_state(inode, EXT4_STATE_NEW);
 
 	ei->i_extra_isize = sbi->s_want_extra_isize;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4913,7 +4913,6 @@ struct inode *__ext4_iget(struct super_b
 	ei->i_projid = make_kprojid(&init_user_ns, i_projid);
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
-	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
 	ei->i_inline_off = 0;
 	ei->i_dir_start_lookup = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1412,6 +1412,7 @@ static struct inode *ext4_alloc_inode(st
 
 	inode_set_iversion(&ei->vfs_inode, 1);
 	ei->i_flags = 0;
+	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
 	spin_lock_init(&ei->i_raw_lock);
 	ei->i_prealloc_node = RB_ROOT;
 	atomic_set(&ei->i_prealloc_active, 0);


