Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3B8183CC3;
	Mon, 18 Aug 2025 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526149; cv=none; b=KDOQjYu0Lxzg5/sb/zKKsSAd7LO1s8lFj5NQiYW+vBiQYyQX0c+mjXmUQ+L3yio3MonjnZNwFWfQuyAcAgQkUyju03j1ikoVsLmwYsk7Z9hDw5tU2h/DrbEyhcPb/qzFyrY+qo7zaQmXPy4JTV1Dq0UauO35kaCGmKQhLSKOT9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526149; c=relaxed/simple;
	bh=9ZgJvsKaVoqy3S0uTjnwONYurjj7B7ueIdheciTM04w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaYyaHjxXq40bxxqiM1EQ+pEffQM6xTeFKfeVJmk6McHJND4TZ/5T2L7qo8kYxS48IU3qB/5Qv3wpYNuymIkkXJNeQDeMWXidAO/0knRf6NbqjHMBiW6sdVq7AHgdz8ekf5jSa5CK/yZxc8/dS3rAoUvIP+h0yVP5Y7z776W9MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+NGhLKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+NGhLKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1213C4CEEB;
	Mon, 18 Aug 2025 14:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526149;
	bh=9ZgJvsKaVoqy3S0uTjnwONYurjj7B7ueIdheciTM04w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+NGhLKrIiRFvUA2Zr+DVPldE2+pfEvTmYkSHGbd8LUgU/OvzCOJyLwmTqHrwxMcb
	 r2frxH58KAgft2C/cIxWmG9cnWaFFM+5vnNXPoYXQNGo6dxaCwlEKXYnY34tSKsdaK
	 F7A9rQEx4s42hWbFM8ItysKh1bvO90uHLkoC6TTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 472/570] ublk: check for unprivileged daemon on each I/O fetch
Date: Mon, 18 Aug 2025 14:47:39 +0200
Message-ID: <20250818124524.061576070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 5058a62875e1916e5133a1639f0207ea2148c0bc ]

Commit ab03a61c6614 ("ublk: have a per-io daemon instead of a per-queue
daemon") allowed each ublk I/O to have an independent daemon task.
However, nr_privileged_daemon is only computed based on whether the last
I/O fetched in each ublk queue has an unprivileged daemon task.
Fix this by checking whether every fetched I/O's daemon is privileged.
Change nr_privileged_daemon from a count of queues to a boolean
indicating whether any I/Os have an unprivileged daemon.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: ab03a61c6614 ("ublk: have a per-io daemon instead of a per-queue daemon")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250808155216.296170-1-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 3e60558bf525..dabb468fa0b9 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -215,7 +215,7 @@ struct ublk_device {
 
 	struct completion	completion;
 	unsigned int		nr_queues_ready;
-	unsigned int		nr_privileged_daemon;
+	bool 			unprivileged_daemons;
 	struct mutex cancel_mutex;
 	bool canceling;
 	pid_t 	ublksrv_tgid;
@@ -1532,7 +1532,7 @@ static void ublk_reset_ch_dev(struct ublk_device *ub)
 	/* set to NULL, otherwise new tasks cannot mmap io_cmd_buf */
 	ub->mm = NULL;
 	ub->nr_queues_ready = 0;
-	ub->nr_privileged_daemon = 0;
+	ub->unprivileged_daemons = false;
 	ub->ublksrv_tgid = -1;
 }
 
@@ -1945,12 +1945,10 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
 	__must_hold(&ub->mutex)
 {
 	ubq->nr_io_ready++;
-	if (ublk_queue_ready(ubq)) {
+	if (ublk_queue_ready(ubq))
 		ub->nr_queues_ready++;
-
-		if (capable(CAP_SYS_ADMIN))
-			ub->nr_privileged_daemon++;
-	}
+	if (!ub->unprivileged_daemons && !capable(CAP_SYS_ADMIN))
+		ub->unprivileged_daemons = true;
 
 	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues) {
 		/* now we are ready for handling ublk io request */
@@ -2759,8 +2757,8 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub,
 
 	ublk_apply_params(ub);
 
-	/* don't probe partitions if any one ubq daemon is un-trusted */
-	if (ub->nr_privileged_daemon != ub->nr_queues_ready)
+	/* don't probe partitions if any daemon task is un-trusted */
+	if (ub->unprivileged_daemons)
 		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 
 	ublk_get_device(ub);
-- 
2.50.1



