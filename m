Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79031F890C;
	Tue,  3 Dec 2024 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240064; cv=none; b=UtH2AEQNQ3SkfsBpj2bu1pfg9UsKorNdnBT0zfAdPExR6Pgo4PMPQeTTVaCoC0KQvK8ZVvlECnPFGnAtMPB2RY1y0ayaH1iHhwb+bJqE46zqgQimMyWGs3ONe93rvkdLbIz+BedUBNgJ+8KLz8DLMX5i9D8LrQ2EobDbQU/l2sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240064; c=relaxed/simple;
	bh=7On8JbsJWXoMpKh9OwjxCIMd2OirNn4T9jBbrVZiF6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2f2s3CEJf4Pbg6jIVsBOxhqM0dBGbKxnVvoapU3w1e4ymm9xtcAJuTFZXmuCTk0GjYmTRRbp5ckdvoNZ2k13R44QHn3Ngnsm1Uu1f84q7vFftUZl3+Tu6gRF1IHKwVmZ4JZYG+o9hMxkTB6KYxsEx3uchIgfwY7AMwY11NAZ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAon+gTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAon+gTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7E3C4CED8;
	Tue,  3 Dec 2024 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240064;
	bh=7On8JbsJWXoMpKh9OwjxCIMd2OirNn4T9jBbrVZiF6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAon+gTIBB8+9/qBl5GQT7O6Rckdp7/1QDiE7oajPigL7Aabk2sy/hf/FYkNKTK6Y
	 9SR5Bp7QsOuRlRr4uaHWRJAVhRYwMavTE+XP3Id5iB2Oh9yID4ZW0q1SyFOeVchi1t
	 GOwAJGsCBDk14LbpEbPa1RSvhwxqXpzBis63iP6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/826] block/fs: Pass an iocb to generic_atomic_write_valid()
Date: Tue,  3 Dec 2024 15:35:38 +0100
Message-ID: <20241203144743.886343064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 9a8dbdadae509e5717ff6e5aa572ca0974d2101d ]

Darrick and Hannes both thought it better that generic_atomic_write_valid()
should be passed a struct iocb, and not just the member of that struct
which is referenced; see [0] and [1].

I think that makes a more generic and clean API, so make that change.

[0] https://lore.kernel.org/linux-block/680ce641-729b-4150-b875-531a98657682@suse.de/
[1] https://lore.kernel.org/linux-xfs/20240620212401.GA3058325@frogsfrogsfrogs/

Fixes: c34fc6f26ab8 ("fs: Initial atomic write support")
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241019125113.369994-2-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c       | 8 ++++----
 fs/read_write.c    | 4 ++--
 include/linux/fs.h | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index e696ae53bf1e0..968b47b615c4b 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -35,13 +35,13 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 	return opf;
 }
 
-static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
+static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *iocb,
 				struct iov_iter *iter, bool is_atomic)
 {
-	if (is_atomic && !generic_atomic_write_valid(iter, pos))
+	if (is_atomic && !generic_atomic_write_valid(iocb, iter))
 		return true;
 
-	return pos & (bdev_logical_block_size(bdev) - 1) ||
+	return iocb->ki_pos & (bdev_logical_block_size(bdev) - 1) ||
 		!bdev_iter_is_aligned(bdev, iter);
 }
 
@@ -374,7 +374,7 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (!iov_iter_count(iter))
 		return 0;
 
-	if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
+	if (blkdev_dio_invalid(bdev, iocb, iter, is_atomic))
 		return -EINVAL;
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
diff --git a/fs/read_write.c b/fs/read_write.c
index 64dc24afdb3a7..2c32635308281 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1830,7 +1830,7 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
 	return 0;
 }
 
-bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos)
+bool generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter)
 {
 	size_t len = iov_iter_count(iter);
 
@@ -1840,7 +1840,7 @@ bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos)
 	if (!is_power_of_2(len))
 		return false;
 
-	if (!IS_ALIGNED(pos, len))
+	if (!IS_ALIGNED(iocb->ki_pos, len))
 		return false;
 
 	return true;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3559446279c15..faf7596ace971 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3726,6 +3726,6 @@ static inline bool vfs_empty_path(int dfd, const char __user *path)
 	return !c;
 }
 
-bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos);
+bool generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter);
 
 #endif /* _LINUX_FS_H */
-- 
2.43.0



