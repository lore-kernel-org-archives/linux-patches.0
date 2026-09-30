Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E92833B6F1;
	Wed, 30 Sep 2026 15:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783455; cv=none; b=G0fPsqY5/elCghETSaWPZM9Spuvs0UzMUQG0FCq9cteUcPOhnmnGRM3OAulK7lnIR3YI57x8fTG5oQ5ZWnyxmb7/3JkCwxw5tfxxtFL4ORuhgb5wNvuD9/5diTQTFk6m6h4hQrtP4+MPPgR5SxozGIkBgdO5m8oY1NIVjt5x248=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783455; c=relaxed/simple;
	bh=EoRkOPoUhFX9+28QofMFZCZKAW44NyOGt3c5EQl+Cgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5reKs5HaVfrg4bKvswGWG+8NjeNDT6MXLnGbWmgzPdsra6Su+X10fladwglYmy9xAJSuCfqtu9EimAMQ/T8hwEO78PoG6VCcpmm6biXu4HpOiZao3VLEnwUltDXyned6TcnNuAwIlZC9D57vDURQg9bzMR1e5IHXLY5uPFR/zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3JxJriA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3JxJriA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A411F0089B;
	Wed, 30 Sep 2026 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783449;
	bh=tAFvNdJN932kGGAK/V3Ex29tkiqZAtgxYp3LOhVIXzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3JxJriAWLkuo5ll7ZtX6F0hebKqXrCPL/sv6UP1DMIYULl3WNvsQrhXbkER503vd
	 8FkuNDTyDWzDQZ6lbbsFPR/8eQg7QHmvVWMB9q+pibUc0Zuck7NDWF/j1jheIXLjdH
	 QZdr/oqew/13MueJZaPUrlIXjuW8z+hSAdWhoFKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Gorenko <sergeygo@nvidia.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/595] IB/iser: Remove iser_reg_data_sg helper function
Date: Wed, 30 Sep 2026 17:24:11 +0200
Message-ID: <20260930152355.379059040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit 7f68d7493ff07a0ad63f63c4a1a4e0781cec0dd2 ]

Open coding it makes the code more readable and simple.

Link: https://lore.kernel.org/r/20220308145546.8372-2-mgurtovoy@nvidia.com
Reviewed-by: Sergey Gorenko <sergeygo@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d85f0f0a7c85 ("IB/iser: reject a remote invalidation of an unregistered direction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 31 +++++++----------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 9c8ebfe754fc8..8d1de26f58647 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -327,40 +327,26 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	return 0;
 }
 
-static int iser_reg_data_sg(struct iscsi_iser_task *task,
-			    struct iser_data_buf *mem,
-			    struct iser_fr_desc *desc, bool use_dma_key,
-			    struct iser_mem_reg *reg)
-{
-	struct iser_device *device = task->iser_conn->ib_conn.device;
-
-	if (use_dma_key)
-		return iser_reg_dma(device, mem, reg);
-
-	return iser_fast_reg_mr(task, mem, &desc->rsc, reg);
-}
-
 int iser_reg_mem_fastreg(struct iscsi_iser_task *task,
 			 enum iser_data_dir dir,
 			 bool all_imm)
 {
 	struct ib_conn *ib_conn = &task->iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
 	struct iser_data_buf *mem = &task->data[dir];
 	struct iser_mem_reg *reg = &task->rdma_reg[dir];
-	struct iser_fr_desc *desc = NULL;
+	struct iser_fr_desc *desc;
 	bool use_dma_key;
 	int err;
 
 	use_dma_key = mem->dma_nents == 1 && (all_imm || !iser_always_reg) &&
 		      scsi_get_prot_op(task->sc) == SCSI_PROT_NORMAL;
+	if (use_dma_key)
+		return iser_reg_dma(device, mem, reg);
 
-	if (!use_dma_key) {
-		desc = iser_reg_desc_get_fr(ib_conn);
-		reg->mem_h = desc;
-	}
-
+	desc = iser_reg_desc_get_fr(ib_conn);
 	if (scsi_get_prot_op(task->sc) == SCSI_PROT_NORMAL) {
-		err = iser_reg_data_sg(task, mem, desc, use_dma_key, reg);
+		err = iser_fast_reg_mr(task, mem, &desc->rsc, reg);
 		if (unlikely(err))
 			goto err_reg;
 	} else {
@@ -372,11 +358,12 @@ int iser_reg_mem_fastreg(struct iscsi_iser_task *task,
 		desc->sig_protected = true;
 	}
 
+	reg->mem_h = desc;
+
 	return 0;
 
 err_reg:
-	if (desc)
-		iser_reg_desc_put_fr(ib_conn, desc);
+	iser_reg_desc_put_fr(ib_conn, desc);
 
 	return err;
 }
-- 
2.53.0



