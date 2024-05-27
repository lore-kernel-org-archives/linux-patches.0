Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4361649C2;
	Mon, 27 May 2024 19:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836529; cv=none; b=edT9pttXD/bEIvu8mlc9nULi2pVN7QR+UfG/+GALLw7jmM3xqXuy3QlQhXvq+8LrELMJpKr6wGKHog9HhOmVrK0FOUjcVtB6lSQZTSqWbP0twAGodMh/j3ZbJOx6Gn8vCJEuaVhFlnlzTq2JFCTYPV6YTCes9H8gy9QvuS+BVy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836529; c=relaxed/simple;
	bh=Yh74qXK4Lcf+4/A5QTNdD9mbrQA88WDlIG9nsC0fdoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4SS1iQjywEFxGUK7dBMlm5HeltVBacU8MFzJIVbHKGeIcKH5sNbMhns6wwiI5al0QzPNB4IYbioiZ6D3PpZqnu0+fRXT3TYQymtcfRIMFuz4RivNK3Ib+6x4fRva9oSB++noVhD6i4Pn3yrJN5eq+dRb7BSdZcfXFmn3XHP0Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtX1gllZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtX1gllZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBB6C2BBFC;
	Mon, 27 May 2024 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836528;
	bh=Yh74qXK4Lcf+4/A5QTNdD9mbrQA88WDlIG9nsC0fdoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtX1gllZ7owu2WeaoDdpYbn4DakGcsNnwVacFnUkHt21cahCaHv80HCCFWk0eBO2v
	 q84nMB4M8dV1/dyPq/1zKo72sbv5fykK1elgN/PCR+SZLHngufsCCAxkifFSnV5iUJ
	 xytU0WBLSMk4nX9GB2Rin8IUulvosRlILpYppicA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0a3683a0a6fecf909244@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 087/427] block: refine the EOF check in blkdev_iomap_begin
Date: Mon, 27 May 2024 20:52:14 +0200
Message-ID: <20240527185609.874384294@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 679d9b752fe82..df2c68d3f198e 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -390,7 +390,7 @@ static int blkdev_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	iomap->bdev = bdev;
 	iomap->offset = ALIGN_DOWN(offset, bdev_logical_block_size(bdev));
-	if (iomap->offset >= isize)
+	if (offset >= isize)
 		return -EIO;
 	iomap->type = IOMAP_MAPPED;
 	iomap->addr = iomap->offset;
-- 
2.43.0



