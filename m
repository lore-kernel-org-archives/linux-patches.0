Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A90CDDAB;
	Tue, 11 Nov 2025 01:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825165; cv=none; b=BNlVbh9nE/duBklcWpNkYFd0diYFaFMvYtRcoxy/bWCLWdR+4w/F+YdT1jRbm9dC4YSVfC46fh0cOItXCWnoxfXh6Z/1Tni1mS++6QHgrKEHCwfaL4t2hU4wg18rBV5ytKwmLQc0myQxxuJ+4lrawgu+Pzu5ultAONiJXvClPu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825165; c=relaxed/simple;
	bh=UHkzwCyYOh2BnG7bOW3AfYss0cwA3ft/KKfByTeWb3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfL87RuyRUOQYzOLcfCa1gpyjymnEckpJ2Pkm73pI1yZJxko1F7uobRm12DcMNmEyFLexT6G5YykOgnqhHoOsGvpBEv7UOIl7mpHbsjN/9TymWC8xTi4k7sw5kkQVhrgcuNvMtlB1JBrTiax4S09T8bV+vUQWJwphDopaVXL01k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrVNVW7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrVNVW7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306B8C4CEFB;
	Tue, 11 Nov 2025 01:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825165;
	bh=UHkzwCyYOh2BnG7bOW3AfYss0cwA3ft/KKfByTeWb3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrVNVW7vSSqmGukf4XWMIEby+MMGM+IZHKa49oKTtHZCTq4JpxoqdWMyjD+rV/tim
	 +8gsI0ATwlL+37fTSdm216OgofFQpo1Zw3kuAJWXwUwykWbeHARKOZuEnjy5SbNsFc
	 TZAOGmDXs4+vgPIZHtRtkSTH4z59k58YcFCSQb6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 688/849] RDMA/hns: Fix recv CQ and QP cache affinity
Date: Tue, 11 Nov 2025 09:44:18 +0900
Message-ID: <20251111004553.060883759@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit c4b67b514af8c2d73c64b36e0cd99e9b26b9ac82 ]

Currently driver enforces affinity between QP cache and send CQ
cache, which helps improve the performance of sending, but doesn't
set affinity with recv CQ cache, resulting in suboptimal performance
of receiving.

Use one CQ bank per context to ensure the affinity among QP, send CQ
and recv CQ. For kernel ULP, CQ bank is fixed to 0.

Fixes: 9e03dbea2b06 ("RDMA/hns: Fix CQ and QP cache affinity")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20251016114051.1963197-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 58 +++++++++++++++++++--
 drivers/infiniband/hw/hns/hns_roce_device.h |  4 ++
 drivers/infiniband/hw/hns/hns_roce_main.c   |  4 ++
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 3a5c93c9fb3e6..6aa82fe9dd3df 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/pci.h>
 #include <rdma/ib_umem.h>
 #include <rdma/uverbs_ioctl.h>
 #include "hns_roce_device.h"
@@ -37,6 +38,43 @@
 #include "hns_roce_hem.h"
 #include "hns_roce_common.h"
 
+void hns_roce_put_cq_bankid_for_uctx(struct hns_roce_ucontext *uctx)
+{
+	struct hns_roce_dev *hr_dev = to_hr_dev(uctx->ibucontext.device);
+	struct hns_roce_cq_table *cq_table = &hr_dev->cq_table;
+
+	if (hr_dev->pci_dev->revision < PCI_REVISION_ID_HIP09)
+		return;
+
+	mutex_lock(&cq_table->bank_mutex);
+	cq_table->ctx_num[uctx->cq_bank_id]--;
+	mutex_unlock(&cq_table->bank_mutex);
+}
+
+void hns_roce_get_cq_bankid_for_uctx(struct hns_roce_ucontext *uctx)
+{
+	struct hns_roce_dev *hr_dev = to_hr_dev(uctx->ibucontext.device);
+	struct hns_roce_cq_table *cq_table = &hr_dev->cq_table;
+	u32 least_load = cq_table->ctx_num[0];
+	u8 bankid = 0;
+	u8 i;
+
+	if (hr_dev->pci_dev->revision < PCI_REVISION_ID_HIP09)
+		return;
+
+	mutex_lock(&cq_table->bank_mutex);
+	for (i = 1; i < HNS_ROCE_CQ_BANK_NUM; i++) {
+		if (cq_table->ctx_num[i] < least_load) {
+			least_load = cq_table->ctx_num[i];
+			bankid = i;
+		}
+	}
+	cq_table->ctx_num[bankid]++;
+	mutex_unlock(&cq_table->bank_mutex);
+
+	uctx->cq_bank_id = bankid;
+}
+
 static u8 get_least_load_bankid_for_cq(struct hns_roce_bank *bank)
 {
 	u32 least_load = bank[0].inuse;
@@ -55,7 +93,21 @@ static u8 get_least_load_bankid_for_cq(struct hns_roce_bank *bank)
 	return bankid;
 }
 
-static int alloc_cqn(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
+static u8 select_cq_bankid(struct hns_roce_dev *hr_dev,
+			   struct hns_roce_bank *bank, struct ib_udata *udata)
+{
+	struct hns_roce_ucontext *uctx = udata ?
+		rdma_udata_to_drv_context(udata, struct hns_roce_ucontext,
+					  ibucontext) : NULL;
+
+	if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
+		return uctx ? uctx->cq_bank_id : 0;
+
+	return get_least_load_bankid_for_cq(bank);
+}
+
+static int alloc_cqn(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
+		     struct ib_udata *udata)
 {
 	struct hns_roce_cq_table *cq_table = &hr_dev->cq_table;
 	struct hns_roce_bank *bank;
@@ -63,7 +115,7 @@ static int alloc_cqn(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 	int id;
 
 	mutex_lock(&cq_table->bank_mutex);
-	bankid = get_least_load_bankid_for_cq(cq_table->bank);
+	bankid = select_cq_bankid(hr_dev, cq_table->bank, udata);
 	bank = &cq_table->bank[bankid];
 
 	id = ida_alloc_range(&bank->ida, bank->min, bank->max, GFP_KERNEL);
@@ -396,7 +448,7 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 		goto err_cq_buf;
 	}
 
-	ret = alloc_cqn(hr_dev, hr_cq);
+	ret = alloc_cqn(hr_dev, hr_cq, udata);
 	if (ret) {
 		ibdev_err(ibdev, "failed to alloc CQN, ret = %d.\n", ret);
 		goto err_cq_db;
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 78ee04a48a74a..06832c0ac0556 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -217,6 +217,7 @@ struct hns_roce_ucontext {
 	struct mutex		page_mutex;
 	struct hns_user_mmap_entry *db_mmap_entry;
 	u32			config;
+	u8 cq_bank_id;
 };
 
 struct hns_roce_pd {
@@ -495,6 +496,7 @@ struct hns_roce_cq_table {
 	struct hns_roce_hem_table	table;
 	struct hns_roce_bank bank[HNS_ROCE_CQ_BANK_NUM];
 	struct mutex			bank_mutex;
+	u32 ctx_num[HNS_ROCE_CQ_BANK_NUM];
 };
 
 struct hns_roce_srq_table {
@@ -1305,5 +1307,7 @@ hns_roce_user_mmap_entry_insert(struct ib_ucontext *ucontext, u64 address,
 				size_t length,
 				enum hns_roce_mmap_type mmap_type);
 bool check_sl_valid(struct hns_roce_dev *hr_dev, u8 sl);
+void hns_roce_put_cq_bankid_for_uctx(struct hns_roce_ucontext *uctx);
+void hns_roce_get_cq_bankid_for_uctx(struct hns_roce_ucontext *uctx);
 
 #endif /* _HNS_ROCE_DEVICE_H */
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index d50f36f8a1107..f3607fe107a7f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -425,6 +425,8 @@ static int hns_roce_alloc_ucontext(struct ib_ucontext *uctx,
 	if (ret)
 		goto error_fail_copy_to_udata;
 
+	hns_roce_get_cq_bankid_for_uctx(context);
+
 	return 0;
 
 error_fail_copy_to_udata:
@@ -447,6 +449,8 @@ static void hns_roce_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	struct hns_roce_ucontext *context = to_hr_ucontext(ibcontext);
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibcontext->device);
 
+	hns_roce_put_cq_bankid_for_uctx(context);
+
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_CQ_RECORD_DB ||
 	    hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB)
 		mutex_destroy(&context->page_mutex);
-- 
2.51.0



