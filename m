Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B6510A21;
	Sat,  3 Feb 2024 04:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933332; cv=none; b=eZUd19RWmzAZHlOWcDYNylfCZn13fDwh4VAvoKmjHfGb+jbamdsdNHTXV6HuTSclougXAT5jPRpDhwLtNEVOyxAP4I/ZM8xVx9S0Hylu5QQ48/ps7VHxb/1ZybgtYe+bi4w6VSc5ZP3dLpjrt9wouu8IRsGrMFKKVGTgzF5SPIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933332; c=relaxed/simple;
	bh=+OAw/pGo5Vf1nDDQ/N76eaJZYSt4YY4/I6RHqxeT3dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ4YS5zWR8CLNhN5tk6thuOuCvmWKf6vxEVGEBlmGpghbhq81nKWztOPRZsXlItArRZVPHIuosLBvpcTxbPopLjl/0cTble22lb5h7m0F30PVPgnLufG1TguXbJGNAcieLZGV/ZTh0sf+t4BOoErfmyG9hLY743bJx0jCngtlrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s942w0s2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s942w0s2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA08CC433F1;
	Sat,  3 Feb 2024 04:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933331;
	bh=+OAw/pGo5Vf1nDDQ/N76eaJZYSt4YY4/I6RHqxeT3dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s942w0s2loe5WUAMgPFC1VQW/cSJbhuQbLyM6s/9rvMcRLwwhbeO24Je7q8uDEohc
	 9+yLhQmodxH0F87pugRjkJghh8QjRCgpnebgQgxFgvOPAktFgFf4NlHuSlwaocvny3
	 2aGoNK6RjuIyqYWE0CzIxGrlC4J4Il5/0c5eckv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/219] erofs: fix ztailpacking for subpage compressed blocks
Date: Fri,  2 Feb 2024 20:03:22 -0800
Message-ID: <20240203035320.456328068@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit e5aba911dee5e20fa82efbe13e0af8f38ea459e7 ]

`pageofs_in` should be the compressed data offset of the page rather
than of the block.

Acked-by: Chao Yu <chao@kernel.org>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231214161337.753049-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index cf9a2fa7f55d..47e71964eeff 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -652,7 +652,6 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 
 	if (ztailpacking) {
 		pcl->obj.index = 0;	/* which indicates ztailpacking */
-		pcl->pageofs_in = erofs_blkoff(map->m_pa);
 		pcl->tailpacking_size = map->m_plen;
 	} else {
 		pcl->obj.index = map->m_pa >> PAGE_SHIFT;
@@ -852,6 +851,7 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 		get_page(fe->map.buf.page);
 		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page,
 			   fe->map.buf.page);
+		fe->pcl->pageofs_in = map->m_pa & ~PAGE_MASK;
 		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
 	} else {
 		/* bind cache first when cached decompression is preferred */
-- 
2.43.0



