Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6F233711F;
	Fri, 17 Oct 2025 15:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713446; cv=none; b=HTTrfHe6lVrxvg+ms1xWrc3OS16+pLYfqVaeWDq+l6QP8MalkkSKHSTLMAQ6f4uGRNRJwlaZAcFvwRCkwNdpRimSaioLSc0e02/xiPBLQa8o2L2P68frYh/gGt6U8nKNWKJJQ/xvnOOc/P/fWFNIFHdQfjzk5mZln0fWeDtssuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713446; c=relaxed/simple;
	bh=45o7xz+O4+HlcxcXpB9uzFJ/cOrfV2gnQYFogqGlXpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2JGkINxgG8nAN6z4SxiN3/ksx/7LfmDvrgQMwXdyyEasbjLL406JztlkuwpqocDexUMJ/joZmqZ78XdpM9787EGG0Q7wnbxxrSpI24rbZLPGHNn6Ci1LauRBWh/wF8hZWA0oqyERjPJNhvRI147JZVIgpZj1hwMDHOTwUO4yWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2HBTEVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2HBTEVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF15EC4CEE7;
	Fri, 17 Oct 2025 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713446;
	bh=45o7xz+O4+HlcxcXpB9uzFJ/cOrfV2gnQYFogqGlXpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2HBTEVCof0ZoMZgfxGk357dNkcVrgYO7DpWVTkiNL6Yb5mA6lV6So5MGgfsHflrg
	 20ImyTPtEXIOiNLRvS4KT+Xd2G+bt2Wl1cyjQkh2519lfhgo3wEcqac9lzY2NVZbxb
	 g1mp2PeRhR0siZ5l0Sz/vmsiq9nTgE+GTtWSzAIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/168] minixfs: Verify inode mode when loading from disk
Date: Fri, 17 Oct 2025 16:54:00 +0200
Message-ID: <20251017145134.980113135@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index da8bdd1712a70..9da6903e306c6 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -470,8 +470,14 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
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



