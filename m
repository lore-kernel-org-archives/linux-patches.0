Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940372472BC;
	Tue, 29 Apr 2025 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945884; cv=none; b=N0c2NMWpkbj/VpKSoapPiJmfkgpm2tXLM8Ez3Ja5Pu3ty052IdLuujjYCg79/f2SCs/Rbxn5J3Rfjjz5p8AwlZR45YOHDEXBC0EfdQx3zD7aAYrQMHP3OemsJufO3ISdCvRwmUyxI1xRLJ71FXS/COu/PqOGmKXgTYb+kZT00Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945884; c=relaxed/simple;
	bh=P9lo53axNgzC0A/qTukiy8m2VpTbuHLjqy6nOKnponU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkEuW0P8qZbqEn9LYQHbhtyY1v54AEJ+f2sl3Lmq6Mpu9WWo8eoQsYZHyz6Yuw7R4iVrfNVFWUEFpUj+iXi/1TeUy8D763cFUAfv0rBBNgCtvFu85CS+JfdA6QFtsRaSAr03vihz9FehO+hbvIShq+yPgC/CBFMHAPsV8gmhSMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZPURz57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZPURz57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0406CC4CEE9;
	Tue, 29 Apr 2025 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945884;
	bh=P9lo53axNgzC0A/qTukiy8m2VpTbuHLjqy6nOKnponU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZPURz57joBuNrctTb6/IwTWtoxi3BnxwkCRF3FffWOfkA9QfY220lyKYQgTSZ09o
	 2thPXBixTWNLUPCvdLKfXXbY1/jaTeBgbzH6I9afNYy9Cr3YBeMZ588sB8HrpGhJ0k
	 wq/ar8xaVr8uLkS4QNRIkfrn0pkgB7Y7BQl1O3OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 080/311] block: never reduce ra_pages in blk_apply_bdi_limits
Date: Tue, 29 Apr 2025 18:38:37 +0200
Message-ID: <20250429161124.323993977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7b720c720253e2070459420b2628a7b9ee6733b3 ]

When the user increased the read-ahead size through sysfs this value
currently get lost if the device is reprobe, including on a resume
from suspend.

As there is no hardware limitation for the read-ahead size there is
no real need to reset it or track a separate hardware limitation
like for max_sectors.

This restores the pre-atomic queue limit behavior in the sd driver as
sd did not use blk_queue_io_opt and thus never updated the read ahead
size to the value based of the optimal I/O, but changes behavior for
all other drivers.  As the new behavior seems useful and sd is the
driver for which the readahead size tweaks are most useful that seems
like a worthwhile trade off.

Fixes: 804e498e0496 ("sd: convert to the atomic queue limits API")
Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250424082521.1967286-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 66721afeea546..67b119ffa1689 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -61,8 +61,14 @@ void blk_apply_bdi_limits(struct backing_dev_info *bdi,
 	/*
 	 * For read-ahead of large files to be effective, we need to read ahead
 	 * at least twice the optimal I/O size.
+	 *
+	 * There is no hardware limitation for the read-ahead size and the user
+	 * might have increased the read-ahead size through sysfs, so don't ever
+	 * decrease it.
 	 */
-	bdi->ra_pages = max(lim->io_opt * 2 / PAGE_SIZE, VM_READAHEAD_PAGES);
+	bdi->ra_pages = max3(bdi->ra_pages,
+				lim->io_opt * 2 / PAGE_SIZE,
+				VM_READAHEAD_PAGES);
 	bdi->io_pages = lim->max_sectors >> PAGE_SECTORS_SHIFT;
 }
 
-- 
2.39.5



