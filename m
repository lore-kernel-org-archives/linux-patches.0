Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FD1322DC8;
	Mon, 18 Aug 2025 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526118; cv=none; b=TqVfsIym7AdVaYUWU7ybhDB/OfpMBtdpNF7CvgoUlLQceqhEzB0tg4SB6qudtq/sV2P7mW83IjK353/FZ/fkuN7U/Xjt1pkAIDeu/6B9NbpM3JLCbg0VnCa/iabtpAsxfXb3v7bprTyq49Hwdg93qJp36B2V2e1SMRBkdjtBTd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526118; c=relaxed/simple;
	bh=2i2wVO4o/GNpC4rQDvnlH09GUGWTveWAHMNVYjpQBCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Spt4yRKGh06z3O3sHV+O0BPcWXPF26zo0I+1JE5PdrA66nVm/6osoKrzHe/Qe0zdXlMp+tZMyqJLiN5aKkzZlicnT4d8kMg76yUumUvXjsobqUIbdlpi8ky1cEA9BduAdBoh2Cw6cR58qVek/9cOL9+DUgZFg99QWmhfKyJTKbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSPtrNpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSPtrNpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0138BC4CEEB;
	Mon, 18 Aug 2025 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526118;
	bh=2i2wVO4o/GNpC4rQDvnlH09GUGWTveWAHMNVYjpQBCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSPtrNpHeTzSiN6+GcsqKl7ErE8I+RPxcx1DdbnTghXSf/ERWfnBko2JgtxkbIsoA
	 Xj7lxzNKYx4d6UgByvEo9iAf3lPqxN1POEmEdzSrxIeAc8W6qAoELCZhwJW+XYGu1q
	 2cXLFgQqFLmRu3yKDW4u0zZJ2sSBS4yj9zbPr7ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 464/570] pNFS: Fix stripe mapping in block/scsi layout
Date: Mon, 18 Aug 2025 14:47:31 +0200
Message-ID: <20250818124523.737808663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index cab8809f0e0f..44306ac22353 100644
--- a/fs/nfs/blocklayout/dev.c
+++ b/fs/nfs/blocklayout/dev.c
@@ -257,10 +257,11 @@ static bool bl_map_stripe(struct pnfs_block_dev *dev, u64 offset,
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
@@ -273,7 +274,7 @@ static bool bl_map_stripe(struct pnfs_block_dev *dev, u64 offset,
 	offset = chunk * dev->chunk_size;
 
 	/* disk offset of the stripe */
-	disk_offset = div_u64(offset, dev->nr_children);
+	disk_offset = disk_chunk * dev->chunk_size;
 
 	child = &dev->children[chunk_idx];
 	child->map(child, disk_offset, map);
-- 
2.39.5



