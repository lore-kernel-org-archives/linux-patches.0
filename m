Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB70E51008;
	Mon,  8 Jan 2024 15:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIqw4foT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD701C433AB;
	Mon,  8 Jan 2024 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726641;
	bh=TFAtQBxZoL8jnYl6VSWveBsLM6d33s4eEL2d69OruCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIqw4foTu1k12pwF9LTPkItHLVi6amyuDHGJrk5/kY5r3IDjvLJ2g08pFMy6rhgsL
	 pze6Ry9FJWa7g9Cs6nlmO7o2wURAGo2ATdA4vcUZuM8W1PTxpOJfRcI6lnZVB7zWJL
	 UaI5bKCaFknIpawxHETfKVZq1/wVTt6S+AVxa1E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/124] ASoC: fsl_rpmsg: Fix error handler with pm_runtime_enable
Date: Mon,  8 Jan 2024 16:07:38 +0100
Message-ID: <20240108150604.456231671@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit f9d378fc68c43fd41b35133edec9cd902ec334ec ]

There is error message when defer probe happens:

fsl_rpmsg rpmsg_audio: Unbalanced pm_runtime_enable!

Fix the error handler with pm_runtime_enable.

Fixes: b73d9e6225e8 ("ASoC: fsl_rpmsg: Add CPU DAI driver for audio base on rpmsg")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20231225080608.967953-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_rpmsg.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_rpmsg.c b/sound/soc/fsl/fsl_rpmsg.c
index abe19a8a7aa72..f7180f1959dd0 100644
--- a/sound/soc/fsl/fsl_rpmsg.c
+++ b/sound/soc/fsl/fsl_rpmsg.c
@@ -239,7 +239,7 @@ static int fsl_rpmsg_probe(struct platform_device *pdev)
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
 					      &fsl_rpmsg_dai, 1);
 	if (ret)
-		return ret;
+		goto err_pm_disable;
 
 	rpmsg->card_pdev = platform_device_register_data(&pdev->dev,
 							 "imx-audio-rpmsg",
@@ -249,16 +249,22 @@ static int fsl_rpmsg_probe(struct platform_device *pdev)
 	if (IS_ERR(rpmsg->card_pdev)) {
 		dev_err(&pdev->dev, "failed to register rpmsg card\n");
 		ret = PTR_ERR(rpmsg->card_pdev);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	return 0;
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+	return ret;
 }
 
 static void fsl_rpmsg_remove(struct platform_device *pdev)
 {
 	struct fsl_rpmsg *rpmsg = platform_get_drvdata(pdev);
 
+	pm_runtime_disable(&pdev->dev);
+
 	if (rpmsg->card_pdev)
 		platform_device_unregister(rpmsg->card_pdev);
 }
-- 
2.43.0



