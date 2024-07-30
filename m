Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C7C1A6166;
	Tue, 30 Jul 2024 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358116; cv=none; b=nnfTiLJK8XSI4AFHvKYAsrPAhyymMUKxQCpev8EOPlBR0x9pnFOIS0BlvLvvOALQmzt9vAE/xq7CLsyqv7BquoPyenqc7XhfLPThD43p51sC0QvSdMjBBGz3iCX2JSDYpp+ScStlFMmfDn0Kr6ep9CcF2ndws1Y0RQguCRlU8ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358116; c=relaxed/simple;
	bh=EO1yovHpvI64se5kIS2FolspIMmEfT7Kmi4AxA4RfM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qO8rOXnfpeh7cB//yRN8Mc3053bB8041JcJOuR2grnv9FtnhNOIlkimG38lSCsymaCOYYAfHvN8drWko7XrAqgEDudetVd7preBJK1Fd1zoK+Pa/1zJYh7vDRA5+LfbNXzRSgFuvQXWY5234BJTlDWjtKXKtAwF9nqpbSvRqzNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qke9QRFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qke9QRFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415ADC32782;
	Tue, 30 Jul 2024 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358116;
	bh=EO1yovHpvI64se5kIS2FolspIMmEfT7Kmi4AxA4RfM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qke9QRFNmfzDdsR8qbc+xvLqjCJlAUincDVSP8Y53N2UyWiDb2UR3PDEnUsctg7f2
	 ayVQy9vznqZksbdHI6VjWavQaXqbRplS+9XM3Ou5ORoeKH4tsxtgz0UKbekWNzddgU
	 Rp/fPvbaKVzag0Sj+YipgRg7uvTRU3KS9TwBpH50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 327/568] pinctrl: single: fix possible memory leak when pinctrl_enable() fails
Date: Tue, 30 Jul 2024 17:47:14 +0200
Message-ID: <20240730151652.655504155@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8f773bfbdd428819328a2d185976cfc6ae811cd3 ]

This driver calls pinctrl_register_and_init() which is not
devm_ managed, it will leads memory leak if pinctrl_enable()
fails. Replace it with devm_pinctrl_register_and_init().
And call pcs_free_resources() if pinctrl_enable() fails.

Fixes: 5038a66dad01 ("pinctrl: core: delete incorrect free in pinctrl_enable()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240606023704.3931561-3-yangyingliang@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 461a7c02d4a39..17e08f21756c3 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1327,7 +1327,6 @@ static void pcs_irq_free(struct pcs_device *pcs)
 static void pcs_free_resources(struct pcs_device *pcs)
 {
 	pcs_irq_free(pcs);
-	pinctrl_unregister(pcs->pctl);
 
 #if IS_BUILTIN(CONFIG_PINCTRL_SINGLE)
 	if (pcs->missing_nr_pinctrl_cells)
@@ -1884,7 +1883,7 @@ static int pcs_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto free;
 
-	ret = pinctrl_register_and_init(&pcs->desc, pcs->dev, pcs, &pcs->pctl);
+	ret = devm_pinctrl_register_and_init(pcs->dev, &pcs->desc, pcs, &pcs->pctl);
 	if (ret) {
 		dev_err(pcs->dev, "could not register single pinctrl driver\n");
 		goto free;
@@ -1917,8 +1916,10 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	return pinctrl_enable(pcs->pctl);
+	if (pinctrl_enable(pcs->pctl))
+		goto free;
 
+	return 0;
 free:
 	pcs_free_resources(pcs);
 
-- 
2.43.0



