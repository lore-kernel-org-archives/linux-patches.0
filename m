Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F01145B27;
	Tue, 21 Jul 2026 18:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659219; cv=none; b=hxqowA0GkOxvSHLxChokG0MhUF9h+tDB21qvEvUONezTBuGlh3SaQc8PToN6mUlPc3TL7b1yKghM2A2934/ICk+6ZlDvD9/RRlho2XwhhWOXqjQBHE3ERs/4pZSv/ftnrTF2H2ohbx7zMbT/VtHgMkqNNa2xDFRfyYnmij7iabc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659219; c=relaxed/simple;
	bh=NRf1BeRv1J6bEwRIDI49bVDRMoyrCbJAcSBiawzA4HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa58aKNYRJzsJnMY+GMFjlKafFMEckGpPhfT4o2fryANABMoW3Nqc3YZ6AnnGiHWymhfcSyEa02AmD8qrfbgHFE0GQnIHGAowd44jnf8a/TOHMRksrKNDLfnD7HwmKQ5wl1OLKqWOQfcRX5q8GCKqKW+Ae4A7oRoqcj9pgicnF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ql+AyenR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ql+AyenR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7EC1F000E9;
	Tue, 21 Jul 2026 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659218;
	bh=RwP87/0JO8Wf8FqWH62nDQKwG56oJlCqG13vYHFoVds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ql+AyenRVGYTC4jkmt5j7F10q6fensaBufgtDe58fu0rsgHKzhmtArRhTOo13dc/x
	 MZvKGe00dj7ehmjahWMpSJ0H+Zx/oQ03rVl8jgxJ+Buyz5OS4tIyfc1prmIxcsG4dH
	 6cgaibCkNzgnecKvPItR/lfsFwtrIm9IAepqizeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 1395/1611] gpio: mt7621: be sure IRQ domain is created before exposing GPIO chips
Date: Tue, 21 Jul 2026 17:25:11 +0200
Message-ID: <20260721152546.820596900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit 0e024f58291dfcb28d98c512002e1a80fad69798 upstream.

Function 'mediatek_gpio_bank_probe()' registers three GPIO chips using
'devm_gpiochip_add_data()'. At this point, the chips become live and visible
to consumers. However, the IRQ domain isn't allocated and set up until
'mt7621_gpio_irq_setup()' is called after the GPIO chips setup finishes.
If a consumer requests a GPIO IRQ concurrently 'mt7621_gpio_to_irq()' can
be called and pass a NULL irq domain pointer irq_create_mapping(), that can
corrupt the mappings or cause a crash. Fix this possible problem seting up
irq domain before GPIO chips setup is performed.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a46f2e5720f5 ("gpio: mt7621: fix interrupt banks mapping on gpio chips")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://patch.msgid.link/20260626060112.2498324-4-sergio.paracuellos@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mt7621.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpio/gpio-mt7621.c
+++ b/drivers/gpio/gpio-mt7621.c
@@ -464,12 +464,6 @@ mediatek_gpio_probe(struct platform_devi
 	mtk->num_gpios = MTK_BANK_WIDTH * MTK_BANK_CNT;
 	platform_set_drvdata(pdev, mtk);
 
-	for (i = 0; i < MTK_BANK_CNT; i++) {
-		ret = mediatek_gpio_bank_probe(dev, i);
-		if (ret)
-			return ret;
-	}
-
 	if (mtk->gpio_irq > 0) {
 		ret = mt7621_gpio_irq_setup(pdev, mtk);
 		if (ret)
@@ -480,6 +474,12 @@ mediatek_gpio_probe(struct platform_devi
 	if (ret)
 		return ret;
 
+	for (i = 0; i < MTK_BANK_CNT; i++) {
+		ret = mediatek_gpio_bank_probe(dev, i);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 


