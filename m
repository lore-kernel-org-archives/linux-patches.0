Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CC51F419B;
	Mon, 13 Oct 2025 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370236; cv=none; b=SPgGDY3okbIgZ28Mep2HpqbASm0fJQMOVUOwhNVbE1PxwzJ8gA4YJapqgBLOlZbRTxKK5QHewAfIQuqNIlyURhPSpt6xH4ilq/n7wET7/DHgYdPca6rYifcTS3GI+QcZmY70nZHI1eQ7xaxbyv6+b17MKPrzYN2V+6y1L//WaR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370236; c=relaxed/simple;
	bh=T8Yi7yU+1WS3fzFNu+2BSusE2IROF2opV85fOOPEH9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se6jQdRNSdwiO0A1j+YhAg5S/cs0ig/wPUFq6yxW2CNCwkdj8CPGYwbqcvOmqtRT/gvQGwx30v/M3SdB3w2DAEHduRr+kyZbMsMhmJiNeUDtJETkyozRlhy+60rOu87GV6Zxd9ehux2qXhBoGW2rgApSGTxc8pfmecmurHEQ3a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXCSY3M0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXCSY3M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB89C4CEE7;
	Mon, 13 Oct 2025 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370236;
	bh=T8Yi7yU+1WS3fzFNu+2BSusE2IROF2opV85fOOPEH9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXCSY3M0FVDl9jUfVNDb+TQthiPgum0/TLGsAvSrat1xkhFRhms4AMtvH9Jdg7lZO
	 hVsP93x20cg7GQKU34rM5EHI7HegzApbvdEhuplJx6uUfZTv/kYMSnpH4AZaHTNLBY
	 N3IGm3spPOtbM/cHlB3e/NTG22eVs9bc3we/1txI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.17 519/563] dm: fix queue start/stop imbalance under suspend/load/resume races
Date: Mon, 13 Oct 2025 16:46:20 +0200
Message-ID: <20251013144430.115023925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

commit 7f597c2cdb9d3263a6fce07c4fc0a9eaa8e8fc43 upstream.

When suspend and load run concurrently, before q->mq_ops is set in
blk_mq_init_allocated_queue(), __dm_suspend() skip dm_stop_queue(). As a
result, the queue's quiesce depth is not incremented.

Later, once table load has finished and __dm_resume() runs, which triggers
q->quiesce_depth ==0 warning in blk_mq_unquiesce_queue():
Call Trace:
 <TASK>
 dm_start_queue+0x16/0x20 [dm_mod]
 __dm_resume+0xac/0xb0 [dm_mod]
 dm_resume+0x12d/0x150 [dm_mod]
 do_resume+0x2c2/0x420 [dm_mod]
 dev_suspend+0x30/0x130 [dm_mod]
 ctl_ioctl+0x402/0x570 [dm_mod]
 dm_ctl_ioctl+0x23/0x30 [dm_mod]

Fix this by explicitly tracking whether the request queue was
stopped in __dm_suspend() via a new DMF_QUEUE_STOPPED flag.
Only call dm_start_queue() in __dm_resume() if the queue was
actually stopped.

Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-core.h |    1 +
 drivers/md/dm.c      |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -162,6 +162,7 @@ struct mapped_device {
 #define DMF_SUSPENDED_INTERNALLY 7
 #define DMF_POST_SUSPENDING 8
 #define DMF_EMULATE_ZONE_APPEND 9
+#define DMF_QUEUE_STOPPED 10
 
 static inline sector_t dm_get_size(struct mapped_device *md)
 {
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2960,8 +2960,10 @@ static int __dm_suspend(struct mapped_de
 	 * Stop md->queue before flushing md->wq in case request-based
 	 * dm defers requests to md->wq from md->queue.
 	 */
-	if (dm_request_based(md))
+	if (dm_request_based(md)) {
 		dm_stop_queue(md->queue);
+		set_bit(DMF_QUEUE_STOPPED, &md->flags);
+	}
 
 	flush_workqueue(md->wq);
 
@@ -2983,7 +2985,7 @@ static int __dm_suspend(struct mapped_de
 	if (r < 0) {
 		dm_queue_flush(md);
 
-		if (dm_request_based(md))
+		if (test_and_clear_bit(DMF_QUEUE_STOPPED, &md->flags))
 			dm_start_queue(md->queue);
 
 		unlock_fs(md);
@@ -3067,7 +3069,7 @@ static int __dm_resume(struct mapped_dev
 	 * so that mapping of targets can work correctly.
 	 * Request-based dm is queueing the deferred I/Os in its request_queue.
 	 */
-	if (dm_request_based(md))
+	if (test_and_clear_bit(DMF_QUEUE_STOPPED, &md->flags))
 		dm_start_queue(md->queue);
 
 	unlock_fs(md);


