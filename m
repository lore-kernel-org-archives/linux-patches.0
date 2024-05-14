Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D0561674;
	Tue, 14 May 2024 11:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686353; cv=none; b=gWWKbK+dzOlYf2zJsZiQUBX32Z3zxsEWQUyrkMZOzAKsODJKUrAkrgeDVwtuxa6wg3/xTNGzKXZoJOKxe/AbOn1j3UxOHTgIeFRD1keuH5AFldFPxTlanKwfoio2JIO8sQGgHaWOgU0GD589b91V/s7k6RUnEIy0IyYgxh5RpeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686353; c=relaxed/simple;
	bh=cUtVs0jvGmJIORPvDOyVrywLbFmL7Dj1aEqrT0hR5X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShrM/ED3jHwGFJ2Dng6JpW3IZ4qLVp1bCRIziErX7xepULaTJ0LwI+WWbw09zsIhqzn/az16TSHQJHBO8W+OoYDSMVkRZWoPecsAjDU/Uv5/Ux8lSvVCwK5c85U/6tHX4O26uKs20nX0PhJ7Jz6cAlyds3duZgKieJWOi9ht21w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdgnydLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdgnydLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84112C2BD10;
	Tue, 14 May 2024 11:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686352;
	bh=cUtVs0jvGmJIORPvDOyVrywLbFmL7Dj1aEqrT0hR5X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdgnydLhmoSEhqHJKQ15dqLIL2hVK+H+e55llhzsdvPWmdjlP7dLKhwBkg3vnMVCf
	 aYlYG3foQZg7f+6VfjBYCQziBdzdsFBQl6ZBQiD0wCtJKjfgq2ZIu4dIoFWhCEDGp8
	 TzDhC8Tfwa97zwDn89kBc61YRGo1yHseQAPdhpUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/236] block: fix overflow in blk_ioctl_discard()
Date: Tue, 14 May 2024 12:17:50 +0200
Message-ID: <20240514101024.473371413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 47567ba1185a6..99b8e2e448729 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -89,7 +89,7 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 		unsigned long arg)
 {
 	uint64_t range[2];
-	uint64_t start, len;
+	uint64_t start, len, end;
 	struct inode *inode = bdev->bd_inode;
 	int err;
 
@@ -110,7 +110,8 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 	if (len & 511)
 		return -EINVAL;
 
-	if (start + len > bdev_nr_bytes(bdev))
+	if (check_add_overflow(start, len, &end) ||
+	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
 	filemap_invalidate_lock(inode->i_mapping);
-- 
2.43.0



