Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796FB27A93D;
	Mon, 18 Aug 2025 13:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523499; cv=none; b=DF/z09Xo8eQozX2Ux2eSm01P5w4qsUXmo3TlMxcLmOsaZgYyOGHSRdR/YLOUUCV25v/IZiJ9Gm5/Vf64B07KpUkF7IV3oj+TdVeqIUZcwAiLcDVXv8uFQPZ7yOhfJXFC2eKq90DUnqdH6WjwBnt/wMU62bRVIgDH7N5wxD13Wrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523499; c=relaxed/simple;
	bh=1ZWWTshUupryZdCWmTIjDVO8ghpzGqpx6TptzbZXBTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0Z38j8VUpX813+9nklvxGncvBlzghXYR6IU7AJOwNwQlrXyWjOgGg+ui5DaZqChgn2p1GvZLneb00ZJuGRenlszYR3GLnpK3t/dOcL4K9jp3wW7a/uYIjavPRAADA++751xBQ08+uN7ypTacq0UL+xD7wLZBbukL5ycfNu7PcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRvaWGLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRvaWGLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C889C4CEEB;
	Mon, 18 Aug 2025 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523499;
	bh=1ZWWTshUupryZdCWmTIjDVO8ghpzGqpx6TptzbZXBTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRvaWGLofw+k2E+p41FpOq/PrddqKJqQDEcXd+9K1JFv804gQT8GsW9AtlMNPD1cU
	 Qq5bWIKmWjaGWgjAEmkK53t8PazA3nCKtPFcl9xh58/JZ+JzU1uWLHWv5oxaGcUwpv
	 hTVg6IEufRjQeNLK8kiOgaaqXaVOmcFOtMVU2/h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 157/515] irqchip/renesas-rzv2h: Enable SKIP_SET_WAKE and MASK_ON_SUSPEND
Date: Mon, 18 Aug 2025 14:42:23 +0200
Message-ID: <20250818124504.430453142@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0f0fd7d4dfdf..f1f7869b49cb 100644
--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -394,7 +394,9 @@ static const struct irq_chip rzv2h_icu_chip = {
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



