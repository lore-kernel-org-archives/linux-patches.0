Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B177547AF69;
	Sat, 12 Sep 2026 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231514; cv=none; b=fkDPAavuaMS74RGkyppP45A7TPK46un8K3O6eWqxLrk/hMn9FzG6K44717XpAXNY4W2hYpkrkgkWdWnzOMpqaQqwI5kKMzYWLihzCBUZkOFp03rO3aHCQvAncUePyFx5AhEUYOgvVAC681wClK68uB/iu5kbI1+LHqWZfSLJXwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231514; c=relaxed/simple;
	bh=WfWa7ddSQX0y+ExuaAtm/9k73mTfOUCn3yMMMw/ZFzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Shw2Ccr/5RiyDR0WOGHEoK/LKroP/sW/lu/AABQ05BhiOeGo5GC5bJL2VGh73BgrDzITO/QN9OivOO7QsKLamrPxG0lPb00tZvHke8jSd+eXhEMQgS62eGrYGKpkp+zFns1igkJbvNT3/UJq93Nl08qHh58BIZcsuy/4Gie9cHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2Y08KSQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2Y08KSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537F91F000FF;
	Sat, 12 Sep 2026 16:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231513;
	bh=yqNuNcbEdaHxKGbCfynMjRoAKETdbSvxcbNMPJSjoAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2Y08KSQppXyFcm24iUpbrqQ4WNQUt38vehMdTM3bHzDbW3YKvMgWDuY7Nv8oWcZX
	 oGffeiTS5w5i0CTGiOqe4ttHBZ/sLx3LaHPWAbdHmvdGNhW9y1M5hPWTwCdFSO5G7g
	 mdzIlaft/HbcKj9/ucGhyZNK/Y3PsG3i0OZiOnpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0971/1191] ASoC: pxa: Use devm_clk_get_optional() for extclk clock
Date: Sat, 12 Sep 2026 09:01:39 +0200
Message-ID: <20260912065610.021870555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 452f0caf415b9..3db97b6db1390 100644
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



