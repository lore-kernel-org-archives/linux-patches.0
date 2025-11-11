Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652542857F0;
	Tue, 11 Nov 2025 01:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823482; cv=none; b=bQHYLTUC1DkaXDFY6B0du9QGUrKBa9J7FSi3NEmIxmiTw+23X7rNDxuKphm4hnRx8utlqOsXgZrX2p/0A0mBNORdVOXUsZAYZGlB5KcO+UEpa3J9crzdodgqO1nceULh5P5xVyOPKJe6mtG4FaCEAn8mDVR/hw0cEcUW63VuwOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823482; c=relaxed/simple;
	bh=oDuLshvQ9iWE/T5St0n//bXxfqJFNwvzFK2iG1oFYTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuxf8OcaH6MYETg21W7RjmAUIPiAoUhXtd6IVn95wOtS7+g2AF9cOQS142Z0pdT2h3axLyqA/5NYMgt6j/ypiDV0614ZX88E0KUa3WJBjbNP8MzjwExtJpggeASq9vequTGQqXkO9C0hdiOCfEpeOwZrP8lGxqp5OI5Y1pXGFlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBBBweEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBBBweEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EB1C2BC86;
	Tue, 11 Nov 2025 01:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823482;
	bh=oDuLshvQ9iWE/T5St0n//bXxfqJFNwvzFK2iG1oFYTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBBBweEB2iFYgilu7KIqyGY505X/CDDZ0ac69rSB6JMzEZVtA/N+cVQ7+fu00gwHF
	 0VVtZ4ZBa8IYRZkOF7VhMeZhEt9vlK49AsKxpqL9GRvMIPX6D5jWekrvBtpPsZj7VX
	 Z7qt4SF0FwkfsYJ/Pia2kbQPCrnDUB4YdmWDBAjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/565] fuse: zero initialize inode private data
Date: Tue, 11 Nov 2025 09:41:51 +0900
Message-ID: <20251111004532.639130626@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 3ca1b311181072415b6432a169de765ac2034e5a ]

This is slightly tricky, since the VFS uses non-zeroing allocation to
preserve some fields that are left in a consistent state.

Reported-by: Chunsheng Luo <luochunsheng@ustc.edu>
Closes: https://lore.kernel.org/all/20250818083224.229-1-luochunsheng@ustc.edu/
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/inode.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index fd3321e29a3e5..153f3102f167d 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -94,14 +94,11 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
 	if (!fi)
 		return NULL;
 
-	fi->i_time = 0;
+	/* Initialize private data (i.e. everything except fi->inode) */
+	BUILD_BUG_ON(offsetof(struct fuse_inode, inode) != 0);
+	memset((void *) fi + sizeof(fi->inode), 0, sizeof(*fi) - sizeof(fi->inode));
+
 	fi->inval_mask = ~0;
-	fi->nodeid = 0;
-	fi->nlookup = 0;
-	fi->attr_version = 0;
-	fi->orig_ino = 0;
-	fi->state = 0;
-	fi->submount_lookup = NULL;
 	mutex_init(&fi->mutex);
 	spin_lock_init(&fi->lock);
 	fi->forget = fuse_alloc_forget();
-- 
2.51.0



