Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC061514DC;
	Tue,  2 Jul 2024 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941283; cv=none; b=mq4rpcQTitkgj7XL072b+oY6cr358LHSSY3mzeHbnZpz5mcDfEzgkFH2qma400tqBFGY/QF+onnB2SVZ0fa+P1dLtaRQHIJgprktWp1x30GERYY9QqIh04YM5Az++AyHQyx/9mJF20KcHXq7xk7eSQtO8iztr5J0ioJG8gpns1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941283; c=relaxed/simple;
	bh=mjV9FnJ2ATPoPGAuBBdW1ORNMUAGvSUhGsffgKscA0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXF5cRpIb3EfQPHt2aCKA0utiEr2OKqaaIaMsmR9n1RZNhMfn4GmrLlN9sOnK/DY2eodkPzjNeskoPLLlapUwKSh2VWnDqh0A5Nn0HV725MyuTB4C50cQ1DLUlivnFWS8f6fMugNNKColutIf04uBWxylBESCP/j4OvEpnHAIgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaS6la7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaS6la7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F2CC116B1;
	Tue,  2 Jul 2024 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941283;
	bh=mjV9FnJ2ATPoPGAuBBdW1ORNMUAGvSUhGsffgKscA0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaS6la7rCOphBJ03gBLm9cBYx5vvRGOL9fKRehvd+EVJbaDcN7afX5USN2YbDOB8Q
	 UzFGscrmuFqGu7ht51c2LwPoEdnQVUwX6+FmEGKuhWdnHNVGJZaT44xAERgrlUznGN
	 dS2EM0jM+GSqgRU2q5MmH+2HZ5qlGdqrjfRgxH7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/128] ASoC: fsl-asoc-card: set priv->pdev before using it
Date: Tue,  2 Jul 2024 19:03:40 +0200
Message-ID: <20240702170226.959264753@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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
index 8d14b5593658d..8b29099975c91 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -545,6 +545,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->pdev = pdev;
+
 	cpu_np = of_parse_phandle(np, "audio-cpu", 0);
 	/* Give a chance to old DT binding */
 	if (!cpu_np)
@@ -754,7 +756,6 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize sound card */
-	priv->pdev = pdev;
 	priv->card.dev = &pdev->dev;
 	priv->card.owner = THIS_MODULE;
 	ret = snd_soc_of_parse_card_name(&priv->card, "model");
-- 
2.43.0



