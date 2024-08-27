Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AC51C825E;
	Tue, 27 Aug 2024 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772180; cv=none; b=hVVoF9JP3bP/hr6ATMgEZ3rrKc1WFzqtD35h7XByyOIZPskIa5d5hn7+JwgAQ/rYILOPAqBMlLPbcZoXx2CAVsJYaB/3EKUuXls1qCtt8p9awyU0qpqQV33vuaSRF3/iGKQ92e1E5AAX1Cv715PhY8j16qCrOKYCz/8Ou2I5gUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772180; c=relaxed/simple;
	bh=mC/G39zT54jCa/PbIJFszNCKlxz08OR5hr80quqJXgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XI5v4OdeFQtZZIGAYzy74gcxitGLw01PqkSbMhJ5wNJKBLAatw1KMVBHYr/+TW4Ew2DaV7mx1xoAeoKPcOPA2d0FnVyUsSXqlTL+WDFRB/JZMoe+qRLixiZmqiN3m4ygEqnJBiWI44NnZukO3QcX79ZmnGkgQaxFJv0aEwTmEJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/3t6NW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/3t6NW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA1CC6104A;
	Tue, 27 Aug 2024 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772180;
	bh=mC/G39zT54jCa/PbIJFszNCKlxz08OR5hr80quqJXgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/3t6NW4QVT5xRjHER0K7i63WJz7LxYzIG2F2z0MFcFTJQ83HwpGPylZIrFrWn2Aj
	 DFwo9lE8dBtLcC82UMGFvp3+HlEVqsav/iFFVGa4DX9o+H10ZmXsW8gjitwdaomwti
	 kcF+YR4VColhKUk01NI53hfLgEIKUXPgxZTAtL3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/321] net: hns3: fix wrong use of semaphore up
Date: Tue, 27 Aug 2024 16:36:55 +0200
Message-ID: <20240827143842.320312371@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 8445d9d3c03101859663d34fda747f6a50947556 ]

Currently, if hns3 PF or VF FLR reset failed after five times retry,
the reset done process will directly release the semaphore
which has already released in hclge_reset_prepare_general.
This will cause down operation fail.

So this patch fixes it by adding reset state judgement. The up operation is
only called after successful PF FLR reset.

Fixes: 8627bdedc435 ("net: hns3: refactor the precedure of PF FLR")
Fixes: f28368bb4542 ("net: hns3: refactor the procedure of VF FLR")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 01e24b69e9203..dfb428550ac03 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11538,8 +11538,8 @@ static void hclge_reset_done(struct hnae3_ae_dev *ae_dev)
 		dev_err(&hdev->pdev->dev, "fail to rebuild, ret=%d\n", ret);
 
 	hdev->reset_type = HNAE3_NONE_RESET;
-	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
-	up(&hdev->reset_sem);
+	if (test_and_clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		up(&hdev->reset_sem);
 }
 
 static void hclge_clear_resetting_state(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1f5a27fb309aa..aebb104f4c290 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1764,8 +1764,8 @@ static void hclgevf_reset_done(struct hnae3_ae_dev *ae_dev)
 			 ret);
 
 	hdev->reset_type = HNAE3_NONE_RESET;
-	clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
-	up(&hdev->reset_sem);
+	if (test_and_clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
+		up(&hdev->reset_sem);
 }
 
 static u32 hclgevf_get_fw_version(struct hnae3_handle *handle)
-- 
2.43.0



