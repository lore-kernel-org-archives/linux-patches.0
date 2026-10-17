Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077E3BBA04;
	Sat, 17 Oct 2026 17:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259067; cv=none; b=tMqoHcx5dg7Ir9EEN7iGTVqIKVb+T5LJfkdAY90IDuOtkGiuwWKsnfzdec+2tkwsm85IPo8eBqpC0x8PiqiP7Hh89iNdR3Shda0SaAPXp2OJvH9KSi0UbjdLrZlBNF23lbvxFUYmuTyVAHz3WYq3gu/OcirSZO5JKuzWT4o/lfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259067; c=relaxed/simple;
	bh=59fp3TiPpm+si3cH4ebR8rQ3q3/+MjvO4jF/33B9kP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfNCH+HPmHn5uGGTnpiAxy1eDGcGWPKGI3CsWYbCEJXNpjt9qhFNhriXuu91mLaQaixknqCd74Wwn/BGMPNzYLmBI1FiXQbgpd+rOeEHSOwZl2yTX/WIFfy9fpD3hr/6Kv8vcVxgCaRUjoX/l0Hj5b1913D//fJlM1PGgn5Eyrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBe3vK/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBe3vK/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E8B1F000C4;
	Sat, 17 Oct 2026 17:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259066;
	bh=w0rtmSTKK0gJSuV8EaXDOufnA/WXrQjuvclx4JKxRNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBe3vK/EGbg6UIPXd58zD9qjN/srWmNx72ZNF9xeB/BHoKvhctxB6+02gPVpE6sJZ
	 LypEAmJhE8ynEmE9ie+QkhrB+DkxEDzT/PLIrWTitWPQNvgGEQW6t/9iVqJYwq4KTK
	 gbrTUxlNMOCY6EosAWh6f+S5TIZqJpvdZROdFRiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1090/1674] pds_core: Clean up init/uninit flows to be more readable
Date: Sat, 17 Oct 2026 17:56:02 +0200
Message-ID: <20261017160459.110666307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 792d36ccc163ac4aa606b3f5ec31cfd2c3a365de ]

The setup and teardown flows are somewhat hard to follow regarding
pdsc_core_init()/pdsc_dev_init() and their corresponding teardown
flows being in pdsc_teardown(). Improve the readability by adding
new pdsc_core_uninit()/pdsc_dev_unint() functions that mirror their
init counterparts. Also, move the notify and admin qcq allocations
into pdsc_core_init(), so they can be freed in pdsc_core_uninit().

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 0ad134881508 ("pds_core: fix use-after-free on workqueue during remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 81 ++++++++++++------------
 drivers/net/ethernet/amd/pds_core/core.h |  1 +
 drivers/net/ethernet/amd/pds_core/dev.c  | 16 +++++
 3 files changed, 58 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 8a9519e36de14..89e27f8b90f74 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -305,6 +305,17 @@ int pdsc_qcq_alloc(struct pdsc *pdsc, unsigned int type, unsigned int index,
 	return err;
 }
 
+static void pdsc_core_uninit(struct pdsc *pdsc)
+{
+	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
+	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
+
+	if (pdsc->kern_dbpage) {
+		iounmap(pdsc->kern_dbpage);
+		pdsc->kern_dbpage = NULL;
+	}
+}
+
 static int pdsc_core_init(struct pdsc *pdsc)
 {
 	union pds_core_dev_comp comp = {};
@@ -315,9 +326,29 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	struct pds_core_dev_init_data_in cidi;
 	u32 dbid_count;
 	u32 dbpage_num;
+	int numdescs;
 	size_t sz;
 	int err;
 
+	numdescs = PDSC_ADMINQ_MAX_LENGTH;
+	err = pdsc_qcq_alloc(pdsc, PDS_CORE_QTYPE_ADMINQ, 0, "adminq",
+			     PDS_CORE_QCQ_F_CORE | PDS_CORE_QCQ_F_INTR,
+			     numdescs,
+			     sizeof(union pds_core_adminq_cmd),
+			     sizeof(union pds_core_adminq_comp),
+			     0, &pdsc->adminqcq);
+	if (err)
+		return err;
+
+	err = pdsc_qcq_alloc(pdsc, PDS_CORE_QTYPE_NOTIFYQ, 0, "notifyq",
+			     PDS_CORE_QCQ_F_NOTIFYQ,
+			     PDSC_NOTIFYQ_LENGTH,
+			     sizeof(struct pds_core_notifyq_cmd),
+			     sizeof(union pds_core_notifyq_comp),
+			     0, &pdsc->notifyqcq);
+	if (err)
+		goto err_out_uninit;
+
 	cidi.adminq_q_base = cpu_to_le64(pdsc->adminqcq.q_base_pa);
 	cidi.adminq_cq_base = cpu_to_le64(pdsc->adminqcq.cq_base_pa);
 	cidi.notifyq_cq_base = cpu_to_le64(pdsc->notifyqcq.cq.base_pa);
@@ -341,7 +372,7 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	if (err) {
 		dev_err(pdsc->dev, "Device init command failed: %pe\n",
 			ERR_PTR(err));
-		return err;
+		goto err_out_uninit;
 	}
 
 	pdsc->hw_index = le32_to_cpu(cido.core_hw_index);
@@ -351,7 +382,8 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	pdsc->kern_dbpage = pdsc_map_dbpage(pdsc, dbpage_num);
 	if (!pdsc->kern_dbpage) {
 		dev_err(pdsc->dev, "Cannot map dbpage, aborting\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_out_uninit;
 	}
 
 	pdsc->adminqcq.q.hw_type = cido.adminq_hw_type;
@@ -364,6 +396,10 @@ static int pdsc_core_init(struct pdsc *pdsc)
 
 	pdsc->last_eid = 0;
 
+	return 0;
+
+err_out_uninit:
+	pdsc_core_uninit(pdsc);
 	return err;
 }
 
@@ -406,32 +442,12 @@ static int pdsc_viftypes_init(struct pdsc *pdsc)
 
 int pdsc_setup(struct pdsc *pdsc, bool init)
 {
-	int numdescs;
 	int err;
 
 	err = pdsc_dev_init(pdsc);
 	if (err)
 		return err;
 
-	numdescs = PDSC_ADMINQ_MAX_LENGTH;
-	err = pdsc_qcq_alloc(pdsc, PDS_CORE_QTYPE_ADMINQ, 0, "adminq",
-			     PDS_CORE_QCQ_F_CORE | PDS_CORE_QCQ_F_INTR,
-			     numdescs,
-			     sizeof(union pds_core_adminq_cmd),
-			     sizeof(union pds_core_adminq_comp),
-			     0, &pdsc->adminqcq);
-	if (err)
-		goto err_out_teardown;
-
-	err = pdsc_qcq_alloc(pdsc, PDS_CORE_QTYPE_NOTIFYQ, 0, "notifyq",
-			     PDS_CORE_QCQ_F_NOTIFYQ,
-			     PDSC_NOTIFYQ_LENGTH,
-			     sizeof(struct pds_core_notifyq_cmd),
-			     sizeof(union pds_core_notifyq_comp),
-			     0, &pdsc->notifyqcq);
-	if (err)
-		goto err_out_teardown;
-
 	/* Set up the Core with the AdminQ and NotifyQ info */
 	err = pdsc_core_init(pdsc);
 	if (err)
@@ -456,33 +472,18 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 
 void pdsc_teardown(struct pdsc *pdsc, bool removing)
 {
-	int i;
-
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
 	if (pdsc->adminqcq.work.func)
 		cancel_work_sync(&pdsc->adminqcq.work);
-	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
-	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
+
+	pdsc_core_uninit(pdsc);
 
 	kfree(pdsc->viftype_status);
 	pdsc->viftype_status = NULL;
 
-	if (pdsc->intr_info) {
-		for (i = 0; i < pdsc->nintrs; i++)
-			pdsc_intr_free(pdsc, i);
-
-		kfree(pdsc->intr_info);
-		pdsc->intr_info = NULL;
-		pdsc->nintrs = 0;
-	}
-
-	if (pdsc->kern_dbpage) {
-		iounmap(pdsc->kern_dbpage);
-		pdsc->kern_dbpage = NULL;
-	}
+	pdsc_dev_uninit(pdsc);
 
-	pci_free_irq_vectors(pdsc->pdev);
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
 }
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 4213714085031..b61d7c5afda19 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -282,6 +282,7 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 int pdsc_devcmd_init(struct pdsc *pdsc);
 int pdsc_devcmd_reset(struct pdsc *pdsc);
 int pdsc_dev_init(struct pdsc *pdsc);
+void pdsc_dev_uninit(struct pdsc *pdsc);
 
 int pdsc_intr_alloc(struct pdsc *pdsc, char *name,
 		    irq_handler_t handler, void *data);
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 0e9398503a04d..68f44c4a4c42c 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -323,6 +323,22 @@ static int pdsc_identify(struct pdsc *pdsc)
 	return 0;
 }
 
+void pdsc_dev_uninit(struct pdsc *pdsc)
+{
+	if (pdsc->intr_info) {
+		int i;
+
+		for (i = 0; i < pdsc->nintrs; i++)
+			pdsc_intr_free(pdsc, i);
+
+		kfree(pdsc->intr_info);
+		pdsc->intr_info = NULL;
+		pdsc->nintrs = 0;
+	}
+
+	pci_free_irq_vectors(pdsc->pdev);
+}
+
 int pdsc_dev_init(struct pdsc *pdsc)
 {
 	unsigned int nintrs;
-- 
2.53.0



