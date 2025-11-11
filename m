Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0B5263F4E;
	Tue, 11 Nov 2025 01:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824879; cv=none; b=UzEWx6PlYQErN8jIQe6FiBvZykJ9KJjw3PVDNj+sRArWaaDUTxgDPGG5cWz5/lyFWxi0NQJGts8hnHz3iMPqJa9mBCLR4R0bNlGUR7SauBj1JYJuOxzRo9wfd6J7BFKe6JoWs9qxeJSrefRb2RJlYNcb0O0OQzNXWgiQciwb4cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824879; c=relaxed/simple;
	bh=GI8swBkacSLQGi/I0sN4CKZUlGlBsfTkr84+XBfq7Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHK7GjeMXqZCDI0T9Y62BSh8E+viXAOb33XiCSM0KkPhuEQesm0YFct8nSwGcZyR6UjiBgKw2mh9dUwAPegfuHyFG5cwesMZ+fn/FoCgr1QL4mG+MXTqmtB/2dhTcc6v5YyBOGGRYj/AFeimzW/hE1AsWTKEA3prP2Kyu/ixUlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/NwLW3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/NwLW3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7D2C113D0;
	Tue, 11 Nov 2025 01:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824878;
	bh=GI8swBkacSLQGi/I0sN4CKZUlGlBsfTkr84+XBfq7Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/NwLW3EfWgSBFcXBZ2es4rwe4qXODPitWi6fnyZriadiemexodiVudpgsf5mgubT
	 4m4cqLnvGHAy7ejG/UFAnI46GZ39XPPyZthfZJp49ScXRKVUqeKT9YVLFkoqajqU5w
	 PXcDzf3knEkPs0hmuW0qm4kf+1ou3uOa4U+ILeaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 590/849] jfs: Verify inode mode when loading from disk
Date: Tue, 11 Nov 2025 09:42:40 +0900
Message-ID: <20251111004550.689115742@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7a5aa54fba2bd591b22b9b624e6baa9037276986 ]

The inode mode loaded from corrupted disk can be invalid. Do like what
commit 0a9e74051313 ("isofs: Verify inode mode when loading from disk")
does.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index fcedeb514e14a..21f3d029da7dd 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -59,9 +59,15 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 			 */
 			inode->i_link[inode->i_size] = '\0';
 		}
-	} else {
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+	} else {
+		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %lu.\n",
+		       inode->i_mode, inode->i_ino);
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	unlock_new_inode(inode);
 	return inode;
-- 
2.51.0



