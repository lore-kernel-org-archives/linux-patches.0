Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455FF330B1F;
	Fri, 17 Oct 2025 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716638; cv=none; b=QAf5u8j5UXW64+RUvYnVJKNmlzacFkXP7TkC5y9zF7R3FNLLxtXXLOSYm1k3Lym8NpmODbE/imcI8gNIP4fEdbNGDp1ETkM9d1CUlAnKD2RNe8mEZ+4M3sKvUUMRvEPuf/aIsHotj5957EaDO7ZfU3SGmDkY5hjMPyzSIphEpvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716638; c=relaxed/simple;
	bh=chYDtbYQrCFwWVwdTxRpNYfkOth8G1nsRUhBJt67QCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm+SgCMSPt6Xam7/ThXe6MS4JtfwEyA/s6oHeZNGxpN/UIy1BkJMC8xgdIJYxf2wvVkSbEkGjbcRXu7nnDyv7f/8zpAwdkV5EMZbNuf8hTCqwEyDx+V38v1QSjEGyiAcN2U1cN496bE1kkv41rqq4AZ1bS/5H7evOKq/giRoZP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0Lwk9ZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0Lwk9ZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01C3C4CEE7;
	Fri, 17 Oct 2025 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716638;
	bh=chYDtbYQrCFwWVwdTxRpNYfkOth8G1nsRUhBJt67QCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0Lwk9ZJOs6rW/hEuXhGWOofUlJhGxatAMVEpFJ+TGUUDy91HVMXO51AyveNSGJCA
	 rid/F08vj33oeEgpN9dJahNOm+PJ1V004xt3jEVpwGLO+bfGBUuQHsvf87yKGJRWsC
	 CsOG7bIICBLCaYPschjyzFUWRKytal6JD1PN4Lws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/276] minixfs: Verify inode mode when loading from disk
Date: Fri, 17 Oct 2025 16:55:53 +0200
Message-ID: <20251017145151.978675212@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
index d4bd94234ef73..807ae40b64b06 100644
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



