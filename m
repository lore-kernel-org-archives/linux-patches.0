Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF1D79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E03C433EF;
	Thu, 12 Jan 2023 14:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534225;
	bh=ltLall8t4l0jScUlJ8vnXkTa9xYUVWppB7QlDGQhEM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQeFtCGIvgB6keygBSDzNfNy+2gOoBBs+mb6nKT8tZKydLoDefD8uVyU23gDYVQwM
	 cvvlOY9HPsptCjqjw9lDeeIa/9mKQq6liDWuIvHgCk72ulRLesNcm4ehDMCrefRH+L
	 C6yjXcsokuC6Ebpx3cZObaA8mV7Gxjn42rM85wDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 730/783] net: hns3: add interrupts re-initialization while doing VF FLR
Date: Thu, 12 Jan 2023 14:57:26 +0100
Message-Id: <20230112135558.184194694@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index d6580e942724..f7f3e4bbc477 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3089,7 +3089,8 @@ static int hclgevf_pci_reset(struct hclgevf_dev *hdev)
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



