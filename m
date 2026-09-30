Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA1050E5B3;
	Wed, 30 Sep 2026 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785953; cv=none; b=TByrRLw8n53C88M235d4oxA1524axYZqXKWFeiuf8BaNiBk5zRahIBMaM2NpTI89Z2Y+CzkzJr4UnhhKfquRnANUo3e5XQaW75O3DQoY25ircFluq7LKRo6JhDOj9mT2Ve/y6fE23CYWQamivIB9lMOazY6t5OrTBmCdk2mD5tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785953; c=relaxed/simple;
	bh=cAmGGz80jbljiYCiktPKXbEj5SwS3HkzBgzEF3PvrwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snf6ARmmV0m3r2Fd8teMRPrtYO2H10+5i9GnezTWGeC5YVgSRI2TvLqhh6qjcQyM78o19Q3zOmqtnhPZirievIQV5uXHjtU4gxyMYYuXRWhBSmRNgEm54esZVj0fzVIhaeoyGP3b2Sh595/JNiWQiXGMMvZrjLbe8AueEAcRRxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dyroj8+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dyroj8+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E70C1F000FF;
	Wed, 30 Sep 2026 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785951;
	bh=mUR4eVqk//tg3WH/HywH4Bcz10w4dc3WYcOKIH3//h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dyroj8+HHrE1e+4SKZItsgMIQEXG2gR5MTAEJM+cpUFEiA35W4Rj6M7wQzfO5Exhu
	 5rgco5S0/mw5iGMdQdYjF08w3q9yuLLG1L+hTVtdL/LJR+MM2YgVRCCl4PxdemSReM
	 GH/mlCAKinOrSyBuCvx5Z73XtClILEQLf1v7proY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Margolin <mrgolin@amazon.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 645/982] RDMA/efa: Keep admin queues alive while IRQ is registered
Date: Wed, 30 Sep 2026 17:23:01 +0200
Message-ID: <20260930152430.620466286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e08aca85c02ff290f785f07acae758f0daf5f49e ]

The management IRQ handler accesses both the admin completion queue and the
async event queue. The driver registered the IRQ before constructing these
queues and destroyed them before freeing the IRQ, so the handler's lifetime
was not contained by the resources it accesses.

Initialize the queues with interrupts masked, request the IRQ, and then
switch to interrupt mode. On removal, reset the device and free the IRQ
before destroying the queues. Also reset the device before destroying the
queues if IRQ registration fails, because the device already has their DMA
addresses.

Fixes: b7f5e880f377 ("RDMA/efa: Add the efa module")
Link: https://patch.msgid.link/20260907-use-after-free-of-admin-queue-struct-v1-1-dd9d9267fbf4@nvidia.com
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c  |  4 +---
 drivers/infiniband/hw/efa/efa_main.c | 15 +++++++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index bafd210dd43e8..d6fb2edc96891 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -743,7 +743,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 
 	aq->dmadev = edev->dmadev;
 	aq->efa_dev = edev->efa_dev;
-	set_bit(EFA_AQ_STATE_POLLING_BIT, &aq->state);
+	efa_com_set_admin_polling_mode(edev, true);
 
 	sema_init(&aq->avail_cmds, aq->depth);
 
@@ -761,8 +761,6 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 	if (err)
 		goto err_destroy_sq;
 
-	efa_com_set_admin_polling_mode(edev, false);
-
 	err = efa_com_admin_init_aenq(edev, aenq_handlers);
 	if (err)
 		goto err_destroy_cq;
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 924940ca9de0a..68e2d5c96c886 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -595,18 +595,21 @@ static struct efa_dev *efa_probe_device(struct pci_dev *pdev)
 	edev->aq.msix_vector_idx = dev->admin_msix_vector_idx;
 	edev->aenq.msix_vector_idx = dev->admin_msix_vector_idx;
 
-	err = efa_set_mgmnt_irq(dev);
+	err = efa_com_admin_init(edev, &aenq_handlers);
 	if (err)
 		goto err_disable_msix;
 
-	err = efa_com_admin_init(edev, &aenq_handlers);
+	err = efa_set_mgmnt_irq(dev);
 	if (err)
-		goto err_free_mgmnt_irq;
+		goto err_destroy_admin;
+
+	efa_com_set_admin_polling_mode(edev, false);
 
 	return dev;
 
-err_free_mgmnt_irq:
-	efa_free_irq(dev, &dev->admin_irq);
+err_destroy_admin:
+	efa_com_dev_reset(edev, EFA_REGS_RESET_INIT_ERR);
+	efa_com_admin_destroy(edev);
 err_disable_msix:
 	efa_disable_msix(dev);
 err_reg_read_destroy:
@@ -630,8 +633,8 @@ static void efa_remove_device(struct pci_dev *pdev,
 
 	edev = &dev->edev;
 	efa_com_dev_reset(edev, reset_reason);
-	efa_com_admin_destroy(edev);
 	efa_free_irq(dev, &dev->admin_irq);
+	efa_com_admin_destroy(edev);
 	efa_disable_msix(dev);
 	efa_com_mmio_reg_read_destroy(edev);
 	devm_iounmap(&pdev->dev, edev->reg_bar);
-- 
2.53.0



