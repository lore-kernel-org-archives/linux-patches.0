Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B42D3603D5;
	Sat, 12 Sep 2026 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231796; cv=none; b=OX0uSwQqigJXhuo8lh0/nH0H8iEAqZuPEttCngrTgL2qkDd6UxRWCydAXe0fdAgdbb84dUid35BL3WLwi1HReGNoK4WByZ2fcf+ateUOb8qERSbnvlhF31U14IRf6XyPZQrJvQkWhrcrWLuktk6WgrBNN2V/SrIElv2uYxcEuGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231796; c=relaxed/simple;
	bh=eO9AkKER9VZVL8eZl0yq5WJPyDZytHUhT1gb1rnlB2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBXawqtug9Zrsb/+DK+UEWgperhqeeConCoPdcri72KA3v9GXfoCzyYlN8Tv6/Uty56F+e10tqZpb1sL6DkpQtgmwMNeef5qAVuRGzQBbS0jhWjYzi6EHizZVNVHxFOmSg9IJ0MTU1qeZdk8qklBwKO4bOFVtqyyxdfWt3X/eC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzAhoR74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzAhoR74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535261F000FF;
	Sat, 12 Sep 2026 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231795;
	bh=/GOuKqhpwAUT4/sf9H3Smg7ccwr3Hr1rOFtu8WZwoxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzAhoR74DYRpRQHU1MvSlH3RVo+pA/f3COTcSByxGun5wVh+HP2IpRqNymbqfYTtB
	 /YpVmjM4icNNJerBviXZfRLg5n+IV9vPVCC1er1KQNixODTwYpFKZj+nXDL4aLySFD
	 e9xPNXO6wBHbR+8CI5Xy3qibJCKq5l/oSvs1KDqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1073/1191] irqchip/renesas-rzg2l: Fix loss of interrupt
Date: Sat, 12 Sep 2026 09:03:21 +0200
Message-ID: <20260912065612.272625104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 5df559252c6ef..ededb389bf5e6 100644
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



