Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A0C1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9Xb3/eB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6F9C433C7;
	Wed,  4 Oct 2023 18:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443542;
	bh=0QxYENzu4fX5bKSNoJqCfMXQnL1TJg5QfxEMmI52GXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9Xb3/eB6Xp6Q+P5g23uHII8BKmdbd7TWRg1rsfnEKjHVZ2X3EW6+rE0EpZaqYecL
	 doRhWKUSXpbvrWzAdFZTG8GYDKzfeQ5hrOBL76bLRrQpwknZ/f3j7OXij2TWk2+XaZ
	 yXJbCHjd+6CjatSWMpXqxYhe/p0DTBPKKQHwQ+xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/259] ASoC: imx-rpmsg: Set ignore_pmdown_time for dai_link
Date: Wed,  4 Oct 2023 19:55:59 +0200
Message-ID: <20231004175225.837539012@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit fac58baf8fcfcd7481e8f6d60206ce2a47c1476c ]

i.MX rpmsg sound cards work on codec slave mode. MCLK will be disabled
by CPU DAI driver in hw_free(). Some codec requires MCLK present at
power up/down sequence. So need to set ignore_pmdown_time to power down
codec immediately before MCLK is turned off.

Take WM8962 as an example, if MCLK is disabled before DAPM power down
playback stream, FIFO error will arise in WM8962 which will have bad
impact on playback next.

Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20230913102656.2966757-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-rpmsg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/fsl/imx-rpmsg.c b/sound/soc/fsl/imx-rpmsg.c
index 4d99f4858a14f..76c6febf24990 100644
--- a/sound/soc/fsl/imx-rpmsg.c
+++ b/sound/soc/fsl/imx-rpmsg.c
@@ -88,6 +88,14 @@ static int imx_rpmsg_probe(struct platform_device *pdev)
 			    SND_SOC_DAIFMT_NB_NF |
 			    SND_SOC_DAIFMT_CBC_CFC;
 
+	/*
+	 * i.MX rpmsg sound cards work on codec slave mode. MCLK will be
+	 * disabled by CPU DAI driver in hw_free(). Some codec requires MCLK
+	 * present at power up/down sequence. So need to set ignore_pmdown_time
+	 * to power down codec immediately before MCLK is turned off.
+	 */
+	data->dai.ignore_pmdown_time = 1;
+
 	/* Optional codec node */
 	ret = of_parse_phandle_with_fixed_args(np, "audio-codec", 0, 0, &args);
 	if (ret) {
-- 
2.40.1



