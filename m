Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCE75102A;
	Mon, 11 Dec 2023 18:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MQ72xCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B47EC433C9;
	Mon, 11 Dec 2023 18:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320531;
	bh=lYTcl3pyRqtgSoeOhUIaWzDtBnlZ76ZUkxxMQ4UyEf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MQ72xCgngnjNNc8+hmwU2X3MJzvDrMaH+6q8Tt0XiCZNjBe6KLjLaJ/LnjBDXPDJ
	 4+m4E5N2BMPK/qNdQ+SWJRBiTbsH0Q/2UmcVNcyDriUnt2xJgzy9AaN4c4LapGm32N
	 HL3+WtB8osy/g4iXjjN6LN3txsaE2nYtCdfJ1T8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/194] RDMA/irdma: Refactor error handling in create CQP
Date: Mon, 11 Dec 2023 19:21:08 +0100
Message-ID: <20231211182039.970516129@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sindhu Devale <sindhu.devale@intel.com>

[ Upstream commit 133b1cba46c6c8b67c630eacc0a1e4969da16517 ]

In case of a failure in irdma_create_cqp, do not call
irdma_destroy_cqp, but cleanup all the allocated resources
in reverse order.

Drop the extra argument in irdma_destroy_cqp as its no longer needed.

Signed-off-by: Krzysztof Czurylo <krzysztof.czurylo@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230725155505.1069-3-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 2b78832f50c4 ("RDMA/irdma: Fix UAF in irdma_sc_ccq_get_cqe_info()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 35 +++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 027584febb8ca..8aa507e87df37 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -572,7 +572,7 @@ static void irdma_destroy_irq(struct irdma_pci_f *rf,
  * Issue destroy cqp request and
  * free the resources associated with the cqp
  */
-static void irdma_destroy_cqp(struct irdma_pci_f *rf, bool free_hwcqp)
+static void irdma_destroy_cqp(struct irdma_pci_f *rf)
 {
 	struct irdma_sc_dev *dev = &rf->sc_dev;
 	struct irdma_cqp *cqp = &rf->cqp;
@@ -580,8 +580,8 @@ static void irdma_destroy_cqp(struct irdma_pci_f *rf, bool free_hwcqp)
 
 	if (rf->cqp_cmpl_wq)
 		destroy_workqueue(rf->cqp_cmpl_wq);
-	if (free_hwcqp)
-		status = irdma_sc_cqp_destroy(dev->cqp);
+
+	status = irdma_sc_cqp_destroy(dev->cqp);
 	if (status)
 		ibdev_dbg(to_ibdev(dev), "ERR: Destroy CQP failed %d\n", status);
 
@@ -925,8 +925,8 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
 
 	cqp->scratch_array = kcalloc(sqsize, sizeof(*cqp->scratch_array), GFP_KERNEL);
 	if (!cqp->scratch_array) {
-		kfree(cqp->cqp_requests);
-		return -ENOMEM;
+		status = -ENOMEM;
+		goto err_scratch;
 	}
 
 	dev->cqp = &cqp->sc_cqp;
@@ -936,15 +936,14 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
 	cqp->sq.va = dma_alloc_coherent(dev->hw->device, cqp->sq.size,
 					&cqp->sq.pa, GFP_KERNEL);
 	if (!cqp->sq.va) {
-		kfree(cqp->scratch_array);
-		kfree(cqp->cqp_requests);
-		return -ENOMEM;
+		status = -ENOMEM;
+		goto err_sq;
 	}
 
 	status = irdma_obj_aligned_mem(rf, &mem, sizeof(struct irdma_cqp_ctx),
 				       IRDMA_HOST_CTX_ALIGNMENT_M);
 	if (status)
-		goto exit;
+		goto err_ctx;
 
 	dev->cqp->host_ctx_pa = mem.pa;
 	dev->cqp->host_ctx = mem.va;
@@ -970,7 +969,7 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
 	status = irdma_sc_cqp_init(dev->cqp, &cqp_init_info);
 	if (status) {
 		ibdev_dbg(to_ibdev(dev), "ERR: cqp init status %d\n", status);
-		goto exit;
+		goto err_ctx;
 	}
 
 	spin_lock_init(&cqp->req_lock);
@@ -981,7 +980,7 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
 		ibdev_dbg(to_ibdev(dev),
 			  "ERR: cqp create failed - status %d maj_err %d min_err %d\n",
 			  status, maj_err, min_err);
-		goto exit;
+		goto err_ctx;
 	}
 
 	INIT_LIST_HEAD(&cqp->cqp_avail_reqs);
@@ -995,8 +994,16 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
 	init_waitqueue_head(&cqp->remove_wq);
 	return 0;
 
-exit:
-	irdma_destroy_cqp(rf, false);
+err_ctx:
+	dma_free_coherent(dev->hw->device, cqp->sq.size,
+			  cqp->sq.va, cqp->sq.pa);
+	cqp->sq.va = NULL;
+err_sq:
+	kfree(cqp->scratch_array);
+	cqp->scratch_array = NULL;
+err_scratch:
+	kfree(cqp->cqp_requests);
+	cqp->cqp_requests = NULL;
 
 	return status;
 }
@@ -1744,7 +1751,7 @@ void irdma_ctrl_deinit_hw(struct irdma_pci_f *rf)
 				      rf->reset, rf->rdma_ver);
 		fallthrough;
 	case CQP_CREATED:
-		irdma_destroy_cqp(rf, true);
+		irdma_destroy_cqp(rf);
 		fallthrough;
 	case INITIAL_STATE:
 		irdma_del_init_mem(rf);
-- 
2.42.0



