Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C022FDC4D;
	Thu, 15 Jan 2026 16:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496313; cv=none; b=LTLgDLw5jPuTcMoaWoKGhjRie/xXSzqr66mI89yq6sFxamLsb2BWq7bTqgxBpoIA/Q5lz3zrU86l0EDeT+HYrF0d08+hZnj6O3xi+F4nEk6kVwkZkfX0d+N77o0h1MQCkRrXRJP36JaVAG0962xII0sR9pGCxXRafFz+dyOJqnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496313; c=relaxed/simple;
	bh=gIApn50qCgE71j1Flq2qViBBlN/fLTiqGxTPSBkbkng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbjXyEoeEvW06+LeQVKfnmidBT0ARZ6awvPxeUgDpHZBOWdTZnH/xxTzN2NNqVwMmLI3dQGYGzdzNbgqSXbmDMoLd2xVFa825TpoB5nzZBplvfPF5JYOUJZ3/mLxKkrZUj4Tr/vq+AjbeWkQba52oETFJ9KlppS5ZYrFIZG3hRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ojhn7Bt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ojhn7Bt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A4AC116D0;
	Thu, 15 Jan 2026 16:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496313;
	bh=gIApn50qCgE71j1Flq2qViBBlN/fLTiqGxTPSBkbkng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ojhn7Bt2EcQ9NzV1dcPSxy0X1TnFAX4+zmSn0VubU2H4/ySHrrsQzlabGpqCsy364
	 9C8C4bcjqWhhQCHG39pUmyaSvbVepRlDHAPAXcc2qG1MxSHLCTW4hUwur1FlbR+xLJ
	 FNRvjYalgy5Z//mkuMrzGYMxWxYzT+KvIKoVCUQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruikai Peng <ruikai@pwno.io>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/181] ublk: fix use-after-free in ublk_partition_scan_work
Date: Thu, 15 Jan 2026 17:48:10 +0100
Message-ID: <20260115164207.836226739@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit f0d385f6689f37a2828c686fb279121df006b4cb ]

A race condition exists between the async partition scan work and device
teardown that can lead to a use-after-free of ub->ub_disk:

1. ublk_ctrl_start_dev() schedules partition_scan_work after add_disk()
2. ublk_stop_dev() calls ublk_stop_dev_unlocked() which does:
   - del_gendisk(ub->ub_disk)
   - ublk_detach_disk() sets ub->ub_disk = NULL
   - put_disk() which may free the disk
3. The worker ublk_partition_scan_work() then dereferences ub->ub_disk
   leading to UAF

Fix this by using ublk_get_disk()/ublk_put_disk() in the worker to hold
a reference to the disk during the partition scan. The spinlock in
ublk_get_disk() synchronizes with ublk_detach_disk() ensuring the worker
either gets a valid reference or sees NULL and exits early.

Also change flush_work() to cancel_work_sync() to avoid running the
partition scan work unnecessarily when the disk is already detached.

Fixes: 7fc4da6a304b ("ublk: scan partition in async way")
Reported-by: Ruikai Peng <ruikai@pwno.io>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index babb58d2dcaf7..e09c1b5999b75 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -255,20 +255,6 @@ static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
 		u16 q_id, u16 tag, struct ublk_io *io, size_t offset);
 static inline unsigned int ublk_req_build_flags(struct request *req);
 
-static void ublk_partition_scan_work(struct work_struct *work)
-{
-	struct ublk_device *ub =
-		container_of(work, struct ublk_device, partition_scan_work);
-
-	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
-					     &ub->ub_disk->state)))
-		return;
-
-	mutex_lock(&ub->ub_disk->open_mutex);
-	bdev_disk_changed(ub->ub_disk, false);
-	mutex_unlock(&ub->ub_disk->open_mutex);
-}
-
 static inline struct ublksrv_io_desc *
 ublk_get_iod(const struct ublk_queue *ubq, unsigned tag)
 {
@@ -1663,6 +1649,27 @@ static void ublk_put_disk(struct gendisk *disk)
 		put_device(disk_to_dev(disk));
 }
 
+static void ublk_partition_scan_work(struct work_struct *work)
+{
+	struct ublk_device *ub =
+		container_of(work, struct ublk_device, partition_scan_work);
+	/* Hold disk reference to prevent UAF during concurrent teardown */
+	struct gendisk *disk = ublk_get_disk(ub);
+
+	if (!disk)
+		return;
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &disk->state)))
+		goto out;
+
+	mutex_lock(&disk->open_mutex);
+	bdev_disk_changed(disk, false);
+	mutex_unlock(&disk->open_mutex);
+out:
+	ublk_put_disk(disk);
+}
+
 /*
  * Use this function to ensure that ->canceling is consistently set for
  * the device and all queues. Do not set these flags directly.
@@ -2107,7 +2114,7 @@ static void ublk_stop_dev(struct ublk_device *ub)
 	mutex_lock(&ub->mutex);
 	ublk_stop_dev_unlocked(ub);
 	mutex_unlock(&ub->mutex);
-	flush_work(&ub->partition_scan_work);
+	cancel_work_sync(&ub->partition_scan_work);
 	ublk_cancel_dev(ub);
 }
 
-- 
2.51.0



