Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8373A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVYUuPsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F784C433C8;
	Wed, 15 Nov 2023 19:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077569;
	bh=KIp+Fk340Gj4o37V8TziSaH+ti5MZN7kz1BOmAVY9nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVYUuPsjLD6ZMLlQi162gCEeC26aMjVoQ8YIi0uXBoaNdynPKD7up0PaIZjyoA7kL
	 twWPiJ2EkusjwhVZQGRB6cwMhrsTqkgyrFbWUaLdVxXBOmtfpcudMyFAF7WFJB1OT0
	 lsqzxhaVBmtaLJksu5Qe1YhAgCZy9MWW3arZNHP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 383/603] RDMA/hns: Fix init failure of RoCE VF and HIP08
Date: Wed, 15 Nov 2023 14:15:28 -0500
Message-ID: <20231115191639.814069434@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 07f06e0e5cd99555c861e874716d9e2627655fd5 ]

During device init, a struct for HW stats will be allocated. As HW
stats are not supported for VF and HIP08, currently
hns_roce_alloc_hw_port_stats() returns NULL in this case. However,
ib-core considers the returned NULL pointer as memory allocation
failure and returns ENOMEM, eventually leading to the failure of VF
and HIP08 init.

In the case where the driver does not support the .alloc_hw_port_stats()
ops, ib-core will return EOPNOTSUPP and ignore this error code in the
upper layer function. So for VF and HIP08, just don't set the HW stats
ops to ib-core.

Fixes: 5a87279591a1 ("RDMA/hns: Support hns HW stats")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231017125239.164455-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index e1a88f2d51b6c..4a9cd4d21bc99 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -553,10 +553,6 @@ static struct rdma_hw_stats *hns_roce_alloc_hw_port_stats(
 		return NULL;
 	}
 
-	if (hr_dev->pci_dev->revision <= PCI_REVISION_ID_HIP08 ||
-	    hr_dev->is_vf)
-		return NULL;
-
 	return rdma_alloc_hw_stats_struct(hns_roce_port_stats_descs,
 					  ARRAY_SIZE(hns_roce_port_stats_descs),
 					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
@@ -576,10 +572,6 @@ static int hns_roce_get_hw_stats(struct ib_device *device,
 	if (port > hr_dev->caps.num_ports)
 		return -EINVAL;
 
-	if (hr_dev->pci_dev->revision <= PCI_REVISION_ID_HIP08 ||
-	    hr_dev->is_vf)
-		return -EOPNOTSUPP;
-
 	ret = hr_dev->hw->query_hw_counter(hr_dev, stats->value, port,
 					   &num_counters);
 	if (ret) {
@@ -633,8 +625,6 @@ static const struct ib_device_ops hns_roce_dev_ops = {
 	.query_pkey = hns_roce_query_pkey,
 	.query_port = hns_roce_query_port,
 	.reg_user_mr = hns_roce_reg_user_mr,
-	.alloc_hw_port_stats = hns_roce_alloc_hw_port_stats,
-	.get_hw_stats = hns_roce_get_hw_stats,
 
 	INIT_RDMA_OBJ_SIZE(ib_ah, hns_roce_ah, ibah),
 	INIT_RDMA_OBJ_SIZE(ib_cq, hns_roce_cq, ib_cq),
@@ -643,6 +633,11 @@ static const struct ib_device_ops hns_roce_dev_ops = {
 	INIT_RDMA_OBJ_SIZE(ib_ucontext, hns_roce_ucontext, ibucontext),
 };
 
+static const struct ib_device_ops hns_roce_dev_hw_stats_ops = {
+	.alloc_hw_port_stats = hns_roce_alloc_hw_port_stats,
+	.get_hw_stats = hns_roce_get_hw_stats,
+};
+
 static const struct ib_device_ops hns_roce_dev_mr_ops = {
 	.rereg_user_mr = hns_roce_rereg_user_mr,
 };
@@ -719,6 +714,10 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_XRC)
 		ib_set_device_ops(ib_dev, &hns_roce_dev_xrcd_ops);
 
+	if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09 &&
+	    !hr_dev->is_vf)
+		ib_set_device_ops(ib_dev, &hns_roce_dev_hw_stats_ops);
+
 	ib_set_device_ops(ib_dev, hr_dev->hw->hns_roce_dev_ops);
 	ib_set_device_ops(ib_dev, &hns_roce_dev_ops);
 	ib_set_device_ops(ib_dev, &hns_roce_dev_restrack_ops);
-- 
2.42.0



