Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EE84595B;
	Mon, 14 Oct 2024 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917623; cv=none; b=GiYv57S1dEAPNbEbWtw7mv05USNwvHQQi8236ESFozMAN0lCCgVy+kMprWuKLnOyDwzH+HEK1SJWSzf0Psf3p0ptyRE03/HsbkovIIwWwVEagKw07/sAyMNlKgAH39ix8Jl/226aWFpFpX8XHC9EWSQf++RoWDz7PgxIU84/O98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917623; c=relaxed/simple;
	bh=8GNUb8uIkd/+6CHex5WjZWSkKn3PErbuLOZN9itGIiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROZyDsGMZv+pHrTyqFLc5vj6lpgxrF2hcSIsA4HlaCaFy+TSifHnRvTxVGBTiuEhM9ACnPw2qrBTHPhcm1SnvHCV1IcBhqp61upmMNAbn2BumAb3Wpz3661FlpcmYpI7ekl0sNAqefWMn4ZSSNDmCgj/ZmkbQNbJHbQh2YFC8zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpMfP9rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpMfP9rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17495C4CEC3;
	Mon, 14 Oct 2024 14:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917623;
	bh=8GNUb8uIkd/+6CHex5WjZWSkKn3PErbuLOZN9itGIiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpMfP9rvflCi+aNQ4TAAzK4yZi/5/rVb1xWPmivSP5/Pg2o6CK1LAWjhf4Zhw975K
	 aCUGH/uYFu+249fm7FJAaMu5PYB8XibtbwIlGvpthDyhj5WVwdnzXKL1MH1G0wSp4J
	 w+uRcrFAMt1frZgSEoG4LxTtOwGV/JSO7YbYzug8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/798] ASoC: rt5682s: Return devm_of_clk_add_hw_provider to transfer the error
Date: Mon, 14 Oct 2024 16:10:38 +0200
Message-ID: <20241014141221.234585722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 80c673aa14db8..07d514b4ce707 100644
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



