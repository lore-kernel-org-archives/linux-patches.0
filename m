Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA780357720;
	Wed,  3 Dec 2025 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779859; cv=none; b=LRj3Th03NgV/OukjF/91f6a1FNz5s0n19OTpjmNXEKeisZ9H5SFp/WbiBOMnUJUcWOlclWqOuDou34kZuWXddFdF9tuX7P4mL+VfkDcGSiDdmickxhD4ngmzZHt0ukdwZCqBhGeWHMJpDO2oLlQ/e48W+dMmvoyzwsC3yctVfEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779859; c=relaxed/simple;
	bh=y/JirUQ/lT668CX5M4LBJVkVVxzjiLVDcjI58zy2kBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jarzPrH5ySBprIYgyfc10DsD8Sq9QShoA/FtRDDQ0J0pm8q6eiQPOErd+F8OkUbGWaA5lgAHd/XwR6uYMXp/LLQzC0JuAiSMCh9w4Vh/R8ksk1RK7DKcpO8pnHlGSyaHMkX2tzXvIEOmKxiWIDoi0f7zoKhg2+v9VcDXwNqJHqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRlTK6IS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRlTK6IS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B898C4CEF5;
	Wed,  3 Dec 2025 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779859;
	bh=y/JirUQ/lT668CX5M4LBJVkVVxzjiLVDcjI58zy2kBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRlTK6ISY71iYKlnukkyMVMZHUh1gfYcuC23p0PI/IYy16PkOjJatbjES1UUZayqc
	 hO3tHK21ZstOkSNpGVSGUD283nNBvQ1CyP2iypHF6RvEwnZVhaYFbyisM1JPG11AyQ
	 4PimTAvcB9XIPZdqgxP2plLru7NiEEqMpHlVOLdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 382/568] ASoC: cs4271: Fix regulator leak on probe failure
Date: Wed,  3 Dec 2025 16:26:24 +0100
Message-ID: <20251203152454.687172211@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 6b6eddc63ce871897d3a5bc4f8f593e698aef104 ]

The probe function enables regulators at the beginning
but fails to disable them in its error handling path.
If any operation after enabling the regulators fails,
the probe will exit with an error, leaving the regulators
permanently enabled, which could lead to a resource leak.

Add a proper error handling path to call regulator_bulk_disable()
before returning an error.

Fixes: 9a397f473657 ("ASoC: cs4271: add regulator consumer support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251105062246.1955-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs4271.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs4271.c b/sound/soc/codecs/cs4271.c
index 2021cf4426061..f6c9430612f53 100644
--- a/sound/soc/codecs/cs4271.c
+++ b/sound/soc/codecs/cs4271.c
@@ -594,17 +594,17 @@ static int cs4271_component_probe(struct snd_soc_component *component)
 
 	ret = regcache_sync(cs4271->regmap);
 	if (ret < 0)
-		return ret;
+		goto err_disable_regulator;
 
 	ret = regmap_update_bits(cs4271->regmap, CS4271_MODE2,
 				 CS4271_MODE2_PDN | CS4271_MODE2_CPEN,
 				 CS4271_MODE2_PDN | CS4271_MODE2_CPEN);
 	if (ret < 0)
-		return ret;
+		goto err_disable_regulator;
 	ret = regmap_update_bits(cs4271->regmap, CS4271_MODE2,
 				 CS4271_MODE2_PDN, 0);
 	if (ret < 0)
-		return ret;
+		goto err_disable_regulator;
 	/* Power-up sequence requires 85 uS */
 	udelay(85);
 
@@ -614,6 +614,10 @@ static int cs4271_component_probe(struct snd_soc_component *component)
 				   CS4271_MODE2_MUTECAEQUB);
 
 	return 0;
+
+err_disable_regulator:
+	regulator_bulk_disable(ARRAY_SIZE(cs4271->supplies), cs4271->supplies);
+	return ret;
 }
 
 static void cs4271_component_remove(struct snd_soc_component *component)
-- 
2.51.0



