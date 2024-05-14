Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A6513E3FE;
	Tue, 14 May 2024 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683537; cv=none; b=tcNJB4dRBA8KNUxBDjTlsE66n3bIrvOHvtxwZII5nK+7FL/mz8r45rWmvhNli+WuG1cg5Eha2hNex1Ej9MfhcYkUixFj8L0nKnBE9S5VpdfXJOdioXYwl0YAMhCQeX++k+mv1ROV3NscTCuSnDA5/JSLed5hFyMuiI7NyiJ3AFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683537; c=relaxed/simple;
	bh=1nDvjBuNLfwmeF4+vzCFP2o1UxfO2GD2mKFUUyNsB1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL47WF70E9pxnUA583KMR3C6zjdd2m/zVG9nuACnlEIexQph0WL8XsX8Baa5c4bdyR2fRw85E6GY5ZR3jLF+sUqboCbfm4acj2GWlvSJqFlSeTwwQmEfmlFS6A+prQULYsyV7YAgZ+ex6A9d1+evqv9DNZENEEz70H+hSZph5tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8mVoJ/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8mVoJ/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F93CC32782;
	Tue, 14 May 2024 10:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683537;
	bh=1nDvjBuNLfwmeF4+vzCFP2o1UxfO2GD2mKFUUyNsB1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8mVoJ/sKUPKv5wSCJy3WFZU9PmUmNn+o16OYzMEzybKyk2cvWystBn2TI6c2UNp6
	 vdNsMDl4aAO3k5YVIMp/aeMGTNALIiCAmLvxeQgMkkpGCxBYB0T4keH3wqDnQLm3hm
	 IoKS0EKaL3EJkpLdQHiEbYU4w9dNRscKpNN8Xj94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 232/336] net: hns3: fix kernel crash when devlink reload during initialization
Date: Tue, 14 May 2024 12:17:16 +0200
Message-ID: <20240514101047.374444904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 35d92abfbad88cf947c010baf34b075e40566095 ]

The devlink reload process will access the hardware resources,
but the register operation is done before the hardware is initialized.
So, processing the devlink reload during initialization may lead to kernel
crash.

This patch fixes this by registering the devlink after
hardware initialization.

Fixes: cd6242991d2e ("net: hns3: add support for registering devlink for VF")
Fixes: 93305b77ffcb ("net: hns3: fix kernel crash when devlink reload during pf initialization")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 17 +++++------------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c        | 10 ++++------
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 012e281f65a56..c55b5430b75a9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11618,16 +11618,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto out;
 
-	ret = hclge_devlink_init(hdev);
-	if (ret)
-		goto err_pci_uninit;
-
-	devl_lock(hdev->devlink);
-
 	/* Firmware command queue initialize */
 	ret = hclge_comm_cmd_queue_init(hdev->pdev, &hdev->hw.hw);
 	if (ret)
-		goto err_devlink_uninit;
+		goto err_pci_uninit;
 
 	/* Firmware command initialize */
 	ret = hclge_comm_cmd_init(hdev->ae_dev, &hdev->hw.hw, &hdev->fw_version,
@@ -11795,6 +11789,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		dev_warn(&pdev->dev,
 			 "failed to wake on lan init, ret = %d\n", ret);
 
+	ret = hclge_devlink_init(hdev);
+	if (ret)
+		goto err_ptp_uninit;
+
 	hclge_state_init(hdev);
 	hdev->last_reset_time = jiffies;
 
@@ -11802,8 +11800,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		 HCLGE_DRIVER_NAME);
 
 	hclge_task_schedule(hdev, round_jiffies_relative(HZ));
-
-	devl_unlock(hdev->devlink);
 	return 0;
 
 err_ptp_uninit:
@@ -11817,9 +11813,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	pci_free_irq_vectors(pdev);
 err_cmd_uninit:
 	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
-err_devlink_uninit:
-	devl_unlock(hdev->devlink);
-	hclge_devlink_uninit(hdev);
 err_pci_uninit:
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 08db8e84be4ed..43ee20eb03d1f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2845,10 +2845,6 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclgevf_devlink_init(hdev);
-	if (ret)
-		goto err_devlink_init;
-
 	ret = hclge_comm_cmd_queue_init(hdev->pdev, &hdev->hw.hw);
 	if (ret)
 		goto err_cmd_queue_init;
@@ -2941,6 +2937,10 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 
 	hclgevf_init_rxd_adv_layout(hdev);
 
+	ret = hclgevf_devlink_init(hdev);
+	if (ret)
+		goto err_config;
+
 	set_bit(HCLGEVF_STATE_SERVICE_INITED, &hdev->state);
 
 	hdev->last_reset_time = jiffies;
@@ -2960,8 +2960,6 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 err_cmd_init:
 	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
 err_cmd_queue_init:
-	hclgevf_devlink_uninit(hdev);
-err_devlink_init:
 	hclgevf_pci_uninit(hdev);
 	clear_bit(HCLGEVF_STATE_IRQ_INITED, &hdev->state);
 	return ret;
-- 
2.43.0



