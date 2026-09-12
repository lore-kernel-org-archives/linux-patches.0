Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91555344DB5;
	Sat, 12 Sep 2026 08:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203344; cv=none; b=Dbw2mXJY2nJuoXwuhzqGuG5KIMXEY21nmcCXxbCxT69q85mNP95pKoCEN7Kt+oAC3n3VYcjvMVTkN/zu1NHTKA202GOveARl0lxT1kS1wR+KcUNJy75ZnBsBeOQKOgGgHinEs+FUqTElZ0strcxzYi09gT7tdHhEzgXIYUMxBv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203344; c=relaxed/simple;
	bh=s7Xc9DWTa9SDKCIrPVKGC4UtsazEEvF6StgUJ59RA4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyJZnvCohznSWM9S+KEEOO1ef0KXzuI7Zb/jVCvP+R8wq8LDehuwBV6Okc0TFizYk+/ogx6Nx1WUPwFkDpCnHAvSh945xOEE2xb5MPM4kRqgfHHGp0kNQsmIjrTHIlVZYjWaF1KeEHYI6Xk5IRfcD6hsw9gzADaZne0WeYKDmOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYBVuPdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYBVuPdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205851F000FF;
	Sat, 12 Sep 2026 08:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203343;
	bh=v/FeYuNCPaR78Eu/WxSOmhu/DJwsOw2Sg9HgOeUcZrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYBVuPdJorNNmBGndV667lpL7D/CkSZnk9oKuZ7FFD2OCMZMlv0i4Kjhzv1TtQGrf
	 /hwH1+CvS3LJUL4zE5C42DGyRN8uG41xRCXbCopWp3NanuZlZC6CWJmY4OmbNgHEL8
	 MWo5UFs+OEj1NHzkG2qXiHagS6bGKXPBQtsuU+u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1372/1815] ASoC: pxa: Use devm_clk_get_optional() for extclk clock
Date: Sat, 12 Sep 2026 08:52:02 +0200
Message-ID: <20260912065721.238347041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f8054c1c59fae..3a0abcb0bfbdf 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -769,13 +769,10 @@ static int pxa_ssp_probe(struct snd_soc_dai *dai)
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



