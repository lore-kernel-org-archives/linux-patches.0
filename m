Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6161C219A8E;
	Tue, 16 Dec 2025 11:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884828; cv=none; b=BRC82IoP+QESCvy8akhHdhuTS8r/tejWzEnDcHwnIS60qBwTxYNrvxIf8i9JwGaNMarnkrnhfmb5e8ztRREDe+eTC4A4wHcoN9akih+waN2bQp2vi+Y+XHT2oquUNy3M6IIdWp75vTtMViODw+k27iFgZgg51/Be4UK0KPwaxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884828; c=relaxed/simple;
	bh=xYjsP45h2wYkxbfxthsYVrsgz7JlWat7AiOs4Rhp/VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXfcPZ6QbpEk2j0hyaHgCVQa8J1w0eNxpQWfugjrAf0P+KA0WvMDOWNR1x0/bCKO8mN5px2KQGlrFcZhNDaCR5ubw455mInZgdjCOP78WxGfGE4TB1gDyh5x0THX3lB+v36JwQE1X13DMaQZvdOKiulVIoGy2HMCRcXfyyHRYMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u09MYKI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u09MYKI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EFDC4CEF1;
	Tue, 16 Dec 2025 11:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884828;
	bh=xYjsP45h2wYkxbfxthsYVrsgz7JlWat7AiOs4Rhp/VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u09MYKI0V9Fk8RhHdKJCX4ojMdO5VDuiD4IcYJWwCCltvev0DI8GENv3FHFR/j/9S
	 MVxZBPhnZm1v35WLOXleQm3ej/7XS7Pe6ZBDImqfFJMNf2ZddfSPTo5Wa7zdhC3WSL
	 8ZJNeCLsYzs2OSYD0/8IBx+rn5ZjMGj+MZj25vjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/354] Revert "nfs: clear SB_RDONLY before getting superblock"
Date: Tue, 16 Dec 2025 12:14:37 +0100
Message-ID: <20251216111332.142757795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d216b698d44e33417ad4cc796cb04ccddbb8c0ee ]

This reverts commit 8cd9b785943c57a136536250da80ba1eb6f8eb18.

Silently ignoring the "ro" and "rw" mount options causes user confusion,
and regressions.

Reported-by: Alkis Georgopoulos<alkisg@gmail.com>
Cc: Li Lingfeng <lilingfeng3@huawei.com>
Fixes: 8cd9b785943c ("nfs: clear SB_RDONLY before getting superblock")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 44e5cb00e2ccf..ae5c5e39afa03 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1303,17 +1303,8 @@ int nfs_get_tree_common(struct fs_context *fc)
 	if (IS_ERR(server))
 		return PTR_ERR(server);
 
-	/*
-	 * When NFS_MOUNT_UNSHARED is not set, NFS forces the sharing of a
-	 * superblock among each filesystem that mounts sub-directories
-	 * belonging to a single exported root path.
-	 * To prevent interference between different filesystems, the
-	 * SB_RDONLY flag should be removed from the superblock.
-	 */
 	if (server->flags & NFS_MOUNT_UNSHARED)
 		compare_super = NULL;
-	else
-		fc->sb_flags &= ~SB_RDONLY;
 
 	/* -o noac implies -o sync */
 	if (server->flags & NFS_MOUNT_NOAC)
-- 
2.51.0



