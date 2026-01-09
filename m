Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C2133032C;
	Fri,  9 Jan 2026 12:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960041; cv=none; b=W3zpTzoorVPtue5lN0X0K+jZkQ9/KMnPjspoAYSOT1P3r4bZF/sNLJnUJ620GYFjS4ZuOwembCAizOMePyFVUgI4kW4DK/2tY+5f5keAwnpWcLUB+GWix+jVWvMlSq9D3WzaoKNd14l3At2jHHeqEUMv0n6dwnGbN2LPYqEUQI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960041; c=relaxed/simple;
	bh=luZyloHN2DMSIU/RTHgHVbRiBsxxOAyzyq7dDiK+Yh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz5Yhtf7RzfIsM72Z0+fnk+hNhqRa2Kzzm6M21+8/3m3roHItloxVgysn0KVuzD9jC8p1ltBSqcO10VDYAgtjZMeFEFy8RBz3wZTndcAX0vAhAKCX/n2wRJ10FcKrGkSHV5tE3Hd5rqsAF8VF0E5IrsNUWA6nHTMdXXMwrvULYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWCeJXUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWCeJXUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26556C4CEF1;
	Fri,  9 Jan 2026 12:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960041;
	bh=luZyloHN2DMSIU/RTHgHVbRiBsxxOAyzyq7dDiK+Yh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWCeJXUs5/p2tCseWwNtkILd47aB6BvFpy2qI7SueIp8sGgy+v4OIMkmGDGHNOE35
	 sNYkQGd5vEh3tW2/ldbhjPzgiUxnwCWA90p6SrYjOE6w/5f6aRXYDrvZXGrkwQER31
	 e0DYYkDha3TPOHjaTV6S82ecvJJzc/Zi16hnxgIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/737] Revert "nfs: clear SB_RDONLY before getting superblock"
Date: Fri,  9 Jan 2026 12:36:44 +0100
Message-ID: <20260109112143.962519299@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 59bf4b2c0f86e..e1bcad5906ae7 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1277,17 +1277,8 @@ int nfs_get_tree_common(struct fs_context *fc)
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



