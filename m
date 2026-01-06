Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522743612E0;
	Tue,  6 Jan 2026 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721820; cv=none; b=np/qTfHRNhFViV7JG4w7B7DEb5i57jOqQFulPBBZalAjNSy2+6D+GcKjC6VTqbhoJ3NAQFp6qOCa72CJBmrWCsvtLHGODVpetZWCAYrkhhnj/qDrnjZ06/dMJtokZiE/YGFk+RDgbk4KV+vcCWy1vQzCko7MQacG3NGQLvBO3n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721820; c=relaxed/simple;
	bh=8Lie3ZOdtXw+3O6VeD0Bx4nwtKZlYiWzFNN6oxi/wO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVEss2FcPbC/YQv3IjezyHrPLN3U9d1UZiWNNQwkV1pOfOJmXQn1MLcpkRgJpRe3fltssrKJhRbhm0XbaSDe+1YKzoryqmDONjjDFsvi8S1Kye1+2AbL2M+Xcx4UigoRJJ57Cck+etCXMITGg40KAV575v8ypTplyJFlKjIvmFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbRuBv+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbRuBv+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54AAC116C6;
	Tue,  6 Jan 2026 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721820;
	bh=8Lie3ZOdtXw+3O6VeD0Bx4nwtKZlYiWzFNN6oxi/wO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbRuBv+g9uG96VG7Ya7BV8X95AnyknSfVORcqhHMZtthfa01e0ereEwib98EsMvs8
	 ceZ8V6kQrNjR90rzkTVV3yhlNpwnHCpgQjpdPFnb8eMmK3o0U9JizrVzclAC2MrXJR
	 G4M5EMG7V0ZZF6RrdN9F/1kujQB5TEfWqDbz/z9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Yoav Cohen <yoav@nvidia.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/312] ublk: scan partition in async way
Date: Tue,  6 Jan 2026 18:02:35 +0100
Message-ID: <20260106170550.769429235@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

[ Upstream commit 7fc4da6a304bdcd3de14fc946dc2c19437a9cc5a ]

Implement async partition scan to avoid IO hang when reading partition
tables. Similar to nvme_partition_scan_work(), partition scanning is
deferred to a work queue to prevent deadlocks.

When partition scan happens synchronously during add_disk(), IO errors
can cause the partition scan to wait while holding ub->mutex, which
can deadlock with other operations that need the mutex.

Changes:
- Add partition_scan_work to ublk_device structure
- Implement ublk_partition_scan_work() to perform async scan
- Always suppress sync partition scan during add_disk()
- Schedule async work after add_disk() for trusted daemons
- Add flush_work() in ublk_stop_dev() before grabbing ub->mutex

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reported-by: Yoav Cohen <yoav@nvidia.com>
Closes: https://lore.kernel.org/linux-block/DM4PR12MB63280C5637917C071C2F0D65A9A8A@DM4PR12MB6328.namprd12.prod.outlook.com/
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 796035891888..23aba73d24dc 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -237,6 +237,7 @@ struct ublk_device {
 	bool canceling;
 	pid_t 	ublksrv_tgid;
 	struct delayed_work	exit_work;
+	struct work_struct	partition_scan_work;
 
 	struct ublk_queue       *queues[];
 };
@@ -254,6 +255,20 @@ static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
 		u16 q_id, u16 tag, struct ublk_io *io, size_t offset);
 static inline unsigned int ublk_req_build_flags(struct request *req);
 
+static void ublk_partition_scan_work(struct work_struct *work)
+{
+	struct ublk_device *ub =
+		container_of(work, struct ublk_device, partition_scan_work);
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &ub->ub_disk->state)))
+		return;
+
+	mutex_lock(&ub->ub_disk->open_mutex);
+	bdev_disk_changed(ub->ub_disk, false);
+	mutex_unlock(&ub->ub_disk->open_mutex);
+}
+
 static inline struct ublksrv_io_desc *
 ublk_get_iod(const struct ublk_queue *ubq, unsigned tag)
 {
@@ -2092,6 +2107,7 @@ static void ublk_stop_dev(struct ublk_device *ub)
 	mutex_lock(&ub->mutex);
 	ublk_stop_dev_unlocked(ub);
 	mutex_unlock(&ub->mutex);
+	flush_work(&ub->partition_scan_work);
 	ublk_cancel_dev(ub);
 }
 
@@ -3023,9 +3039,17 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub,
 
 	ublk_apply_params(ub);
 
-	/* don't probe partitions if any daemon task is un-trusted */
-	if (ub->unprivileged_daemons)
-		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
+	/*
+	 * Suppress partition scan to avoid potential IO hang.
+	 *
+	 * If ublk server error occurs during partition scan, the IO may
+	 * wait while holding ub->mutex, which can deadlock with other
+	 * operations that need the mutex. Defer partition scan to async
+	 * work.
+	 * For unprivileged daemons, keep GD_SUPPRESS_PART_SCAN set
+	 * permanently.
+	 */
+	set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 
 	ublk_get_device(ub);
 	ub->dev_info.state = UBLK_S_DEV_LIVE;
@@ -3042,6 +3066,10 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub,
 
 	set_bit(UB_STATE_USED, &ub->state);
 
+	/* Schedule async partition scan for trusted daemons */
+	if (!ub->unprivileged_daemons)
+		schedule_work(&ub->partition_scan_work);
+
 out_put_cdev:
 	if (ret) {
 		ublk_detach_disk(ub);
@@ -3207,6 +3235,7 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 	mutex_init(&ub->mutex);
 	spin_lock_init(&ub->lock);
 	mutex_init(&ub->cancel_mutex);
+	INIT_WORK(&ub->partition_scan_work, ublk_partition_scan_work);
 
 	ret = ublk_alloc_dev_number(ub, header->dev_id);
 	if (ret < 0)
-- 
2.51.0



