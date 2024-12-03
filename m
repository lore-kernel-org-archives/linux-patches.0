Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19064209F41;
	Tue,  3 Dec 2024 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239984; cv=none; b=PAyLYJGklO/MReoZ9TTww0NGChNWUdr8K9ktfRwklnf8uRYkYL+BIDRdQzaNb1Qs1RpNlLBvkPj3vfD3BkbuXcGnTNVAr/9Z+I0lv6sg8eYNk0nT16SfEMkG/LqONsCDQAyRs8cMB8U5gkozwwYfGZgkRuYt9D4Emo4SE+J+QAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239984; c=relaxed/simple;
	bh=jQNX0rYmLz63nfn/fQdHDjGrcprmf6ZR7Ftn/0dgfZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk79SPzeSxVwRb7TjzYatDackkNzP1WJKiuyLyYSgZYu0xx0K7gFfBoj9qnwmiKRXM4nYl4RQyGPwnYO8ux576cEs+Q0eOuOmefkMtmcu+77xyf2nZJozU7ve595QensAkuioyzXlYRyVt8dusp3216N/bL2uY20/WmKVGMeIyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUmfTSNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUmfTSNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9A1C4CECF;
	Tue,  3 Dec 2024 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239983;
	bh=jQNX0rYmLz63nfn/fQdHDjGrcprmf6ZR7Ftn/0dgfZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUmfTSNqlqI/Qoz7gV2X4OMqMmRYraML1aEoTz+2j2KtfET6Ui7E3SJf2mivKb8dd
	 S/YPK6F2J3EEXCueg6aEYd1yH+EVRsRZdG4S1kMUZXhQWKws6xAkyOcY6tT6shGA9W
	 +45PLiezGJ5C8aRx7tmFXi2zda2KvHGKC8038Q+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 801/817] block: Dont allow an atomic write be truncated in blkdev_write_iter()
Date: Tue,  3 Dec 2024 15:46:13 +0100
Message-ID: <20241203144027.493331684@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 2cbd51f1f8739fd2fdf4bae1386bcf75ce0176ba ]

A write which goes past the end of the bdev in blkdev_write_iter() will
be truncated. Truncating cannot tolerated for an atomic write, so error
that condition.

Fixes: caf336f81b3a ("block: Add fops atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241127092318.632790-1-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 56db751bba49b..16bb5ae702379 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -676,6 +676,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct file *file = iocb->ki_filp;
 	struct inode *bd_inode = bdev_file_inode(file);
 	struct block_device *bdev = I_BDEV(bd_inode);
+	bool atomic = iocb->ki_flags & IOCB_ATOMIC;
 	loff_t size = bdev_nr_bytes(bdev);
 	size_t shorted = 0;
 	ssize_t ret;
@@ -695,7 +696,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
-	if (iocb->ki_flags & IOCB_ATOMIC) {
+	if (atomic) {
 		ret = generic_atomic_write_valid(iocb, from);
 		if (ret)
 			return ret;
@@ -703,6 +704,8 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	size -= iocb->ki_pos;
 	if (iov_iter_count(from) > size) {
+		if (atomic)
+			return -EINVAL;
 		shorted = iov_iter_count(from) - size;
 		iov_iter_truncate(from, size);
 	}
-- 
2.43.0



