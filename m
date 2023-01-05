Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B558494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD18C433D2;
	Thu,  5 Jan 2023 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923612;
	bh=8VOqvNRQ9LkhVcGqWpvSJK4VO82BywRUzm2Yx2+pgzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TwLn9WVRbK1RpODy+IkiSB/Z9yngQ7FYmvKnWfy7zUvk3GN/IA5GovZIWjQ2wtl4K
	 KOzNygE0LL8XRolcNyAczwvEy3+mrqaRJSyLXDsW2x0FBYO44aJ8DXYPjzSyzYupLD
	 L3aXCQb4buaIlQJtFG3jmerj0/2n59ty7J/paGK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 076/251] ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe
Date: Thu,  5 Jan 2023 13:53:33 +0100
Message-Id: <20230105125338.253924782@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 97b801be6f8e53676b9f2b105f54e35c745c1b22 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by going to
err_pm instead of err_clk.

Fixes:f086ba9d5389c ("ASoC: pcm512x: Support mastering BCLK/LRCLK using the PLL")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220928160402.126140-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm512x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index c0807b82399a..614d39258e40 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -1475,7 +1475,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-in\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_in = val;
 		}
@@ -1484,7 +1484,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-out\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_out = val;
 		}
@@ -1493,12 +1493,12 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			dev_err(dev,
 				"Error: both pll-in and pll-out, or none\n");
 			ret = -EINVAL;
-			goto err_clk;
+			goto err_pm;
 		}
 		if (pcm512x->pll_in && pcm512x->pll_in == pcm512x->pll_out) {
 			dev_err(dev, "Error: pll-in == pll-out\n");
 			ret = -EINVAL;
-			goto err_clk;
+			goto err_pm;
 		}
 	}
 #endif
-- 
2.35.1



