Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2059434D3AE;
	Fri, 21 Nov 2025 13:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732693; cv=none; b=gN5ko9//h+F6C3+acW7em3fDhC7seJVE35+2GiRBU/a/EXdg1tfBLJN57+DAL31a0vvfxnP+ktKzG/e3KRNKVKohPsDkywKY2h9u/b2J1d88GbEyUmUn6KIDS61Txl0kkf0OA6BMmqpUlK/Cnk3Z/P7vuegFrsH5772cio2d8+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732693; c=relaxed/simple;
	bh=/+u39v5QHUWVXXyU0+63PykGbdEdyq/cY0wfycmmzJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arY3O/bLr326TTLGbx1c57CuINh42YyHrcCuFtZTQA67/vbi+fjeZrClbL+md/JsNsM4q4NPk2kHpBF/3RMgJhYNz/QNfjNJxdjAi4TJ5ZUGuI5Da5KIe171yFmfkLJM+HPAyvofp2pjTGLdzUqycJwUYbR8TVFkvCZWTAO1d38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v93iiVxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v93iiVxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5117FC4CEFB;
	Fri, 21 Nov 2025 13:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732692;
	bh=/+u39v5QHUWVXXyU0+63PykGbdEdyq/cY0wfycmmzJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v93iiVxqkXadtrGXSw3Meu5d4rq6kB6y0Gj7TUpmbqZOsvS82/HSgw9Ud/yIi2UYN
	 JX56mfJqQpwh/o3+3KYuWYmHEGK9a5uNNAQv5FsQk0YXlfyDRwDAsb5Ics79Prtu/f
	 xYNXb9LNxN5oNXstwwGN9pQpN9DGd5Xkn5FadxDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/529] fuse: zero initialize inode private data
Date: Fri, 21 Nov 2025 14:07:45 +0100
Message-ID: <20251121130236.926500642@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 735abf426a064..96050028d91b0 100644
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



