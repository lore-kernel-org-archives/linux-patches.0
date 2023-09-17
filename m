Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7626FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75964C433C8;
	Sun, 17 Sep 2023 19:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980615;
	bh=P/7bbUwXrpb4PrL0+RkWVpGg1KozRuNksUEphJvx7M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1JsKey2i8AK3U2hjLgA6qufc304g4f00OG2IT2wuXUCil3NH/2jEqDWPTue7nYrF
	 ouxb77betP6JZR3zY+eI4ufSlCi8bFqHulhII6JS1s4UGO8hcEZnFvjrkCL/VD7YZy
	 byPdxccyf6z0OohxtClLi6z8xTu3dWXT6xwrF7uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 244/285] regulator: raa215300: Fix resource leak in case of error
Date: Sun, 17 Sep 2023 21:14:04 +0200
Message-ID: <20230917191059.797074808@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit e21ac64e669e960688e79bf5babeed63132dac8a ]

The clk_register_clkdev() allocates memory by calling vclkdev_alloc() and
this memory is not freed in the error path. Similarly, resources allocated
by clk_register_fixed_rate() are not freed in the error path.

Fix these issues by using devm_clk_hw_register_fixed_rate() and
devm_clk_hw_register_clkdev().

After this, the static variable clk is not needed. Replace it with 
local variable hw in probe() and drop calling clk_unregister_fixed_rate()
from raa215300_rtc_unregister_device().

Fixes: 7bce16630837 ("regulator: Add Renesas PMIC RAA215300 driver")
Cc: stable@kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230816135550.146657-2-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/raa215300.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/raa215300.c b/drivers/regulator/raa215300.c
index 8e1a4c86b9789..253645696d0bb 100644
--- a/drivers/regulator/raa215300.c
+++ b/drivers/regulator/raa215300.c
@@ -38,8 +38,6 @@
 #define RAA215300_REG_BLOCK_EN_RTC_EN	BIT(6)
 #define RAA215300_RTC_DEFAULT_ADDR	0x6f
 
-static struct clk *clk;
-
 static const struct regmap_config raa215300_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -49,10 +47,6 @@ static const struct regmap_config raa215300_regmap_config = {
 static void raa215300_rtc_unregister_device(void *data)
 {
 	i2c_unregister_device(data);
-	if (!clk) {
-		clk_unregister_fixed_rate(clk);
-		clk = NULL;
-	}
 }
 
 static int raa215300_clk_present(struct i2c_client *client, const char *name)
@@ -130,10 +124,16 @@ static int raa215300_i2c_probe(struct i2c_client *client)
 		u32 addr = RAA215300_RTC_DEFAULT_ADDR;
 		struct i2c_board_info info = {};
 		struct i2c_client *rtc_client;
+		struct clk_hw *hw;
 		ssize_t size;
 
-		clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 32000);
-		clk_register_clkdev(clk, clk_name, NULL);
+		hw = devm_clk_hw_register_fixed_rate(dev, clk_name, NULL, 0, 32000);
+		if (IS_ERR(hw))
+			return PTR_ERR(hw);
+
+		ret = devm_clk_hw_register_clkdev(dev, hw, clk_name, NULL);
+		if (ret)
+			return dev_err_probe(dev, ret, "Failed to initialize clkdev\n");
 
 		if (np) {
 			int i;
-- 
2.40.1



