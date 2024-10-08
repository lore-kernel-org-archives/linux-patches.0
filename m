Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4391DE8B1;
	Tue,  8 Oct 2024 13:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393101; cv=none; b=U9cfy2P1li2+Rb2RxPiBum/lThFgmOigjz912LKLYjqDPYzFnxkp7kn1ziYglrzz+PM3aU4OVtXiBgMyd7EzKABDGPF//PcQJoQ92w2WqKh6vY0oU9e1yovi9yopwqLfAcYPGl6XpItO21JDbI8+WK1tlt9hgPcsEX5lEJy/E/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393101; c=relaxed/simple;
	bh=v4GO/fFmt90bZ1OXHb0c7H9GxeuGH8IM1LviQ0MKtQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm6xpdHI+6ZK44+Z0E3LG1ZbM3PnT/eNeCcUL7fMC0g4TQ6whmU2jFUSY7jneVnAaeQbfZ10pAu8j2W5S5eNMSYddQwtAgcqcXnhlIvqftQ4NRGmVyghtHpxaU/D3XsnSd1gEuJFKF1Sd/38yaeMeUB1i5deZUL7IXvauqMvRz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POI93PK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POI93PK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E5DC4CECC;
	Tue,  8 Oct 2024 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393101;
	bh=v4GO/fFmt90bZ1OXHb0c7H9GxeuGH8IM1LviQ0MKtQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POI93PK88ERxhq1ldYlKrxFsrtF5LTTciPX2jhKMgt5+/VHE84ZTn4NF0TT2v8ToM
	 HXTw7OQMjfjuu9jNdSCBCWkVL1Mkc60d/pcBu4Lp3RW3nSeXEQQduPbBGDs8PRDEXe
	 /A5Yk9KpHnC+zrk0awyHT108YN5ikMepi4Pspczg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/386] ASoC: imx-card: Set card.owner to avoid a warning calltrace if SND=m
Date: Tue,  8 Oct 2024 14:04:56 +0200
Message-ID: <20241008115631.479304920@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 356a0bc3b126b..f8144bf4c90d3 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -714,6 +714,7 @@ static int imx_card_probe(struct platform_device *pdev)
 
 	data->plat_data = plat_data;
 	data->card.dev = &pdev->dev;
+	data->card.owner = THIS_MODULE;
 
 	dev_set_drvdata(&pdev->dev, &data->card);
 	snd_soc_card_set_drvdata(&data->card, data);
-- 
2.43.0



