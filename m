Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D8F342146;
	Wed,  3 Dec 2025 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777847; cv=none; b=enkz0wEzNYIa7frWept842pRrSZPw7i2X0QEJnL0534rI+0BiFTJ/DzCLXG5vhYSoIUl1g9fdEMEuIcNa1Jolo0sfuwHTO2YlwmW+1UP9Jd6a090LSjPsK5V8SkkWMeU6Uwho0u2+wZ0WGFv1V0HINjEH6+vHGpzAojjSRK0BSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777847; c=relaxed/simple;
	bh=OcJ7YBzS+TYV1Q3secgEisAtZPOfA9EPLUXkxMILleU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2OS/xAShtTZv5g5mskICMDnj+OFy+H40co8I/kMiKIMjFhA4Mjgyjyocd1YC7vZu16n1kRfnKMBlEdBoVWMsha7oXBN0v8lkpygwXjlLPGssbEIx05NDP2Za821hdxj0w3MxigSePb9Y1ULSfDe95yOCONZfOGbMhTYH23QqLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ciy0Zm3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ciy0Zm3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A584C4CEF5;
	Wed,  3 Dec 2025 16:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777846;
	bh=OcJ7YBzS+TYV1Q3secgEisAtZPOfA9EPLUXkxMILleU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ciy0Zm3a39AY3v+aDNSyOlzY5e1+1fWkTw0j2/Dln1BRI3GJ+J9lQjuXrRUm99nAW
	 Rguia0+KlgBrUg7hcg/cfgs+UpTEZzS0tHj1Sy9t/13u8HzX0z+Fg3vb6+0QCumij2
	 AlF8qhCBfD27b7fXij8uU2LdfAJdedRhtcKKcMFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/392] jfs: Verify inode mode when loading from disk
Date: Wed,  3 Dec 2025 16:25:14 +0100
Message-ID: <20251203152420.113479706@linuxfoundation.org>
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
index e132dafa1b6ca..6d6425cdb1185 100644
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



