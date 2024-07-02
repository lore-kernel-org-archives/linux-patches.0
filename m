Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACD443152;
	Tue,  2 Jul 2024 17:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940758; cv=none; b=EiS+ruZWioensa8hZz4r3deSlFw9eJY41BoB+BEhnvkE/vCc2lYkhDG0J/vfrfkipELSkpaaQnHl/hMR/9jFsRfUnlDmrVjVuH+sEb3QjsZjOPFfjIeETUL+d/mIuTe+6uQuTnxqsubyYRWbZULKGGqUhyId4YakdonSJaviAi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940758; c=relaxed/simple;
	bh=/AU2bADwpRiEWTye3hhy5nCuY3e4+dg9Hc6NcKtHmfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7rwSzRmNMRLOpwhU/GpBft56UHhJPSH/1y8OQBaV7RKsAXbxQ77xd71rM1x94Nahx6+Ie7x5PlBGIebwfkW4I2kpqlzz/zfXS0yhAYr1OYh+7JbM68ycSnpu+B2DMFTHh1oYAeT32CHGtt2WN+anWMWR/kQkNI192G9K63r+58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6dyMifK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6dyMifK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01BCC116B1;
	Tue,  2 Jul 2024 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940758;
	bh=/AU2bADwpRiEWTye3hhy5nCuY3e4+dg9Hc6NcKtHmfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6dyMifKIAhm5PUsWofiH1Q9+Nj7T3U4XeG+0y0f6vGvqmu8HgL2A9Eb5zKtxCNYY
	 KyQtac2eldf0sAQarbMWet1uynREhwKjvBi9Mu0WmsAPc/CZvZytOT44jJ8PtWb5Iu
	 zR3f/UerB1bl+DAqJ6N7GVU6tLcSkzyndNk2YnYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/163] ASoC: fsl-asoc-card: set priv->pdev before using it
Date: Tue,  2 Jul 2024 19:02:21 +0200
Message-ID: <20240702170234.087820793@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>

[ Upstream commit 90f3feb24172185f1832636264943e8b5e289245 ]

priv->pdev pointer was set after being used in
fsl_asoc_card_audmux_init().
Move this assignment at the start of the probe function, so
sub-functions can correctly use pdev through priv.

fsl_asoc_card_audmux_init() dereferences priv->pdev to get access to the
dev struct, used with dev_err macros.
As priv is zero-initialised, there would be a NULL pointer dereference.
Note that if priv->dev is dereferenced before assignment but never used,
for example if there is no error to be printed, the driver won't crash
probably due to compiler optimisations.

Fixes: 708b4351f08c ("ASoC: fsl: Add Freescale Generic ASoC Sound Card with ASRC support")
Signed-off-by: Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>
Link: https://patch.msgid.link/20240620132511.4291-2-elinor.montmasson@savoirfairelinux.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 5f181b89838ac..f76252b3f5913 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -559,6 +559,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->pdev = pdev;
+
 	cpu_np = of_parse_phandle(np, "audio-cpu", 0);
 	/* Give a chance to old DT binding */
 	if (!cpu_np)
@@ -781,7 +783,6 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize sound card */
-	priv->pdev = pdev;
 	priv->card.dev = &pdev->dev;
 	priv->card.owner = THIS_MODULE;
 	ret = snd_soc_of_parse_card_name(&priv->card, "model");
-- 
2.43.0



