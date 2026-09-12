Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E6F2F531B;
	Sat, 12 Sep 2026 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226012; cv=none; b=Yex3HlggLKSLe/IheZdzTepjw2eAx7M7VYdf8y3HmlMyKCcuJ5GDf4w9YILHlAwtXmOkVzz/p6v/lE7vZWCemKP45xkZF6LjlgGQ+85O/ttNLYaQhP2SBBnnXjqDZqX7NG6qVHphwVzDA6LB69GUIjcUT7gzW9UfTHDxWoSDCIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226012; c=relaxed/simple;
	bh=1VA6CqgrVlGN4Yfn2U8pO4oJh137EGPrqE3tDrgm5Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZs37zGkPwm0iXe+ktvVn08SUuzUjnbRYg0U49cIUFKh7QsgUJTSgGr/egViu7IAM+/uHdz/KNGlg0ZjYRFl0ZBN7JakiNQQkwdkcwTOxRme1+y7iuCgLBrr6f8GEGWW21UBYHGOn2VHIj/OG4gswfYRrI4eT/fzMnUL5swJlmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQfrsA4d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQfrsA4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DB81F000FF;
	Sat, 12 Sep 2026 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226011;
	bh=zhpk3RAlYCXAHNAChWqjpCWWWtEZ0SXK/mqDexwl4co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQfrsA4dB9amo1jms77mL4MSSWoY+M+gWiFAJLeLVMfP+aeyI0CmKsDHVotIj9Apx
	 7AXOGtMgn+CAyVurCLLy1TMj9vsyFShTXhmy2NG+7T1VY+rezvmyCMMWUDyLjnpvYj
	 63BZ8QHgLRKG7dT+JWdTZOdJx6+9NbpZ/YGmKwc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1313/1424] irqchip/renesas-rzg2l: Fix loss of interrupt
Date: Sat, 12 Sep 2026 09:02:25 +0200
Message-ID: <20260912065636.667412960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 5a7836186fd41..05b364d500bd7 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -100,7 +100,7 @@ static void rzg2l_clear_irq_int(struct rzg2l_irqc_priv *priv, unsigned int hwirq
 	 * falling/rising-edge.
 	 */
 	if ((iscr & bit) && (iitsr & IITSR_IITSEL_MASK(hw_irq))) {
-		writel_relaxed(iscr & ~bit, priv->base + ISCR);
+		writel_relaxed(~bit, priv->base + ISCR);
 		/*
 		 * Enforce that the posted write is flushed to prevent that the
 		 * just handled interrupt is raised again.
@@ -116,7 +116,7 @@ static void rzg2l_clear_tint_int(struct rzg2l_irqc_priv *priv, unsigned int hwir
 
 	reg = readl_relaxed(priv->base + TSCR);
 	if (reg & bit) {
-		writel_relaxed(reg & ~bit, priv->base + TSCR);
+		writel_relaxed(~bit, priv->base + TSCR);
 		/*
 		 * Enforce that the posted write is flushed to prevent that the
 		 * just handled interrupt is raised again.
-- 
2.53.0



