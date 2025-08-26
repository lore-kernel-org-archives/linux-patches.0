Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D18B239E8B;
	Tue, 26 Aug 2025 14:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219136; cv=none; b=cnse2LrecNB3pA0AjAfnNO844nbK1QfIm7UEAmahZve+iTgDyrr9bN+qO5gabi4pU2o/7FucfOREQFPoJNaam7k24wqahOHrWHK+SRjtwqFxplWXxdDYrHT5atO2ozoAEk0mZZ/x5jP+SE5CIpSOrzeDcPgiAotFHd8V3gyIV+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219136; c=relaxed/simple;
	bh=+i9a+WWHrI4ixR8iaZx/IZTobwGPi8hqedAaZ6IYWaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evBplre6Wn5E6T8bGMplN4pOoqwWTEkKki1dAI9jYVhK7Z9Ga+ge7jlS8VUvN9W0GYuYxBJ5J6ZRg2mT6lezt0uc/iD1HNpBR7Bk8D+KCL8rWkR5rCHuTRmbBVoxe9v1QSg41we9wmx9GKsCkdrp8mePDIA7odm2sB0Mdv7RBs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZPk7g2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZPk7g2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2448C4CEF1;
	Tue, 26 Aug 2025 14:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219136;
	bh=+i9a+WWHrI4ixR8iaZx/IZTobwGPi8hqedAaZ6IYWaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZPk7g2v7la4nKOvn4Hjn2AMrWJA2z13f1sWPvXwyJce35EGyFFEHG4On4rr/fKhz
	 9gHFK1gS+Qq4AGShp2Ig4e/o1S6cbIsaeejT3tIAKFJUu6oIwhvo4U+kVblItLlO/N
	 wIL5DC9yJWFZf8ZiV6Ww5DOH+nIWbVax52Nt/N7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 267/403] pNFS: Fix stripe mapping in block/scsi layout
Date: Tue, 26 Aug 2025 13:09:53 +0200
Message-ID: <20250826110914.181640237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6e3a14fdff9c..007d68a3a616 100644
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



