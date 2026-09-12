Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7EF383C88;
	Sat, 12 Sep 2026 19:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240016; cv=none; b=WbIe4QY0xf3Dy0w+LnVWgjz4Xk1v2mPY3zFmII/el5U83r34Rl2KOnqH3GJL3yIC4kQE/2Iyb1WxkOoWLWkeek/XCEoG5++geOCZqIRSHzmyAz/TgFiJptKhbEXM94eTlQX5eCRgeO5J3JYCzcttm1bamqFXhaje0C07I0+PHoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240016; c=relaxed/simple;
	bh=vFPQd/F48LiFwU+tKvzO1u2vYu14+RSXRyyyJZTL7tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0lADa/CQX6wqt2syThnjFW/LAgCB7SpkkGKysdcDMKqJEJheFIV9HXqB2H2HGj20LM/9KAnfHIjWJnoz7aZUcXz3Ze3kVInBZ33MfOzOjmuD3ZttWyNCUnoS+XrYHe/cF5ODACmkr80lbXoNzMmI0VzfWVcHFhOi1/VWd0eibg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRxcDx3L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRxcDx3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB98B1F000FF;
	Sat, 12 Sep 2026 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240014;
	bh=mGbEw9+BNzRNAJQdks8cAdexDsq+S4z2x1HSxSpOT6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRxcDx3LoIv72nzMmW9Pg7ehiNU+8dTojWzqEuZIh9fqsVrdI8bFS8z7SCScQ6iva
	 E/JgARIefE8UpeQAvufCOOpjAcKI56WoGO3yTIYdCzk3+svJMay63k+3v6k6bVhMZI
	 3mFjXjB8GW2FJMUKQz9JhXbchStxKu69BOKRHy1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 783/935] ASoC: pxa: Use devm_clk_get_optional() for extclk clock
Date: Sat, 12 Sep 2026 09:03:33 +0200
Message-ID: <20260912065544.787011514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 6ec64d757af9b75a3c64f9f7dad76bdc1efc06ca ]

The Device Tree binding defines the extclk clock as an optional
property, but the driver currently uses devm_clk_get() and manually
handles the absence of the clock.

Use devm_clk_get_optional() to match the binding and simplify the
optional clock handling. This also propagates errors other than the
absence of the optional clock, including -EPROBE_DEFER.

This changes the existing behavior for errors other than
-EPROBE_DEFER. RFC to discuss whether these errors should cause probe
to fail rather than being treated as an unavailable optional clock.

Fixes: 90eb6b59d311 ("ASoC: pxa-ssp: add support for an external clock in devicetree")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260811100949.61142-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/pxa/pxa-ssp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index d6a2af293f458..69029000b3b3b 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -775,13 +775,10 @@ static int pxa_ssp_probe(struct snd_soc_dai *dai)
 			goto err_priv;
 		}
 
-		priv->extclk = devm_clk_get(dev, "extclk");
+		priv->extclk = devm_clk_get_optional(dev, "extclk");
 		if (IS_ERR(priv->extclk)) {
 			ret = PTR_ERR(priv->extclk);
-			if (ret == -EPROBE_DEFER)
-				goto err_priv;
-
-			priv->extclk = NULL;
+			goto err_priv;
 		}
 	} else {
 		priv->ssp = pxa_ssp_request(dai->id + 1, "SoC audio");
-- 
2.53.0



