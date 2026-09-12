Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217EA2FFDEA;
	Sat, 12 Sep 2026 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223146; cv=none; b=gptgGny/l3/q2jNfdc5e1SqSPk5tQqUUvCu0mCZJzSnKgcznyPxSy2I9bP5x/6J0D6eQEervOMCp4Lur5uLow0KjfxPd2sgAdrkMNQc0Fxlkk0LvKAfX07PxqqDo0EQg0Xcdpr03QS2wudS1OTc5WDxcFBYFZtwYZlvkKFuIoT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223146; c=relaxed/simple;
	bh=CdFUGFxs/vuvyhvWQwReEBSFfnNEOMAnaxAJ73vAFls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvmEZYVdCpK6zgGxQvBfItCwMYTMDTZzyEbIKeNB4ThT2klWOLBYn0wCQOVX66ZSztRUZifXPH6ZYr7GIBXJhGdBo0iYeMjsODATvBwz1w9XdIb8/3NHm+sR6uxwvrVL7k9l779iP94lkBtPQFuSH8ZAnF13fMKOjeKSBwH0GSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnajSVnY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnajSVnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF7B1F000FF;
	Sat, 12 Sep 2026 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223145;
	bh=rvRqJeHKQb+J229edZRhf9yC6EVH5x0iwCdt8lnUIyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnajSVnY9at+YDH4xHx/ZdWwfENfmm/KlOr9wm7Rv1u+6ULxtRtj5pE1UOh8hJEmJ
	 bE8K3qXS3z4ky3zkWRJ2mtafAcZvLpBuib6Q2XOFghu5xTpTATE5ZkQlUgjcsh0LRV
	 Hi6ihQbhFvfp2f7zbDY17O9mzOLFmQ2DR0PTs9JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0731/1424] RDMA/hfi1: Create workqueues before device initialization
Date: Sat, 12 Sep 2026 08:52:43 +0200
Message-ID: <20260912065623.663340054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

[ Upstream commit 0d5618c1b2fc9dd4fc086f0226acd8a077ab6c1b ]

create_workqueues() only needs fields set up by hfi1_alloc_devdata().
Call it before hfi1_init_dd() so a workqueue allocation failure happens
before chip resources are initialized.

To keep the reordered error paths safe, make init_one() own hfi1_devdata.
hfi1_init_dd() unwinds its partial setup but leaves the allocation for the
caller to free. If device initialization fails, destroy the workqueues
before freeing the device data.

Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-6-b9e9641268a5@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Stable-dep-of: 9f674ba674a0 ("RDMA/hfi1: Allocate device data after PCI initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c |  4 +---
 drivers/infiniband/hw/hfi1/hfi.h  |  2 --
 drivers/infiniband/hw/hfi1/init.c | 19 ++++++++++---------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 9b542f7c6c115..00a054007822f 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -15065,7 +15065,7 @@ int hfi1_init_dd(struct hfi1_devdata *dd)
 	 */
 	ret = hfi1_pcie_ddinit(dd, pdev);
 	if (ret < 0)
-		goto bail_free;
+		goto bail;
 
 	/* Save PCI space registers to rewrite after device reset */
 	ret = save_pci_variables(dd);
@@ -15320,8 +15320,6 @@ int hfi1_init_dd(struct hfi1_devdata *dd)
 bail_cleanup:
 	hfi1_free_rx(dd);
 	hfi1_pcie_ddcleanup(dd);
-bail_free:
-	hfi1_free_devdata(dd);
 bail:
 	return ret;
 }
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 38772e52d7edb..14d01f7af1189 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -2044,9 +2044,7 @@ struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
 		/* waiting for an urgent packet to arrive */
 #define HFI1_CTXT_WAITING_URG 4
 
-/* free up any allocated data at closes */
 int hfi1_init_dd(struct hfi1_devdata *dd);
-void hfi1_free_devdata(struct hfi1_devdata *dd);
 
 /* LED beaconing functions */
 void hfi1_start_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 2f5319f9d2990..6590b66260841 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -630,8 +630,6 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 	ppd->sm_trap_qp = 0x0;
 	ppd->sa_qp = 0x1;
 
-	ppd->hfi1_wq = NULL;
-
 	spin_lock_init(&ppd->cca_timer_lock);
 
 	for (i = 0; i < OPA_MAX_SLS; i++) {
@@ -1165,7 +1163,7 @@ static void finalize_asic_data(struct hfi1_devdata *dd,
  * It cleans up and frees all data structures set up by
  * by hfi1_alloc_devdata().
  */
-void hfi1_free_devdata(struct hfi1_devdata *dd)
+static void hfi1_free_devdata(struct hfi1_devdata *dd)
 {
 	struct hfi1_asic_data *ad;
 	unsigned long flags;
@@ -1617,17 +1615,17 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto bail;
 
+	ret = create_workqueues(dd);
+	if (ret)
+		goto free_devdata;
+
 	/*
 	 * Do device-specific initialization, function table setup, dd
 	 * allocation, etc.
 	 */
 	ret = hfi1_init_dd(dd);
 	if (ret)
-		goto clean_bail; /* error already printed */
-
-	ret = create_workqueues(dd);
-	if (ret)
-		goto clean_bail;
+		goto destroy_workqueues; /* error already printed */
 
 	/* do the generic initialization */
 	initfail = hfi1_init(dd, 0);
@@ -1681,7 +1679,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-clean_bail:
+destroy_workqueues:
+	destroy_workqueues(dd);
+free_devdata:
+	hfi1_free_devdata(dd);
 	hfi1_pcie_cleanup(pdev);
 bail:
 	return ret;
-- 
2.53.0



