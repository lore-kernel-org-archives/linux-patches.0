Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5BD2E62C;
	Mon,  8 Apr 2024 13:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581668; cv=none; b=H4hyCiIQtwZ4VZYSpKsJnUJaIo3j6kUTCkygYG2nkHVB26NFy3XIWXWSb5m/rw001Pm0UUl8BjL1hkuAvxczGZFlAVs6M0BealXaqCTTyoTvreOCfL3KSW8eq4Oe4Nkn8V4/JNLSE9E2yxa+wUtCDJiArAiyzt0D4qDn/YSEAiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581668; c=relaxed/simple;
	bh=C5DT4ZHjDoTyaln/6BypSt0BBqVIzFcV3mSVpiXjgL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQWR9potoOOaeO896klpInDOVqTufxQ6P7lEFC0o74uBTr3Nw83Xv2EPMOdGC4LxQfLZFT4GzRCP9AVuFspgHTAapcWMOoUP6R1kLINwCCSIoErXHzgIqNllv7SQ5UMp8LnsnKsEvzrfbh4vJ342PxTYniiA1rcG5Ant4mDBcbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msYwchVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msYwchVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A96C433F1;
	Mon,  8 Apr 2024 13:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581668;
	bh=C5DT4ZHjDoTyaln/6BypSt0BBqVIzFcV3mSVpiXjgL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msYwchVwkWg2D8V74p7X+QhhKHE+m2c3W7d3bh8kUBJ2wfDjps3slTIVfM+WLsbRv
	 Xl8Yo7JuSdwY9C03EfEfkM68l2Cd0DHjSX8RGuozlp4+HZ3NM6/02uUU9Cjv0BE/3p
	 s+vasHm9etfBsSZKpTvNaZtvbTr6PrF5mM/BhYMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/252] net: hns3: fix kernel crash when devlink reload during pf initialization
Date: Mon,  8 Apr 2024 14:55:26 +0200
Message-ID: <20240408125307.492090455@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
index f1ca2cda2961e..dfd0c5f4cb9f5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11614,6 +11614,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_pci_uninit;
 
+	devl_lock(hdev->devlink);
+
 	/* Firmware command queue initialize */
 	ret = hclge_comm_cmd_queue_init(hdev->pdev, &hdev->hw.hw);
 	if (ret)
@@ -11793,6 +11795,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_task_schedule(hdev, round_jiffies_relative(HZ));
 
+	devl_unlock(hdev->devlink);
 	return 0;
 
 err_mdiobus_unreg:
@@ -11805,6 +11808,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 err_cmd_uninit:
 	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
 err_devlink_uninit:
+	devl_unlock(hdev->devlink);
 	hclge_devlink_uninit(hdev);
 err_pci_uninit:
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
-- 
2.43.0



