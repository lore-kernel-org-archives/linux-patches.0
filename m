Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D830217722;
	Fri, 17 Oct 2025 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714788; cv=none; b=DgdkajLPPsJgYMhAH11ufYA4EAl2POVUbDvX0T7etn0npeiF04SFcoFp+r88c10ePy9Gt+52xh7at6xO2URpVXfcGHDdSNK6R22PFWMCEbQI0/x5zT2qyPHjBh7Cc8tCif76hQJ+0aXuE86jfWu0zZwNWnYXg6i/0RQExns0lZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714788; c=relaxed/simple;
	bh=RbDeQX5EkfLsPjlFOvk7my6V4Kyycgf4ASkjnASx0GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRSVHvj4ZJb27lDVK3Fj5TeDBfSXGGac2KwYZKuhIoZsjcYuAK6MSjOTWC5W6VfntH5PZGC+wa3m5FJN9sgDYJ6nzR/pehUoCHHwVqxsKKl7q2f/clgMDJHVb8wxDuhrkdnUoAs6wM70ShocV6PI+L2eKvATyh9d3Jhd1JeOeSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRkc6+mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRkc6+mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096D0C4CEE7;
	Fri, 17 Oct 2025 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714788;
	bh=RbDeQX5EkfLsPjlFOvk7my6V4Kyycgf4ASkjnASx0GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRkc6+mkaM9fBhNTZH4KmLWPoTJtMQEPZ0h5/Pb0coeYXepl7R0v4qfNo/1uH2Wg8
	 XbbA2V9qc30XnZb3bt4jNWLXCx+fRzZ28L0zEniCKXvhQ0UEnjPr6vFXql3qEj7Zgm
	 9onalC0eHXrjZzf9CeZb0iS16WvkuS7TZKOQXwoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/277] minixfs: Verify inode mode when loading from disk
Date: Fri, 17 Oct 2025 16:54:33 +0200
Message-ID: <20251017145156.873842352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 73861970938ad1323eb02bbbc87f6fbd1e5bacca ]

The inode mode loaded from corrupted disk can be invalid. Do like what
commit 0a9e74051313 ("isofs: Verify inode mode when loading from disk")
does.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/ec982681-84b8-4624-94fa-8af15b77cbd2@I-love.SAKURA.ne.jp
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index f007e389d5d29..fc01f9dc8c391 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -491,8 +491,14 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
 		inode->i_op = &minix_symlink_inode_operations;
 		inode_nohighmem(inode);
 		inode->i_mapping->a_ops = &minix_aops;
-	} else
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
+	} else {
+		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %lu.\n",
+		       inode->i_mode, inode->i_ino);
+		make_bad_inode(inode);
+	}
 }
 
 /*
-- 
2.51.0



