Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A64718E5;
	Sat, 12 Sep 2026 12:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215435; cv=none; b=tiRe26ebWwXPXIexVKQn9gZsu6PE6/LVG3+SGCI5m1bmWQgC5shmoMcYZLwZSEYedrdhUGHI2OaC/b76mvswF4pxNxTP3V8Mz5cVFznO/cvuc0AY+Lzq6XMcskFH028o9qmjGQYqZbyeIf9X1DHn/gkNdcqk9SVFq/Jadkgwgc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215435; c=relaxed/simple;
	bh=xDzJjunQkFCfURarTL8jr1XhPhZwjveMsQz2pgDjX+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4V0TWsSuI4JQRvKqUyUBQBMZFrVlJk5VDXuig+V/l+pljSN0d8wAjhDLE0Ogf1EnRT+TPoqJG9qsZQDpBpRqEZM8FsgtZybBm07wYe06bFxx54D5SfkYkTlf1vKDL1V+YJL2P2ry6QNd1EtP2iGJmOn0/6cNdPotYL73//LmVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoyOzV5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoyOzV5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CEE1F000FF;
	Sat, 12 Sep 2026 12:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215433;
	bh=VoU57YqqQYZW99sIi2ommpuCxiLgHRwEG4Pjrv2Alug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SoyOzV5RNIuy5iT3Vh6fYZyr+wEEuXks0KJ02GtWN3iKBVNTIIodH9Cfs0xUo9Fwh
	 VpHXHHE6hFMMrOXd3k7i8+7JsjtdN5xHPisfLCYU2jDDZnA+UEbSPvHKB3QgDnHyRV
	 Jp7M+nW31GHlh0pVpSObSNybPie968j7lfEN/wag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0514/1376] RDMA/hfi1: Create workqueues before device initialization
Date: Sat, 12 Sep 2026 08:49:00 +0200
Message-ID: <20260912065618.994165607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c52e6b2c9914d..db96a7547fb7c 100644
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
index eb38f81aeeb1e..67df5c65c6e51 100644
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
index fc6c01d64050e..904a426115c54 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -630,8 +630,6 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 	ppd->sm_trap_qp = 0x0;
 	ppd->sa_qp = 0x1;
 
-	ppd->hfi1_wq = NULL;
-
 	spin_lock_init(&ppd->cca_timer_lock);
 
 	for (i = 0; i < OPA_MAX_SLS; i++) {
@@ -1164,7 +1162,7 @@ static void finalize_asic_data(struct hfi1_devdata *dd,
  * It cleans up and frees all data structures set up by
  * by hfi1_alloc_devdata().
  */
-void hfi1_free_devdata(struct hfi1_devdata *dd)
+static void hfi1_free_devdata(struct hfi1_devdata *dd)
 {
 	struct hfi1_asic_data *ad;
 	unsigned long flags;
@@ -1616,17 +1614,17 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -1680,7 +1678,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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



