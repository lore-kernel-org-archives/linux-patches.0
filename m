Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971AE6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C9AC433CD;
	Sun, 17 Sep 2023 19:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980611;
	bh=Xc4Dztb/+WFXUv0Zi81Xz4/bxsHRxVl33b4jdQl7iIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyCLecM44yhJkv4f1P6wOIidJf9JIMHBTJ5JDR7gLu0WgpBVwKH3Oxqq/+ngEi+aA
	 LQv6CNDRVexsWgC4QTinSs+WnImpCMQLHq+m038l170bGB97lSUYe9n549m48eAXdx
	 xGUf/U2FBLe+tuhnHcV6dntFmXnjTiEsCenacPns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 243/285] regulator: raa215300: Change the scope of the variables {clkin_name, xin_name}
Date: Sun, 17 Sep 2023 21:14:03 +0200
Message-ID: <20230917191059.769363564@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 42a95739c5bc4d7a6e93a43117e9283598ba2287 ]

Change the scope of the variables {clkin_name, xin_name} from global->local
to fix the below warning.

drivers/regulator/raa215300.c:42:12: sparse: sparse: symbol 'xin_name' was
not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306250552.Fan9WTiN-lkp@intel.com/
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230629104200.102663-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e21ac64e669e ("regulator: raa215300: Fix resource leak in case of error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/raa215300.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/raa215300.c b/drivers/regulator/raa215300.c
index 24a1c89f5dbc9..8e1a4c86b9789 100644
--- a/drivers/regulator/raa215300.c
+++ b/drivers/regulator/raa215300.c
@@ -38,8 +38,6 @@
 #define RAA215300_REG_BLOCK_EN_RTC_EN	BIT(6)
 #define RAA215300_RTC_DEFAULT_ADDR	0x6f
 
-const char *clkin_name = "clkin";
-const char *xin_name = "xin";
 static struct clk *clk;
 
 static const struct regmap_config raa215300_regmap_config = {
@@ -71,8 +69,10 @@ static int raa215300_clk_present(struct i2c_client *client, const char *name)
 static int raa215300_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
-	const char *clk_name = xin_name;
+	const char *clkin_name = "clkin";
 	unsigned int pmic_version, val;
+	const char *xin_name = "xin";
+	const char *clk_name = NULL;
 	struct regmap *regmap;
 	int ret;
 
@@ -114,15 +114,17 @@ static int raa215300_i2c_probe(struct i2c_client *client)
 	ret = raa215300_clk_present(client, xin_name);
 	if (ret < 0) {
 		return ret;
-	} else if (!ret) {
+	} else if (ret) {
+		clk_name = xin_name;
+	} else {
 		ret = raa215300_clk_present(client, clkin_name);
 		if (ret < 0)
 			return ret;
-
-		clk_name = clkin_name;
+		if (ret)
+			clk_name = clkin_name;
 	}
 
-	if (ret) {
+	if (clk_name) {
 		char *name = pmic_version >= 0x12 ? "isl1208" : "raa215300_a0";
 		struct device_node *np = client->dev.of_node;
 		u32 addr = RAA215300_RTC_DEFAULT_ADDR;
-- 
2.40.1



