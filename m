Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFBF1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaIscHFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1632C433C7;
	Wed,  4 Oct 2023 18:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443965;
	bh=8tBnaWAjBSyNSviA+5S+5s81kWgl+X86cxAoM+LVKoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaIscHFpDyO4zMGKWWaWNfFvceCeTMOmXHA/uRKEvzZF0k5FlOFWFiBqP9xFvee+g
	 XDQtr2l+1meFGM5N8S6IaBQL6Wr/IYdbExOdHRWVG8ORdl/ADAIGOjir4UqL8K0mf4
	 Kq6oQBQqr3FkktF0BWQ+GlfAHV0gpnZOgFxL+sBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 082/321] net: hns3: add cmdq check for vf periodic service task
Date: Wed,  4 Oct 2023 19:53:47 +0200
Message-ID: <20231004175233.011608794@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit bd3caddf299a640efb66c6022efed7fe744db626 ]

When the vf cmdq is disabled, there is no need to keep these task running.
So this patch skip these task when the cmdq is disabled.

Fixes: ff200099d271 ("net: hns3: remove unnecessary work in hclgevf_main")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 7a2f9233d6954..a4d68fb216fb9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1855,7 +1855,8 @@ static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 	unsigned long delta = round_jiffies_relative(HZ);
 	struct hnae3_handle *handle = &hdev->nic;
 
-	if (test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state))
+	if (test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state) ||
+	    test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state))
 		return;
 
 	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
-- 
2.40.1



