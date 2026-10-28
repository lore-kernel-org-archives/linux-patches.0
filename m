Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208166;
	b=4U1l8wHE8fDjrlvzgPz+nwD2h8AtJ8Rd0gMc9J1WGp2C1yHZf3uVdlOYtYtTmhARRA/5
	 VX0uY4yw5cIFLStE2HwXtcDpWjyD2y7eES8DokUol/zjd4hbvHP5H3G3VFgqHUZe5qyxC
	 ML2ARM1V9vZsyb0ZeQFp5lSU8DGAAILRg0+QQQ1vUyICcesK/P19og1Fp7p2cJHGT2iG6
	 wdiMH8uTF7EmA6S5IASE9Ea4fdRy/yFdQwjnzXaKI9sZwK8ZqIBcU8bxnUiwd6G6sHVKj
	 /AShljsJb+JMhPcq3lS10Qnvn96YmPJoJ55PO9DaWlWBemPTfOf3f9lO88OgSI1IcuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4jiF5mU5zORIzdry0KqeKl4GTfkkVxSOUrhoULb/C5M=;
	b=5DkCYtXtxTGWrXgcUwn+RQjkt3HxMYGKIQgC2qL4KJB2MrSwPxHidblTDcL7kSJLA83b
	 zqwR+hg4pYBq6b15OBmw6EdR3e4qDW35iZJU56iktwRGLg1lFzQEKnRA4tf5O3QFs/oUN
	 0czFwJoFhECfuXmq8eyXFLu8ZI9zS9CycbPcI0Vc+3ndMS2a5+M4jpltZ15nojPmtqyIx
	 2/6pIa98/8wZQ3g5jjRBIPEYtbGr6MfdrEHSEsGc/sw2HnXZfmYJoKBglgx2aLXS0oRU6
	 m+UVbfZVaxqHesGx4xvOvkrDHPC1mLRVzu/ctuOJrO2WNwoRPxYrQO1YHaRbQZ2p2cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAwk6tYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76522606A31A;
	Wed, 28 Oct 2026 17:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAwk6tYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89121F01825;
	Wed, 28 Oct 2026 17:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208166;
	bh=4jiF5mU5zORIzdry0KqeKl4GTfkkVxSOUrhoULb/C5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAwk6tYMFwcv1u8k+U+q768upyS2ziae4LQjHSK4/sOwIxs6Ri4gGd4dRk0WYhtr+
	 7Zol5/H12Oz2kuRHpfNK5atZNh/u+FSyxXKS5PpvEfeHYyuKdIsSw7o49zVcqyiDer
	 mr54lEPWw3ITVTciUwd+RbRAXu4lo9UTLuFYRkTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/516] scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
Date: Wed, 28 Oct 2026 17:52:56 +0100
Message-ID: <20261028170004.100135196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1a4a740e118a0..4e2d6e0cfb9b0 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -566,16 +566,19 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, struct req_que *req)
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
@@ -587,6 +590,7 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = rsp->id;
+	size_t rsp_entry_size = sizeof(response_t);
 
 	if (rsp->msix && rsp->msix->have_irq) {
 		free_irq(rsp->msix->vector, rsp->msix->handle);
@@ -594,15 +598,18 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
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
@@ -788,9 +795,6 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_fatal, base_vha, 0x00df,
 			    "%s failed.\n", __func__);
-			mutex_lock(&ha->mq_lock);
-			clear_bit(que_id, ha->req_qid_map);
-			mutex_unlock(&ha->mq_lock);
 			goto que_failed;
 		}
 		vha->flags.qpairs_req_created = 1;
@@ -904,9 +908,6 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
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



