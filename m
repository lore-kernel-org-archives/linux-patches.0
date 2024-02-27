Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B7E13AA4C;
	Tue, 27 Feb 2024 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044133; cv=none; b=jq76UilG7DdwC0c5XpR8u/ZOy+OsUhy4wlAh/FxVKj9XwlIs6BcJM30UnHEC5vOVgf3tDakUMKvMo3xZc3hdwoOZ8KgBdeuQlOrvIlxYn3+3G4dM7EDBZ2piLRfyR8uIuvjTUsMcYbDYst+j2hh66lIUHlb8ywYP4379ybkYqcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044133; c=relaxed/simple;
	bh=nUuQZ2gRDrTt9SjRzI+gG2AVYDcZowhMy0Or3iQ/DG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBGcOGguzb4fRLTS8tyx4FFouwuyrbfexILwj8JK9z0XOxBkbDyBD3KClPT/RsDHPu65d0+te39pTjXfTtDRAITzRKqeQu70vlpFZ7mvn3tHkZCLncQLZbWKeJmLh7PXZE/IUf9t0xZvgz4NtjtVW+9vyQwDxhQbLbo2mY8lsXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dwj/icJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dwj/icJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4313BC433F1;
	Tue, 27 Feb 2024 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044133;
	bh=nUuQZ2gRDrTt9SjRzI+gG2AVYDcZowhMy0Or3iQ/DG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dwj/icJMU6dSXeSQTpdxnFC8uu+qtL84RrImD571kZWBRgsQHv6JqF8sNmRxj0Yfk
	 pwIOrT4+8YvQlfoX+w6+6q7SjcVt439vAZxDvKHmGZQu2FotRRqgbiF+GeKmdUMBHF
	 VmRhToKCmKeStwcG+m76kTE4xLU82SgfY7LBTSHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/122] ASoC: fsl_micfil: register platform component before registering cpu dai
Date: Tue, 27 Feb 2024 14:26:47 +0100
Message-ID: <20240227131600.217680764@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 97f83c63e7652..826829e3ff7a2 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -756,18 +756,23 @@ static int fsl_micfil_probe(struct platform_device *pdev)
 
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
2.43.0



