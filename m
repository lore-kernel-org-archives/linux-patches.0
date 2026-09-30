Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFAD52844E;
	Wed, 30 Sep 2026 17:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789995; cv=none; b=bSQ+8XpTRzg8mKO/wqJ4ouaX0MChMG+mVy6gWdyDDPAMUDYdaRR5wa0hLZVQc4msL9IF2Pkw5dO0Umhyf/x7+7mcUgUpzMI5uR5vg5eyAGKglMTS6CWcSC9X9Lgcq1TltiIC5sUt917JzI7EaTwLvhjEMpjGTX+5snctboQfWic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789995; c=relaxed/simple;
	bh=pKjJYio9DQxeTvI+pzoQyNlk1y/hqaB+jYd3vOHLb6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifkT/nTUuOp9Ken0zfffRvlFy8suXyNpZVxQUyGM9I/Fq0MQK3ISDjTwrmw+qJfa3Ql4D52BfZRh8G5xUMapbv0yjYKsFk7SJgCktHNY0mAnGoec8l8U9qjIPSSpnJj873akJffwyLGn44QD3dyz5Q/5TPkSq+WJlUZA+KYvnTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka0GVV4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka0GVV4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356BF1F000FF;
	Wed, 30 Sep 2026 17:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789993;
	bh=74tCU7K3z8wjmMvsiKIwVbG27BIoweu+jTqv1VwRsYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ka0GVV4TkrG1O2IHFpWskLd9zX8J9KviQtBtJaU7PHBAMeErYgkOSUNBtyTewMk3x
	 6UGtQKBv/kx1pL0sZGy/1rXKsaSHtHzc2q6UZUTps83j5vOFIt1HPS7M+IUtskdqLe
	 Qcn749o+dmx3aYucRwsB2h27HE29y/IerId7T5Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 672/877] scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
Date: Wed, 30 Sep 2026 17:26:23 +0200
Message-ID: <20260930152429.170167838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 34a40e0dff940ac5eba494a69b553ea571e24873 ]

qla25xx_free_req_que() and qla25xx_free_rsp_que() have two pre-existing
bugs exposed on the error path of qla25xx_create_{req,rsp}_que():

 1. When dma_alloc_coherent() fails during queue creation, the error
    path calls the free function with req->ring / rsp->ring still NULL
    (from kzalloc).  The unconditional dma_free_coherent() with a NULL
    cpu_addr is undefined behavior and can panic.

 2. The free functions clear req_qid_map / rsp_qid_map under vport_lock,
    but the create functions protect the same bitmaps with mq_lock.
    This provides no mutual exclusion.  Additionally, the create error
    path clears the bit and releases mq_lock before calling the free
    function, creating a window where another thread can allocate the
    same que_id and have its ha->req_q_map entry clobbered by the
    subsequent lockless NULL assignment in the free function.

Fix by:

 - Guarding dma_free_coherent() with a NULL check on the ring pointer.

 - Using mq_lock (the lock held by all creators) in the free functions
   to atomically NULL the map entry and clear the bitmap bit.

 - Removing the now-redundant clear_bit blocks from the create error
   paths since the free functions handle it atomically.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-41-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>

Backport adaptation for the stable tree: the 29xx IOCB size-selection
helpers are absent, and queue creation still allocates fixed-size entries.
Initialize the local req_entry_size and rsp_entry_size values with
sizeof(request_t) and sizeof(response_t), respectively, so DMA freeing
continues to match allocation without adding helper functions or 29xx
support. Retain all NULL-ring guards, mq_lock protection, and removal of
the premature bitmap clears.

Keep the response-ring cleanup layout used by upstream so target commit
19788a55cab61d78e33e0914a5a31d27843e8a4a applies unchanged.

Stable-dep-of: 19788a55cab6 ("scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mid.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -574,16 +574,19 @@ qla25xx_free_req_que(struct scsi_qla_hos
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = req->id;
+	size_t req_entry_size = sizeof(request_t);
 
-	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
-		sizeof(request_t), req->ring, req->dma);
+	if (req->ring)
+		dma_free_coherent(&ha->pdev->dev,
+				  (req->length + 1) * req_entry_size,
+				  req->ring, req->dma);
 	req->ring = NULL;
 	req->dma = 0;
 	if (que_id) {
+		mutex_lock(&ha->mq_lock);
 		ha->req_q_map[que_id] = NULL;
-		mutex_lock(&ha->vport_lock);
 		clear_bit(que_id, ha->req_qid_map);
-		mutex_unlock(&ha->vport_lock);
+		mutex_unlock(&ha->mq_lock);
 	}
 	kfree(req->outstanding_cmds);
 	kfree(req);
@@ -594,6 +597,7 @@ qla25xx_free_rsp_que(struct scsi_qla_hos
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = rsp->id;
+	size_t rsp_entry_size = sizeof(response_t);
 
 	if (rsp->msix && rsp->msix->have_irq) {
 		free_irq(rsp->msix->vector, rsp->msix->handle);
@@ -601,15 +605,18 @@ qla25xx_free_rsp_que(struct scsi_qla_hos
 		rsp->msix->in_use = 0;
 		rsp->msix->handle = NULL;
 	}
-	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
-		sizeof(response_t), rsp->ring, rsp->dma);
+
+	if (rsp->ring)
+		dma_free_coherent(&ha->pdev->dev,
+				  (rsp->length + 1) * rsp_entry_size,
+				  rsp->ring, rsp->dma);
 	rsp->ring = NULL;
 	rsp->dma = 0;
 	if (que_id) {
+		mutex_lock(&ha->mq_lock);
 		ha->rsp_q_map[que_id] = NULL;
-		mutex_lock(&ha->vport_lock);
 		clear_bit(que_id, ha->rsp_qid_map);
-		mutex_unlock(&ha->vport_lock);
+		mutex_unlock(&ha->mq_lock);
 	}
 	kfree(rsp);
 }
@@ -794,9 +801,6 @@ qla25xx_create_req_que(struct qla_hw_dat
 		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_fatal, base_vha, 0x00df,
 			    "%s failed.\n", __func__);
-			mutex_lock(&ha->mq_lock);
-			clear_bit(que_id, ha->req_qid_map);
-			mutex_unlock(&ha->mq_lock);
 			goto que_failed;
 		}
 		vha->flags.qpairs_req_created = 1;
@@ -908,9 +912,6 @@ qla25xx_create_rsp_que(struct qla_hw_dat
 		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_fatal, base_vha, 0x00e7,
 			    "%s failed.\n", __func__);
-			mutex_lock(&ha->mq_lock);
-			clear_bit(que_id, ha->rsp_qid_map);
-			mutex_unlock(&ha->mq_lock);
 			goto que_failed;
 		}
 		vha->flags.qpairs_rsp_created = 1;


