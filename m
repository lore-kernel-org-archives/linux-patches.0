Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E691170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA99C433C8;
	Mon, 11 Sep 2023 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442582;
	bh=q3QJDsPNdZNlgWai0j+l4ArQvNX9d2IPQnAPU6gbVEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CF16Y+WWpqoaniyRSaUGNXIT+LM+vp583jNjlFXJGNdvuyJilZjaOcDWjWDjbBkz6
	 I0DYslqn+7XbsCptCMoSN0wvJCiDz0rzvPHfPcWIt8blq3hnTrcBSwFB4RK7S4ot6E
	 JnHoI2u57lyopbnyr+023ieugY/YIiE/6xB4NowI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 076/737] ASoC: rt1308-sdw: fix random louder sound
Date: Mon, 11 Sep 2023 15:38:55 +0200
Message-ID: <20230911134652.637332838@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 37aba3190891d4de189bd5192ee95220e295f34d ]

This patch uses a vendor register to check whether the system hibernated ever.
The driver will only set the preset when the driver brings up or the system hibernated.
It will avoid the unknown issue that makes the speaker output louder and can't control the volume.

Signed-off-by: Shuming Fan <shumingf@realtek.com
Link: https://lore.kernel.org/r/20230811093822.37573-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308-sdw.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1308-sdw.c b/sound/soc/codecs/rt1308-sdw.c
index 1797af824f60b..e2699c0b117be 100644
--- a/sound/soc/codecs/rt1308-sdw.c
+++ b/sound/soc/codecs/rt1308-sdw.c
@@ -52,6 +52,7 @@ static bool rt1308_volatile_register(struct device *dev, unsigned int reg)
 	case 0x300a:
 	case 0xc000:
 	case 0xc710:
+	case 0xcf01:
 	case 0xc860 ... 0xc863:
 	case 0xc870 ... 0xc873:
 		return true;
@@ -213,7 +214,7 @@ static int rt1308_io_init(struct device *dev, struct sdw_slave *slave)
 {
 	struct rt1308_sdw_priv *rt1308 = dev_get_drvdata(dev);
 	int ret = 0;
-	unsigned int tmp;
+	unsigned int tmp, hibernation_flag;
 
 	if (rt1308->hw_init)
 		return 0;
@@ -242,6 +243,10 @@ static int rt1308_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
+	regmap_read(rt1308->regmap, 0xcf01, &hibernation_flag);
+	if ((hibernation_flag != 0x00) && rt1308->first_hw_init)
+		goto _preset_ready_;
+
 	/* sw reset */
 	regmap_write(rt1308->regmap, RT1308_SDW_RESET, 0);
 
@@ -282,6 +287,12 @@ static int rt1308_io_init(struct device *dev, struct sdw_slave *slave)
 	regmap_write(rt1308->regmap, 0xc100, 0xd7);
 	regmap_write(rt1308->regmap, 0xc101, 0xd7);
 
+	/* apply BQ params */
+	rt1308_apply_bq_params(rt1308);
+
+	regmap_write(rt1308->regmap, 0xcf01, 0x01);
+
+_preset_ready_:
 	if (rt1308->first_hw_init) {
 		regcache_cache_bypass(rt1308->regmap, false);
 		regcache_mark_dirty(rt1308->regmap);
-- 
2.40.1



