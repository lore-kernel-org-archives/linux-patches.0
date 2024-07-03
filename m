Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA393174ED1;
	Wed,  3 Jul 2024 10:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003608; cv=none; b=jufIWY01YqigZcjULZejpKOk/+95QQtdfNAFpdaYCYz1q2LLM9K13pEk6GeD4oiNrJn57xcSOqGbSV9to/9BXiQr68101kBwOvu1gqIYwBY1dt1cqISWmqW5EtGs7K4VoREKEMxEH3HNdtnum20EA/pZFulsmTjMcNA7keba0dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003608; c=relaxed/simple;
	bh=zH5cIJAHrsUx9+zGn7tnUigtoRq90hGBJ6SUQlOfZsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7fJDFJT4/tvxdmpr2W42IqMxJ8w973xUmAXQBtQwTKV3ofCAcUwaNOXgQPEDwWQusUCFxSa4HhU5z2aqwE+xk8zJUpEib9DuiOdwKqrwT2dMku+3bsRAW7QjYlmOjEjyf4zymKvNmjyDf7Ywwi/myN4lRYL4mGcGX46Nyo2DF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TD+Dg4/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TD+Dg4/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688A8C2BD10;
	Wed,  3 Jul 2024 10:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003607;
	bh=zH5cIJAHrsUx9+zGn7tnUigtoRq90hGBJ6SUQlOfZsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TD+Dg4/jeWuFRDyiRNqDKiFVJX/eCgpcyIEa0Gbr2K6gGtmJlu2zyfxAUsv0/LX04
	 VMPYWOjjhzTzRi4i92Aindk3vxDYNoxeZaVt3XXySpgLvzGevc3zoKkKaYMqgy9IgF
	 6I3XeonjNVv6HieC6iOTFcLO9N2P53XuJQB6lVB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/139] ASoC: fsl-asoc-card: set priv->pdev before using it
Date: Wed,  3 Jul 2024 12:40:02 +0200
Message-ID: <20240703102834.406579317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 600d9be9706ef..b2929c31c0011 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -479,6 +479,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->pdev = pdev;
+
 	cpu_np = of_parse_phandle(np, "audio-cpu", 0);
 	/* Give a chance to old DT binding */
 	if (!cpu_np)
@@ -591,7 +593,6 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		 codec_dev->name);
 
 	/* Initialize sound card */
-	priv->pdev = pdev;
 	priv->card.dev = &pdev->dev;
 	priv->card.name = priv->name;
 	priv->card.dai_link = priv->dai_link;
-- 
2.43.0



