Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9480643ACD
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKlOaxw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43240C4AF7A;
	Wed, 15 Nov 2023 20:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081422;
	bh=LCYIvIPLo5UTJE+xfmT0R8HGUQrc3xxF6NCOGvMXYRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKlOaxw3ICf38Yv4Vl/Aq14S36YtvfrzdAaLvoiSY9qY61O1dyk4BiyQ7tbzkGkOb
	 d8KhrXZi8qRkaQPg/OuNm+2UBj0cvW56pJlNx/JfJaZM8lKh5F4y1oQ+vzGVbP7gib
	 H9WgLTfxm5PS4C22EF9CwVoBRhtqZ3jU2V6aUq14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/244] ASoC: fsl: Fix PM disable depth imbalance in fsl_easrc_probe
Date: Wed, 15 Nov 2023 15:35:37 -0500
Message-ID: <20231115203557.038801948@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit 9e630efb5a4af56fdb15aa10405f5cfd3f5f5b83 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by calling
pm_runtime_disable when error returns.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Link: https://lore.kernel.org/r/tencent_C0D62E6D89818179A02A04A0C248F0DDC40A@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index cf0e10d17dbe3..c7ff48208d005 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -1965,17 +1965,21 @@ static int fsl_easrc_probe(struct platform_device *pdev)
 					      &fsl_easrc_dai, 1);
 	if (ret) {
 		dev_err(dev, "failed to register ASoC DAI\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = devm_snd_soc_register_component(dev, &fsl_asrc_component,
 					      NULL, 0);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register ASoC platform\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	return 0;
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+	return ret;
 }
 
 static int fsl_easrc_remove(struct platform_device *pdev)
-- 
2.42.0



