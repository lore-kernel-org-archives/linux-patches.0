Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489B30CDB9;
	Mon, 13 Oct 2025 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367350; cv=none; b=XRp9AyZTI81Bx4yMpSGaaGh/zM/jlz4oeT4jFa4L4s8MaQAmJzKu+lD9kM9U+3tgRQ6ggaBKNCz41HgpiSoTtjIt7q9U7Uyg1pitOidkGxB8TW7ZdeOoRGH7QvC/4OODcUUncR6sb1wSZAjU9IEQIu66nzrCIHWOnIRv5btCU3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367350; c=relaxed/simple;
	bh=YXR+Vagoev1l9n3xH17K+ponOxGVyVKt/pAOAX7JoP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb2+Juh0yF61z498Th/txGqanC1SlKZSiwizE6NdT21HjOml9gA2eLqkpuuQ4SBOOw0i/L9aeWJRzSsmW3JqRqgcGT7GpHzYs3WzSCpwIL158zAncL5RSQD3vcsHME85pcDt6NqNeZIUKz9qYC2sCc5SKlQltEtUhBZpfT/QENI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap5U8fOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap5U8fOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D483C4CEE7;
	Mon, 13 Oct 2025 14:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367349;
	bh=YXR+Vagoev1l9n3xH17K+ponOxGVyVKt/pAOAX7JoP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap5U8fOF+PUp110X7eWmLMBwKX4pfb82Q3I9qIIbAAtzr/r9wn4uw0LCnVQ+wNit0
	 2W44j7sGcqh19B5y2XUKPB1asSBE0/cDnZ+z/sdVbcJAM6yUFif3trp9TydGwmqDFc
	 Ba5L9LAsAFiWQpCMbbx4cJapXT+W62Ije8QpvaJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 178/196] dm: fix queue start/stop imbalance under suspend/load/resume races
Date: Mon, 13 Oct 2025 16:45:51 +0200
Message-ID: <20251013144321.134661285@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -160,6 +160,7 @@ struct mapped_device {
 #define DMF_SUSPENDED_INTERNALLY 7
 #define DMF_POST_SUSPENDING 8
 #define DMF_EMULATE_ZONE_APPEND 9
+#define DMF_QUEUE_STOPPED 10
 
 void disable_discard(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2720,8 +2720,10 @@ static int __dm_suspend(struct mapped_de
 	 * Stop md->queue before flushing md->wq in case request-based
 	 * dm defers requests to md->wq from md->queue.
 	 */
-	if (dm_request_based(md))
+	if (dm_request_based(md)) {
 		dm_stop_queue(md->queue);
+		set_bit(DMF_QUEUE_STOPPED, &md->flags);
+	}
 
 	flush_workqueue(md->wq);
 
@@ -2743,7 +2745,7 @@ static int __dm_suspend(struct mapped_de
 	if (r < 0) {
 		dm_queue_flush(md);
 
-		if (dm_request_based(md))
+		if (test_and_clear_bit(DMF_QUEUE_STOPPED, &md->flags))
 			dm_start_queue(md->queue);
 
 		unlock_fs(md);
@@ -2826,7 +2828,7 @@ static int __dm_resume(struct mapped_dev
 	 * so that mapping of targets can work correctly.
 	 * Request-based dm is queueing the deferred I/Os in its request_queue.
 	 */
-	if (dm_request_based(md))
+	if (test_and_clear_bit(DMF_QUEUE_STOPPED, &md->flags))
 		dm_start_queue(md->queue);
 
 	unlock_fs(md);


