Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED08342CA9;
	Tue, 11 Nov 2025 01:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823567; cv=none; b=CXMG2zcNzkSd60LdaV0NfP/BcKX4xw8NwA/NV7gvMzyLEeBwSLE1QAVky88CkuSBzOmxzRy8VqTROyfapVZJRXUtlQHEjbyvYvCClTsLd+0Ar4azki/7qZL3Okhu3fa3j2ojOhJg01CnG2V2wqERW9LaSZ4qmSVx/2P3Qc1kkH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823567; c=relaxed/simple;
	bh=K8otp3WpNGLynWgVmT9BdbaXfvMvNGmAyWXu85+7bAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpWLIg7MP000bM4EuOYzpIFTRX9ypnhkbhIawHBHnwRliwS8fZbqRT+xVECxf7zvidCAtCUBo9J29TvGDZ2yymu1gtdSW6cc+8n6LrMgXN4Bvkb+3tYt8O5VZp43yEh23av+HArnii0kYochj67n2yFsiHD7fU9KzI7TKMIO6Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REe40nfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REe40nfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7D0C2BC86;
	Tue, 11 Nov 2025 01:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823567;
	bh=K8otp3WpNGLynWgVmT9BdbaXfvMvNGmAyWXu85+7bAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REe40nfMgDpyD/ib8GWEiCbOcy1w1d2DG3aT07b7ogevvOte2E30CVhd4HVBdd5fX
	 Mhx93/LmHbMnJOW+RFMTeA47TqGKDYlsfEB1LYX0wCiNnvEPpfloinfzZVy7wSuqTn
	 cH9GqUnLE4FQTMoYZabYKcwJq86rWPG+BoWFo1Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 289/849] RDMA/mana_ib: Drain send wrs of GSI QP
Date: Tue, 11 Nov 2025 09:37:39 +0900
Message-ID: <20251111004543.396588386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 44d69d3cf2e8047c279cbb9708f05e2c43e33234 ]

Drain send WRs of the GSI QP on device removal.

In rare servicing scenarios, the hardware may delete the
state of the GSI QP, preventing it from generating CQEs
for pending send WRs. Since WRs submitted to the GSI QP
hold CM resources, the device cannot be removed until
those WRs are completed. This patch marks all pending
send WRs as failed, allowing the GSI QP to release the CM
resources and enabling safe device removal.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1753779618-23629-1-git-send-email-kotaranov@linux.microsoft.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/cq.c      | 26 ++++++++++++++++++++++++++
 drivers/infiniband/hw/mana/device.c  |  3 +++
 drivers/infiniband/hw/mana/mana_ib.h |  3 +++
 3 files changed, 32 insertions(+)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 28e154bbb50f8..1becc87791235 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -291,6 +291,32 @@ static int mana_process_completions(struct mana_ib_cq *cq, int nwc, struct ib_wc
 	return wc_index;
 }
 
+void mana_drain_gsi_sqs(struct mana_ib_dev *mdev)
+{
+	struct mana_ib_qp *qp = mana_get_qp_ref(mdev, MANA_GSI_QPN, false);
+	struct ud_sq_shadow_wqe *shadow_wqe;
+	struct mana_ib_cq *cq;
+	unsigned long flags;
+
+	if (!qp)
+		return;
+
+	cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
+
+	spin_lock_irqsave(&cq->cq_lock, flags);
+	while ((shadow_wqe = shadow_queue_get_next_to_complete(&qp->shadow_sq))
+			!= NULL) {
+		shadow_wqe->header.error_code = IB_WC_GENERAL_ERR;
+		shadow_queue_advance_next_to_complete(&qp->shadow_sq);
+	}
+	spin_unlock_irqrestore(&cq->cq_lock, flags);
+
+	if (cq->ibcq.comp_handler)
+		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+
+	mana_put_qp_ref(qp);
+}
+
 int mana_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
index fa60872f169f4..bdeddb642b877 100644
--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -230,6 +230,9 @@ static void mana_ib_remove(struct auxiliary_device *adev)
 {
 	struct mana_ib_dev *dev = dev_get_drvdata(&adev->dev);
 
+	if (mana_ib_is_rnic(dev))
+		mana_drain_gsi_sqs(dev);
+
 	ib_unregister_device(&dev->ib_dev);
 	dma_pool_destroy(dev->av_pool);
 	if (mana_ib_is_rnic(dev)) {
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 5d31034ac7fb3..af09a3e6ccb78 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -43,6 +43,8 @@
  */
 #define MANA_AV_BUFFER_SIZE	64
 
+#define MANA_GSI_QPN		(1)
+
 struct mana_ib_adapter_caps {
 	u32 max_sq_id;
 	u32 max_rq_id;
@@ -718,6 +720,7 @@ int mana_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 int mana_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		      const struct ib_send_wr **bad_wr);
 
+void mana_drain_gsi_sqs(struct mana_ib_dev *mdev);
 int mana_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
 
-- 
2.51.0



