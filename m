Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC3518DB2A;
	Wed, 25 Feb 2026 01:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983155; cv=none; b=EYI6HuanzVp9yroEepztaLcDKZikJkNyJmzhF/Mmb3cBiKBGxmIlTgbFyYsgQg/0wG5+4UTfnYqVPAsY9ivDirFI8gnpX6df+wGSnsxtDNsuDUA7uk64xY8nLi45jRPgH2k04vvap91s7fDI8X8IFkakX+flhlquGEknZmzrrBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983155; c=relaxed/simple;
	bh=2gGFIjn0RBVcjQcAR8CNoxu6TixVvlxYG5pvUkrtgQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNRJQxVqjod0sxCt2H86jO8Sf5aIKqPhAQnjAomeNYHXG/9vwUT6hkmSusufzGt7lTom/hJAf6TgCxM+QQLaOhGpWwJMqTwuUbfot0K9yrTTVzSVHONycJkXiVeUcwLyem/np19mYY60OqTWddkDtixwVjG8I2nswtEkQvcWeAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0d9LFagd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0d9LFagd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EAAC116D0;
	Wed, 25 Feb 2026 01:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983155;
	bh=2gGFIjn0RBVcjQcAR8CNoxu6TixVvlxYG5pvUkrtgQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0d9LFagdhqQB3iGwz8y2XiTH/f5cpVQRf93tA+Is1UaCNq6DtyzksQPFGyKFegpUZ
	 xORQ2cFfTq/NRAK/eKwfX9oVi0LgkTH63gYKKCq6R2JDrUM0AjezQX5txhDx4mE5dS
	 TqDU+WXafJmv/ovkKnCgyW7alx+LKpFw/UkvzyVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 309/781] ASoC: cs4271: Fix resource leak in cs4271_soc_resume()
Date: Tue, 24 Feb 2026 17:16:58 -0800
Message-ID: <20260225012407.284599101@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit fef1f756155c30511397bbcd9d55640ab2e44d99 ]

Smatch detects this resource leak:

sound/soc/codecs/cs4271.c:548 cs4271_soc_resume() warn:
 'cs4271->clk' from clk_prepare_enable() not released on lines: 540,546.

Instead of direct returns, unprepare the clock and disable regulators on
the error paths.

Fixes: cf6bf51b5325 ("ASoC: cs4271: Add support for the external mclk")
Fixes: 9a397f473657 ("ASoC: cs4271: add regulator consumer support")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://patch.msgid.link/20260110195337.2522347-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs4271.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs4271.c b/sound/soc/codecs/cs4271.c
index 77dfc83a3c013..d8cdd37e9112b 100644
--- a/sound/soc/codecs/cs4271.c
+++ b/sound/soc/codecs/cs4271.c
@@ -528,7 +528,7 @@ static int cs4271_soc_resume(struct snd_soc_component *component)
 	ret = clk_prepare_enable(cs4271->clk);
 	if (ret) {
 		dev_err(component->dev, "Failed to enable clk: %d\n", ret);
-		return ret;
+		goto err_disable_regulators;
 	}
 
 	/* Do a proper reset after power up */
@@ -537,15 +537,21 @@ static int cs4271_soc_resume(struct snd_soc_component *component)
 	/* Restore codec state */
 	ret = regcache_sync(cs4271->regmap);
 	if (ret < 0)
-		return ret;
+		goto err_disable_clk;
 
 	/* then disable the power-down bit */
 	ret = regmap_update_bits(cs4271->regmap, CS4271_MODE2,
 				 CS4271_MODE2_PDN, 0);
 	if (ret < 0)
-		return ret;
+		goto err_disable_clk;
 
 	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(cs4271->clk);
+err_disable_regulators:
+	regulator_bulk_disable(ARRAY_SIZE(cs4271->supplies), cs4271->supplies);
+	return ret;
 }
 #else
 #define cs4271_soc_suspend	NULL
-- 
2.51.0



