Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D333B455181;
	Sat, 12 Sep 2026 10:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210409; cv=none; b=DzOQLIxHTyu2VaZXOdbfIxa8NZn3yAktfwlNb9uJDzwsj1j9pDEulyw08v1m/BhPH6LrCkxcDI5L51rN4Zzqd4Pxz7IQqu7fNuKmhxnzpeEsv4FMjuI+eLGdQAjshkI195Wub7BdiWfVHDNErn5QlDhDu/MlZaMWYxBHVhWpNHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210409; c=relaxed/simple;
	bh=wOsGytF83+FovkOqjs8eKnGVXtqJ1aRWJXDtnRPh1dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPHrVjSzCoFG8jTblhgROqaxWWcJPklJkmFzLd6ukus5NtbwSFKbKOiA6LonmUO6cLDGS71vHVf/FqPX6S9JwdTeCWjLahcOKCQzxLKixK3kSxyChbkn9vel05QQAs0eJGhPBwkuvsj7iXZlTCdaTei/E4l0ESq2rM7DhsHjD2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRfn+WIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRfn+WIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADBD1F000FF;
	Sat, 12 Sep 2026 10:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210408;
	bh=rVJbk7UWEjtkuNXGuwjOK+nvD7Yaz6KmYpGvNgyox+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRfn+WIXH0/Mvvs057LbYWtOxKJ7OKXW0CpzSpF1Dhfd0a5S6Jn9lndVOtwow0eR4
	 dZrRElXeNhtzxX7NWiHbVa9BF5/l8szCxloGetqMvsT3bu2i4LTGPEHE1w/Rfs39Pt
	 46u8uSKhDKQRF2Kz1tLg/sLKr9pWaQRkZBLwJadY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1021/1518] pinctrl: airoha: fix IRQ mask/unmask code
Date: Sat, 12 Sep 2026 08:53:10 +0200
Message-ID: <20260912065646.547488377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit 20b996280640f492ebdd41c2d2c991801df75e61 ]

When using IRQCHIP_IMMUTABLE, airoha_irq_unmask() must manually call
gpiochip_enable_irq() and airoha_irq_mask() must call
gpiochip_disable_irq(). Without these calls, gpiolib never sets the
GPIOD_FLAG_IRQ_IS_ENABLED bit. Because this bit is missing,
gpiod_direction_output() will not realize the pin is actively used
as an interrupt.

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 2163532f9af01..059f1d32f6255 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2544,6 +2544,7 @@ static void airoha_irq_unmask(struct irq_data *data)
 	if (WARN_ON_ONCE(data->hwirq >= ARRAY_SIZE(gpiochip->irq_type)))
 		return;
 
+	gpiochip_enable_irq(gc, irqd_to_hwirq(data));
 	switch (gpiochip->irq_type[data->hwirq]) {
 	case IRQ_TYPE_LEVEL_LOW:
 		val = val << 1;
@@ -2578,6 +2579,7 @@ static void airoha_irq_mask(struct irq_data *data)
 
 	regmap_clear_bits(pinctrl->regmap, gpiochip->level[index], mask);
 	regmap_clear_bits(pinctrl->regmap, gpiochip->edge[index], mask);
+	gpiochip_disable_irq(gc, irqd_to_hwirq(data));
 }
 
 static int airoha_irq_type(struct irq_data *data, unsigned int type)
-- 
2.53.0



