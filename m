Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DF726B087;
	Thu, 13 Feb 2025 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460871; cv=none; b=IiY6En5+PP5Eu11iyADtfpUnhfccAR70svLt5RTgxZ6Nl8Ds8SUvMS23uEpioR/v8nXrM4pOeeu+LqgnC26khwxCtYc8S7K5QE0Gf+277xE44znMDvxVH4avNNImv56LHy+0dca2LwgSSM5ZGNtoEI6AHzxPdVMXY8mP1Z3aQAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460871; c=relaxed/simple;
	bh=dwQHhRUjl+wF6tS0zGHf3rcy/DWrVuLDW0d/W4IXUC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttlmHJvcaXngMiQP/7//ZLQYlsfqauY/1ATYmLA2nhNsR/AEJ6E9/kehK41idkDOB+gMW4Eh0wzMMU5KS5Rn0di/SGuoaQ14yzQof3aQ9vZCyqO3L8v9iFQUPzlloutM9Vfr3pl2Fywm3aqpKFaIyzEIuJMojzq6WPoAdDfUzHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knl/aRy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knl/aRy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092F9C4CED1;
	Thu, 13 Feb 2025 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460871;
	bh=dwQHhRUjl+wF6tS0zGHf3rcy/DWrVuLDW0d/W4IXUC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knl/aRy2g900KPcDMohGO9b6uqTG4vp68WK3L6Z8h2N4EbrhzhyHyLJqfDQMF1HV1
	 mYI3LvmfNBqVOmHFfuNWOk9DMuIZkqkQQSX00QlGL6dhDOJLeu9FBNNwm5Z7oWIz0K
	 X96Ate2S2q2lcpgcZiBV4c6LQGtCeSc5Wa4//Vws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 235/273] nilfs2: fix possible int overflows in nilfs_fiemap()
Date: Thu, 13 Feb 2025 15:30:07 +0100
Message-ID: <20250213142416.720921132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1267,7 +1267,7 @@ int nilfs_fiemap(struct inode *inode, st
 			if (size) {
 				if (phys && blkphy << blkbits == phys + size) {
 					/* The current extent goes on */
-					size += n << blkbits;
+					size += (u64)n << blkbits;
 				} else {
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
@@ -1280,14 +1280,14 @@ int nilfs_fiemap(struct inode *inode, st
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


