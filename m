Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D19F320389;
	Mon, 18 Aug 2025 13:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522499; cv=none; b=gSa4JkK9pG77AwbRQcimOcPLhr/6w3fleS7vmo67ONFBmt1EPnPYZZwLEr1Ya69vVp4yq+xvvvQG6T2cADMjLNNy8922TF3aVc/bmsIYQMETPAjGX3MMPo9gO5aoH9LEiH23U+c5I4lKla5JAE09n5EHdzlqzRcG4zWUKPhWt3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522499; c=relaxed/simple;
	bh=12WKNPSHvJXMMRgrCWg9WVf4SDHqA8ftHb6O+sKL4UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI9TcuM82ru3891rMPr8T8tD7c00ERc6mcmw7KJPB+htUmY90odabvdyNVev6EHRDKmFRvwA7BwX/NVhKhSeKVlMK6fsQiWHC1Y4mj84ZyT7vUvS8BwDKwjsUz4QbkIbElOZ7g0r1C2O7Xsx7Dx4LThw/lqywCSNApY9bIO3FvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9b+iy3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9b+iy3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6150C113D0;
	Mon, 18 Aug 2025 13:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522499;
	bh=12WKNPSHvJXMMRgrCWg9WVf4SDHqA8ftHb6O+sKL4UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9b+iy3xMBGS5PTvsni5MyfEYdnloFGP+ruinlcm3p178H45qokDss2Fa9BEvE/vl
	 iOIrMOT5tf4545VzPJBMCrSqenRj9daT8tvszbwT2i6ZPrdKqeBCv+M41qCCh5QbAC
	 /LWrKIPhzRllr/+qkKpmNMuiCmzR1hagqW2lfHPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 335/444] dm-table: fix checking for rq stackable devices
Date: Mon, 18 Aug 2025 14:46:01 +0200
Message-ID: <20250818124501.493349003@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 8ca719b81987be690f197e82fdb030580c0a07f3 ]

Due to the semantics of iterate_devices(), the current code allows a
request-based dm table as long as it includes one request-stackable
device. It is supposed to only allow tables where there are no
non-request-stackable devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e45cffdd419a..20b8f560a2da 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -894,17 +894,17 @@ static bool dm_table_supports_dax(struct dm_table *t,
 	return true;
 }
 
-static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
-				  sector_t start, sector_t len, void *data)
+static int device_is_not_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
 {
 	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
 
 	/* request-based cannot stack on partitions! */
 	if (bdev_is_partition(bdev))
-		return false;
+		return true;
 
-	return queue_is_mq(q);
+	return !queue_is_mq(q);
 }
 
 static int dm_table_determine_type(struct dm_table *t)
@@ -1000,7 +1000,7 @@ static int dm_table_determine_type(struct dm_table *t)
 
 	/* Non-request-stackable devices can't be used for request-based dm */
 	if (!ti->type->iterate_devices ||
-	    !ti->type->iterate_devices(ti, device_is_rq_stackable, NULL)) {
+	    ti->type->iterate_devices(ti, device_is_not_rq_stackable, NULL)) {
 		DMERR("table load rejected: including non-request-stackable devices");
 		return -EINVAL;
 	}
-- 
2.39.5



