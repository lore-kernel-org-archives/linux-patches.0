Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21453418E;
	Fri, 24 Nov 2023 19:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvoG4NUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E73C433C8;
	Fri, 24 Nov 2023 19:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853294;
	bh=MLEc9P9n1W6DV1W4vHIJ7eWzoaPl+nye8dhT0yqCzJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvoG4NUdQQyYtT4LGusHBuznJMLCPTTXFklt2it/DrQ2i89TyViIEWpb6D1a/oRjz
	 ZVg1Aa5SeRXrHxxpbjMKtiGip2LIqe3Da9h988H+NTEP/TjMLhPO/nk7zra2saBHzS
	 LBXzbBiEzfkdHkEntJM0MjmBhsCDRi0jD3VQMa4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/297] net: hns3: add barrier in vf mailbox reply process
Date: Fri, 24 Nov 2023 17:52:29 +0000
Message-ID: <20231124172004.018813147@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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
index df6e9b8b26e0f..608a14fc27acc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -60,6 +60,9 @@ static int hclgevf_get_mbx_resp(struct hclgevf_dev *hdev, u16 code0, u16 code1,
 		i++;
 	}
 
+	/* ensure additional_info will be seen after received_resp */
+	smp_rmb();
+
 	if (i >= HCLGEVF_MAX_TRY_TIMES) {
 		dev_err(&hdev->pdev->dev,
 			"VF could not get mbx(%u,%u) resp(=%d) from PF in %d tries\n",
@@ -175,6 +178,10 @@ static void hclgevf_handle_mbx_response(struct hclgevf_dev *hdev,
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



