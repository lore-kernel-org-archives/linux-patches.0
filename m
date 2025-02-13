Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0E2A1CF;
	Thu, 13 Feb 2025 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459914; cv=none; b=jKHGECwY2ifSKumx+bwbXwma1et7kxeDM0rOnJUKvH0ohIlNMJ2D7To9qKrqWTyXgJbi7xHrMF/7L3hHw48WEIS2nVgmRCvRTgeIxA7+OCVl5uKJYva9pU3wTCPifZ/RwUIcDtEfJ+am/856L5SOr/yNtYqhSHm6ryk9gn3CbPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459914; c=relaxed/simple;
	bh=lXX9sACP/thvG+c1+plsN8jzulAEphqeELkJPS6AHOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Drr4Bs2xV1dh3eA2qsP+dyiPjH01hawRFHCaa1Kkmqt10672ElVMKo/omWWCymmdjpfl7DKJAEYP4iKSRQ718Oy5lCH+eXBAgfeI02RiYuTrEYS3zEmE61kPlOxj52xKs/ZM3SbCLRp/o/J8qrXDZCU1rerYTV3+fA8rSgcqW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=do15G55E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="do15G55E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EC8C4CED1;
	Thu, 13 Feb 2025 15:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459913;
	bh=lXX9sACP/thvG+c1+plsN8jzulAEphqeELkJPS6AHOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=do15G55Et4VPAoMfkMTGmFobiy6/Kuaxbd30RWURvelUdpYNmDIKT+lvRi7RWzc+r
	 Q5RjPhv5rRBbwodn6v82t5dIqLcF+9Sy0fTfAG3usA8enGh0TID2tOZknSLFnTpUvQ
	 7Js3q73dT7M57uZOHEnL7gXS5K3qjlS7dPNHafTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 401/443] nilfs2: fix possible int overflows in nilfs_fiemap()
Date: Thu, 13 Feb 2025 15:29:26 +0100
Message-ID: <20250213142456.080748719@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1188,7 +1188,7 @@ int nilfs_fiemap(struct inode *inode, st
 			if (size) {
 				if (phys && blkphy << blkbits == phys + size) {
 					/* The current extent goes on */
-					size += n << blkbits;
+					size += (u64)n << blkbits;
 				} else {
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
@@ -1201,14 +1201,14 @@ int nilfs_fiemap(struct inode *inode, st
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


