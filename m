Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8662A174ED1;
	Wed,  3 Jul 2024 10:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004157; cv=none; b=ciXaDkBwIfjdJVYxKsuJEMyhb6UhwEwxJRozDnQDasjjxnQN7tZYXHnTOs2mpuhv+pPQwycNVWpyGMx0fg4hFwTxvkXUmK1UbkcGtrgfS0nbWaxRx/BsLKHYY6Xn2MbtJmc8SiVgSxxJXY6GZdNLaHMvFwhdgf/nAPc9ddYxwco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004157; c=relaxed/simple;
	bh=PDwgDYeEEsUYnxQnwBg3/jSjPEnKhhzBSpf5BrAWMRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kelcMcWCpTIa+IQoWReOlgLbfeD/HZiTJntVVdGXYRB5ACMeg+2LSsUnb/W5Gv2iZFYpJBUxF8fz2cDLx8jjvHP5M8vDVskKB03DAykxA4wqlAjWw9lx4Fz60DCYsIrnPqYaJJl9fzNJjZbQ23G3rZmrdd1Yvbk6ly/tPIZT+vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LX18YVBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LX18YVBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B49C2BD10;
	Wed,  3 Jul 2024 10:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004157;
	bh=PDwgDYeEEsUYnxQnwBg3/jSjPEnKhhzBSpf5BrAWMRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LX18YVBhvdyBCwWmH87mCqyhX7lzAdZWl5NNHSkGCEHcduxs9iHQXkUhfluvYJ43u
	 PXm3b8C327axauSYbbnpMH1via2YnfOC6yfXdN/KNbcuLC83wrVXn4bBfcMmiQIZPc
	 EsuCqozHQQZNZB9Ms6swGFNacllegdDoKYFrLfEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/189] ASoC: fsl-asoc-card: set priv->pdev before using it
Date: Wed,  3 Jul 2024 12:40:01 +0200
Message-ID: <20240703102846.765293824@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index db663e7d17a42..c7f7335bbf863 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -494,6 +494,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->pdev = pdev;
+
 	cpu_np = of_parse_phandle(np, "audio-cpu", 0);
 	/* Give a chance to old DT binding */
 	if (!cpu_np)
@@ -606,7 +608,6 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		 codec_dev->name);
 
 	/* Initialize sound card */
-	priv->pdev = pdev;
 	priv->card.dev = &pdev->dev;
 	priv->card.name = priv->name;
 	priv->card.dai_link = priv->dai_link;
-- 
2.43.0



