Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337DA3FAE01;
	Wed, 20 May 2026 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299921; cv=none; b=rXj503C/+PiBD9V4gO5FNzJIZ/8Elc6Z+bQYGbK8P0OTvQKU9OuhbiDuS9eGBdkx9t8nZksRLab/QQRiNI9LGBTHkbdDm8CIXR1mCIDQMiOOaBngOG68lxaS6iCQH4CVMx6FdEh3ybzheJ3VbBBjMQV5gRsXsstQVSoneagB4K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299921; c=relaxed/simple;
	bh=VBFqmSZo8pVK15/Y6k0En+8dmUkm+vG8zmrJRWHFblA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuZwC7P9VzDT+sjvEUcR3AUSuHsYDdH7IVoSq8oL466bM7aW+uJA7Ndza7Cm2c4GPpKa2/X9oEvLASGAZSarIqWhAgWfdKi5o8uifyFg20GaQhQDpDcXGEMNG2ccOQIYHWkP4LUSvN7sEn3ewxYi73XnaaefGk+KYADaVSRqrCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoF21ofB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoF21ofB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41AD1F00893;
	Wed, 20 May 2026 17:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299918;
	bh=J9P+NyPXO2ofH+/tfENw2N9OgSoS+RRcSo+h+cDrkfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoF21ofBiH+fWjM0CQsi24SCWdOZ3HNe+T6B9/k12Jlg97+tQjubRpl6BiNE1qp4i
	 fraxE5Ijutkcff1evX1wcKfmJ0Plf5T+hCYE0Us72hlbpAmVbRVQ4hlCmOdb9ddKO/
	 7O9f16LlqGbfpKbSP6z3mHpf97iSSV5gAVlNC7jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 929/957] irqchip/meson-gpio: Use the correct register in meson_s4_gpio_irq_set_type()
Date: Wed, 20 May 2026 18:23:32 +0200
Message-ID: <20260520162154.734002816@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

commit 5363b67ac8ebcc3e227dbf59fc8061949109841d upstream.

meson_s4_gpio_irq_set_type() uses the both-edge trigger register for
configuring level type and single edge mode interrupts, which is not
correct.

Use REG_EDGE_POL instead.

Fixes: bbd6fcc76b39 ("irqchip: Add support for Amlogic A4 and A5 SoCs")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260508-a9-gpio-irqchip-v1-1-9dc5f3e022e0@amlogic.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-meson-gpio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/irqchip/irq-meson-gpio.c
+++ b/drivers/irqchip/irq-meson-gpio.c
@@ -404,8 +404,7 @@ static int meson_s4_gpio_irq_set_type(st
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
 		val |= BIT(ctl->params->edge_single_offset + idx);
 
-	meson_gpio_irq_update_bits(ctl, params->edge_pol_reg,
-				   BIT(idx) | BIT(12 + idx), val);
+	meson_gpio_irq_update_bits(ctl, REG_EDGE_POL, BIT(idx) | BIT(12 + idx), val);
 	return 0;
 };
 


