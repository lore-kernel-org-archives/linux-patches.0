Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3AB3191D2;
	Fri,  9 Jan 2026 12:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962015; cv=none; b=bRul9IcNDmDHzYm5gu1e461mgTDVi841BtPrKzdxDLpTpmtcQsT1BAyPGyo/IRNmJwz0xv1WJZwlUIiR3QLZtlAR5mK/wDFb1NOXd2CsE5cwI/hsFqsOmRfD0aXZeWL0Tu77mFlb38LX7X0lp5ljyJkN54Kd1RkC5rwJT1BtCG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962015; c=relaxed/simple;
	bh=bbrn08rqyMa28wHd/g4964CqtnXJdqk2uPrfiASJggk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw1tVst5Py8TD1F7Iu2+Q8xIVZOk/qXGpIVn1BxZR69kmAVcoWTppy9309a/6182AqLvaMeBJHoaFgeyVP5SUUDMqAArhFLQT71PxyMKZRtUnGotOixgb9PitbzcFQr/omRwvG+I+86D70dBlLes+X6tfvfi7SQKkrwfS2lEFWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7Xda4FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7Xda4FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE89EC19421;
	Fri,  9 Jan 2026 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962015;
	bh=bbrn08rqyMa28wHd/g4964CqtnXJdqk2uPrfiASJggk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7Xda4FD+p+/CL5Ha9xlEIhdrnQPEjouePy8d5L4rAq0tH4HFvanN75s9Opa0RwVq
	 pt5do6qUZpgDqo2ojA7Tbc+7/6JcQJVXb77Sl7xXBg5yc2vPqCDfE4h1pUlj2Py0jC
	 rrWoKtF/NKnCHZYfwSiDftvOWv2DU52poBON3mfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/634] irqchip/mchp-eic: Fix error code in mchp_eic_domain_alloc()
Date: Fri,  9 Jan 2026 12:38:15 +0100
Message-ID: <20260109112125.599334957@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c726a19837d29..7f84c736d2827 100644
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



