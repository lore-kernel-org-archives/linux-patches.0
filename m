Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D650369990;
	Sat, 12 Sep 2026 08:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200504; cv=none; b=Ir26+3VsPwmdWdyLv//lDhRbaAz9bWGH+T0bE4w/nOuCnmuKaa7+qu3OzL9KdBTOaxao/jtie1rXFa7mcGDLtvqOAUMwpuoEmWPPEgyf5tEjeWeVAoZfuZ88RsI3m50DARGOWppHHU2Lm8yCPf+2b1JSMlBXGGOApVoRTgo7ly8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200504; c=relaxed/simple;
	bh=L+HRDpzuBY1TmIHOcV1sbtfxIY4pnOKQJciF1WGbSDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOMAYY9dBmJJ5OaNWS6VlhahAxs/TdKEkyQm5/la5w18d2SUrp7U7E0u10BO0TeRhh4/qYyON8IMjKGhXIiqY+zT1RoAj65Yc8CwYW1ZBUtS2l6Mv0EM+Fwto7FILkXZZmeWaRVFhpkpPefCruhGP4i6fzG0uuYMGKu7xFTH4KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztN7u6+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztN7u6+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844471F000FF;
	Sat, 12 Sep 2026 08:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200502;
	bh=Ji8KSRMb2EP+mQRCRMln4yOvVZuxRPIvlci6PMvYP6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztN7u6+mi7dowMZOhmWPxt/EDk6DyXHTMuNv0s3fGKX9t+I0+gSVVong/JgS2FUOm
	 rMUFZQ/+ZIKyBY7TnYJWVGcd5AV2sNeNRw5QAG0+oxLiQrWBxHreJqQGCmKSx5iCXG
	 Db1IFB1xxM6GuKKSmjJKpeXhxDwmzZgpMqNt3gWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0776/1815] md/raid10: consistently fail atomic writes that require splitting
Date: Sat, 12 Sep 2026 08:42:06 +0200
Message-ID: <20260912065707.127518247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 3409bf2f9678d769a4c33bd232a3571c51fac481 ]

RAID10 currently handles one badblock path explicitly by failing atomic
writes with EIO. However, another badblock path can also reduce the
writable range and force the bio through bio_submit_split_bioset(),
which implicitly completes the bio with EINVAL.

Fix this by handling atomic writes in the common split check. If RAID10
determines that an atomic write would require splitting, complete the
bio with EIO.

Fixes: a1d9b4fd42d9 ("md/raid10: Atomic write support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260710101521.1714-4-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3c7f883e93bb0..8c419033a9bf3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1333,6 +1333,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
 
 	if ((mddev_is_clustered(mddev) &&
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1420,16 +1421,6 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 			if (is_bad) {
 				int good_sectors;
 
-				/*
-				 * We cannot atomically write this, so just
-				 * error in that case. It could be possible to
-				 * atomically write other mirrors, but the
-				 * complexity of supporting that is not worth
-				 * the benefit.
-				 */
-				if (bio->bi_opf & REQ_ATOMIC)
-					goto err_handle;
-
 				good_sectors = first_bad - dev_sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
@@ -1449,6 +1440,9 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->sectors = max_sectors;
 
 	if (r10_bio->sectors < bio_sectors(bio)) {
+		if (atomic)
+			goto err_handle;
+
 		allow_barrier(conf);
 		bio = bio_submit_split_bioset(bio, r10_bio->sectors,
 					      &conf->bio_split);
-- 
2.53.0



