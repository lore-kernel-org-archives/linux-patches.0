Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410BD3176EE;
	Sat, 12 Sep 2026 19:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242227; cv=none; b=NywE+BuVLWn6EN1ut+TNUcmhsAvemrRDfiPEEc3FjTFOZ4xnPcV2Xo9k3vDNEXwxEXscJBmQZlxwWdBXtnEXXhIzDis9NrCVWwyJ7d0DGV3DUADAbQSvhqzEB6r12TpO5GPH4JwSqGE87DRGJnuuEhI6flqPLfnusA8bdzpclbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242227; c=relaxed/simple;
	bh=4LrkdpxdTbodBdSsOufWScwl1KB4c4CRoO0Na3d6fEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqTr8NkkLXS/OisGGdlpMZWqQtWmp5OBudV0yxmSyO4KNmnUZY6C7ONZn5xmfFKVY8XBIC5Q3iO9nhRa1g+wu3qE4l1kTCCYx15CamSfcWtmEnIJwU3bv4u641jo7Iih3CuzyTnqt1pwyWGyWt8Cvg8Y+gcjXhhQqrhwiiMUlTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idxVJycn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idxVJycn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCBA1F000FF;
	Sat, 12 Sep 2026 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242226;
	bh=g0LujtN7MCimCD5zZlFaSqOw58LIbYjWrViFJa4+S1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idxVJycnz8q7qSANuy7yhTeQ46jqGurBweLYRfrJ5adV4GHy820RS7QxOPKJDud9u
	 IDTjKO4AFM9acSmeaEYzgNZ6dhJu7kbGjq6dqmqJvK+Etl6ickWGzS3YjMYZSEG6Ow
	 z1NXCCqJjN+lyezERHG5MDTFwXDxzVJZpysl9Lp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/798] net: hns3: dont auto enable misc vector
Date: Sat, 12 Sep 2026 08:59:16 +0200
Message-ID: <20260912065524.681267892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 98b1e3b27734139c76295754b6c317aa4df6d32e ]

Currently, there is a time window between misc irq enabled
and service task inited. If an interrupte is reported at
this time, it will cause warning like below:

[   16.324639] Call trace:
[   16.324641]  __queue_delayed_work+0xb8/0xe0
[   16.324643]  mod_delayed_work_on+0x78/0xd0
[   16.324655]  hclge_errhand_task_schedule+0x58/0x90 [hclge]
[   16.324662]  hclge_misc_irq_handle+0x168/0x240 [hclge]
[   16.324666]  __handle_irq_event_percpu+0x64/0x1e0
[   16.324667]  handle_irq_event+0x80/0x170
[   16.324670]  handle_fasteoi_edge_irq+0x110/0x2bc
[   16.324671]  __handle_domain_irq+0x84/0xfc
[   16.324673]  gic_handle_irq+0x88/0x2c0
[   16.324674]  el1_irq+0xb8/0x140
[   16.324677]  arch_cpu_idle+0x18/0x40
[   16.324679]  default_idle_call+0x5c/0x1bc
[   16.324682]  cpuidle_idle_call+0x18c/0x1c4
[   16.324684]  do_idle+0x174/0x17c
[   16.324685]  cpu_startup_entry+0x30/0x6c
[   16.324687]  secondary_start_kernel+0x1a4/0x280
[   16.324688] ---[ end trace 6aa0bff672a964aa ]---

So don't auto enable misc vector when request irq..

Fixes: 7be1b9f3e99f ("net: hns3: make hclge_service use delayed workqueue")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20250106143642.539698-5-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fa51463bfd8b4..0dcfc7c8a4713 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6,6 +6,7 @@
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
@@ -3285,7 +3286,7 @@ static int hclge_misc_irq_init(struct hclge_dev *hdev)
 	snprintf(hdev->misc_vector.name, HNAE3_INT_NAME_LEN, "%s-misc-%s",
 		 HCLGE_NAME, pci_name(hdev->pdev));
 	ret = request_irq(hdev->misc_vector.vector_irq, hclge_misc_irq_handle,
-			  0, hdev->misc_vector.name, hdev);
+			  IRQF_NO_AUTOEN, hdev->misc_vector.name, hdev);
 	if (ret) {
 		hclge_free_vector(hdev, 0);
 		dev_err(&hdev->pdev->dev, "request misc irq(%d) fail\n",
@@ -10267,12 +10268,13 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		mod_timer(&hdev->reset_timer, jiffies + HCLGE_RESET_INTERVAL);
 	}
 
-	/* Enable MISC vector(vector0) */
-	hclge_enable_vector(&hdev->misc_vector, true);
-
 	hclge_state_init(hdev);
 	hdev->last_reset_time = jiffies;
 
+	/* Enable MISC vector(vector0) */
+	enable_irq(hdev->misc_vector.vector_irq);
+	hclge_enable_vector(&hdev->misc_vector, true);
+
 	dev_info(&hdev->pdev->dev, "%s driver initialization finished.\n",
 		 HCLGE_DRIVER_NAME);
 
@@ -10663,7 +10665,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	/* Disable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, false);
-	synchronize_irq(hdev->misc_vector.vector_irq);
+	disable_irq(hdev->misc_vector.vector_irq);
 
 	/* Disable all hw interrupts */
 	hclge_config_mac_tnl_int(hdev, false);
-- 
2.53.0



