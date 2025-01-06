Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4411422DD;
	Mon,  6 Jan 2025 15:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178460; cv=none; b=hPn7QlO40DAW2VFrrz4TeSMe3zkaKMVZAbrkzpYtl/4XHByz5Ad0a4pPsaSngnmQNu/eG3CxXT4T+MYZFPko0WxWaqbiKkbw6bWhnMtRQKzAmILMQaDkAhia9hfqIl65nyKNiYbrW2eEWl/YzQReuV8P7gL0qPNMmbJOU5n8m8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178460; c=relaxed/simple;
	bh=nrlP7m5FLc71ZfOjw3W2CIdW7bxB/4iA3Rn9UiSngO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ph3Cn4NSXq9I7mqLGoTKG4ycP2HlmirIvX4xToBbwaufMTw1LSvlfjzrbluLloJQBlBxGHlfzAR5YZl+TgLx5QGdD2hQiu11WlS/73DYGQWYTZkNZxaMsf7k7JDFzVH5qCMo/5ufulcp1gTorB8E3l8hXk4kO/UAYpx4/fkDxwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0T1KXwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0T1KXwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC37C4CED2;
	Mon,  6 Jan 2025 15:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178459;
	bh=nrlP7m5FLc71ZfOjw3W2CIdW7bxB/4iA3Rn9UiSngO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0T1KXwqmdIhwBzccTUVYZYnSs62J6SUzC0ZpFAI0Zmw4WZpYuqe+tXqPd0iFsYOe
	 m2LWKlv/4UYwQ5hYd/+6ausldppjNyvTbwElmXPL74BKTFALc4j8W/QKYpneYqOjQD
	 J1tdlf+CvQ9epU6bWTC6DaiJLd8hzP0Fv2zWoI4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/138] sd: update the bdev size in sd_revalidate_disk
Date: Mon,  6 Jan 2025 16:16:58 +0100
Message-ID: <20250106151136.791084823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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



