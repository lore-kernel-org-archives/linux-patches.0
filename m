Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B173922B
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6BAC433D2;
	Wed,  7 Jun 2023 20:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171161;
	bh=Z3kg5meoaB1mRCtpryU2e1kd7aU7iytMrSZC4B6svjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8P+N4xd6uy1p3amqBN4P/L6aHjNvNA5Psc2hx08CbDDY78zU3ww+7JNa2KNUh6g2
	 Ttm0D0b6IZrxkITQm7BcVzjXE8E1S/RYUTMTg4DFj+vB7DR3OhYnhemugR3wglgklD
	 23rPX+5XpZMDK1pGJ+aVSRqh5SQ1erUPn9Fo+6S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Wang <D202280639@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/99] iommu/rockchip: Fix unwind goto issue
Date: Wed,  7 Jun 2023 22:15:57 +0200
Message-ID: <20230607200900.393748299@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
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
index 96f37d9d4d93c..67a8c08d82105 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -1230,18 +1230,20 @@ static int rk_iommu_probe(struct platform_device *pdev)
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
 
 	return 0;
+err_pm_disable:
+	pm_runtime_disable(dev);
 err_remove_sysfs:
 	iommu_device_sysfs_remove(&iommu->iommu);
 err_put_group:
-- 
2.39.2



