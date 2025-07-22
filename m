Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2618D22FDFF;
	Tue, 22 Jul 2025 13:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192021; cv=none; b=uOaNsrnJpVmCDaCvHI4yLTaNy3SPPxyRUoppvuTYlmno+BRyjl/nheCDJcPJ1AWi2M0CW1EnGIDaymY2AkS3SLiaKz7u1VVzkwOBg2xgcb3/gLhL1/g7qZSzVsuSyd3x3hTYfItH4vH0FZUKkVCp4QZukQqq/90igtDoaOHv6Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192021; c=relaxed/simple;
	bh=cgldl5s17tbS3Lv3QHqNgz96u/+hSiuuCxjF0LwAKH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9CH5JhgrJTEzh6KI3BAKF2SQFdUqskGg9xooCsS4et/zYFKahyeb0de7ANXGAOoY+fnZRbURP3w0nRTYC66LwQ8E4eFAZ/XBcAEMkTfkd5PsMfNVlz236hC/MgYvIe2uLnG3Z+C3wqwdLXq6WJBLjwUNz/fKQuNftGpx5lNkXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0gLWEWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0gLWEWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16917C4CEEB;
	Tue, 22 Jul 2025 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192020;
	bh=cgldl5s17tbS3Lv3QHqNgz96u/+hSiuuCxjF0LwAKH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0gLWEWRjEFtf3QnwGHA/Chs7JsAuo6NLOlI4ecPeXjH8TNpLLzEBTeeB1niKoq6x
	 7s6GW41Fm/J3dgVM1efbsMRQ617tlHfy/7pNgMTvBrCfZudr99U0KSCoqZ1cHpdEb0
	 XWbKNkkBAccz2A/OoTTvBUVfStXZHusQdXGwO1rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 21/79] isofs: Verify inode mode when loading from disk
Date: Tue, 22 Jul 2025 15:44:17 +0200
Message-ID: <20250722134329.158844863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jan Kara <jack@suse.cz>

commit 0a9e7405131380b57e155f10242b2e25d2e51852 upstream.

Verify that the inode mode is sane when loading it from the disk to
avoid complaints from VFS about setting up invalid inodes.

Reported-by: syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/20250709095545.31062-2-jack@suse.cz
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/isofs/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1491,9 +1491,16 @@ static int isofs_read_inode(struct inode
 		inode->i_op = &page_symlink_inode_operations;
 		inode_nohighmem(inode);
 		inode->i_data.a_ops = &isofs_symlink_aops;
-	} else
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+	} else {
+		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %lu.\n",
+			inode->i_mode, inode->i_ino);
+		ret = -EIO;
+		goto fail;
+	}
 
 	ret = 0;
 out:


