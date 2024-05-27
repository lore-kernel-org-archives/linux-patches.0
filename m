Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25533168C4;
	Mon, 27 May 2024 19:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837825; cv=none; b=Pydd50EMcqbk6l1ckWxCIGyrS/nEA/ae7smW14L8jysamTVNoUfhEdnuT5lgbQL3LLsI/jsADrCaLr1RQIJANY290r6ZWSw6cRM5HdVCUQVlxq3uUEQiQI8kCAeGq0g3x9OTYzNjms31L7ufI4G0mH5ejGoSefts34M3hQ8waac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837825; c=relaxed/simple;
	bh=14LyUVF5+Sb8X73f2OkZ4S6Od1BZt5XGWLtgEvHu5Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPT/bP0oqfqYwvSKBOWieGjFY3TPW5ArptSl/DRA8q6JKSO2FU0Yfy28hmghRlV0t2za9fDpQmQ7utlLVWoD34tAf8sR1XL/4ZUcF7JdN4DKA2z8aQH4Z0W0kQLdopXcpzxpYPPJS5X/TiOZm1iW1j0iBsq24h4IHcROD8CRBrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtQRA3qc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtQRA3qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3BDC32782;
	Mon, 27 May 2024 19:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837825;
	bh=14LyUVF5+Sb8X73f2OkZ4S6Od1BZt5XGWLtgEvHu5Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtQRA3qcYfOc8G+tIjcthskkhYoOVqkwro0uIEObS5sD78t3IJPl/Rbv5cyyCezgi
	 0q+ufgb1vIyVPUBTOpxyjD5oVKnOoJH8aKBqR+/zH5yYX54NDWl6zBVf3rbEBGk1ul
	 KUXV7eeqGoRMFiL0m3lLssYGBZUhhAeFLSWP8h8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0a3683a0a6fecf909244@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 158/493] block: refine the EOF check in blkdev_iomap_begin
Date: Mon, 27 May 2024 20:52:40 +0200
Message-ID: <20240527185635.577231649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0c12028aec837f5a002009bbf68d179d506510e8 ]

blkdev_iomap_begin rounds down the offset to the logical block size
before stashing it in iomap->offset and checking that it still is
inside the inode size.

Check the i_size check to the raw pos value so that we don't try a
zero size write if iter->pos is unaligned.

Fixes: 487c607df790 ("block: use iomap for writes to block devices")
Reported-by: syzbot+0a3683a0a6fecf909244@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: syzbot+0a3683a0a6fecf909244@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20240503081042.2078062-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 0cf8cf72cdfa1..799821040601a 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -387,7 +387,7 @@ static int blkdev_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	iomap->bdev = bdev;
 	iomap->offset = ALIGN_DOWN(offset, bdev_logical_block_size(bdev));
-	if (iomap->offset >= isize)
+	if (offset >= isize)
 		return -EIO;
 	iomap->type = IOMAP_MAPPED;
 	iomap->addr = iomap->offset;
-- 
2.43.0



