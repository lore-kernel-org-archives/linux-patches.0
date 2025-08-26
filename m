Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D94267386;
	Tue, 26 Aug 2025 11:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208058; cv=none; b=D2h3K+Th7qJaiQdAYgzfOgCurDApqKFrAsoG0ExUKo+9nufnQmcE6R2UXptLogifFw0vKcPXqpKQ7oGDc0VAqSm1GZo0ftS8JgDRpBAjW+8uYXRj2TFU0HTTlAXITunD0vBChx6uhX4xwTK0c0rRDyWD5v41/Pf5Ghj2pgn176w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208058; c=relaxed/simple;
	bh=MBmP15HQajuJCAK3Inss2wAqLky66xLlKAwiV+y/UsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3AZ+vUIkN1eqg/M0r/m4s5iNXxj6e9LP+JrUkN2hE7xKPcxHoTGyPL5QOp3sF2+7Vh2qu/QaekncJOSnuUgP5fj0M+K5qszfItWNlwMrmyp8aRUZDQPKbgiPuXZFPjAFc3z7KrE7k8oLvjZojY7AS4EFZxrs6MiDwK7FV0eSbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ob+z5G+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ob+z5G+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80961C4CEF1;
	Tue, 26 Aug 2025 11:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208055;
	bh=MBmP15HQajuJCAK3Inss2wAqLky66xLlKAwiV+y/UsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ob+z5G+1zmWF5TUH5lorwJdbGMqeRirJFKCdSpc5rgCDE2T5WsI9E1YD2yLT0p/kc
	 y1Gap6GtY9OMwc5qZj9h2PT6BSRpAQKoe7ZSyX/JXFc2CSJNjtil/IsK7CTz4IYv28
	 vicjh313j2DIywzy4Qd3OpL8XNXn3U6kglw5oMyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 389/457] drm/hisilicon/hibmc: fix irq_request()s irq name variable is local
Date: Tue, 26 Aug 2025 13:11:13 +0200
Message-ID: <20250826110946.911131995@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baihan Li <libaihan@huawei.com>

[ Upstream commit 8bed4ec42a4e0dc8113172696ff076d1eb6d8bcb ]

The local variable is passed in request_irq (), and there will be use
after free problem, which will make request_irq failed. Using the global
irq name instead of it to fix.

Fixes: b11bc1ae4658 ("drm/hisilicon/hibmc: Add MSI irq getting and requesting for HPD")
Signed-off-by: Baihan Li <libaihan@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250813094238.3722345-4-shiyongbang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
index 768b97f9e74a..4cdcc34070ee 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -32,7 +32,7 @@
 
 DEFINE_DRM_GEM_FOPS(hibmc_fops);
 
-static const char *g_irqs_names_map[HIBMC_MAX_VECTORS] = { "vblank", "hpd" };
+static const char *g_irqs_names_map[HIBMC_MAX_VECTORS] = { "hibmc-vblank", "hibmc-hpd" };
 
 static irqreturn_t hibmc_interrupt(int irq, void *arg)
 {
@@ -277,7 +277,6 @@ static void hibmc_unload(struct drm_device *dev)
 static int hibmc_msi_init(struct drm_device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
-	char name[32] = {0};
 	int valid_irq_num;
 	int irq;
 	int ret;
@@ -292,9 +291,6 @@ static int hibmc_msi_init(struct drm_device *dev)
 	valid_irq_num = ret;
 
 	for (int i = 0; i < valid_irq_num; i++) {
-		snprintf(name, ARRAY_SIZE(name) - 1, "%s-%s-%s",
-			 dev->driver->name, pci_name(pdev), g_irqs_names_map[i]);
-
 		irq = pci_irq_vector(pdev, i);
 
 		if (i)
@@ -302,10 +298,10 @@ static int hibmc_msi_init(struct drm_device *dev)
 			ret = devm_request_threaded_irq(&pdev->dev, irq,
 							hibmc_dp_interrupt,
 							hibmc_dp_hpd_isr,
-							IRQF_SHARED, name, dev);
+							IRQF_SHARED, g_irqs_names_map[i], dev);
 		else
 			ret = devm_request_irq(&pdev->dev, irq, hibmc_interrupt,
-					       IRQF_SHARED, name, dev);
+					       IRQF_SHARED, g_irqs_names_map[i], dev);
 		if (ret) {
 			drm_err(dev, "install irq failed: %d\n", ret);
 			return ret;
-- 
2.50.1



