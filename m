Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C5C3750D5;
	Wed, 23 Sep 2026 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172920; cv=none; b=puU8TZcGQqxZGFdM4+IdUVsyfMrWJNZE2wAHaWSTVdVi7821FT5/iAP2CNEWTVMac0xjTImy5muT4ql2m7uAg1l2ZEBg5O7LOkiF9UxkBd7xLQZ2A2uObBDMd5aG/q6DTNLIoViU3GU3JiNtA18sfsSGdtZgT1L/wn3yVY/+3X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172920; c=relaxed/simple;
	bh=NAj+cRqDlYiGL4o19OOddlOVJtJrjdLOovnr3XxYgx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5LYL4HifIV2Jb3jI1hKahRxjtpuXQ0pCNF4GuA6HlrJF9QWYA0SG8WAcdIrnMqiEpS84GALfJSK22D5+pRzXCQiAVQ2SLPVKT9B1ZOLZ66+X2ZBX37oydV7s3PvkSOMjRHz20EnAoXLa4Ap/2U3nlgDVAEszcRlpWlUhteNG2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylz+yAn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylz+yAn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9610C1F000FF;
	Wed, 23 Sep 2026 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172919;
	bh=xur00F8C88fMvNpaqPTIVNYyBhfqjbrrOylkuDcUOt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylz+yAn8LyYG1B3NdLAKH4wftnnlzGwlZGTDqs+uxpPC5nrmAi7lscfKpeCdZBmBI
	 4TqmJVnV75EiHcf6MUok9ggf3aPosMSR/1tkF50yfzMo1I3PSBn0pw+qvuK7OA0Ljr
	 MLxbrGADmD/51/AXwAWhmFLOH+DFALNWCD8qKG/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Margolin <mrgolin@amazon.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 099/438] RDMA/efa: Keep EQ resources alive while IRQ is registered
Date: Wed, 23 Sep 2026 16:02:00 +0200
Message-ID: <20260923140647.344961095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e22a3627b7151754f07f90ea3d1ab6e85f5d93f4 ]

The completion IRQ handler accesses the EQ state and DMA buffer. Its IRQ was
registered before that state was initialized, while teardown released the
buffer before free_irq() synchronized the handler.

Initialize the EQ without arming it, register the IRQ, and then arm it.
Reverse the resource order during teardown by freeing the IRQ before
destroying the EQ.

Fixes: 2a152512a155 ("RDMA/efa: CQ notifications")
Link: https://patch.msgid.link/20260907-use-after-free-of-admin-queue-struct-v1-2-dd9d9267fbf4@nvidia.com
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c  |  3 +--
 drivers/infiniband/hw/efa/efa_com.h  |  1 +
 drivers/infiniband/hw/efa/efa_main.c | 18 ++++++++++--------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 12ccb6441d13d..eed6000fc62df 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -1192,7 +1192,7 @@ static void efa_com_destroy_eq(struct efa_com_dev *edev,
 				      err);
 }
 
-static void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
+void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
 {
 	u32 val = 0;
 
@@ -1281,7 +1281,6 @@ int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
 	eeq->phase = 1;
 	eeq->depth = params.depth;
 	eeq->cb = cb;
-	efa_com_arm_eq(edev, eeq);
 
 	return 0;
 
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index f8c692b0e092e..d9b3eb0cdf37c 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -159,6 +159,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 void efa_com_admin_destroy(struct efa_com_dev *edev);
 int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
 		    efa_eqe_handler cb, u16 depth, u8 msix_vec);
+void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq);
 void efa_com_eq_destroy(struct efa_com_dev *edev, struct efa_com_eq *eeq);
 int efa_com_dev_reset(struct efa_com_dev *edev,
 		      enum efa_regs_reset_reason_types reset_reason);
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 25af30c441929..c2ecd44476d4f 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -300,28 +300,30 @@ static void efa_set_host_info(struct efa_dev *dev)
 
 static void efa_destroy_eq(struct efa_dev *dev, struct efa_eq *eq)
 {
-	efa_com_eq_destroy(&dev->edev, &eq->eeq);
 	efa_free_irq(dev, &eq->irq);
+	efa_com_eq_destroy(&dev->edev, &eq->eeq);
 }
 
 static int efa_create_eq(struct efa_dev *dev, struct efa_eq *eq, u32 msix_vec)
 {
 	int err;
 
-	efa_setup_comp_irq(dev, eq, msix_vec);
-	err = efa_request_irq(dev, &eq->irq);
+	err = efa_com_eq_init(&dev->edev, &eq->eeq, efa_process_eqe,
+			      dev->dev_attr.max_eq_depth, msix_vec);
 	if (err)
 		return err;
 
-	err = efa_com_eq_init(&dev->edev, &eq->eeq, efa_process_eqe,
-			      dev->dev_attr.max_eq_depth, msix_vec);
+	efa_setup_comp_irq(dev, eq, msix_vec);
+	err = efa_request_irq(dev, &eq->irq);
 	if (err)
-		goto err_free_comp_irq;
+		goto err_destroy_eq;
+
+	efa_com_arm_eq(&dev->edev, &eq->eeq);
 
 	return 0;
 
-err_free_comp_irq:
-	efa_free_irq(dev, &eq->irq);
+err_destroy_eq:
+	efa_com_eq_destroy(&dev->edev, &eq->eeq);
 	return err;
 }
 
-- 
2.53.0



