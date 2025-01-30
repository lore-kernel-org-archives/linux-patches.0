Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35238383;
	Thu, 30 Jan 2025 14:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246540; cv=none; b=iNUQHPOkRmQnEUH1GyPTkt9QkVXjVdRBKoRGPCkJfBWWmNKm5uU/lIpnA95t7+ryMRyv7qu0s2iw2GGayURGg7ZbQ5weCxivIHQKCl0R7vyGc7VJ630MbQGLiXnRchCbXzDZJzLuXeLWEr8Z10gbex/SF417fgMMzAvI4Kd8GZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246540; c=relaxed/simple;
	bh=3nrZeS71jK+EwtMfm5RWqaHpnCwWj6rLjt9BRaj+Y2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHqENAM0cHdISzY/mMMRLkWLdY0rs7zyZSgIW+hDe5da39HCL8cwX8sLT6v+tUQLA8M2/6g0Q3/WL++LWS2/Sxe6wzg69SDXq1GnaILjiJI+VMsifnpEMEHKoBaW5n1vZe4EY4U+f8faii9utMMnCSlvPFd7X97G7tRuoVx7atE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gucs9gXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gucs9gXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B806AC4CEE0;
	Thu, 30 Jan 2025 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246540;
	bh=3nrZeS71jK+EwtMfm5RWqaHpnCwWj6rLjt9BRaj+Y2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gucs9gXqboDqMsOalVkr83pXlu10x1GUzkWi6a2NpgCLFKheP5yQQEE2QL2UUbZkc
	 xVOSgRm1Cd6ixqQDwUNEe5CSgIhTX+LFxB/bLfhH3vxx/NvZG1z6YasJHiKczsUEC7
	 JZH4alB/SWluvpI1Q5YYoubIIFjwIFc+JruwGj7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Rajani Kantha <rajanikantha@engineer.com>
Subject: [PATCH 6.6 27/43] block: fix integer overflow in BLKSECDISCARD
Date: Thu, 30 Jan 2025 14:59:34 +0100
Message-ID: <20250130133459.995930116@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 697ba0b6ec4ae04afb67d3911799b5e2043b4455 upstream.

I independently rediscovered

	commit 22d24a544b0d49bbcbd61c8c0eaf77d3c9297155
	block: fix overflow in blk_ioctl_discard()

but for secure erase.

Same problem:

	uint64_t r[2] = {512, 18446744073709551104ULL};
	ioctl(fd, BLKSECDISCARD, r);

will enter near infinite loop inside blkdev_issue_secure_erase():

	a.out: attempt to access beyond end of device
	loop0: rw=5, sector=3399043073, nr_sectors = 1024 limit=2048
	bio_check_eod: 3286214 callbacks suppressed

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Link: https://lore.kernel.org/r/9e64057f-650a-46d1-b9f7-34af391536ef@p183
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Rajani Kantha <rajanikantha@engineer.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -115,7 +115,7 @@ static int blk_ioctl_discard(struct bloc
 		return -EINVAL;
 
 	filemap_invalidate_lock(inode->i_mapping);
-	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
+	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (err)
 		goto fail;
 	err = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
@@ -127,7 +127,7 @@ fail:
 static int blk_ioctl_secure_erase(struct block_device *bdev, blk_mode_t mode,
 		void __user *argp)
 {
-	uint64_t start, len;
+	uint64_t start, len, end;
 	uint64_t range[2];
 	int err;
 
@@ -142,11 +142,12 @@ static int blk_ioctl_secure_erase(struct
 	len = range[1];
 	if ((start & 511) || (len & 511))
 		return -EINVAL;
-	if (start + len > bdev_nr_bytes(bdev))
+	if (check_add_overflow(start, len, &end) ||
+	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
 	filemap_invalidate_lock(bdev->bd_inode->i_mapping);
-	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
+	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (!err)
 		err = blkdev_issue_secure_erase(bdev, start >> 9, len >> 9,
 						GFP_KERNEL);


