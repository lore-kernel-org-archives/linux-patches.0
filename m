Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E4E1D0E3A;
	Wed,  2 Oct 2024 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877640; cv=none; b=ZmaUIHP0bwrRNcfAai3KQVjpBFP1JZRd4x3C+g84dfOxn0FCmQ2f92O8sK9LSY3dsmKcroH2P7Hw3khne8CS6KZ6pRy0k/EtOg1JChFqWtCZv9n48lRlkG4tI6SbjI1plPWm6PFiI+Twv9A6JxAXzGI06OSOlE1zxZktIsxtJJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877640; c=relaxed/simple;
	bh=d8sAm0dNBHGaDRWdnsuWN31E2ZKH8ejg9RzGlFgflOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+QM2Fy8UUQZwmyobwg5JHLj4RbgiEmCKteNzk192dyv0wj9NhiCWSDpxw4IsZF/I5CADEuuuJ9rBv4FcFHtw65GF8+xVVfqeHQjZYtMITjQGzzNQraQqCEa7dx1GeoO8qZL5s8LPtPQ3jceHLSCT2WW62KEaZ+a9cHe4mH8uR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGfhMCKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGfhMCKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8887C4CEC2;
	Wed,  2 Oct 2024 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877640;
	bh=d8sAm0dNBHGaDRWdnsuWN31E2ZKH8ejg9RzGlFgflOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGfhMCKsL2fV0ZII5dok4/5OxYs/I83NKqcwfi20kKWAo65nshlgcvQkuwWJAyLdN
	 uWg0Kjy9at+Pyc9+ohhdqpffSvISeW+8/+1EjA5RGYq3kmwNGGCUFXfrJpHA2mKM/Z
	 HvTlDLm4awBBo4JOG83FDnaCwO65A6pEP9hY7Jlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 144/634] ASoC: rt5682s: Return devm_of_clk_add_hw_provider to transfer the error
Date: Wed,  2 Oct 2024 14:54:04 +0200
Message-ID: <20241002125816.789827606@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 3ff810b9bebe5578a245cfa97c252ab602e703f1 ]

Return devm_of_clk_add_hw_provider() in order to transfer the error, if it
fails due to resource allocation failure or device tree clock provider
registration failure.

Fixes: bdd229ab26be ("ASoC: rt5682s: Add driver for ALC5682I-VS codec")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20240717115436.3449492-1-make24@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index f50f196d700d7..ce2e88e066f3e 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -2828,7 +2828,9 @@ static int rt5682s_register_dai_clks(struct snd_soc_component *component)
 		}
 
 		if (dev->of_node) {
-			devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, dai_clk_hw);
+			ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, dai_clk_hw);
+			if (ret)
+				return ret;
 		} else {
 			ret = devm_clk_hw_register_clkdev(dev, dai_clk_hw,
 							  init.name, dev_name(dev));
-- 
2.43.0



