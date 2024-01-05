Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131D728DDA;
	Fri,  5 Jan 2024 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnahglFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD7FC433C7;
	Fri,  5 Jan 2024 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465843;
	bh=4n72VA07Y2kjFV8kgUtYx8N5Djg6ZGmtk7oQzObZtVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnahglFgg+g52bItpBPWkCwT5udCHicKNx9wUSSKVnRYX7RTU93KdGMfjmMb5rjSD
	 9FfktBf3k6fuIVm0XklG23iKx3s7D9Qa4CIvSGGjTt6QxpFMvoBOPcXlcRj4Uf2/je
	 T30KDziVbuQNLXeOaz6XPvi2QcUiSAERtOY7+67o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sarthak Kukreti <sarthakkukreti@chromium.org>,
	Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 47/47] block: Dont invalidate pagecache for invalid falloc modes
Date: Fri,  5 Jan 2024 15:39:34 +0100
Message-ID: <20240105143817.481760478@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Kukreti <sarthakkukreti@chromium.org>

commit 1364a3c391aedfeb32aa025303ead3d7c91cdf9d upstream.

Only call truncate_bdev_range() if the fallocate mode is supported. This
fixes a bug where data in the pagecache could be invalidated if the
fallocate() was called on the block device with an invalid mode.

Fixes: 25f4c41415e5 ("block: implement (some of) fallocate for block devices")
Cc: stable@vger.kernel.org
Reported-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Fixes: line?  I've never seen those wrapped.
Link: https://lore.kernel.org/r/20231011201230.750105-1-sarthakkukreti@chromium.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/block_dev.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -2114,21 +2114,26 @@ static long blkdev_fallocate(struct file
 	if ((start | len) & (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	/* Invalidate the page cache, including dirty pages. */
+	/*
+	 * Invalidate the page cache, including dirty pages, for valid
+	 * de-allocate mode calls to fallocate().
+	 */
 	mapping = bdev->bd_inode->i_mapping;
-	truncate_inode_pages_range(mapping, start, end);
 
 	switch (mode) {
 	case FALLOC_FL_ZERO_RANGE:
 	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
+		truncate_inode_pages_range(mapping, start, end);
 		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
 					    GFP_KERNEL, BLKDEV_ZERO_NOUNMAP);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
+		truncate_inode_pages_range(mapping, start, end);
 		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
 					     GFP_KERNEL, BLKDEV_ZERO_NOFALLBACK);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
+		truncate_inode_pages_range(mapping, start, end);
 		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
 					     GFP_KERNEL, 0);
 		break;


