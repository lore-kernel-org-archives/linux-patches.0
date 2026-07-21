Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078A83264FF;
	Tue, 21 Jul 2026 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659225; cv=none; b=HNj44jek0viN+JsSkX1QJAUdAKP55iCsxihq4UUqF5f/iA53eRPy8kEEBXhHPamGwzzZ7q5gVz6GJ7cwf4mbBz0qhJvIGAMngmKAn/Ynt1/xyk5u3iRXSO6z58AiNnm88ESk8q8HiS7w2z0YRtbqD4iDO+0FWt4Ch8bL7YXotB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659225; c=relaxed/simple;
	bh=BqQuLzhTqaSQD74ZWgLLuaUSsP/+hLIontiycSTj6Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+2zark/FnDds2H5H2YNnTSHMum4Z4JAS9csieBUUkhIR9t/l7Y+xvJgcy6ENSLfcnKJ850KSxP2DDQHZil+6+VGQWGK1ouYL9fKJLoXM7g398viUwdej5NxqZFgF2U5yO0WWngU/mr7A+m3jUgPUDKGv/i76toDcsjBpLQLuxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWskNr9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWskNr9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A31B1F000E9;
	Tue, 21 Jul 2026 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659223;
	bh=Y3Cb3414YDpUN3WvdxlvCH15J0LdnN6h+laWayh21QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWskNr9V1DuGppbEQzeXLosn9MSd8Im67+feBd0d+rDXpvPSSmvG0+UYCmC2TnmeM
	 sVfdNrwPfwc5gr6WNctkj6adH+yMo61Ss9KlX8+A8Wc2NAVvMcTRz3WMWKHlfQV6qU
	 +pRIMqyBRlCBme4c1yAF4vLuMiM4CzLICa3kXlCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 1397/1611] gpio: mt7621: avoid corruption of shared interrupt trigger state
Date: Tue, 21 Jul 2026 17:25:13 +0200
Message-ID: <20260721152546.865204230@linuxfoundation.org>
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

commit 1781172526d1092323af443fa03f00e6de560401 upstream.

The bank-shared fields like 'rising' and 'falling' are modified using
non-atomic read-modify-write operations. Since every gpio chip instance
represents an entire bank of 32 pins, if 'mediatek_gpio_irq_type()' is
called concurrently for different IRQs on the same bank a possible overwrite
of each other's configuration is possible. Thus, protect this state with
'gpio_generic_lock_irqsave' lock in the same way it is handled in irp_chip
'mediatek_gpio_irq_mask()' and 'mediatek_gpio_irq_unmask()' callbacks.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4ba9c3afda41 ("gpio: mt7621: Add a driver for MT7621")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://patch.msgid.link/20260626060112.2498324-2-sergio.paracuellos@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mt7621.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpio/gpio-mt7621.c
+++ b/drivers/gpio/gpio-mt7621.c
@@ -187,6 +187,8 @@ mediatek_gpio_irq_type(struct irq_data *
 	struct mtk_gc *rg = gpiochip_get_data(gc);
 	u32 mask = BIT(mt7621_gpio_hwirq_to_offset(d->hwirq, rg));
 
+	guard(gpio_generic_lock_irqsave)(&rg->chip);
+
 	if (type == IRQ_TYPE_PROBE) {
 		if ((rg->rising | rg->falling |
 		     rg->hlevel | rg->llevel) & mask)


