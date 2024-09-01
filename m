Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8391EB5B;
	Sun,  1 Sep 2024 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210123; cv=none; b=sZCbP/hRBU5ucVn/ZwB69oCmLnq0Kwx2JcRBoWiIctqYSOfC3Ity3/npn+88/EXiNz1y/aWluMuXNgab91+eOs6vR4HvXw0lsohNDVVYAdK5LSHiwd/tarlnEh1CDIE7jIIMWkekwQsEDsyGv1kaGi0ESWM8MYMwWsHQlVhkD9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210123; c=relaxed/simple;
	bh=Lnsk7dbacXQbbngeeUBeiyqJMx5Lt8wxbPRvgtGEmkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzgaJeRaTLZ+9zVxfAf+bh2IvardCQMTCXkhrE2EXSnhMJue/2aWrA7OuObqRG7T4tpDZSdqYlAbTc5QNjAPE6Vo3Be2A6tSg+pA+h8PrSKaVTur2U3EgIxopJGPxauOTsMt9dufjT/n3P/RKp4oRIwU/lpB0eDuZcvy74/NUSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvVt+bZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvVt+bZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECA4C4CEC3;
	Sun,  1 Sep 2024 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210123;
	bh=Lnsk7dbacXQbbngeeUBeiyqJMx5Lt8wxbPRvgtGEmkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvVt+bZc7UiLA8MvSYvTESK9m1dMRHSypll0MVwi7SsPOVnG/SDn92WakLHLegdte
	 XvGvNDNFw2p2sis9GjdyivyN6SRsk7pu0+mAPena3iArJKYAD0dM75+3g+p3Bet80N
	 8tFQr4qWWSNcm3Llh0xlkYyI5JEQHB+KT7OhbGoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/215] net: hns3: add checking for vf id of mailbox
Date: Sun,  1 Sep 2024 18:16:47 +0200
Message-ID: <20240901160826.941767839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 4e2969a0d6a7549bc0bc1ebc990588b622c4443d ]

Add checking for vf id of mailbox, in order to avoid array
out-of-bounds risk.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 77c432ab7856c..e2fe41d3972fb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -1066,10 +1066,11 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		req = (struct hclge_mbx_vf_to_pf_cmd *)desc->data;
 
 		flag = le16_to_cpu(crq->desc[crq->next_to_use].flag);
-		if (unlikely(!hnae3_get_bit(flag, HCLGE_CMDQ_RX_OUTVLD_B))) {
+		if (unlikely(!hnae3_get_bit(flag, HCLGE_CMDQ_RX_OUTVLD_B) ||
+			     req->mbx_src_vfid > hdev->num_req_vfs)) {
 			dev_warn(&hdev->pdev->dev,
-				 "dropped invalid mailbox message, code = %u\n",
-				 req->msg.code);
+				 "dropped invalid mailbox message, code = %u, vfid = %u\n",
+				 req->msg.code, req->mbx_src_vfid);
 
 			/* dropping/not processing this invalid message */
 			crq->desc[crq->next_to_use].flag = 0;
-- 
2.43.0



