Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70764A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEECEC433EF;
	Tue, 10 Jan 2023 18:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374472;
	bh=p+FoBVmN+7/qhlph2th6u60IRY/kk7ajIirBy8j6bVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaoGeolCt09FGHNn5oqy66uIqu6dk9mUYXTYJzFXc7IHa9EvvblFN+3FVVdtD0+9j
	 cCFZTUIlYq9FMcjjpBZ3O/9w7I8djetNLfZ71gO6PK3q2iDbCvML1sOVQarXq/p57R
	 D5MSdhwIS8hV1GWraejNr2IMQMO6CY6RFqRIoIK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/159] net: hns3: add interrupts re-initialization while doing VF FLR
Date: Tue, 10 Jan 2023 19:02:57 +0100
Message-Id: <20230110180019.242088395@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 09e6b30eeb254f1818a008cace3547159e908dfd ]

Currently keep alive message between PF and VF may be lost and the VF is
unalive in PF. So the VF will not do reset during PF FLR reset process.
This would make the allocated interrupt resources of VF invalid and VF
would't receive or respond to PF any more.

So this patch adds VF interrupts re-initialization during VF FLR for VF
recovery in above cases.

Fixes: 862d969a3a4d ("net: hns3: do VF's pci re-initialization while PF doing FLR")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index db6f7cdba958..081bd2c3f289 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2767,7 +2767,8 @@ static int hclgevf_pci_reset(struct hclgevf_dev *hdev)
 	struct pci_dev *pdev = hdev->pdev;
 	int ret = 0;
 
-	if (hdev->reset_type == HNAE3_VF_FULL_RESET &&
+	if ((hdev->reset_type == HNAE3_VF_FULL_RESET ||
+	     hdev->reset_type == HNAE3_FLR_RESET) &&
 	    test_bit(HCLGEVF_STATE_IRQ_INITED, &hdev->state)) {
 		hclgevf_misc_irq_uninit(hdev);
 		hclgevf_uninit_msi(hdev);
-- 
2.35.1



