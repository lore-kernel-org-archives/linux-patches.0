Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3766717BB03;
	Wed,  3 Jul 2024 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006010; cv=none; b=snXYkfkTlZnwiyfCot9QTrpw67lCC865JKGDsfwNIyej/vDcGWrh0X57EtEb2aqINBmS77r8SPWizawFuDFJB6e3Jrev40g5ZB0MSig5U4AgKAZL2i6cjoULwFrMi+4WfTz60au91MLbeTQlHF+BbGBreQTWcIOPXPfRR9wcvHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006010; c=relaxed/simple;
	bh=0/q2IWBbsgcZx/Xtmf3rnujB/l5bz2FhDIri+eE3Mfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8NrANJMsvkvgT7g2hhvqDsBku16E8V8W+oBHOMKGJoWtTx9jH/oABtTPOpAqVDwyZPSNPw/lSDOL762MRVVkbI3tVP/f5rIbsSwzWDHLnNZpjKA9cRW86+YJ1DujbAzPgUAhp9/ItnZERbq2arS4BbhRz3mrpLof24CTYf5fVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPVaF2o/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPVaF2o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B295EC2BD10;
	Wed,  3 Jul 2024 11:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006010;
	bh=0/q2IWBbsgcZx/Xtmf3rnujB/l5bz2FhDIri+eE3Mfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPVaF2o/Ryc4PyT0bIYJNIWnGfiSSJ7NbtZ+6Q18WfSzpaeOQsVEHrtx8WSSWSeo0
	 akHBXlyKq/urwWy2Ou+QWaPzZUC4dk0lA0Y4rNpzM4YwFPF9wlpniSvRRjWVaBg56H
	 0XLjhAm+VVUYt2neEcRz3qEpduHt6xkY5QNRG5Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/356] ASoC: fsl-asoc-card: set priv->pdev before using it
Date: Wed,  3 Jul 2024 12:40:06 +0200
Message-ID: <20240703102923.328821818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index 5000d779aade2..98a157e46637a 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -548,6 +548,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->pdev = pdev;
+
 	cpu_np = of_parse_phandle(np, "audio-cpu", 0);
 	/* Give a chance to old DT binding */
 	if (!cpu_np)
@@ -742,7 +744,6 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize sound card */
-	priv->pdev = pdev;
 	priv->card.dev = &pdev->dev;
 	priv->card.owner = THIS_MODULE;
 	ret = snd_soc_of_parse_card_name(&priv->card, "model");
-- 
2.43.0



