Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141D41C68C;
	Sun,  1 Sep 2024 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209468; cv=none; b=jjBtQ/zrEhrpeshpWzCnJ40MRY8H3RlSYY4EWOLcIZtdwITKZsNoJXEx2yyriVDPQMRIS7gbAVgw1GewGbALcyLoLOf5Parzh+ragUg7kUONbv+jza3d+cWSj7D/suuy1PBQoMHGNy6BIvzIeQw00UVgV3oyyaBUrYNSX5sAZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209468; c=relaxed/simple;
	bh=2rcf6Ahy0k5HAy/Di0TepiruEd2VBYoW+OXMXJPE7So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eT+nvCMBbda2MpSbVZdzRU4kd7xftbVksyrOfIydwxcLar8UtFcc748aBnIgIVYovntN962a7orpCAiFvl94rScr+xouCo26S8N7g8nlBW5Dn+R0UrfJznvFre+EZAsc/kG5Mf5MX7XQ4swT0Ad36FTIRhPG/+N7YRNQeAp5koM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qf3Qbhiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qf3Qbhiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9030FC4CEC3;
	Sun,  1 Sep 2024 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209467;
	bh=2rcf6Ahy0k5HAy/Di0TepiruEd2VBYoW+OXMXJPE7So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qf3Qbhiz8U2SqfPsK9mmuqq6M+yIM+6qz5RNO79Kv8xM83uwhxblhyGjZPked2OIz
	 gU/J4vbTy+rlZM04By8YOOZpMOgys3fcNdC0MzktGQmsxSTCHtaicLIqJksUAS2UD7
	 R/oaAaJqpVsZvoEmLXl4zEyweru69Fh+CZnj7TrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/151] net: hns3: fix wrong use of semaphore up
Date: Sun,  1 Sep 2024 18:16:28 +0200
Message-ID: <20240901160815.156117877@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5dbee850fef53..885793707a5f1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10051,8 +10051,8 @@ static void hclge_flr_done(struct hnae3_ae_dev *ae_dev)
 		dev_err(&hdev->pdev->dev, "fail to rebuild, ret=%d\n", ret);
 
 	hdev->reset_type = HNAE3_NONE_RESET;
-	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
-	up(&hdev->reset_sem);
+	if (test_and_clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		up(&hdev->reset_sem);
 }
 
 static void hclge_clear_resetting_state(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index be41117ec1465..755935f9efc81 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2093,8 +2093,8 @@ static void hclgevf_flr_done(struct hnae3_ae_dev *ae_dev)
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



