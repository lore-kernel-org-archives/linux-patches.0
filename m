Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7562AF05;
	Tue,  3 Dec 2024 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237737; cv=none; b=tp8wLt161jiHgcCslcOfc1WN+iTmhDKo1aS7FXDwNNgB1vU2Hr7DBabPc1aRg18d4DBbSXUYjdFIwNv/gAM4sJ6qP1Yu1rPQmzyW3ikzKj+O+uoyNobWh3cKgYe8IpglwWBGQWk2y/o2S7DMogFeUgZV9Y0oZX6BtppwcKxgjk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237737; c=relaxed/simple;
	bh=st5VPXQgvFMk4o2BqsKTtQcGvrK8tHrwPdMj2mKiR2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7Qkdcd8VdAknQZFWy5js1z1P1Yt34PPHFOxiMceyiCmtlzpY/QE9pv3mETHS1/gyIll0YszXd7YJ10VE9cHAAoKyEuJXl5LnbUyCZExrnqMEWptnuGESArmZc5zCJEQSR9j80N9aZEKV81japBccMT0+uPPRsnFdK44DBPxAgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kk1QdRnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kk1QdRnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F1EC4CECF;
	Tue,  3 Dec 2024 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237736;
	bh=st5VPXQgvFMk4o2BqsKTtQcGvrK8tHrwPdMj2mKiR2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kk1QdRnWeRz1pWPW7SyhCDJqPU8frkBHyV3Yp762kuAKk4KKtaMszxv86gyK5G8at
	 TEPFSwD2Q5962yZNWTUxlt1mhiqk7dZk+bHNCRWPc0OQoV1tqG9405K1Du7ykZuTGl
	 lnETiQFknOE/TDvd2JsWUkpWKIOqXAizUbOO/zC0=
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
Subject: [PATCH 6.11 055/817] block/fs: Pass an iocb to generic_atomic_write_valid()
Date: Tue,  3 Dec 2024 15:33:47 +0100
Message-ID: <20241203143957.827468852@linuxfoundation.org>
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
index 9825c1713a49a..1c0f9d3138451 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -34,13 +34,13 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
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
 
@@ -373,7 +373,7 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (!iov_iter_count(iter))
 		return 0;
 
-	if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
+	if (blkdev_dio_invalid(bdev, iocb, iter, is_atomic))
 		return -EINVAL;
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
diff --git a/fs/read_write.c b/fs/read_write.c
index 90e283b31ca18..d8af6f2f1c9af 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1737,7 +1737,7 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
 	return 0;
 }
 
-bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos)
+bool generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter)
 {
 	size_t len = iov_iter_count(iter);
 
@@ -1747,7 +1747,7 @@ bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos)
 	if (!is_power_of_2(len))
 		return false;
 
-	if (!IS_ALIGNED(pos, len))
+	if (!IS_ALIGNED(iocb->ki_pos, len))
 		return false;
 
 	return true;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6ca11e241a249..0a8acd6063896 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3663,6 +3663,6 @@ static inline bool vfs_empty_path(int dfd, const char __user *path)
 	return !c;
 }
 
-bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos);
+bool generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter);
 
 #endif /* _LINUX_FS_H */
-- 
2.43.0



