Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62941FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A7FC433C7;
	Tue,  1 Aug 2023 09:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883104;
	bh=Iidxy7Txz/Ag0UZabRS2GyTWPkAKLCVfqDrMetzxoSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oov/Vfjy6jVKYhyK/hCM1F/iR3RRZuZugxaL/ih6xvNo3HmDOKILXhxJR2d59Hl2X
	 D7Y7Ke2xRZSv1j6fmxvk68XCKzt7lDzgFg0gOeR4hLFYYDQ4fcTZLuA/JJGNz4upQu
	 zVSazCKsKlAJ2midcZezwMJblQx8X7BI7mcHGOYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 116/239] RDMA/bnxt_re: Fix hang during driver unload
Date: Tue,  1 Aug 2023 11:19:40 +0200
Message-ID: <20230801091929.917993613@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 29900bf351e1a7e4643da5c3c3cd9df75c577b88 ]

Driver unload hits a hang during stress testing of load/unload.

stack trace snippet -

tasklet_kill at ffffffff9aabb8b2
bnxt_qplib_nq_stop_irq at ffffffffc0a805fb [bnxt_re]
bnxt_qplib_disable_nq at ffffffffc0a80c5b [bnxt_re]
bnxt_re_dev_uninit at ffffffffc0a67d15 [bnxt_re]
bnxt_re_remove_device at ffffffffc0a6af1d [bnxt_re]

tasklet_kill can hang if the tasklet is scheduled after it is disabled.

Modified the sequences to disable the interrupt first and synchronize
irq before disabling the tasklet.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1689322969-25402-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 10 +++++-----
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  9 ++++-----
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index e589b04f953c5..b34cc500f51f3 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -420,19 +420,19 @@ void bnxt_qplib_nq_stop_irq(struct bnxt_qplib_nq *nq, bool kill)
 	if (!nq->requested)
 		return;
 
-	tasklet_disable(&nq->nq_tasklet);
+	nq->requested = false;
 	/* Mask h/w interrupt */
 	bnxt_qplib_ring_nq_db(&nq->nq_db.dbinfo, nq->res->cctx, false);
 	/* Sync with last running IRQ handler */
 	synchronize_irq(nq->msix_vec);
-	if (kill)
-		tasklet_kill(&nq->nq_tasklet);
-
 	irq_set_affinity_hint(nq->msix_vec, NULL);
 	free_irq(nq->msix_vec, nq);
 	kfree(nq->name);
 	nq->name = NULL;
-	nq->requested = false;
+
+	if (kill)
+		tasklet_kill(&nq->nq_tasklet);
+	tasklet_disable(&nq->nq_tasklet);
 }
 
 void bnxt_qplib_disable_nq(struct bnxt_qplib_nq *nq)
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 0028043bb51cd..05683ce64887f 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -826,19 +826,18 @@ void bnxt_qplib_rcfw_stop_irq(struct bnxt_qplib_rcfw *rcfw, bool kill)
 	if (!creq->requested)
 		return;
 
-	tasklet_disable(&creq->creq_tasklet);
+	creq->requested = false;
 	/* Mask h/w interrupts */
 	bnxt_qplib_ring_nq_db(&creq->creq_db.dbinfo, rcfw->res->cctx, false);
 	/* Sync with last running IRQ-handler */
 	synchronize_irq(creq->msix_vec);
-	if (kill)
-		tasklet_kill(&creq->creq_tasklet);
-
 	free_irq(creq->msix_vec, rcfw);
 	kfree(creq->irq_name);
 	creq->irq_name = NULL;
-	creq->requested = false;
 	atomic_set(&rcfw->rcfw_intr_enabled, 0);
+	if (kill)
+		tasklet_kill(&creq->creq_tasklet);
+	tasklet_disable(&creq->creq_tasklet);
 }
 
 void bnxt_qplib_disable_rcfw_channel(struct bnxt_qplib_rcfw *rcfw)
-- 
2.40.1



