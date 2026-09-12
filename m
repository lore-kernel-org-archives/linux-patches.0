Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D57A400DF6;
	Sat, 12 Sep 2026 09:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204553; cv=none; b=ca5DunWzf5O3TPpb39pMkejfz8PTp2gB6m3lIY/5JCNXjkbuCFUrA0vAv7Wyys1zXsH7QA0SYEvha41Lwxq2udo/nP5X4nJc2TCs2m7vFMoDnZN8sP3AIXUrOHOlHVuKElRD1ic8OJDelHFLmpEEOzRg+gC+uRCQU+L4/s56jA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204553; c=relaxed/simple;
	bh=gU9+iBQ3ZBok0J0BHdsrk7V7IZRH1WJHvybbWSHPEBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cqr2utzbLmcQzyqHfe7yTvdxKr5KNIRMA6DLzqeOvuF1WbhD+a77EzH1XZ1+DtFkmKZOuKSBCET2F0mUuhEB7j99oojIJcKIc9aHBEyad5jBQryhBpqytn5SIb2qdVtTkwecdUaVtU276iuM29YY2TNxc0pVbAHzt60PRrgUu1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTq3fAlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTq3fAlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851561F000FF;
	Sat, 12 Sep 2026 09:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204550;
	bh=WWMVLpvQbhIN6di3Of+ZfJjpwJr3Sr+BbZex6efJqCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTq3fAlKL5a/7OrRF8DxNIUuCnM1MooLnZJlzMnRQdZ1aqXt3Q9MTvbCVLVyxaYLS
	 fOEuxnFtmuTyBLVOXh5eTaJjf5NyUidIguOmVLQ7HwCnhAQps+4gFBJaUf533VLcs0
	 MsASPyyrjCYq5R1oS9Qriaa7DkVlcMwwCnLbHdGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1635/1815] irqchip/renesas-rzg2l: Fix loss of interrupt
Date: Sat, 12 Sep 2026 08:56:25 +0200
Message-ID: <20260912065727.373957300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 50b10bd0c2d721ad38abd1abe3acdefb6caa0944 ]

rzg2l_clear_irq_int() and rzg2l_clear_tint_int() perform a
read-modify-write on the ISCR/TSCR status registers to clear the bit
for the interrupt just handled. Since these registers are
write-0-to-clear per bit, this is racy:

If another interrupt's status bit gets set between the read and the write,
that bit is written back as 0 by the software-constructed value, clearing
an interrupt that hasn't been serviced yet and losing it.

This can be reproduced by triggering multiple interrupts at once, e.g.:

  gpioset -c gpiochip0 355=0 353=0 328=0 352=0

Fix this by writing back only the bit being cleared, with all other bits
set to 1, instead of read-modify-writing the whole register.  Since 1-bits
are left unchanged by hardware, concurrently-set status bits for other
interrupts are preserved.

Fixes: 3fed09559cd8 ("irqchip: Add RZ/G2L IA55 Interrupt Controller driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260818110937.5816-1-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index f6b2e69a2f4e0..b3774f82855ab 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -161,7 +161,7 @@ static void rzg2l_clear_irq_int(struct rzg2l_irqc_priv *priv, unsigned int hwirq
 	 * falling/rising-edge.
 	 */
 	if ((iscr & bit) && (iitsr & IITSR_IITSEL_MASK(hw_irq))) {
-		writel_relaxed(iscr & ~bit, priv->base + ISCR);
+		writel_relaxed(~bit, priv->base + ISCR);
 		/*
 		 * Enforce that the posted write is flushed to prevent that the
 		 * just handled interrupt is raised again.
@@ -177,7 +177,7 @@ static void rzg2l_clear_tint_int(struct rzg2l_irqc_priv *priv, unsigned int hwir
 
 	reg = readl_relaxed(priv->base + TSCR);
 	if (reg & bit) {
-		writel_relaxed(reg & ~bit, priv->base + TSCR);
+		writel_relaxed(~bit, priv->base + TSCR);
 		/*
 		 * Enforce that the posted write is flushed to prevent that the
 		 * just handled interrupt is raised again.
-- 
2.53.0



