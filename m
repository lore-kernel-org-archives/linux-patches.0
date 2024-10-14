Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11EE1AAE02;
	Mon, 14 Oct 2024 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918755; cv=none; b=DivunvXMMShbMrk3hS+utY6cazc6K/pMXMCTm2OzDP6Vv5eWC2ckm73em2UpfbGeRIkveNybcrBn7U8MhBZBmzp2Z8AsZHxvhHQDgC+pQX35X9JORPkUGesVff7iFNlgEeWOkXIbE7/Ghe8DX9KI9/3DoK609q1UjnG64yv+vns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918755; c=relaxed/simple;
	bh=N4OUO7vYuJSeNcGCsqnPZqimS4POnNFnBmFIusMz/uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBKmGesj9BHoe1KkREW0nkZ7V4XlJddtTHk/5JVbeEPr5BSKzFrbDIWh0DuFwIy9ITKfC8rAtwakED5K83RyLgG2C1F2T9W0RpL2McWuz6PRJBjKiTEGvXdqWS6nw1pPMZaiPo//k/juj1SXHh/jAck0eifIv9otA9CLR3KXd2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4Nw6wLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4Nw6wLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230C0C4CEC3;
	Mon, 14 Oct 2024 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918755;
	bh=N4OUO7vYuJSeNcGCsqnPZqimS4POnNFnBmFIusMz/uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4Nw6wLMHMX2lWJe6XuACha5+0efO3MxGJSxJKK+np72iwbAF3dwBxIwiSPGnAklJ
	 p2ZiAFMdJ/sA4HHKqLkWUSB2U6j79b55E04KFePFKSR2KwWMleQz8fhfC0dwf/IN62
	 wbFgZ5DVM0CI5aP0F2gvjVFFqCoGauCDdzmGZKwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 414/798] ASoC: imx-card: Set card.owner to avoid a warning calltrace if SND=m
Date: Mon, 14 Oct 2024 16:16:08 +0200
Message-ID: <20241014141234.213431678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 47d7d3fd72afc7dcd548806291793ee6f3848215 ]

In most Linux distribution kernels, the SND is set to m, in such a
case, when booting the kernel on i.MX8MP EVK board, there is a
warning calltrace like below:
 Call trace:
 snd_card_init+0x484/0x4cc [snd]
 snd_card_new+0x70/0xa8 [snd]
 snd_soc_bind_card+0x310/0xbd0 [snd_soc_core]
 snd_soc_register_card+0xf0/0x108 [snd_soc_core]
 devm_snd_soc_register_card+0x4c/0xa4 [snd_soc_core]

That is because the card.owner is not set, a warning calltrace is
raised in the snd_card_init() due to it.

Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://patch.msgid.link/20241002025659.723544-1-hui.wang@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 64a4d7e9db603..9c1631c444229 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -731,6 +731,7 @@ static int imx_card_probe(struct platform_device *pdev)
 
 	data->plat_data = plat_data;
 	data->card.dev = &pdev->dev;
+	data->card.owner = THIS_MODULE;
 
 	dev_set_drvdata(&pdev->dev, &data->card);
 	snd_soc_card_set_drvdata(&data->card, data);
-- 
2.43.0



