Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE063CB56A;
	Wed, 30 Sep 2026 19:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796041; cv=none; b=F94eHn4G3UCW+s6AHOzD7LhKlB21GYqktgtnGjRCQInsNfvZYWPoK9RtP44igPHku1o13HHMBIAtPEZDkJwDI7KDHo4IGBvkib/fMPXGboVbacL1unk7xqOnIN2qMxd9nOXgNXUDtjgwO22MnaSxYhk6V8agWx2QjizkQKqK6os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796041; c=relaxed/simple;
	bh=ZzXh4K8nedm24mvxN0JAM+LJlmsZRWjVnyf/+Oz3Aqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luE1PP/aGXpviKQi4moRJiqirj4dwZXzbQ6i6lRMQOWj6q4YqjR/NJvDe/s9PDkJ9vmYuhcQSpgILGq16jl05ixYoMAsEt1vpubzFZzIhY9fSRoO/IxuYLTiPW8zJkPLK+Hgd3SFSU/hbyOK7MGjxqwy8HCjFNtv0C27fP9R/dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePutWHOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePutWHOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAAA1F000FF;
	Wed, 30 Sep 2026 19:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796040;
	bh=Fd/BPiq3X0hzezgFekxLwhWEsZn0x249R6dXDhnOXi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePutWHOA38h5n092wYCG1h0DGraDRKpCArKDbfaOnt81aT5YKQYcdbGJxDQvTSq1r
	 N6pwl2MhcRgjZ4tnx2fF807q7sr9OAg/z7ae0uUnUggVZGRgk1ftdx87NngLTV2i/e
	 Ca5L0GqrPQkeVBGa6YaEc0ZAiTb1l+PFgNyThQ8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Margolin <mrgolin@amazon.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0774/1193] RDMA/efa: Keep EQ resources alive while IRQ is registered
Date: Wed, 30 Sep 2026 17:24:18 +0200
Message-ID: <20260930152451.451434000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index d6fb2edc96891..00e339abc2c13 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -1149,7 +1149,7 @@ static void efa_com_destroy_eq(struct efa_com_dev *edev,
 				      err);
 }
 
-static void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
+void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
 {
 	u32 val = 0;
 
@@ -1238,7 +1238,6 @@ int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
 	eeq->phase = 1;
 	eeq->depth = params.depth;
 	eeq->cb = cb;
-	efa_com_arm_eq(edev, eeq);
 
 	return 0;
 
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index 77282234ce686..29a9d087db5d9 100644
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
index 68e2d5c96c886..83e4903ca7fd5 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -288,28 +288,30 @@ static void efa_set_host_info(struct efa_dev *dev)
 
 static void efa_destroy_eq(struct efa_dev *dev, struct efa_eq *eq)
 {
-	efa_com_eq_destroy(&dev->edev, &eq->eeq);
 	efa_free_irq(dev, &eq->irq);
+	efa_com_eq_destroy(&dev->edev, &eq->eeq);
 }
 
 static int efa_create_eq(struct efa_dev *dev, struct efa_eq *eq, u8 msix_vec)
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



