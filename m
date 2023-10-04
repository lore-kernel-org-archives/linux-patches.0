Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0041D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owDFb4Cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3A8C433C8;
	Wed,  4 Oct 2023 18:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444024;
	bh=s3FEAAuuPcgi4FHHNXG9/1o4iKwyoKJhDDA59BWNXpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owDFb4CfLP2+naqJbeXXvPZlplhhquJcCvYayGFHQjv/YrP+gr0UBYWM/+U5Lqr9k
	 mTNWFK3oxnAknZfEPARh7wie3P2f1nau4QyWh9CdV27H3tU6xQLP+3EeDuJ+PFJOX3
	 SjmwkVLoTPVf98y0enkzVOznV0Xttb50po30DZ0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 086/321] net: hns3: add 5ms delay before clear firmware reset irq source
Date: Wed,  4 Oct 2023 19:53:51 +0200
Message-ID: <20231004175233.190360886@linuxfoundation.org>
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

[ Upstream commit 0770063096d5da4a8e467b6e73c1646a75589628 ]

Currently the reset process in hns3 and firmware watchdog init process is
asynchronous. we think firmware watchdog initialization is completed
before hns3 clear the firmware interrupt source. However, firmware
initialization may not complete early.

so we add delay before hns3 clear firmware interrupt source and 5 ms delay
is enough to avoid second firmware reset interrupt.

Fixes: c1a81619d73a ("net: hns3: Add mailbox interrupt handling to PF driver")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a4500abfa286f..ed6cf59853bf6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3564,9 +3564,14 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 static void hclge_clear_event_cause(struct hclge_dev *hdev, u32 event_type,
 				    u32 regclr)
 {
+#define HCLGE_IMP_RESET_DELAY		5
+
 	switch (event_type) {
 	case HCLGE_VECTOR0_EVENT_PTP:
 	case HCLGE_VECTOR0_EVENT_RST:
+		if (regclr == BIT(HCLGE_VECTOR0_IMPRESET_INT_B))
+			mdelay(HCLGE_IMP_RESET_DELAY);
+
 		hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG, regclr);
 		break;
 	case HCLGE_VECTOR0_EVENT_MBX:
-- 
2.40.1



