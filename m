Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47FB2BE65B;
	Sat, 12 Sep 2026 20:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243216; cv=none; b=C3UJYSn4Nq5FVQGbkSSXVsmlTPN48owBGPy0deTPCZBzJoVUWAeWwo0RELWf5QZc1sdvSYoVkiD+j3aXStNf2mnYItqor3hboPjioo5T50qrwDJqvfgEpnsy+RDMumH88JqILbhbehetDZ+lky/mcngrRykcX74CWAX3ODwlsZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243216; c=relaxed/simple;
	bh=KuyE+zGiZsu/Kz9SMNgIUC4k59CtkDfDfgxX2WzZ4ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJU/j0tdwAvyAV5KSneIKHeAlfad8iHx/lkj946/2szZwd2S0TJC2lsKIU8l0BpwGyy7JXfLv0ctOT/p09UXnkL8FpSY3TRzMt7UbizByN73cyNRPmGt7fqCF9VbhHLUGp0RbGzgIMMT0RrgLdkUyI9BY/INviKWFrxqfxrFfGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uu1WNUBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uu1WNUBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95881F000FF;
	Sat, 12 Sep 2026 20:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243214;
	bh=8BSpHx88d+ZQGV8dKOzssEzzag+EVps3BDfBylWLVH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uu1WNUBWrJen9uLAMhvMCS2v0QW4Pzo26Zqfa2KHZ46HuRUerKuTffKYr8GZR8bda
	 DCTHlBY3fmeW4Go8JzBxqDpJ4mDzckBA6xBnLxdVJKu86dRMl3Akv6c4rk71aE2znJ
	 qy0jAp11SzlVp1GWqlACxMhjcllHc1b6gx/bBFes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 677/798] ASoC: pxa: Use devm_clk_get_optional() for extclk clock
Date: Sat, 12 Sep 2026 09:05:05 +0200
Message-ID: <20260912065532.617605864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d847263a18b93..38440defd1fa2 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -793,13 +793,10 @@ static int pxa_ssp_probe(struct snd_soc_dai *dai)
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



