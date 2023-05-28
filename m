Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E13D569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD62C433EF;
	Sun, 28 May 2023 19:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301846;
	bh=zHAYHZ3I3PBKqoRHkwu96WrEYje4FitCYLS1suAjxpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlnDfkrQ68DBjinCJUjJ2Yjvad1XXml6LXGbeInyYc3G+3xWEncna+6s9a7dMF5cI
	 frMs1REFJqWfEK8MyM8AP08AiXXBkIpiRb7SrBxDMoONFvRszIH01xc39f7mJ8hTcN
	 i/pJK1PGkQkntCnkgpRBJB4QsoM+kX7qxrGf7xzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/161] ASoC: fsl_micfil: register platform component before registering cpu dai
Date: Sun, 28 May 2023 20:09:43 +0100
Message-Id: <20230528190839.066519672@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 0adf292069dcca8bab76a603251fcaabf77468ca ]

There is no defer probe when adding platform component to
snd_soc_pcm_runtime(rtd), the code is in snd_soc_add_pcm_runtime()

snd_soc_register_card()
  -> snd_soc_bind_card()
    -> snd_soc_add_pcm_runtime()
      -> adding cpu dai
      -> adding codec dai
      -> adding platform component.

So if the platform component is not ready at that time, then the
sound card still registered successfully, but platform component
is empty, the sound card can't be used.

As there is defer probe checking for cpu dai component, then register
platform component before cpu dai to avoid such issue.

Fixes: 47a70e6fc9a8 ("ASoC: Add MICFIL SoC Digital Audio Interface driver.")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1630665006-31437-4-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index b33746d586337..6285ee8f829e5 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -740,18 +740,23 @@ static int fsl_micfil_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(&pdev->dev);
 
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
+	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to pcm register\n");
+		return ret;
+	}
+
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_micfil_component,
 					      &fsl_micfil_dai, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register component %s\n",
 			fsl_micfil_component.name);
-		return ret;
 	}
 
-	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
-	if (ret)
-		dev_err(&pdev->dev, "failed to pcm register\n");
-
 	return ret;
 }
 
-- 
2.39.2



