Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C56125B69D;
	Tue, 11 Mar 2025 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707023; cv=none; b=ZVjt03EZzn3HNt/2CmXt4i+qnFjuHeMtgzw3quYRUutS9kfhtk8U63y/mJ2YeKxfZkSVq16dpad+UqfKJezMZxMdyrDzXoKR8ifvZ3TUj6ucxtLOgGI9XPMRahS++dGWV9qEbwk4xhMhKl8kwlwanF10sA0+6tX7CK1Bqxzf4/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707023; c=relaxed/simple;
	bh=U4V+RycGWHQMzcU5CFQ07j0RP+Q44ry/rsd6uTn+jyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+nhqcy4uUiheDXR/TlzpFp6kdieO4y9FQRC4L62jDH31DMg6gwDevt/705dLHIPOyNDdlwAcWVFzWvlm9WyUIv+SVp7Xyc59tzr17g5vZYYiUlgoVRCQI9WxqPB/HePLdLn5Jk2shEmaiNO949QAFI97ten76v5ZT3nb33GnlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1vbs8Am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1vbs8Am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12C0C4CEE9;
	Tue, 11 Mar 2025 15:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707023;
	bh=U4V+RycGWHQMzcU5CFQ07j0RP+Q44ry/rsd6uTn+jyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1vbs8AmP+TA3F7+vl+IRzRTRYuAPdcLJWezscYBPPPBPNrhdvWeTcNozp6clYXzY
	 dTZRBUyDtwjRfXJGgIWkTV5HnxMPMbOWB7qJokrN7JFbaUkpei68V0v0piofrd25ci
	 aY08CKaZxl+qQ4UZp2RirH4FofFoHBGvBWpSq/zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 216/462] nilfs2: fix possible int overflows in nilfs_fiemap()
Date: Tue, 11 Mar 2025 15:58:02 +0100
Message-ID: <20250311145806.898059205@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 6438ef381c183444f7f9d1de18f22661cba1e946 upstream.

Since nilfs_bmap_lookup_contig() in nilfs_fiemap() calculates its result
by being prepared to go through potentially maxblocks == INT_MAX blocks,
the value in n may experience an overflow caused by left shift of blkbits.

While it is extremely unlikely to occur, play it safe and cast right hand
expression to wider type to mitigate the issue.

Found by Linux Verification Center (linuxtesting.org) with static analysis
tool SVACE.

Link: https://lkml.kernel.org/r/20250124222133.5323-1-konishi.ryusuke@gmail.com
Fixes: 622daaff0a89 ("nilfs2: fiemap support")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1263,7 +1263,7 @@ int nilfs_fiemap(struct inode *inode, st
 			if (size) {
 				if (phys && blkphy << blkbits == phys + size) {
 					/* The current extent goes on */
-					size += n << blkbits;
+					size += (u64)n << blkbits;
 				} else {
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
@@ -1276,14 +1276,14 @@ int nilfs_fiemap(struct inode *inode, st
 					flags = FIEMAP_EXTENT_MERGED;
 					logical = blkoff << blkbits;
 					phys = blkphy << blkbits;
-					size = n << blkbits;
+					size = (u64)n << blkbits;
 				}
 			} else {
 				/* Start a new extent */
 				flags = FIEMAP_EXTENT_MERGED;
 				logical = blkoff << blkbits;
 				phys = blkphy << blkbits;
-				size = n << blkbits;
+				size = (u64)n << blkbits;
 			}
 			blkoff += n;
 		}


