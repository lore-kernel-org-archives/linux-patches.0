Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF531D0492;
	Tue, 15 Oct 2024 11:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993415; cv=none; b=BUEOv6qaAZzQ5fimwxSJPEk3GNFi8JQg6JNg2aaBA46vtc9M/GBQFNU/k2xewTCkWwEnvrGajefTF7XH52TeSbglINnB8H9DjW1+m1Kn1/WYm2POypYWpLvoqlUgRPBV/t9eSmbFH7qH/6RQd9SZF/rcXXHAoQBDgGNZaBAeG08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993415; c=relaxed/simple;
	bh=2KT/OmFue1BebxmEhGVJScEO4uDC8CRrd8V99EkAxDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAt6M5nyDBUs3b1Z0zx20PmWr5YRM8bidhm+Rq87lqaCW/0cmy90/sVQs0XTvefMwNRw2W8cAHcpz6QvKPlpXFwpIzcMuX8BCoUoXrHxOuFDNT2CO78EOotTTm/zicHt/acsgJzbzhVp95ah8gajtEk9wbunLPSwmJtjcGkVusw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDc6CkTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDc6CkTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEC1C4CEC6;
	Tue, 15 Oct 2024 11:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993414;
	bh=2KT/OmFue1BebxmEhGVJScEO4uDC8CRrd8V99EkAxDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDc6CkTeU/G3aGGdfQlCvaZV0m1VbI8fJ+8dott92cw1QA6DdsDc68radjjDiIdHM
	 WaPGjMi5uj6nH3JmJxiXvsQ/iE3FDMNbojbMD9MYJ565yG1wCB+2utaZnPznNSusCy
	 836dptGmtVdc6Gx36/ap2knQN76N0/5ArxcgQAB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 404/691] ASoC: imx-card: Set card.owner to avoid a warning calltrace if SND=m
Date: Tue, 15 Oct 2024 13:25:52 +0200
Message-ID: <20241015112456.379159537@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index d59f5efbf7ed5..223234f6172b2 100644
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



