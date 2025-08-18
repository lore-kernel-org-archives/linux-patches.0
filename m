Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE69335BCA;
	Mon, 18 Aug 2025 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525242; cv=none; b=bVdL1u7WY1m2syQpyNOt5k7kee3n+Ktq3uk0yhmJWLzg3vRWDIj56wPbVs8M9KmMwkunoK+fDtOQOb/dWhx2vjvd2hATnusOed4C/SpHoiIG1iP8lb9bvAV3wy3j5aeGatW1GDxz/MtrfBa/Z0ZNlSoFdKdaT01+Xoj0QI3h6QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525242; c=relaxed/simple;
	bh=ddt0wY1YmCZ13wEEAITusbkyIypPOpT9nfHPdqcfmsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaSba9LIB6B3j10hjYHvl0jscoSianTsVO1f3VLWs2DYTHVt938CcHERPyxgmKuJpiBufFX4ZgoutiBzc64tm/jGTV9XPXl7ezdzQalx3zBIO0AMUqNXxgYyGdxIu+8AWqACYt3fVJ6VjtuAHVTWXMDMRycsBturHBEE6FmjW1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aF74xvnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aF74xvnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC76C4CEEB;
	Mon, 18 Aug 2025 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525242;
	bh=ddt0wY1YmCZ13wEEAITusbkyIypPOpT9nfHPdqcfmsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aF74xvnVL+SpjvszCOo/WAP/hTFkhKnIElp0jGTwfK8YlizEEw4mmxLKYlUrZq5nE
	 aF6ODcrCdbdR3QiKcEwf0maH6QS+rP1Pi7TUXSKbinACKwO/ZkbnJc9yw1VietknWS
	 u2t1st+5jY4K81QuV4+4KvrTHZ1IgFARdf5V+tus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 170/570] irqchip/renesas-rzv2h: Enable SKIP_SET_WAKE and MASK_ON_SUSPEND
Date: Mon, 18 Aug 2025 14:42:37 +0200
Message-ID: <20250818124512.347113923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit de2942828e7670526289f098df7e50b112e8ff1e ]

The interrupt controller found on RZ/G3E doesn't provide any facility to
configure the wakeup sources. That's the reason why the driver lacks the
irq_set_wake() callback for the interrupt chip.

But this prevent to properly enter power management states like "suspend to
idle".

Enable the flags IRQCHIP_SKIP_SET_WAKE and IRQCHIP_MASK_ON_SUSPEND so the
interrupt suspend logic can handle the chip correctly.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/20250701105923.52151-1-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzv2h.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-renesas-rzv2h.c b/drivers/irqchip/irq-renesas-rzv2h.c
index 69b32c19e8ff..76fb1354e2aa 100644
--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -427,7 +427,9 @@ static const struct irq_chip rzv2h_icu_chip = {
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_set_type		= rzv2h_icu_set_type,
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
-	.flags			= IRQCHIP_SET_TYPE_MASKED,
+	.flags			= IRQCHIP_MASK_ON_SUSPEND |
+				  IRQCHIP_SET_TYPE_MASKED |
+				  IRQCHIP_SKIP_SET_WAKE,
 };
 
 static int rzv2h_icu_alloc(struct irq_domain *domain, unsigned int virq, unsigned int nr_irqs,
-- 
2.39.5



