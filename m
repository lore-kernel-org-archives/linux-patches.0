Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B24D7E575;
	Mon,  8 Apr 2024 13:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581955; cv=none; b=B5MI46ggmjo+rjU3wkZzrHaTWYTwVKBf3fP1jkBAiGN1mlJI4cW887A2KCBzyL0h1kPogONdfZgw0B/QKIhWyctWBkuxT8FFC2TRQFig6MKX/HjAJ6UB4KuyDdn+nrRQyZtgSfsXtDoWGotGqBsUXA0oOKe9QHY4Ykx2FyJ5Hpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581955; c=relaxed/simple;
	bh=iogT51VmWM8z56Gkg/Q1yuwpsDQPVbyTojvtAfgEiNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5n/ZOZASXXL8duvsOUH/Sx3Cw8k5ydjTfDbfI9nfhG6z5jhlmiEW12KkzewaEWvdClt9vungcOPeeCr+l48yw0X//KNm52imbxleG9nhGMcr1OsP5bDJJ/oBTcCwC2pXsOtLWA3OpeNqx46zRkkWP1tVXDFXCH505eaSbDfFAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcRV9N4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcRV9N4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B707AC433F1;
	Mon,  8 Apr 2024 13:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581955;
	bh=iogT51VmWM8z56Gkg/Q1yuwpsDQPVbyTojvtAfgEiNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcRV9N4KCFH7PIk0Hhf1yOTMENpv174mJr62UskzE03W6i3+nm5HTvUodAl0dvR/E
	 mBptQOJf2fxd83k+2hIX7Ek/Vz2JCa/hiTdONb2+3MQeiPLMtabPTYcrP7H01p4ikq
	 HYXnOCJ8+SbgF4FO0lPGIUWQHerwXyb0lvbtek6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 035/273] net: hns3: fix kernel crash when devlink reload during pf initialization
Date: Mon,  8 Apr 2024 14:55:10 +0200
Message-ID: <20240408125310.385086086@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

[ Upstream commit 93305b77ffcb042f1538ecc383505e87d95aa05a ]

The devlink reload process will access the hardware resources,
but the register operation is done before the hardware is initialized.
So, processing the devlink reload during initialization may lead to kernel
crash. This patch fixes this by taking devl_lock during initialization.

Fixes: b741269b2759 ("net: hns3: add support for registering devlink for PF")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 609d3799d7738..a3b7723a97bb1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11613,6 +11613,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_pci_uninit;
 
+	devl_lock(hdev->devlink);
+
 	/* Firmware command queue initialize */
 	ret = hclge_comm_cmd_queue_init(hdev->pdev, &hdev->hw.hw);
 	if (ret)
@@ -11792,6 +11794,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_task_schedule(hdev, round_jiffies_relative(HZ));
 
+	devl_unlock(hdev->devlink);
 	return 0;
 
 err_mdiobus_unreg:
@@ -11804,6 +11807,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 err_cmd_uninit:
 	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
 err_devlink_uninit:
+	devl_unlock(hdev->devlink);
 	hclge_devlink_uninit(hdev);
 err_pci_uninit:
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
-- 
2.43.0



