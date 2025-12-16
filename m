Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40C63845C4;
	Tue, 16 Dec 2025 12:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888674; cv=none; b=biafvQkRCz0aW8/dKBInIcS5q502YJiWidTL8iBTTmtjKvsfFnBz+EOYFtcpARfg32uBJcFqQnnJyEgxOKYjgM4Eav/0InCqf1dwO6s9wJCR/qXkN7z2l87v/LcjxCK1Du8++xk7SbaTlnLJIDyGYRVHlPHW8L4HFVeiZWBmbUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888674; c=relaxed/simple;
	bh=+Ud7VeeukAHNJuxkM7GLYEA6sLbFAlGRgpKJRZaCrfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FycIAyiElzSJKo0Di7pzykWl4pqNAAgZ14KWFksEJOL++LI6JKae9XyQibuQ1P1zgKFEdire/7YXSIFpVHAkJWvyNaNn6ZKQiBWjX+rQblOG/A0ymRIIblOV4hYGDfPvXzlsd4xgmin7lT5HqEnuFFCiHf6xHTuV4wr1pmGR5KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wzl48i0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wzl48i0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184B1C4CEF1;
	Tue, 16 Dec 2025 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888674;
	bh=+Ud7VeeukAHNJuxkM7GLYEA6sLbFAlGRgpKJRZaCrfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wzl48i0eSj9Avv9sP/huJBVVnzyg3f25IDQVWrfCYUJ4MFcVTPkIRZxbKvvjwH8p9
	 lurvvJW+vUqquLk+Rr59cQrSWgzNAlo5VoRBpaRgDU/IByFI/bXu5tbfVs8LMNF2Hp
	 Z9wBy/Ylhuf8mU6VT7Qr62VKONw8BpQqrSBccnGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 597/614] irqchip/mchp-eic: Fix error code in mchp_eic_domain_alloc()
Date: Tue, 16 Dec 2025 12:16:04 +0100
Message-ID: <20251216111423.023052227@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index b513a899c0853..979bb86929f8e 100644
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



