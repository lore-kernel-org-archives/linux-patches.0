Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C0935A948;
	Fri,  9 Jan 2026 12:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960206; cv=none; b=jZoyNQXhWQ6MxJSGxe9tm+mPzcWYbjrjOjqkMJWgbNJcyso64GlQSRQNdL/dMkEJLYAHtWDSz4hc00qXSP1nH8Zx+j/HlJGAsmcnkQGucfvNR85GZT5x3d6wflXOmmgcy9waTupw9OfbWzlCbIyikaSR27pDFI+spyaYMBZhFnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960206; c=relaxed/simple;
	bh=1WHL+Vjoy1D1ONz1EFkX4QaFwY9sIhxDI7uF1U3q54A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK+hOYw+udEUUXFLMl7dKW0SjUKikvjbDqHqsx/Frr/wZ12zcZfDRImKvnnb3HimSmzFxxtpI9up8IOZu5dF66UzBUEhiJnEIjvFyzLLxKVaqwy7FKRWeTWoMymAzkm88Y7ueK0PqUotcbUgWAgKPy7jJjiIxMV5OxN6fE+bbyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zbtOCFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zbtOCFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18259C16AAE;
	Fri,  9 Jan 2026 12:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960206;
	bh=1WHL+Vjoy1D1ONz1EFkX4QaFwY9sIhxDI7uF1U3q54A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zbtOCFBc8pZDopsXaMSf/bADC2uwqJT3z1XGRjuK0LDZq03YmV7hLY38/OTfSWL5
	 xFwiBNSNbCwSsNyB6oaxwD582mHVhZVw9anjP92tUXWHtTZs5I58G4g+ww1Edgb0aV
	 UwsER/dZC2AoXcH8d7ZSnPZbatHPd4UZHIs+W7MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/737] irqchip/mchp-eic: Fix error code in mchp_eic_domain_alloc()
Date: Fri,  9 Jan 2026 12:37:09 +0100
Message-ID: <20260109112144.921125768@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7dbc0d40d8347bd9de55c904f59ea44bcc8dedb7 ]

If irq_domain_translate_twocell() sets "hwirq" to >= MCHP_EIC_NIRQ (2) then
it results in an out of bounds access.

The code checks for invalid values, but doesn't set the error code.  Return
-EINVAL in that case, instead of returning success.

Fixes: 00fa3461c86d ("irqchip/mchp-eic: Add support for the Microchip EIC")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Link: https://patch.msgid.link/aTfHmOz6IBpTIPU5@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mchp-eic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mchp-eic.c b/drivers/irqchip/irq-mchp-eic.c
index 5dcd94c000a26..8a5baa0987a4b 100644
--- a/drivers/irqchip/irq-mchp-eic.c
+++ b/drivers/irqchip/irq-mchp-eic.c
@@ -166,7 +166,7 @@ static int mchp_eic_domain_alloc(struct irq_domain *domain, unsigned int virq,
 
 	ret = irq_domain_translate_twocell(domain, fwspec, &hwirq, &type);
 	if (ret || hwirq >= MCHP_EIC_NIRQ)
-		return ret;
+		return ret ?: -EINVAL;
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
-- 
2.51.0



