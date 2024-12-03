Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274281DA3D;
	Tue,  3 Dec 2024 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239168; cv=none; b=mhmXAhKYsjQs0Njg5/ihTkrmlfpK0K2RSYaxl82VKE55LK0PelZdc+8BMVhr/eOPPwwWNx+JvGMSpM3XUahEcSOsWJTv2haOmjnU8cZqMe4Vbm7ZfzeqDC4zMq3yY1OeRbJxgUCN4RddoZHfjvMFIHLv02OaHueKgZhP5+b8JHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239168; c=relaxed/simple;
	bh=z3dAoXdz6mHON2J5gZsWTTHiMF2ChJ40D5C2J9ZnpCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFhBSZBFMDKL8qxzbphK5RMyPjDhI16XRV+yhca633dhoIAmsPpGl2EXTK/XOTDcAeXtuFdAz26Uk/B/tqCfMfhohMeEjw6OLXcoSnGBEHmD35s9UhkfsEc2e1dv+gaoHb9O648cTn0MnpwR8M7VhRUWm4E91FOxUQAyr0FbweM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuw3mGxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuw3mGxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4D8C4CECF;
	Tue,  3 Dec 2024 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239168;
	bh=z3dAoXdz6mHON2J5gZsWTTHiMF2ChJ40D5C2J9ZnpCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuw3mGxGwgfo+3A8wndK6+LIFqLgPj99C89IGc/BRqA+Lqput3Z9iLBltcTmknlcN
	 a3z1f+fR/Ufv5B5fbAF1zQlbWdyeuJf71Nn30slwoO23+g7tCcF/zhjvIbThmxCxB1
	 qH23WpGeH2FtLqlteSVaecCNFKAiAj1iTDVxEbAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Cyril Hrubis <chrubis@suse.cz>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 523/817] f2fs: fix to map blocks correctly for direct write
Date: Tue,  3 Dec 2024 15:41:35 +0100
Message-ID: <20241203144016.307467450@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 5dd00ebda337b9295e7027691fa70540da369ff2 ]

f2fs_map_blocks() supports to map continuous holes or preallocated
address, we should avoid setting F2FS_MAP_MAPPED for these cases
only, otherwise, it may fail f2fs_iomap_begin(), and make direct
write fallbacking to use buffered IO and flush, result in performance
regression.

Fixes: 9f0f6bf42714 ("f2fs: support to map continuous holes or preallocated address")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409122103.e45aa13b-oliver.sang@intel.com
Cc: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 60a5aaefc5b63..1f2f397febcfa 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1677,7 +1677,8 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map, int flag)
 		/* reserved delalloc block should be mapped for fiemap. */
 		if (blkaddr == NEW_ADDR)
 			map->m_flags |= F2FS_MAP_DELALLOC;
-		if (flag != F2FS_GET_BLOCK_DIO || !is_hole)
+		/* DIO READ and hole case, should not map the blocks. */
+		if (!(flag == F2FS_GET_BLOCK_DIO && is_hole && !map->m_may_create))
 			map->m_flags |= F2FS_MAP_MAPPED;
 
 		map->m_pblk = blkaddr;
-- 
2.43.0



