Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210429;
	b=4py0xOj1p89hVAtsw0dZIvJZE2/1JbRJoiOlHcPQwOPLoC1chzWW4Jf/o7AKWY8ay1IJ
	 kYv6HTYf1xAldQ1v5DCneLD2wXqRmFYYV4Dbff+GBKrtG9wCvQPEY3bfQjPLKAkF3INU/
	 SqzW60yXTBiLP2QEedivquuEp7jAR3z2MABu7UcrLzC9XrwWywhSlYPNM3+EddLLOwnwh
	 hxTLpiSMRQZVLVBdIY6OBX+6dqF+4C1RET9Af/Fj1mRXVKD6tLM7iFVzyufKOIZERzbJ9
	 zBBaq5ZG0W54zOa/FRtZrLkdDnDznOm3HcKxOIoF/tJ+imRFCswPLwp1H4kSrMmdqHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Q4/beVXCuxZaHelte8odf/DAKUhquehh8KBdPTnPhQ=;
	b=uaRN3lDrSiC3jVkFN1mD1xe/dbkGwhaz1HIwe5Dzdg+HU5umE8Ap0+ESLA4ZlLhxCucX
	 gvjVao3dymE/GX8W7LpOfz7zpyViqW5+48OckS+BmNXL8K9EmlfocW9bdy4rwTU5NF0cv
	 4o5ecGKNCQonA5SmsaJuZn5idGlfz3Fly1At4hK40IX4E2MrOQGSZ9VkuEzScP378VakR
	 3e4GwMJue7uKQYF/cp0Q+X5j4LoqJi/+AzO53bNIMpnb3vg/wRUJHwiEEcoHqbpEtxAnJ
	 nG5G1geKNxPJf83E/GDGNSQaeW+JhP6NG8JU1iHj8wGHdmie0OaWqG3/It7nzZsVQ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTOlCZp0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C481606A31A;
	Wed, 28 Oct 2026 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTOlCZp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96461F01825;
	Wed, 28 Oct 2026 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210429;
	bh=8Q4/beVXCuxZaHelte8odf/DAKUhquehh8KBdPTnPhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTOlCZp00tB4jCMb4QvAr0gExUE4bdVNLOvgWiLDYFu1Oij/49UaQPCiXWmG4YHO/
	 N9kLTdVsEMwpSNYObGajyn30IF5qNKciPyHIz3g6vKZrkYFRutOi7AFuLatggYUxbv
	 YWl6Lh4MPMTXlVy9Qii7eQvFOf6Tra731ibiUwwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/571] scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
Date: Wed, 28 Oct 2026 17:52:50 +0100
Message-ID: <20261028170008.572635211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/scsi/qla2xxx/qla_mid.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 7e1956d0435d7..4d2ce7a3de03d 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -583,16 +583,19 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, struct req_que *req)
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
@@ -604,6 +607,7 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = rsp->id;
+	size_t rsp_entry_size = sizeof(response_t);
 
 	if (rsp->msix && rsp->msix->have_irq) {
 		free_irq(rsp->msix->vector, rsp->msix->handle);
@@ -611,15 +615,18 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
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
 	rsp = NULL;
@@ -805,9 +812,6 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_fatal, base_vha, 0x00df,
 			    "%s failed.\n", __func__);
-			mutex_lock(&ha->mq_lock);
-			clear_bit(que_id, ha->req_qid_map);
-			mutex_unlock(&ha->mq_lock);
 			goto que_failed;
 		}
 		vha->flags.qpairs_req_created = 1;
@@ -919,9 +923,6 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_fatal, base_vha, 0x00e7,
 			    "%s failed.\n", __func__);
-			mutex_lock(&ha->mq_lock);
-			clear_bit(que_id, ha->rsp_qid_map);
-			mutex_unlock(&ha->mq_lock);
 			goto que_failed;
 		}
 		vha->flags.qpairs_rsp_created = 1;
-- 
2.53.0



