Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D252032C95F;
	Mon, 27 Oct 2025 18:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591458; cv=none; b=CY2UK1twupmydq9aXCDD9CnhXFg5yN+ZsNSoI8QK+9RAu5LoGnN0hMOwpDVDsl5hDwEJEHfZ4+wz07B+aZVrbDcKPNeBeXeJFLVvvrY+x92BiifVDcW7Xt3Y9qRErRa96v8N86+MsvhRsGrfgwp342bBLK2XqrKiP9loG94TKkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591458; c=relaxed/simple;
	bh=fGZoDg4q6f0ijw+oSwSI986+HbvknNHoJnRhNgOTQaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zw/3WEAHtX3SWWm7X0K3qwwXWlMBrnjCtzMv3q9FeXt5kpsdWk/IrAKermjFC4n1+zdIjVQuVtfaoBVJjTv4tz6DC7aDmYrX0jwaPf4DVsKcBLH1KF/IygIBtJQ8sDkwr+lx+1/8SH0ll/kyD1hC3V7Z5pGMSNekQEwuNByHRFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d99bQf2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d99bQf2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643ECC4CEF1;
	Mon, 27 Oct 2025 18:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591458;
	bh=fGZoDg4q6f0ijw+oSwSI986+HbvknNHoJnRhNgOTQaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d99bQf2mCa3WZBs7Q/DbFF+JSWiqQsNqs8Z3FKCKFjxiSnwTPiQ0gXwtPnHYEH0Jc
	 Z5KTSWB1psdfy1yE1rdMjmsphkICmIkYNuhzL+QwI6IwXqi/2hR1JCo7v3fURmOL7P
	 HfcqgGfEG4RYt7tX3xYZtmYoS9Xdlx0yiv8xotzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/332] minixfs: Verify inode mode when loading from disk
Date: Mon, 27 Oct 2025 19:34:00 +0100
Message-ID: <20251027183529.614520324@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e938f5b1e4b94..7636e789eb49b 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -469,8 +469,14 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
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



