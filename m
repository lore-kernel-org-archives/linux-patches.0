Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D75BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA12CC433D2;
	Tue,  7 Mar 2023 18:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212814;
	bh=n+sYdglaMEvderyK4mj/+bor45xNcgO8npFFKiV++ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o92XsrYbWGp2rYglpfqoOPmwa9OagKCbrWRhQ/e3GBP+Os2MGqG83k9e8yoj32dfu
	 DYdCfGtvvkHiK9rN22X7V4W1JJV62w5KivVeROf+zd63nN3nxMwCVKB0HzYfAJiJbv
	 YHtmbZ8KnENKcuvRt/dD5Ovz4O9z3mQNoKbTh+g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jerome Neanne <jneanne@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	linux-omap@vger.kernel.org,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 304/885] regulator: tps65219: use IS_ERR() to detect an error pointer
Date: Tue,  7 Mar 2023 17:53:58 +0100
Message-Id: <20230307170015.308350237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 2bbba115c3c9a647bcb3201b014fcc3728fe75c8 ]

Fix pointer comparison to integer warning from gcc & sparse:

GCC:
../drivers/regulator/tps65219-regulator.c:370:26: warning: ordered comparison of pointer with integer zero [-Wextra]
  370 |                 if (rdev < 0) {
      |                          ^

sparse warning:
drivers/regulator/tps65219-regulator.c:370:26: sparse: error: incompatible types for operation (<):
drivers/regulator/tps65219-regulator.c:370:26: sparse:    struct regulator_dev *[assigned] rdev
drivers/regulator/tps65219-regulator.c:370:26: sparse:    int

Fixes: c12ac5fc3e0a ("regulator: drivers: Add TI TPS65219 PMIC regulators support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jerome Neanne <jneanne@baylibre.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20230114185736.2076-1-rdunlap@infradead.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65219-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65219-regulator.c b/drivers/regulator/tps65219-regulator.c
index c484c943e4675..070159cb5f094 100644
--- a/drivers/regulator/tps65219-regulator.c
+++ b/drivers/regulator/tps65219-regulator.c
@@ -367,7 +367,7 @@ static int tps65219_regulator_probe(struct platform_device *pdev)
 		irq_data[i].type = irq_type;
 
 		tps65219_get_rdev_by_name(irq_type->regulator_name, rdevtbl, rdev);
-		if (rdev < 0) {
+		if (IS_ERR(rdev)) {
 			dev_err(tps->dev, "Failed to get rdev for %s\n",
 				irq_type->regulator_name);
 			return -EINVAL;
-- 
2.39.2



