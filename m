Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC301CF297;
	Tue,  8 Oct 2024 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389988; cv=none; b=Id2qQJzdFq4tNAGNYoW//DOOpBjI7oYAiyvyAPsgB4igMLSUy/CwXQXKxWQTdTz1ERX1dVn4wNN8m9c5z7voUubiH3YbCDcPYqnhxWcSCCMeoq2mrlocuC78Gf2+P6PLNVwUPEfDDi1mWp84PT8LcS8jQJ7EwPZwk5Jk4qyarwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389988; c=relaxed/simple;
	bh=0rOf0czTH6jHexotBf2DHcsBrnoOUfSPmXwVBhkatIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/Pyt47aZLQW9SwJC0nQjC5p5i7dr41z/KWJYa9VVvq9dhC8H7fu1J3l0lOK3IFDCyQVthsanUp7qNt5TqjZMsy0enKNJ1yPWb9JabsfY9jrXLO6/luM51RPzUwkyUfovgMYPVzSIQijncz7bZNfj7hzV9meFvhGvQYNxGJ1bHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nh912jF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nh912jF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFB1C4CEC7;
	Tue,  8 Oct 2024 12:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389988;
	bh=0rOf0czTH6jHexotBf2DHcsBrnoOUfSPmXwVBhkatIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nh912jF0U8zZXq/GHOdLMSKBJk2DRvWlzv3rhPrIsbGXak5/odLF5ds5XzrC3dNX2
	 OvE45ylpD75amK90csR/N2k8nV8JwIBs3IlItUG4CaL7K8VWvjcxfWvBRpezNiBuUB
	 vc54kbOKL17d5daBADGTR7Oh4A5nxKU+892tf4Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 125/482] block: fix integer overflow in BLKSECDISCARD
Date: Tue,  8 Oct 2024 14:03:08 +0200
Message-ID: <20241008115653.225066326@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 697ba0b6ec4ae04afb67d3911799b5e2043b4455 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index d570e16958961..4515d4679eefd 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -126,7 +126,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 		return -EINVAL;
 
 	filemap_invalidate_lock(bdev->bd_mapping);
-	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
+	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (err)
 		goto fail;
 
@@ -163,7 +163,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 static int blk_ioctl_secure_erase(struct block_device *bdev, blk_mode_t mode,
 		void __user *argp)
 {
-	uint64_t start, len;
+	uint64_t start, len, end;
 	uint64_t range[2];
 	int err;
 
@@ -178,11 +178,12 @@ static int blk_ioctl_secure_erase(struct block_device *bdev, blk_mode_t mode,
 	len = range[1];
 	if ((start & 511) || (len & 511))
 		return -EINVAL;
-	if (start + len > bdev_nr_bytes(bdev))
+	if (check_add_overflow(start, len, &end) ||
+	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
 	filemap_invalidate_lock(bdev->bd_mapping);
-	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
+	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (!err)
 		err = blkdev_issue_secure_erase(bdev, start >> 9, len >> 9,
 						GFP_KERNEL);
-- 
2.43.0



