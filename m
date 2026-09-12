Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABDA328635;
	Sat, 12 Sep 2026 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222724; cv=none; b=uswvQyLjSEk6jsP3dtq3B/lZLN1R01/rmH/DDhpUPSGZ87CGR7HyKfvzukodcwUBP1bbDiCgxDp1Orj/GxEUiquPWNP7acXsL+auXtELmgq3mv+79dP9qfBhgm59Hb8cTkaOO5m7iZcdGGPNKYVLMfQwSPQurD1CKDhTpKdua60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222724; c=relaxed/simple;
	bh=CQCyaGD+hb+b3v/Bcl7ZTJ5nMwZqOznAKJkCVeMG3bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo5nD8O2zA6YnhJ7OiWH9f6iCOHLgzD8rqCQT8dtfTECMAGTs13m+xvENw9UoRD9TjlWp0DO6wQ3e+xXS3qfpoelK+eaD0/2OLhBjww2fw0+U1VtOcWYyh927v9SE7pr2BpfwDIGHAvq1uw+UTez3YyEhA0+FQ8vSZaqxsQeNCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1K+2+Wi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1K+2+Wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B801A1F000FF;
	Sat, 12 Sep 2026 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222722;
	bh=kZ7pl1BWc/kQa6OCTQ/oAi6Dm7ihGLi7pLWukB51f4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1K+2+Wi8vtp7lo0Eb8kAejQ3fUPwBKHDG1bnrl5AmEdFUibXaRPNzMgzhhoeMN+1
	 c0BtJ3ehOBNqRiCzfhIFHN6TVfaWtv547/zUJ9IoZ9Cm/KyAw3FLFfFeOMJPc/bdhj
	 5AtX6kjP4Dy/Wf5mQV4OasheA+Xa8R8m3LKeaYos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0645/1424] nvme-apple: Use acquire/release for queue enabled state
Date: Sat, 12 Sep 2026 08:51:17 +0200
Message-ID: <20260912065621.735240914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 04bb23757a52f..7bfca05d831d1 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -149,6 +149,23 @@ struct apple_nvme_queue {
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
@@ -644,7 +661,7 @@ static bool apple_nvme_handle_cq(struct apple_nvme_queue *q, bool force)
 	bool found;
 	DEFINE_IO_COMP_BATCH(iob);
 
-	if (!READ_ONCE(q->enabled) && !force)
+	if (!apple_nvme_queue_enabled(q) && !force)
 		return false;
 
 	found = apple_nvme_poll_cq(q, &iob);
@@ -747,7 +764,7 @@ static blk_status_t apple_nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * We should not need to do this, but we're still using this to
 	 * ensure we can drain requests on a dying queue.
 	 */
-	if (unlikely(!READ_ONCE(q->enabled)))
+	if (unlikely(!apple_nvme_queue_enabled(q)))
 		return BLK_STS_IOERR;
 
 	if (!nvme_check_ready(&anv->ctrl, req, true))
@@ -824,7 +841,7 @@ static void apple_nvme_disable(struct apple_nvme *anv, bool shutdown)
 	nvme_quiesce_io_queues(&anv->ctrl);
 
 	if (!dead) {
-		if (READ_ONCE(anv->ioq.enabled)) {
+		if (apple_nvme_queue_enabled(&anv->ioq)) {
 			apple_nvme_remove_sq(anv);
 			apple_nvme_remove_cq(anv);
 		}
@@ -848,8 +865,8 @@ static void apple_nvme_disable(struct apple_nvme *anv, bool shutdown)
 		nvme_disable_ctrl(&anv->ctrl, false);
 	}
 
-	WRITE_ONCE(anv->ioq.enabled, false);
-	WRITE_ONCE(anv->adminq.enabled, false);
+	apple_nvme_disable_queue(&anv->ioq);
+	apple_nvme_disable_queue(&anv->adminq);
 	mb(); /* ensure that nvme_queue_rq() sees that enabled is cleared */
 	nvme_quiesce_admin_queue(&anv->ctrl);
 
@@ -974,8 +991,7 @@ static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 	memset(q->tcbs, 0,
 	       APPLE_ANS_MAX_QUEUE_DEPTH * sizeof(struct apple_nvmmu_tcb));
 	memset(q->cqes, 0, depth * sizeof(struct nvme_completion));
-	WRITE_ONCE(q->enabled, true);
-	wmb(); /* ensure the first interrupt sees the initialization */
+	apple_nvme_enable_queue(q);
 }
 
 static void apple_nvme_reset_work(struct work_struct *work)
-- 
2.53.0



