Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E123168DE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013BDC4339B;
	Mon,  8 May 2023 11:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545751;
	bh=E985gS0XTiQghzO+1q2fkBOFLD3foyHgpbS3V42cqYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEuRITyXbypOtTLeaFeyZ8e5f1v+CK/wyAqgrvO/8dctB6Ml5klW4a0WhcUrr/7SX
	 RPKmF4AccsJjrPfM62GZHLCKs5i5G5VQZM4WMojxvGCsCy2nxW0SPMpdcPoHGH1cyt
	 ZgborVAhm1Mn3rhltMLPe7CUzEdmjoZshiAqQFv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YAN SHI <m202071378@hust.edu.cn>,
	kernel test robot <lkp@intel.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/371] regulator: stm32-pwr: fix of_iomap leak
Date: Mon,  8 May 2023 11:45:43 +0200
Message-Id: <20230508094817.697592144@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YAN SHI <m202071378@hust.edu.cn>

[ Upstream commit c4a413e56d16a2ae84e6d8992f215c4dcc7fac20 ]

Smatch reports:
drivers/regulator/stm32-pwr.c:166 stm32_pwr_regulator_probe() warn:
'base' from of_iomap() not released on lines: 151,166.

In stm32_pwr_regulator_probe(), base is not released
when devm_kzalloc() fails to allocate memory or
devm_regulator_register() fails to register a new regulator device,
which may cause a leak.

To fix this issue, replace of_iomap() with
devm_platform_ioremap_resource(). devm_platform_ioremap_resource()
is a specialized function for platform devices.
It allows 'base' to be automatically released whether the probe
function succeeds or fails.

Besides, use IS_ERR(base) instead of !base
as the return value of devm_platform_ioremap_resource()
can either be a pointer to the remapped memory or
an ERR_PTR() encoded error code if the operation fails.

Fixes: dc62f951a6a8 ("regulator: stm32-pwr: Fix return value check in stm32_pwr_regulator_probe()")
Signed-off-by: YAN SHI <m202071378@hust.edu.cn>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304111750.o2643eJN-lkp@intel.com/
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230412033529.18890-1-m202071378@hust.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/stm32-pwr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/stm32-pwr.c b/drivers/regulator/stm32-pwr.c
index 2a42acb7c24e9..e5dd4db6403b2 100644
--- a/drivers/regulator/stm32-pwr.c
+++ b/drivers/regulator/stm32-pwr.c
@@ -129,17 +129,16 @@ static const struct regulator_desc stm32_pwr_desc[] = {
 
 static int stm32_pwr_regulator_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct stm32_pwr_reg *priv;
 	void __iomem *base;
 	struct regulator_dev *rdev;
 	struct regulator_config config = { };
 	int i, ret = 0;
 
-	base = of_iomap(np, 0);
-	if (!base) {
+	base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(base)) {
 		dev_err(&pdev->dev, "Unable to map IO memory\n");
-		return -ENOMEM;
+		return PTR_ERR(base);
 	}
 
 	config.dev = &pdev->dev;
-- 
2.39.2



