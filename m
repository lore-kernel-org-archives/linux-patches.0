Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191E42D0602;
	Thu, 30 Jul 2026 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428295; cv=none; b=mH7G49fEiNq9lSCSHDwJ3Oy9JzsL3N2YzPpdxSmg4Kag4ZSv7XOLajzMDWRACAkXV4Dv1dzbQRUtarTvfBtdf9XEQHkyC5CB7LwHtfLi5IT4uAfbkwTZmS/RCI4MLVqxwjwg9SZ6OcSqhxBNV8dko6k8Azm/NvBNULBVKvXbXBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428295; c=relaxed/simple;
	bh=j35NL+xBvQ1iODAqeQMAapqXrnZbWcJObyoldvT9aNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQAC15B3ePTlo/FIC00P+b+MSixs052qjB95VkDiNjfUfjTz5KRXaJiEr77oUIyPGNhYwpIj28mR/l+mREIDwrijoOJZkfNIXyTcL2O907PTKW5tXEtd00ESvYpgKpV80v6Pu1hrG7V8G+ZX/ZLHhiLjWbtopxnuTwPU5LwSVQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7xiCfxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7xiCfxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B88B1F000E9;
	Thu, 30 Jul 2026 16:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428293;
	bh=sa73Z+ayG2KK2HcaCR61v7b2VGuk83Gz+qtHYU7mvMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7xiCfxVQ2TCPS5E5CRAJ4hnHobjwQN9zzlg3Vd7ckvPuELtwe4RaDaiulzIGl9KN
	 oArDFmqjLwvwRcHdCg87cZZflhoWjT5PYkv/TennMY6BbXJCAd5BdAAYGGmL6G0sLT
	 PSKwbroSW5jd06T7v313AgvLJEYwfryZsIHPNmNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 464/484] gpio: mt7621: avoid corruption of shared interrupt trigger state
Date: Thu, 30 Jul 2026 16:16:01 +0200
Message-ID: <20260730141433.566050558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 1781172526d1092323af443fa03f00e6de560401 ]

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
[ Changed `guard(gpio_generic_lock_irqsave)(&rg->chip)` to `guard(spinlock_irqsave)(&rg->lock)` as the generic GPIO chip lock does not exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mt7621.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpio/gpio-mt7621.c
+++ b/drivers/gpio/gpio-mt7621.c
@@ -156,6 +156,8 @@ mediatek_gpio_irq_type(struct irq_data *
 	int pin = d->hwirq;
 	u32 mask = BIT(pin);
 
+	guard(spinlock_irqsave)(&rg->lock);
+
 	if (type == IRQ_TYPE_PROBE) {
 		if ((rg->rising | rg->falling |
 		     rg->hlevel | rg->llevel) & mask)


