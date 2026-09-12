Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389DC1A6813;
	Sat, 12 Sep 2026 07:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197587; cv=none; b=AZK8lhS0LN88gVvJ0ezuEAMQIm6IbGpZNSI2h40UKrBJ+PCun++AhP6UGPNurWq9RdKyW3sjT6p59JQnAEYd3Q7LSysgkplQSdVQVxGloEbhSYc9C1cKJdLwpYhJ1JLn5/+9vHEcpotApY6z0DOSmaL4p7/aaqzbEQOB27xdzr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197587; c=relaxed/simple;
	bh=f7Xy5PZntNLLAfmWTftWTgrPVuUacpTWBL3hrGURJpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHoREUI4poTXk7gE8ucBMd1IxM3RQW2ZAwiKoeW/ulSUN5tncnjwOD1iZl/kq6WSoU15pRMkK49bSEjmg9ayqZ8+uTpvGLKXjiL3OTt6vH9dCaV3z6uvsS7oCuM90En+425WJ6v8YARRZwpPYZHJMtHjYeRQe+NdjHIoXwjvHFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeKwYT1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeKwYT1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D446D1F000FF;
	Sat, 12 Sep 2026 07:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197585;
	bh=a4w57ycJW9MjZLAMgBMjJSEgaZKNdbC/Cm3LBPjFfIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WeKwYT1YIPvH7jSHN6lzfwVESQEQcPmNx9QN4V3dLqA+TWWL6byRNZgAxn2gTxcaS
	 gdEN5ywbwAaqnaBZYOaNCoP1nwW8YCc7IRDZFFDjG6RCnY9bQQbswaqLSNa8c6mDR9
	 AHkfh8SSr/aDwNnOWF3tdFY1plIlzvT4j9l18vKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0205/1815] nvme-apple: Use acquire/release for queue enabled state
Date: Sat, 12 Sep 2026 08:32:35 +0200
Message-ID: <20260912065653.814100646@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit f61c934aa084b7440fec681be3f4b481eb5a8609 ]

apple_nvme_init_queue() initializes queue state and then marks the queue
enabled. The interrupt and request paths check enabled before using that
queue state.

The old wmb() after WRITE_ONCE(enabled, true) does not publish the
earlier initialization before enabled becomes visible. Use a release store
when enabling the queue and acquire loads when testing it.

Although the shutdown-side enabled accesses are not used for publishing
queue initialization, use helpers for them as well for consistency.

Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index be3b91b43ea5a..2723bc1a7d8a7 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -151,6 +151,23 @@ struct apple_nvme_queue {
 	bool enabled;
 };
 
+static inline bool apple_nvme_queue_enabled(struct apple_nvme_queue *q)
+{
+	/* Pair with apple_nvme_enable_queue(). */
+	return smp_load_acquire(&q->enabled);
+}
+
+static inline void apple_nvme_enable_queue(struct apple_nvme_queue *q)
+{
+	/* Publish queue initialization before setting q->enabled. */
+	smp_store_release(&q->enabled, true);
+}
+
+static inline void apple_nvme_disable_queue(struct apple_nvme_queue *q)
+{
+	WRITE_ONCE(q->enabled, false);
+}
+
 /*
  * The apple_nvme_iod describes the data in an I/O.
  *
@@ -677,7 +694,7 @@ static bool apple_nvme_handle_cq(struct apple_nvme_queue *q, bool force)
 	bool found;
 	DEFINE_IO_COMP_BATCH(iob);
 
-	if (!READ_ONCE(q->enabled) && !force)
+	if (!apple_nvme_queue_enabled(q) && !force)
 		return false;
 
 	found = apple_nvme_poll_cq(q, &iob);
@@ -780,7 +797,7 @@ static blk_status_t apple_nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * We should not need to do this, but we're still using this to
 	 * ensure we can drain requests on a dying queue.
 	 */
-	if (unlikely(!READ_ONCE(q->enabled)))
+	if (unlikely(!apple_nvme_queue_enabled(q)))
 		return BLK_STS_IOERR;
 
 	if (!nvme_check_ready(&anv->ctrl, req, true))
@@ -863,7 +880,7 @@ static void apple_nvme_disable(struct apple_nvme *anv, bool shutdown)
 	nvme_quiesce_io_queues(&anv->ctrl);
 
 	if (!dead) {
-		if (READ_ONCE(anv->ioq.enabled)) {
+		if (apple_nvme_queue_enabled(&anv->ioq)) {
 			apple_nvme_remove_sq(anv);
 			apple_nvme_remove_cq(anv);
 		}
@@ -887,8 +904,8 @@ static void apple_nvme_disable(struct apple_nvme *anv, bool shutdown)
 		nvme_disable_ctrl(&anv->ctrl, false);
 	}
 
-	WRITE_ONCE(anv->ioq.enabled, false);
-	WRITE_ONCE(anv->adminq.enabled, false);
+	apple_nvme_disable_queue(&anv->ioq);
+	apple_nvme_disable_queue(&anv->adminq);
 	mb(); /* ensure that nvme_queue_rq() sees that enabled is cleared */
 	nvme_quiesce_admin_queue(&anv->ctrl);
 
@@ -1016,8 +1033,7 @@ static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 		memset(q->tcbs, 0, anv->hw->max_queue_depth
 			* sizeof(struct apple_nvmmu_tcb));
 	memset(q->cqes, 0, depth * sizeof(struct nvme_completion));
-	WRITE_ONCE(q->enabled, true);
-	wmb(); /* ensure the first interrupt sees the initialization */
+	apple_nvme_enable_queue(q);
 }
 
 static void apple_nvme_reset_work(struct work_struct *work)
-- 
2.53.0



