Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D899320F;
	Tue, 14 May 2024 10:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682882; cv=none; b=OCaqVn4tEH7O00VCrR89U5VbohWS9RrSgnrpGpejqm+Q6BiruwkatrugiBWrA8QBoGU6XoIJ+tcfb5FhV4KvmufsZQsrB8mb5gm5EnaTrV/Vx60LjcFZVjw9mVCE69RBIBIp55JmMa/0GSFooCMaMnc27t3fzJvvaXw+pGTSF40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682882; c=relaxed/simple;
	bh=p83Upf90VZ+4N3Stp69M0nT8gp6eCmvEofTbY01Cueg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWVKy4851qO54ozUd+u+zm3hXP+ikLi/TM8G6oK6Tidvalnvki7eGoHPlbNlDa/9VqabwGcJJz2ZqSWfL8j0SXFnGf/VBQeN9qqBkqlEUVUsFmyRjP7JxN5z2zgrrX7tXNUVBGMioWw8BV8EZu41pAjwfkVG0waL2JGYb5F5Z30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5iJGeQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5iJGeQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45624C2BD10;
	Tue, 14 May 2024 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682882;
	bh=p83Upf90VZ+4N3Stp69M0nT8gp6eCmvEofTbY01Cueg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5iJGeQEZ14GYTiXiB7RiZNdmow9zbPHDCqdI3HRhNAl50yKDSj484NugU3QNtf5J
	 pze14DQBbWu4cLOkxijrzUmVvMYWSP9Z5UKiRxUPkXiRm5RmDtLJIuZVOgjsBYMrUU
	 dwy4xGbv4at1B2q353Uib0sTOebBo5aFD8ArGC14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 127/336] block: fix overflow in blk_ioctl_discard()
Date: Tue, 14 May 2024 12:15:31 +0200
Message-ID: <20240514101043.397177143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 22d24a544b0d49bbcbd61c8c0eaf77d3c9297155 ]

There is no check for overflow of 'start + len' in blk_ioctl_discard().
Hung task occurs if submit an discard ioctl with the following param:
  start = 0x80000000000ff000, len = 0x8000000000fff000;
Add the overflow validation now.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240329012319.2034550-1-linan666@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 5f8c988239c68..7dbed0c1155cf 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -89,7 +89,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 		unsigned long arg)
 {
 	uint64_t range[2];
-	uint64_t start, len;
+	uint64_t start, len, end;
 	struct inode *inode = bdev->bd_inode;
 	int err;
 
@@ -110,7 +110,8 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 	if (len & 511)
 		return -EINVAL;
 
-	if (start + len > bdev_nr_bytes(bdev))
+	if (check_add_overflow(start, len, &end) ||
+	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
 	filemap_invalidate_lock(inode->i_mapping);
-- 
2.43.0



