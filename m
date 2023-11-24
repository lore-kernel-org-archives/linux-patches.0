Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754E539FF3;
	Fri, 24 Nov 2023 18:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjVTJk5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDBDC433C7;
	Fri, 24 Nov 2023 18:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849519;
	bh=Cc8JCaLVUS/07bzbZCWZXs+m2cuKuiRQ0f+W+juHMdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjVTJk5qHi5zpeJ/V/GhuCp78KYShHaMqakvyJSo7PqJ5mPB4DsD3LInLJl4qonzn
	 Qpuc4tM4/r+Fn0oWIM6prCmq84UXWuA4DhnuEylQM+43lc0J7v6ma6xo1R5k5VGU2J
	 ly4bSdHh1lJvM007xtU4kZTyOqa+1pkcr2IxIB9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/530] net: hns3: add barrier in vf mailbox reply process
Date: Fri, 24 Nov 2023 17:45:55 +0000
Message-ID: <20231124172033.818027372@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

[ Upstream commit ac92c0a9a0603fb448e60f38e63302e4eebb8035 ]

In hclgevf_mbx_handler() and hclgevf_get_mbx_resp() functions,
there is a typical store-store and load-load scenario between
received_resp and additional_info. This patch adds barrier
to fix the problem.

Fixes: 4671042f1ef0 ("net: hns3: add match_id to check mailbox response from PF to VF")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index bbf7b14079de3..85c2a634c8f96 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -63,6 +63,9 @@ static int hclgevf_get_mbx_resp(struct hclgevf_dev *hdev, u16 code0, u16 code1,
 		i++;
 	}
 
+	/* ensure additional_info will be seen after received_resp */
+	smp_rmb();
+
 	if (i >= HCLGEVF_MAX_TRY_TIMES) {
 		dev_err(&hdev->pdev->dev,
 			"VF could not get mbx(%u,%u) resp(=%d) from PF in %d tries\n",
@@ -178,6 +181,10 @@ static void hclgevf_handle_mbx_response(struct hclgevf_dev *hdev,
 	resp->resp_status = hclgevf_resp_to_errno(resp_status);
 	memcpy(resp->additional_info, req->msg.resp_data,
 	       HCLGE_MBX_MAX_RESP_DATA_SIZE * sizeof(u8));
+
+	/* ensure additional_info will be seen before setting received_resp */
+	smp_wmb();
+
 	if (match_id) {
 		/* If match_id is not zero, it means PF support match_id.
 		 * if the match_id is right, VF get the right response, or
-- 
2.42.0



