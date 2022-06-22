Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D6C1869
	for <patches@lists.linux.dev>; Wed, 22 Jun 2022 17:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EBCC34114;
	Wed, 22 Jun 2022 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1655920623;
	bh=VRukoejy6moeTDDBjSf9TvBXSWfTEbTgKnfDO7aPvnM=;
	h=From:To:Cc:Subject:Date:From;
	b=PVYuKFKTgIwilzfutOM8aihiifo2iNBWw7BxLK/BlkUoeEdvl7uUdk5C69+7IBQ9j
	 4TtvUEhyWHesAIw8PpyAePXk0nuHtLWqRlTr0d3oQf9BTrq55d28UQKS0rXogUxdkF
	 I0sZeR2q4PdTOU9nfs6Uaze3mc3KRupaYUCnqtGgn4zi+WL+9q8EoL/Q0xKe/Tuzwo
	 h/K+NIKkiMANvODoXAOtsuCH6YpiC5W8JSnJVIvUlzFhjNXDTctn3HIbx3hmXYfXYi
	 jP7+E+Dlb6pzC5+FQlo3sTItTraX0KFBCx4zxWo3WFpWEVMGHCOqvqYLpZEgwjlHSd
	 uHqjNjO4DEDJg==
From: Nathan Chancellor <nathan@kernel.org>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Roger Lu <roger.lu@mediatek.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] soc: mediatek: SVS: Use DEFINE_SIMPLE_DEV_PM_OPS for svs_pm_ops
Date: Wed, 22 Jun 2022 10:56:49 -0700
Message-Id: <20220622175649.1856337-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.0.rc1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building this driver for an architecture that does not support
CONFIG_PM_SLEEP, such as hexagon, the following warnings occur:

  drivers/soc/mediatek/mtk-svs.c:1481:12: error: unused function 'svs_suspend' [-Werror,-Wunused-function]
  static int svs_suspend(struct device *dev)
             ^
  drivers/soc/mediatek/mtk-svs.c:1515:12: error: unused function 'svs_resume' [-Werror,-Wunused-function]
  static int svs_resume(struct device *dev)
             ^
  2 errors generated.

This happens because SIMPLE_DEV_PM_OPS uses SET_SYSTEM_SLEEP_PM_OPS,
which evaluates to nothing when CONFIG_PM_SLEEP is not set, leaving the
functions unused in the eyes of the compiler.

This problem was rectified in commit 1a3c7bb08826 ("PM: core: Add new
*_PM_OPS macros, deprecate old ones") with new macros. Use
DEFINE_SIMPLE_DEV_PM_OPS to fix the warning while not changing
svs_pm_ops when CONFIG_PM_SLEEP is set.

Fixes: 681a02e95000 ("soc: mediatek: SVS: introduce MTK SVS engine")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 606a00a2e57d..d70903f45ddf 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -2381,7 +2381,7 @@ static int svs_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static SIMPLE_DEV_PM_OPS(svs_pm_ops, svs_suspend, svs_resume);
+static DEFINE_SIMPLE_DEV_PM_OPS(svs_pm_ops, svs_suspend, svs_resume);
 
 static struct platform_driver svs_driver = {
 	.probe	= svs_probe,

base-commit: 71eaf1887203d0a59c92fd9dd3436b8d8489d68c
-- 
2.37.0.rc1

