Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B96354AF2;
	Tue, 16 Dec 2025 12:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886481; cv=none; b=gj0u7ffpo69B/RoGRYabSNXOWaKrI1OU+3UI/4EGdq8xeqXnx28cogyxJYiAo4OhVLptSaZalkd6IwBx/wycItoSis1JIkrrePWAVlDdv5D2aLWZX00DddRfc9vw/VEV4LKygG8GrJPy2mvZFPuxD2A7QdIGHRPKZ4u30WrwfFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886481; c=relaxed/simple;
	bh=fSaJUnC6iB6Gg0fwxu5jNbAYscbUPwQSFbVT2vG7r5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9HFfg210RHxbiaxpDFLOkHG49RL/zSwL2FGa/5KIGj6O9dpM/+XZ12Kfui2GtJ2W67TE+lxNKekBHeetvSinj1anq8higeWnN4zxGVGZpVGqRMV7e2tcP1X3awWZUCOg9BYwGsa41QDz3qozDztz+ffaLxaXVh0TYwDl6H0Yak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odeg8Ydv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odeg8Ydv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13136C4CEF1;
	Tue, 16 Dec 2025 12:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886481;
	bh=fSaJUnC6iB6Gg0fwxu5jNbAYscbUPwQSFbVT2vG7r5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odeg8YdvrZ7WS5nu2BaZyLAvMyE1JXmFNFUfUkS3fjnQ3LxblbbY1vbnXqt4kNCAr
	 awb4jrxyLglNK1t8wbLtpHj1iFOJG1hESh86fUNH5qVnH2ZA+XWtr/6v/K+eaYHwWW
	 7ygmptD9mI04afuyhVAZV8YIpUEdyyEop++k/3bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 449/507] Revert "nfs: clear SB_RDONLY before getting superblock"
Date: Tue, 16 Dec 2025 12:14:50 +0100
Message-ID: <20251216111401.719548748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index 527000f5d150c..9b9464e70a7f0 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1308,17 +1308,8 @@ int nfs_get_tree_common(struct fs_context *fc)
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



