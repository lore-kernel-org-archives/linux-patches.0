Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E135D28935A;
	Fri, 17 Oct 2025 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715855; cv=none; b=RxmrxR5ExMpUInYYN6K37edcIwHPwFCFiLucTwJ+RzFPPSkUBfxcE/stlzv+ctTDGhpkyu/9mhYPu3PEpHQtjGKA/alxd1vFFaHNyATJa+kA4kMqZuEJeKpcV2CEZVCf5tHj8O+RvChATzZNgB1x3sZl3e62tpPN3YWvhzENaTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715855; c=relaxed/simple;
	bh=BqFOVS9nlOgYj/3aibV3raqXR/TgZuDvtvQQ6WQLNx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUoHaxzMAaHosDI3yJoZjnk4u5a5g3W8ozuSfsaNRrpr680v0s4ZJ0HNKndKu2CJmBaDfMs9bNqGxE8IxMXayf9jF3LxVA9b2XWysd4ET8wP/nw3lCsdxbbYNAVrfM9c0RNfXnyjN+M9Mgd9V2vPQO/nthyCuEKXN9tolt58+3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4faZ3pu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4faZ3pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8D6C4CEE7;
	Fri, 17 Oct 2025 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715854;
	bh=BqFOVS9nlOgYj/3aibV3raqXR/TgZuDvtvQQ6WQLNx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4faZ3puoOgM8azPEdHkCcgB7jbMKcktIB8ZDGUQIevujqhGdJoeWAMwSuEet3Oah
	 hRVNJ7JVcGRh5r6lqpSeEyzzbUsaIvwuV/qWWM16UV+2DAo9S6i+eG6v1VPIECWgu5
	 MXUgnBwAUTxiwHXSl6nYe3+VuJBS5C+2pJaPdK0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 360/371] minixfs: Verify inode mode when loading from disk
Date: Fri, 17 Oct 2025 16:55:35 +0200
Message-ID: <20251017145215.112519780@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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
index df9d11479caf1..32db676127a9e 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -492,8 +492,14 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
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



