Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD4F196D91;
	Thu,  6 Jun 2024 14:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683179; cv=none; b=O315NCkA44L0XHQJmD9pIoZWATK9czHXVVemvV7POXo2oZAgYiiPTH3EB0l775gCo4qjZtb5S2NCj3LGPlGIPbzEaWulYx9NNVdlW9i8PL8yyw2EsiaZLwPbzu1/s5FHBuBk6YAZ6UUMgaQgngsiMo9FZwoesawwe/IAUSpVb00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683179; c=relaxed/simple;
	bh=S7DMTdNHZZv/pySDPtO37F/xSW48mpMrQ3p2p3BqC04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHDniJQK8KK4AlE83L3xrcsdpauaPINj18LWwkb6+RMd80bmXLGL4Dt8MGu++eDSYsd8DwnSm3e7awnxqguT0rj1rlUIzjnM3p03VpF5Bo2ZX1O3I/J28h1c2Ce/7T2ScpGd4J+JHvLwguSMb/lhXwM6/SMxRix4PZZWfXqTGng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBq4oAuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBq4oAuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D9AC2BD10;
	Thu,  6 Jun 2024 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683179;
	bh=S7DMTdNHZZv/pySDPtO37F/xSW48mpMrQ3p2p3BqC04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBq4oAuKuqjLHTxbSsQbZcg+m+6pWvQSQfLqe0Fca8ayc9avQ2oK8VL6Q+h+9YdkT
	 uBEhH8n5hn8ionh+Qi+K2BHQ4xHHsqgkKbEzatY+NVnSjtSXCHmkgT+E4PlIw63nrE
	 W9IgBL+8bK5nK9whLljUqZ9ZKW0bGVMQwwliSyZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0a3683a0a6fecf909244@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/744] block: refine the EOF check in blkdev_iomap_begin
Date: Thu,  6 Jun 2024 15:56:35 +0200
Message-ID: <20240606131736.355136776@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 73e42742543f6..1df187b306792 100644
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



