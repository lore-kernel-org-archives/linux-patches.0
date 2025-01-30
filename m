Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F3F7482;
	Thu, 30 Jan 2025 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247423; cv=none; b=MjmfRyJKzkSCIwwWLg9N131B2QntmdKe1sD5TOC4fC0yN0LTUJPcT6QYDSFm67Dr7ySXYU5WVAkERper9CWc6bp4ABMkm9f5FMIY9zCVgTpXc5MErr3eUCb2mpfGe7p3QR3Qjjzgn72r0vFQqRVyOmwpeW8F0fo39tPqn4QVvrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247423; c=relaxed/simple;
	bh=7JsmaW9I/2AoRJG6oYbCAp/5LAovujGLZ9Gmq04c23c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6Hwc+UVY0z0Ru/fhd7J+/cXQP//M4ZMGOI5t6VOuR+ZvehGmXYQBnim+uUWgSd0Q7ARpeHbGTlvMRRIiyXBRLA4MkgKmNUQHNMMI9mBjnj8wA0FpHXU+798YoVYsnApZ7011dKd35wlOA5I2FRV1TqbH2y2D1L4HAvtBZ1LhSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpycMoeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpycMoeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6726C4CED2;
	Thu, 30 Jan 2025 14:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247423;
	bh=7JsmaW9I/2AoRJG6oYbCAp/5LAovujGLZ9Gmq04c23c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpycMoeuQVOD1oFYmG4PXhvJ+De8XFMrXo0W/f/GUyENGVopd6Wm4uyp4Xbe3QgYa
	 Xs4DX3X9FwmlQipwwjhHlTIZAP5VkwJB6VHrYJVy80aTeE5sD/u7pjOrnugvtyomkv
	 3W8kRI/xFSkalcCq13dHAIndjzy4NKMFKVnPK86M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Rajani Kantha <rajanikantha@engineer.com>
Subject: [PATCH 6.1 34/49] block: fix integer overflow in BLKSECDISCARD
Date: Thu, 30 Jan 2025 15:02:10 +0100
Message-ID: <20250130140135.201870569@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 static int blk_ioctl_secure_erase(struct block_device *bdev, fmode_t mode,
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


