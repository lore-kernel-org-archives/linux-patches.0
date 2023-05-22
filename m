Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1264171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B5DC4339B;
	Mon, 22 May 2023 19:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783775;
	bh=1WnxCxk6IFMrkNcNVA6AxoWPL4QYuyQycSiGgafzcB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ul12yTFrpOy1MjFgWx4VpcvWaNeioQU4YLpwkypcJb8snV+/EjOPh4PylZ5kG5x9j
	 n6v41c2lSrp6DZtvp7RHzZ91UdwiDm0ChU646ep6jpNJ+G5iuqC1Bs9DV30Wz+AgNF
	 Xs2Wt4G4cRSqhRBzaxppqTNojZ2/hxj1tY3a7lSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/292] ASoC: fsl_micfil: Fix error handler with pm_runtime_enable
Date: Mon, 22 May 2023 20:08:36 +0100
Message-Id: <20230522190409.938472319@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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

[ Upstream commit 17955aba7877a4494d8093ae5498e19469b01d57 ]

There is error message when defer probe happens:

fsl-micfil-dai 30ca0000.micfil: Unbalanced pm_runtime_enable!

Fix the error handler with pm_runtime_enable and add
fsl_micfil_remove() for pm_runtime_disable.

Fixes: 47a70e6fc9a8 ("ASoC: Add MICFIL SoC Digital Audio Interface driver.")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com
Link: https://lore.kernel.org/r/1683540996-6136-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 4b8fe9b8be407..3a03f49452fa3 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -712,7 +712,7 @@ static int fsl_micfil_probe(struct platform_device *pdev)
 	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to pcm register\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	fsl_micfil_dai.capture.formats = micfil->soc->formats;
@@ -722,9 +722,20 @@ static int fsl_micfil_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register component %s\n",
 			fsl_micfil_component.name);
+		goto err_pm_disable;
 	}
 
 	return ret;
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+
+	return ret;
+}
+
+static void fsl_micfil_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
 }
 
 static int __maybe_unused fsl_micfil_runtime_suspend(struct device *dev)
@@ -785,6 +796,7 @@ static const struct dev_pm_ops fsl_micfil_pm_ops = {
 
 static struct platform_driver fsl_micfil_driver = {
 	.probe = fsl_micfil_probe,
+	.remove_new = fsl_micfil_remove,
 	.driver = {
 		.name = "fsl-micfil-dai",
 		.pm = &fsl_micfil_pm_ops,
-- 
2.39.2



