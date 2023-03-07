Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB42BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA143C433D2;
	Tue,  7 Mar 2023 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210041;
	bh=HRuhTwIMZKalMbqJSBvzh0ZM8EGz5WmyxYuKzj/Ec18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AT4hzHG84IL2OU1DE8/4HbS4MlcBn52L4cS+JcTZfPWHjT16ZTOwGHPRmrssQL/Wc
	 A3hyGG8eWLa0naMPBdkdM8BnAwsxhH/de9uQiABmaDa7E75DHZhEDgRFuyNglWGz4o
	 2we05ndFwdgXL4+FReGJ+67qxzWZKMyohU4JcXbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0413/1001] ASoC: mchp-spdifrx: Fix uninitialized use of mr in mchp_spdifrx_hw_params()
Date: Tue,  7 Mar 2023 17:53:05 +0100
Message-Id: <20230307170039.254429322@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 218674a45930c700486d27b765bf2f1b43f8cbf7 ]

Clang warns:

  ../sound/soc/atmel/mchp-spdifrx.c:455:3: error: variable 'mr' is uninitialized when used here [-Werror,-Wuninitialized]
                  mr |= SPDIFRX_MR_ENDIAN_BIG;
                  ^~
  ../sound/soc/atmel/mchp-spdifrx.c:432:8: note: initialize the variable 'mr' to silence this warning
          u32 mr;
                ^
                 = 0
  1 error generated.

Zero initialize mr so that these bitwise OR and assignment operation
works unconditionally.

Fixes: fa09fa60385a ("ASoC: mchp-spdifrx: fix controls which rely on rsr register")
Link: https://github.com/ClangBuiltLinux/linux/issues/1797
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230202-mchp-spdifrx-fix-uninit-mr-v1-1-629a045d7a2f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index b81fc77728dfc..76ce37f641ebd 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -362,7 +362,7 @@ static int mchp_spdifrx_hw_params(struct snd_pcm_substream *substream,
 				  struct snd_soc_dai *dai)
 {
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
-	u32 mr;
+	u32 mr = 0;
 	int ret;
 
 	dev_dbg(dev->dev, "%s() rate=%u format=%#x width=%u channels=%u\n",
-- 
2.39.2



