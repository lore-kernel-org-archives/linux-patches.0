Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093875383D2;
	Wed, 23 Sep 2026 14:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174359; cv=none; b=n3U0IUUHT+NgJ+/CsaxNajRqe6XWP/nvb8mUvHCVcuyjaERhlJGA4qTiyUKANx/KxfXYsZVw4VVHVFYrN9s7pcyr9OsQpS02BOWPfKl+xrP7GXWkYYu5Ve79oUWoFzUtpI6lpOOsLuS0Do2KB0hFxW7NlP5lhq1BFh7tjIdizHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174359; c=relaxed/simple;
	bh=V654YxEfEES5mga/nQ/tY3/pIuXh+YgKsy3yYEPAlWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgC5An0+N+Q69t47fwuFIdQNmIK2Nlzl2Bblo2UtgFoe6xc2IUQtwd5FgUIFVRSyOY4hkNStZs/+CbSyWaPcwyeKbel/70qQsA5RAE/992scSCI2C5trLf8KrQW/y0dpXmYYeM6S35/q2jTKYMXPSp6yHhSbY43Og2Vh7x8NyWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RldjBgAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RldjBgAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD851F000FF;
	Wed, 23 Sep 2026 14:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174357;
	bh=y4SMXecASOzuSQxax2QRbV0fU9XA+NSall99/dq1lCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RldjBgAGAVQb3yFnyL8VezQVoZkybsZhbVZr/ggNgZt6x7Cr6qexTWxSXhS9HkcvJ
	 mjchzp9nn3BJTpXdbjx16VGnxX7pVwWQy/eVrORJicDkWiIjVBiAJBVEVaeKUtjCwl
	 cz0CJCm5mRLdKFU4qdtfC72TxEq8PjjWEHoutSqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Margolin <mrgolin@amazon.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/398] RDMA/efa: Keep EQ resources alive while IRQ is registered
Date: Wed, 23 Sep 2026 16:02:42 +0200
Message-ID: <20260923140645.719495363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7ee2c5cc55ac6..21b9bd1c1fef2 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -1156,7 +1156,7 @@ static void efa_com_destroy_eq(struct efa_com_dev *edev,
 				      err);
 }
 
-static void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
+void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
 {
 	u32 val = 0;
 
@@ -1245,7 +1245,6 @@ int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
 	eeq->phase = 1;
 	eeq->depth = params.depth;
 	eeq->cb = cb;
-	efa_com_arm_eq(edev, eeq);
 
 	return 0;
 
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index 4d9ca97e42962..1f635f4047ac9 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -157,6 +157,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 void efa_com_admin_destroy(struct efa_com_dev *edev);
 int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
 		    efa_eqe_handler cb, u16 depth, u8 msix_vec);
+void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq);
 void efa_com_eq_destroy(struct efa_com_dev *edev, struct efa_com_eq *eeq);
 int efa_com_dev_reset(struct efa_com_dev *edev,
 		      enum efa_regs_reset_reason_types reset_reason);
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index bd19150bc3fa7..fdaf88f0122db 100644
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



