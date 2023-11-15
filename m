Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB19D3309F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2XKF0Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6398BC433C9;
	Wed, 15 Nov 2023 19:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077593;
	bh=SCwI3pPr117IbP1mr22Vtb2FffjGaEshrkDXiNM9jCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2XKF0JgmUSF59ZVtXD03UvrlfAiExMHVNjnY6GxsMTn8OtIYTev4Z2DK0SaYm8YK
	 vv9+Or3OdRlsxyuk87bghBdKx+H7A6VAsicuewL1mh/v9mgWJeCpLVh5m2EyyflHJN
	 UKeLWjkDB6jgnFqPGJpaMLl0fggHgPckKJ302/rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 377/603] RDMA/hns: Fix printing level of asynchronous events
Date: Wed, 15 Nov 2023 14:15:22 -0500
Message-ID: <20231115191639.509469408@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 9faef73ef4f6666b97e04d99734ac09251098185 ]

The current driver will print all asynchronous events. Some of the
print levels are set improperly, e.g. SRQ limit reach and SRQ last
wqe reach, which may also occur during normal operation of the software.
Currently, the information of these event is printed as a warning,
which causes a large amount of printing even during normal use of the
application. As a result, the service performance deteriorates.

This patch fixes the printing storms by modifying the print level.

Fixes: b00a92c8f2ca ("RDMA/hns: Move all prints out of irq handle")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231017125239.164455-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d82daff2d9bd5..2b8f6489ab3df 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5804,7 +5804,7 @@ static void hns_roce_irq_work_handle(struct work_struct *work)
 	case HNS_ROCE_EVENT_TYPE_COMM_EST:
 		break;
 	case HNS_ROCE_EVENT_TYPE_SQ_DRAINED:
-		ibdev_warn(ibdev, "send queue drained.\n");
+		ibdev_dbg(ibdev, "send queue drained.\n");
 		break;
 	case HNS_ROCE_EVENT_TYPE_WQ_CATAS_ERROR:
 		ibdev_err(ibdev, "local work queue 0x%x catast error, sub_event type is: %d\n",
@@ -5819,10 +5819,10 @@ static void hns_roce_irq_work_handle(struct work_struct *work)
 			  irq_work->queue_num, irq_work->sub_type);
 		break;
 	case HNS_ROCE_EVENT_TYPE_SRQ_LIMIT_REACH:
-		ibdev_warn(ibdev, "SRQ limit reach.\n");
+		ibdev_dbg(ibdev, "SRQ limit reach.\n");
 		break;
 	case HNS_ROCE_EVENT_TYPE_SRQ_LAST_WQE_REACH:
-		ibdev_warn(ibdev, "SRQ last wqe reach.\n");
+		ibdev_dbg(ibdev, "SRQ last wqe reach.\n");
 		break;
 	case HNS_ROCE_EVENT_TYPE_SRQ_CATAS_ERROR:
 		ibdev_err(ibdev, "SRQ catas error.\n");
-- 
2.42.0



