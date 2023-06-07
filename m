Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C7419E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE69DC433EF;
	Wed,  7 Jun 2023 20:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170240;
	bh=i3YLo5f0VEPgDE1NfO7JSCLM91WAMc+8Myv8hRN5/Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1+Xec+0Ry6WKKyzyunbFswkO8nVvojV9xoJcAFdycZDmtU686IgykhwLpCjTh1fA
	 aQlZSZju22D/YQP3YYCOUh3IGbprgntvSdUw5rK3LuT3K7BgM+JhNwhz1lKGtrmLx8
	 CtKYgZeuQv5fL3BkupZpjuYHTaFCBbbdcn7AWtu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Wang <D202280639@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/225] iommu/rockchip: Fix unwind goto issue
Date: Wed,  7 Jun 2023 22:13:23 +0200
Message-ID: <20230607200913.680855564@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Wang <D202280639@hust.edu.cn>

[ Upstream commit ec014683c564fb74fc68e8f5e84691d3b3839d24 ]

Smatch complains that
drivers/iommu/rockchip-iommu.c:1306 rk_iommu_probe() warn: missing unwind goto?

The rk_iommu_probe function, after obtaining the irq value through
platform_get_irq, directly returns an error if the returned value
is negative, without releasing any resources.

Fix this by adding a new error handling label "err_pm_disable" and
use a goto statement to redirect to the error handling process. In
order to preserve the original semantics, set err to the value of irq.

Fixes: 1aa55ca9b14a ("iommu/rockchip: Move irq request past pm_runtime_enable")
Signed-off-by: Chao Wang <D202280639@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20230417030421.2777-1-D202280639@hust.edu.cn
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/rockchip-iommu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index a68eadd64f38d..f7e9b56be174f 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -1303,20 +1303,22 @@ static int rk_iommu_probe(struct platform_device *pdev)
 	for (i = 0; i < iommu->num_irq; i++) {
 		int irq = platform_get_irq(pdev, i);
 
-		if (irq < 0)
-			return irq;
+		if (irq < 0) {
+			err = irq;
+			goto err_pm_disable;
+		}
 
 		err = devm_request_irq(iommu->dev, irq, rk_iommu_irq,
 				       IRQF_SHARED, dev_name(dev), iommu);
-		if (err) {
-			pm_runtime_disable(dev);
-			goto err_remove_sysfs;
-		}
+		if (err)
+			goto err_pm_disable;
 	}
 
 	dma_set_mask_and_coherent(dev, rk_ops->dma_bit_mask);
 
 	return 0;
+err_pm_disable:
+	pm_runtime_disable(dev);
 err_remove_sysfs:
 	iommu_device_sysfs_remove(&iommu->iommu);
 err_put_group:
-- 
2.39.2



