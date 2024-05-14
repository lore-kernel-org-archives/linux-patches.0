Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E87C2B9B3;
	Tue, 14 May 2024 11:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686541; cv=none; b=oZqj6tLhvG+DoUMKp1UGVxrQxR3CyuACnqfIFCyukPY7Axu3w3AWzVyNgwsQ2VCMJ4bm+pNEmn29uEkhMqcdtiPrh9IH97UmiRN4UgyUO/QvqFDqZYoxzPm0hTJMq64hJorqdQCp3x9YvGeaK+urGsDDzgmrIONYGVYLgTdRxqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686541; c=relaxed/simple;
	bh=rXyQDx9okTgPfQYIt28T/IfPr0zzZZYkHUUrce/LrKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfeU6K3EttmJ5SeZu9JA8IYQYsjQEWREOFVnHTQkxIpwwRtvPJ4Ai7/R/Uu97WRilB4jZtVGX29aGCPvdUPTZVP/jMgFx9OmB+3uAMfZFPhpp8XfgQf11A6ors6WPQ5IO305uB2nslVmvjY70hQKbuVddgnPygfockMhSu6oWjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoxY8v6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoxY8v6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B816AC2BD10;
	Tue, 14 May 2024 11:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686541;
	bh=rXyQDx9okTgPfQYIt28T/IfPr0zzZZYkHUUrce/LrKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoxY8v6KqEAmH/yxxC3VpnMXc2gU0k6NsIX+GvciwAXBa4SL+mmb9ohQ9KPUDQ8vI
	 iy9eQjPf1/uYHBcqPqChXAsY6CPdakCxZVYbZAzFIN6QejLij7MzsTnLSCVjqhhpth
	 ep+LbJfrxSusPP4PLr19LfMJGk/VM7JXbTY6QsLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/236] net: hns3: fix kernel crash when devlink reload during initialization
Date: Tue, 14 May 2024 12:18:55 +0200
Message-ID: <20240514101026.931533180@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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
index a18dc73c69894..a2655adc764cd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11609,16 +11609,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
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
@@ -11781,6 +11775,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
 
+	ret = hclge_devlink_init(hdev);
+	if (ret)
+		goto err_ptp_uninit;
+
 	hclge_state_init(hdev);
 	hdev->last_reset_time = jiffies;
 
@@ -11788,8 +11786,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		 HCLGE_DRIVER_NAME);
 
 	hclge_task_schedule(hdev, round_jiffies_relative(HZ));
-
-	devl_unlock(hdev->devlink);
 	return 0;
 
 err_ptp_uninit:
@@ -11803,9 +11799,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	pci_free_irq_vectors(pdev);
 err_cmd_uninit:
 	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
-err_devlink_uninit:
-	devl_unlock(hdev->devlink);
-	hclge_devlink_uninit(hdev);
 err_pci_uninit:
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
 	pci_clear_master(pdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1ecf06345526b..1f5a27fb309aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2902,10 +2902,6 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclgevf_devlink_init(hdev);
-	if (ret)
-		goto err_devlink_init;
-
 	ret = hclge_comm_cmd_queue_init(hdev->pdev, &hdev->hw.hw);
 	if (ret)
 		goto err_cmd_queue_init;
@@ -2998,6 +2994,10 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 
 	hclgevf_init_rxd_adv_layout(hdev);
 
+	ret = hclgevf_devlink_init(hdev);
+	if (ret)
+		goto err_config;
+
 	set_bit(HCLGEVF_STATE_SERVICE_INITED, &hdev->state);
 
 	hdev->last_reset_time = jiffies;
@@ -3017,8 +3017,6 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
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



