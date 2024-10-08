Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026E51DACBE;
	Tue,  8 Oct 2024 12:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389671; cv=none; b=cYXv3FsqYu9M/rKaXvH3/TqBFallFcHKHohsYgaBgLb4turKR09CDaE6elWeAJqndkMVrTMa0yKOqZeG9ZCqhZCJH+hSEjm/0ilbRqDbpPkK2UvIrHb+e9q2bGdAxOoliITvL2F+DWQ6DERUuAqvErZWk/GaX9Pb/OzFIp0M6cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389671; c=relaxed/simple;
	bh=by5xsX7WIwxeI1EXDc859higYk0CN8PGYxkucpzSdUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeKYI7emj4bDO2XRDO6NTr+UDB274QHqzwfTku8WNvpe1ctzToJ/SVYWM2Kqy/3TTCCES2xGH2sZ/O+yGCIWfz2X83r0AIp4CwHdOlicYIJnz8RrBFU0mSwjdREYLrMmnLSmzyn60OtEJMIpRM5QFGFflLbO+6hjL042Rfon9To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiiVZie0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiiVZie0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1872AC4CEC7;
	Tue,  8 Oct 2024 12:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389670;
	bh=by5xsX7WIwxeI1EXDc859higYk0CN8PGYxkucpzSdUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiiVZie0IYPWGxIQG6VVK06SAA7Cy0QoZLdup+2oOFA2aA9H0EFoLnwmXPvK6FsGV
	 lOrVaspcacQKYds0Nuzt2RXJY5F0vyS8h8fXHUikOlUc070b6GwsZa6tFLWChpguDd
	 Ota2JIpcTIY1VILEB0+TwzwwG3fzgXyL4Ym0Rqio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 062/482] ASoC: imx-card: Set card.owner to avoid a warning calltrace if SND=m
Date: Tue,  8 Oct 2024 14:02:05 +0200
Message-ID: <20241008115650.747978935@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0e18ccabe28c3..ce0d8cec375a8 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -713,6 +713,7 @@ static int imx_card_probe(struct platform_device *pdev)
 
 	data->plat_data = plat_data;
 	data->card.dev = &pdev->dev;
+	data->card.owner = THIS_MODULE;
 
 	dev_set_drvdata(&pdev->dev, &data->card);
 	snd_soc_card_set_drvdata(&data->card, data);
-- 
2.43.0



