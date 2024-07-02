Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1133F1BD51B;
	Tue,  2 Jul 2024 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940020; cv=none; b=Ze02H6RUHbxxX7rjrM0GajXs8buFfuAqgp4mqZTam4n6BqdS5Fp0St4SWYk4SNcyTCbRTKBrnFLs+PDMoRnQnvG6qQQ+cKUszcGArME1UI+3XomhdcdoFW6V+7JuV3FI8hjlarTY9O1TgajMqARPSdTfOhuyJm9uPRW/Cumt7oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940020; c=relaxed/simple;
	bh=mlZZ5pZWbABOvG/D1MTX4zXN+gqwijpKiwodevwVGEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdegr7fdTrTn/lMyiHA+/oZKAsln3mZ5DLvJ4sFRqjyuBI88RVvExWxRq7oN/y5ouWq1MZkPNRRNgWVcdElAE8f3VEZ2MiFTMZmqSol3sH6MOIYl3o2IUsvK1YyPQXK2wAdZNMlbkFi6HMUZaoFDzPTYUi97MtWlMrjIWy+CWwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AR5gOu7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AR5gOu7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF76C116B1;
	Tue,  2 Jul 2024 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940019;
	bh=mlZZ5pZWbABOvG/D1MTX4zXN+gqwijpKiwodevwVGEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AR5gOu7aFjV6Lo7xTemo+lj642Vi7uHjC3qL1g6t/rPdjGRpiVICxSzPCfc/qQSr3
	 cHc4pgHjwXfNU4p67weiCUi6eIkv/98S/pPTkYdV8eRtp0kFB44JFiwca5Utk7KZE0
	 1yLm/sVTIyrP+cDRxmwUYgNEMBCp3jdU+IibYmyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 029/222] ASoC: fsl-asoc-card: set priv->pdev before using it
Date: Tue,  2 Jul 2024 19:01:07 +0200
Message-ID: <20240702170245.092096514@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index bc07f26ba303f..e5ba256b3de22 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -558,6 +558,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->pdev = pdev;
+
 	cpu_np = of_parse_phandle(np, "audio-cpu", 0);
 	/* Give a chance to old DT binding */
 	if (!cpu_np)
@@ -780,7 +782,6 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize sound card */
-	priv->pdev = pdev;
 	priv->card.dev = &pdev->dev;
 	priv->card.owner = THIS_MODULE;
 	ret = snd_soc_of_parse_card_name(&priv->card, "model");
-- 
2.43.0



