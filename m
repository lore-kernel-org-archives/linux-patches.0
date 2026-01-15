Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F77B3BF314;
	Thu, 15 Jan 2026 17:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499251; cv=none; b=TIowyn5KX0hpIieMYkrfpQ9aogxFEcnuse4IeySleQ5kM+dDsVB+PMuWdWjS4I7nqwxdBLoxM5vRPeIv9e2o5c8iMrcxUSAHMephQERPwWqLBYSRU9ISlvVD90FRDBpJ7HdjgAVJ08q76qG//ALfiwrvCQYBJIvO74/u255pLI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499251; c=relaxed/simple;
	bh=aOdQBCqoZNWlnSgJJdE/wqKzn6CNw3gfpvSWfcBULrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plA7nCyyx3xKaaHVfkGolkbsZSp+M9ImGbLDexxyjnhIUFeRhzMD1aOwYmDxbW7ghiziqeJc176UV+Qe0oyLByJ0ofcrZokl2vD98iS8eLoCegaNFfAH//7LpJfJYS4NoreBuIAUcBsMMzRRpxbTG7M/g81PHaP/St9cRakrg2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjVamnvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjVamnvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB3AC116D0;
	Thu, 15 Jan 2026 17:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499251;
	bh=aOdQBCqoZNWlnSgJJdE/wqKzn6CNw3gfpvSWfcBULrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjVamnvAgzG+aN+E2/1MKSXlzJzjv/69mefFui/9UckknwFtbrPcf5bDL6LF9N1oj
	 sFoOT2F6B/rFz4KiQT8IVjACeAVlTKvWxcQXnJ0BTbtq9F9v1ePzh5RSWJNEo7xgFt
	 IojzYQyY1+PDTF99fVRssnchg4iz6Gl3kgmkhTjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/451] Revert "nfs: clear SB_RDONLY before getting superblock"
Date: Thu, 15 Jan 2026 17:45:29 +0100
Message-ID: <20260115164235.551849340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index 27923c2b36f77..2d2238548a6e5 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1248,17 +1248,8 @@ int nfs_get_tree_common(struct fs_context *fc)
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



