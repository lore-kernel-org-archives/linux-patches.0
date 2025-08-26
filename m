Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496582E88B7;
	Tue, 26 Aug 2025 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217942; cv=none; b=LiICWrUMaFAnJ28Afxkw3dXsRZsVheB3l7mWMmi9RQiboH1cWTWD2tsphqMLfSX67FpOmIN+kqmeD0xF93TQW5awWghzxM1BZJV3XAZXYz14D1RPwyYxLLkTxXuNrZ3c9Z/Gy2Tek1Z9s9OZRogbPGrwcP3w30/CySuhG3S19X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217942; c=relaxed/simple;
	bh=r5zPU9gPuG78r8glDN7nCmsrE2tJIfJoNKFgEEqrjp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDiD1Sai7ZDfogysFB8hwMvZdpI/84sT7tghxQcE2efs6qJSzQlQKBtecv25cdtOhpVAX7/Be7KMvkUBhiCPfIJZkqGq8Ey1HixRnnXDOZRL3Wp/z5NBSzBBQb7u1zYIpB0mYY3JAIfzwkif+AsxTNZTek75znDGvJo4Vf/P2OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrCBSyJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrCBSyJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E44C4CEF1;
	Tue, 26 Aug 2025 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217942;
	bh=r5zPU9gPuG78r8glDN7nCmsrE2tJIfJoNKFgEEqrjp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrCBSyJyQnV45kyDWfwY5DMzJ2+x2+fKLDFNCuRoMStlcqxGKSv1SJHMIqh/pEB9n
	 ewxMe7fI8HMV7V8K+nDlwvUDo0VHmdAYE/CbvVFY+LGkEDkXDUWUJgvEzCPbREC9hW
	 Uj2PuVDfKHtMUVp7VW/NvLVfp64YAuFY1JZGJoW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/523] pNFS: Fix stripe mapping in block/scsi layout
Date: Tue, 26 Aug 2025 13:09:02 +0200
Message-ID: <20250826110932.665280631@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 81438498a285759f31e843ac4800f82a5ce6521f ]

Because of integer division, we need to carefully calculate the
disk offset. Consider the example below for a stripe of 6 volumes,
a chunk size of 4096, and an offset of 70000.

chunk = div_u64(offset, dev->chunk_size) = 70000 / 4096 = 17
offset = chunk * dev->chunk_size = 17 * 4096 = 69632
disk_offset_wrong = div_u64(offset, dev->nr_children) = 69632 / 6 = 11605
disk_chunk = div_u64(chunk, dev->nr_children) = 17 / 6 = 2
disk_offset = disk_chunk * dev->chunk_size = 2 * 4096 = 8192

Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250701122341.199112-1-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/blocklayout/dev.c b/fs/nfs/blocklayout/dev.c
index 16412d6636e8..4e176d7d704d 100644
--- a/fs/nfs/blocklayout/dev.c
+++ b/fs/nfs/blocklayout/dev.c
@@ -199,10 +199,11 @@ static bool bl_map_stripe(struct pnfs_block_dev *dev, u64 offset,
 	struct pnfs_block_dev *child;
 	u64 chunk;
 	u32 chunk_idx;
+	u64 disk_chunk;
 	u64 disk_offset;
 
 	chunk = div_u64(offset, dev->chunk_size);
-	div_u64_rem(chunk, dev->nr_children, &chunk_idx);
+	disk_chunk = div_u64_rem(chunk, dev->nr_children, &chunk_idx);
 
 	if (chunk_idx >= dev->nr_children) {
 		dprintk("%s: invalid chunk idx %d (%lld/%lld)\n",
@@ -215,7 +216,7 @@ static bool bl_map_stripe(struct pnfs_block_dev *dev, u64 offset,
 	offset = chunk * dev->chunk_size;
 
 	/* disk offset of the stripe */
-	disk_offset = div_u64(offset, dev->nr_children);
+	disk_offset = disk_chunk * dev->chunk_size;
 
 	child = &dev->children[chunk_idx];
 	child->map(child, disk_offset, map);
-- 
2.39.5



