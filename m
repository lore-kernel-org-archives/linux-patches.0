Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036BD39FDD;
	Fri, 24 Nov 2023 18:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJ/Ex0mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751F7C433C7;
	Fri, 24 Nov 2023 18:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849528;
	bh=kBqogKaZRzTwZvSGsNmaUSoLpWrh7PsNc/yVte67cLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJ/Ex0mnP1JiiHnJT6d/4SVRO96SK8Rla/neUIOneiQY2X3a47nSm7ljeZi8NqS9c
	 p0EqD/5feA3obOxbUo8QwOeol/nJBiYRXlWcYdfpLh/9YN8yWi/z3SmTYX+9oJ1Rrf
	 sDcSAc4fsm03dWWXL2Egi2LxZWtddtdqSLpR277M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/530] net: hns3: fix VF reset fail issue
Date: Fri, 24 Nov 2023 17:45:59 +0000
Message-ID: <20231124172033.941929292@linuxfoundation.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 65e98bb56fa3ce2edb400930c05238c9b380500e ]

Currently the reset process in hns3 and firmware watchdog init process is
asynchronous. We think firmware watchdog initialization is completed
before VF clear the interrupt source. However, firmware initialization
may not complete early. So VF will receive multiple reset interrupts
and fail to reset.

So we add delay before VF interrupt source and 5 ms delay
is enough to avoid second reset interrupt.

Fixes: 427900d27d86 ("net: hns3: fix the timing issue of VF clearing interrupt sources")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 14 +++++++++++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1c62e58ff6d89..0aa9beefd1c7e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1981,8 +1981,18 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 	return HCLGEVF_VECTOR0_EVENT_OTHER;
 }
 
+static void hclgevf_reset_timer(struct timer_list *t)
+{
+	struct hclgevf_dev *hdev = from_timer(hdev, t, reset_timer);
+
+	hclgevf_clear_event_cause(hdev, HCLGEVF_VECTOR0_EVENT_RST);
+	hclgevf_reset_task_schedule(hdev);
+}
+
 static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 {
+#define HCLGEVF_RESET_DELAY	5
+
 	enum hclgevf_evt_cause event_cause;
 	struct hclgevf_dev *hdev = data;
 	u32 clearval;
@@ -1994,7 +2004,8 @@ static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 
 	switch (event_cause) {
 	case HCLGEVF_VECTOR0_EVENT_RST:
-		hclgevf_reset_task_schedule(hdev);
+		mod_timer(&hdev->reset_timer,
+			  jiffies + msecs_to_jiffies(HCLGEVF_RESET_DELAY));
 		break;
 	case HCLGEVF_VECTOR0_EVENT_MBX:
 		hclgevf_mbx_handler(hdev);
@@ -2937,6 +2948,7 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		 HCLGEVF_DRIVER_NAME);
 
 	hclgevf_task_schedule(hdev, round_jiffies_relative(HZ));
+	timer_setup(&hdev->reset_timer, hclgevf_reset_timer, 0);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 81c16b8c8da29..a73f2bf3a56a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -219,6 +219,7 @@ struct hclgevf_dev {
 	enum hnae3_reset_type reset_level;
 	unsigned long reset_pending;
 	enum hnae3_reset_type reset_type;
+	struct timer_list reset_timer;
 
 #define HCLGEVF_RESET_REQUESTED		0
 #define HCLGEVF_RESET_PENDING		1
-- 
2.42.0



