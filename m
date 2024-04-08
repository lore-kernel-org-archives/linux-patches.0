Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4CA2DF73;
	Mon,  8 Apr 2024 13:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581387; cv=none; b=ljdUNYLBZ7fagH1MgRkoxvPJLIb+wUsBOc/mEC8v70/ikd64ohKoEJWxCVbpArMI1NBMoiAqvNQ3hiRVoxG3KabbfqNwoeLGSq+6kV0USOo4YHRow9+OiTsb2JbHlFg99DntRZLwGTPoQie38dsT4ldSAaYGSbrkEcu/q9XQQnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581387; c=relaxed/simple;
	bh=tVQUDWk3Cg7WNVzCVscOskSCLDeWzC3zeKnRdbVJDRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hlxe4MmVw0ngIStiedjVnEJ78+CofMK6pgqK2BGzmjTOx0uuEE+Tskrp3qfO4dX2myfSCpOAdV2c2w0Rar9ISiZIdEC42jFmmwkk5PB0k+Z8vRGjTnE18hNppVfJ+XC+duGces72DPbO36fp8A6X2gyh1qXTulwEy2syCDoBxZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oksu0rCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oksu0rCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DAAC433C7;
	Mon,  8 Apr 2024 13:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581387;
	bh=tVQUDWk3Cg7WNVzCVscOskSCLDeWzC3zeKnRdbVJDRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oksu0rChcg3j2li9XA4LPM2eT4vsFpZmOEa50C4SCN9cHxVbulPwcKPFI2VaqTDUo
	 Ud+sLyu9Fa8L529bAQqZ4Toq3rnAMx0wRisn7wbFaPs1/nLUaUGREMEbrOdG2aohE+
	 0NbyloPQHuPYsaQulqDsTfUsQU3NGloNZq7D5eFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/138] net: hns3: fix kernel crash when devlink reload during pf initialization
Date: Mon,  8 Apr 2024 14:57:06 +0200
Message-ID: <20240408125256.610904716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
index 27037ce795902..9db363fbc34fd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11604,6 +11604,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_pci_uninit;
 
+	devl_lock(hdev->devlink);
+
 	/* Firmware command queue initialize */
 	ret = hclge_comm_cmd_queue_init(hdev->pdev, &hdev->hw.hw);
 	if (ret)
@@ -11778,6 +11780,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_task_schedule(hdev, round_jiffies_relative(HZ));
 
+	devl_unlock(hdev->devlink);
 	return 0;
 
 err_mdiobus_unreg:
@@ -11790,6 +11793,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 err_cmd_uninit:
 	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
 err_devlink_uninit:
+	devl_unlock(hdev->devlink);
 	hclge_devlink_uninit(hdev);
 err_pci_uninit:
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
-- 
2.43.0



