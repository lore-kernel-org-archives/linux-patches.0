Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40466FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE99C433EF;
	Mon, 16 Jan 2023 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888671;
	bh=i+wsdH6MLIKpKS/H86ktb4cMdxhxBkD4ZmdiYTP2vEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=td1YpqpGO3IfDMktcs3DEjPrUV0ClXlKGdEXwOafP4JvprijIq1JzQ7yL6rQc4lkq
	 XWli8mnsIU4gSAIjLVC1io3pIk5nwIiXecmq39ah7WNjMsoe+jHb4hHv3GqokDV3uF
	 8+58xSD0mQwy5VKdfAjz3t0f9zBYw9fHVtn6wWGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 095/338] ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe
Date: Mon, 16 Jan 2023 16:49:28 +0100
Message-Id: <20230116154825.035449784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index 940bdc30753d..166ac1f5f2c1 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -1472,7 +1472,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-in\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_in = val;
 		}
@@ -1481,7 +1481,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-out\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_out = val;
 		}
@@ -1490,12 +1490,12 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
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



