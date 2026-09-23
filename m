Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3959535FF5B;
	Wed, 23 Sep 2026 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172917; cv=none; b=aRTDBVPsPp2dreg+OsYAQotgZJUHEWfAhExgYdzSEVcloIkj7e8h+F0cITkPQDIs6z6e0hvS76SmTkgJrUHbDAb0VwbnpHxd4N0mE4K7yqSMtudKbA3H1TpRgnZIueWph+cxtH2/EP41yoA6PYsAPP647+Q2B78pUQEMDhdEW8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172917; c=relaxed/simple;
	bh=Lv+l7vnegX56ICNxRpXiG4RLkHkH1BWNCZq8kS5gdkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8ESeHVVlv7dTgaNBGl++zkTvLtlTjtNVj+1dViu38rT1vqUmf/+iOl5IRdLwBH6oWakDn8CKB66+Sy2Wz9cTKhyan4YCaqdVUgiiLg4TwEfG5QE3mDmi5VtnmK1K7RrtnoRDr4ftp6W0HNAzCOw+nwGbZfknVuhSyYAK9FmR6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meCO6aeP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meCO6aeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900321F00893;
	Wed, 23 Sep 2026 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172916;
	bh=aomKAOrkMmSFeZmrbt2TyAIyw6ZYQJRnqu1Ayx9nXSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=meCO6aePPFgol50tP1IlisX51NhEKkpv/hnJP/BeXm7gQmKAJAJviOGWxem2Hl0qO
	 Rd6dg3yGyEfZH+UGvF2YGscq7+MW5oLSsgi2V3Cg8nKZbbdCLXLRYMSP35dk2p7bWm
	 xzxN2oc1fczQy6dPtU7te74UnVXBJFQ4cW8pzlPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Margolin <mrgolin@amazon.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 098/438] RDMA/efa: Keep admin queues alive while IRQ is registered
Date: Wed, 23 Sep 2026 16:01:59 +0200
Message-ID: <20260923140647.318480038@linuxfoundation.org>
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
index 7cc3f4af0bb9d..12ccb6441d13d 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -786,7 +786,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 
 	aq->dmadev = edev->dmadev;
 	aq->efa_dev = edev->efa_dev;
-	set_bit(EFA_AQ_STATE_POLLING_BIT, &aq->state);
+	efa_com_set_admin_polling_mode(edev, true);
 
 	sema_init(&aq->avail_cmds, aq->depth);
 
@@ -804,8 +804,6 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 	if (err)
 		goto err_destroy_sq;
 
-	efa_com_set_admin_polling_mode(edev, false);
-
 	err = efa_com_admin_init_aenq(edev, aenq_handlers);
 	if (err)
 		goto err_destroy_cq;
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 97da8e828e340..25af30c441929 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -611,18 +611,21 @@ static struct efa_dev *efa_probe_device(struct pci_dev *pdev)
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
@@ -646,8 +649,8 @@ static void efa_remove_device(struct pci_dev *pdev,
 
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



