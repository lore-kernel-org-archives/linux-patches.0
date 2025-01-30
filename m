Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075131E522;
	Thu, 30 Jan 2025 14:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247023; cv=none; b=kYr5CLJLNirxUXG/UU+MbsI1xtpWeaPCXIfgfagYocK8pN+npVJ/PGQle4jvl4eNMirCzp4xY5SIdENg21evZmQ4lJ+BuUiWln6Ss7VahnitoHBtIv0IpholeHNIDWOi5YzegZ3zgiP8NhTPRjE5TYVaZQFFB2pF3WCOWzCS568=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247023; c=relaxed/simple;
	bh=nrlP7m5FLc71ZfOjw3W2CIdW7bxB/4iA3Rn9UiSngO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgfyaFFmeChgyJ2vo8dkfSrjcqDKbY+e5rDgYQlynIexVNiylaTwpBO/+rYsOqNLtE71UnwZDmJil4V6D/TdPABp8P3Gs43WmpYMiWfn36zm0VLp2qNS1jYk6Hh/e9Opk1NEpieE8Td1onft2+j/rgwqoXL/7mS8ojrcfm3oy6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBYywJ5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBYywJ5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF8AC4CEE0;
	Thu, 30 Jan 2025 14:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247022;
	bh=nrlP7m5FLc71ZfOjw3W2CIdW7bxB/4iA3Rn9UiSngO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBYywJ5O6CJ6/7DloCIPQzcwXuFGKR93S8HGCjt8rW2vzyvgB34NCmRsea/8CxFwS
	 8+08m/BQRkJsK2XB9u8tdHlyJW7v0+bnncAT9ZQ566pk9i41W80g85jyzLXOboEKhc
	 qOKncKUPDrmRtI28rEcqfGHGfB9xa+OTnVQqDwGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/133] sd: update the bdev size in sd_revalidate_disk
Date: Thu, 30 Jan 2025 15:00:44 +0100
Message-ID: <20250130140144.729793315@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b200e38c493b2a5acff4f86d40a3e45d546c664c ]

This avoids the extra call to revalidate_disk_size in sd_rescan and
is otherwise a no-op because the size did not change, or we are in
the probe path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2f2ca2878876..355d38cab862 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1767,10 +1767,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 static void sd_rescan(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	int ret;
 
-	ret = sd_revalidate_disk(sdkp->disk);
-	revalidate_disk_size(sdkp->disk, ret == 0);
+	sd_revalidate_disk(sdkp->disk);
 }
 
 static int sd_ioctl(struct block_device *bdev, fmode_t mode,
@@ -3295,7 +3293,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	sdkp->first_scan = 0;
 
 	set_capacity_revalidate_and_notify(disk,
-		logical_to_sectors(sdp, sdkp->capacity), false);
+		logical_to_sectors(sdp, sdkp->capacity), true);
 	sd_config_write_same(sdkp);
 	kfree(buffer);
 
@@ -3305,7 +3303,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * capacity to 0.
 	 */
 	if (sd_zbc_revalidate_zones(sdkp))
-		set_capacity_revalidate_and_notify(disk, 0, false);
+		set_capacity_revalidate_and_notify(disk, 0, true);
 
  out:
 	return 0;
-- 
2.39.5



