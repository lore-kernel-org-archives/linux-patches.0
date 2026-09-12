Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A66747CC8A;
	Sat, 12 Sep 2026 13:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218105; cv=none; b=m2CxiiAfW7WF2U5eKX67l1XUl/Vrg2LgQgLt1OXHbZXCyrXL5OXvHV1YnyMBB+iyS0gS0VSowrIGNgX0YGyFBkUZbpFScga7rKckHq05lxlkAhBW7LYQj9Pzx1EZ1D6leglkWyRihNhyv1N8igyXloY0OnF/F6IEq80GfclLcOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218105; c=relaxed/simple;
	bh=LdR9vn+EmQDeVBmfJ1CEUMtI3oZtqJKe3LrzkJ2wz6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVNGe4WAeiCyGD/yrFKsnME+weUugG9eFJRABCRh+7GLOXq9onuRpe6jLrt6NthIaVT7G7gVCOk2DXWTM/Tyr5W0omoUTSA6dtt+GeonUxFtVS3naQ4uWLpm7NuUhr/O4Wx38tNTP0Eum7IPjKe9zdTdOTFGLWbQSPucWBnjF5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfWdXIeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfWdXIeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124FD1F000FF;
	Sat, 12 Sep 2026 13:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218104;
	bh=yrAGs6lM3oWbK1DDrYDbdnqVQXqx4W9Rww21w6gqiWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfWdXIeo1pgtmFetpP0SHPRQttDLzw9lrq1xDHkKyrtp1/AlMDxhtmxNSyj7LHZYq
	 zHWCJefm8D9bmE/eoaalGGUtRBeNzkXmD8x5kk4Ay6XQGm9zy8fu9Jg72MS+aOvVRU
	 j0VtsxVr8XI710iYDmerBjPwAVLzL6M+82XqvJyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1077/1376] ASoC: pxa: Use devm_clk_get_optional() for extclk clock
Date: Sat, 12 Sep 2026 08:58:23 +0200
Message-ID: <20260912065631.564490926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b8a3cb8b75978..ba8cae8e85ef5 100644
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



