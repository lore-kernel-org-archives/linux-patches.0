Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454B73264D4;
	Sat, 12 Sep 2026 14:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222235; cv=none; b=uoeXc0qxAlwgQ3e67T3fehdaozTOVW4NG9wLYvHFmIZKuG04LtqpkwPqbB0CZnEKSw8AhwnAJr3s77XUDrJ7xpOapgZjUBzYifaNgTmAVBVY8y8MRtFvHvdRfprdKvX6tVOYJWhAXUG33fqORg+k+iXe0twyQjlc1CWbKOAEdS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222235; c=relaxed/simple;
	bh=iY2pdX2mnu+3pUVcNVTTU0neL0mioxG2LqhtEZAjY1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfJE+imeeG9UOShZIsD4ypCWBQhATPWMZfVuNOTc0QnkZvztKKQQFFqW/usfQKre7+ryymgvLe3IlOj4iLrYnHad0Vydt49G2uAX1XLnqiXqfm6zLPSyIgO8ygpevKF5eXevcU1YZUrPGqWxdfdIXd1XVknm1UfDJjue7UEMSiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCos1EzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCos1EzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFA01F000FF;
	Sat, 12 Sep 2026 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222234;
	bh=lH5rqlj0wdOcGJf+wjemNYBc2V6vQ64tLk+Itnu694c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCos1EzXlCT0Ew7saK/ZiEnuyfQ1oM3xO2kYWhli/AY+lyxS4vFF0XU/oRrffJO1d
	 jKZRrT+EeBvBIqLj2ckK7/yPvZkTcxRW2ChPnrXHut0jVAd/GdQZGbw0s6aHACnmz3
	 jQ5JmbwZF5LFiQK8eQ95DRQbCHZIXZWoN779VrQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0538/1424] net: hns3: dont auto enable misc vector
Date: Sat, 12 Sep 2026 08:49:30 +0200
Message-ID: <20260912065619.348992341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 04c58928585ca..5c66eb21bb7ea 100644
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
@@ -3713,7 +3714,7 @@ static int hclge_misc_irq_init(struct hclge_dev *hdev)
 	snprintf(hdev->misc_vector.name, HNAE3_INT_NAME_LEN, "%s-misc-%s",
 		 HCLGE_NAME, pci_name(hdev->pdev));
 	ret = request_irq(hdev->misc_vector.vector_irq, hclge_misc_irq_handle,
-			  0, hdev->misc_vector.name, hdev);
+			  IRQF_NO_AUTOEN, hdev->misc_vector.name, hdev);
 	if (ret) {
 		hclge_free_vector(hdev, 0);
 		dev_err(&hdev->pdev->dev, "request misc irq(%d) fail\n",
@@ -11815,9 +11816,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_init_rxd_adv_layout(hdev);
 
-	/* Enable MISC vector(vector0) */
-	hclge_enable_vector(&hdev->misc_vector, true);
-
 	ret = hclge_init_wol(hdev);
 	if (ret)
 		dev_warn(&pdev->dev,
@@ -11830,6 +11828,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_state_init(hdev);
 	hdev->last_reset_time = jiffies;
 
+	/* Enable MISC vector(vector0) */
+	enable_irq(hdev->misc_vector.vector_irq);
+	hclge_enable_vector(&hdev->misc_vector, true);
+
 	dev_info(&hdev->pdev->dev, "%s driver initialization finished.\n",
 		 HCLGE_DRIVER_NAME);
 
@@ -12233,7 +12235,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	/* Disable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, false);
-	synchronize_irq(hdev->misc_vector.vector_irq);
+	disable_irq(hdev->misc_vector.vector_irq);
 
 	/* Disable all hw interrupts */
 	hclge_config_mac_tnl_int(hdev, false);
-- 
2.53.0



