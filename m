Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F9F1A585
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WytpksL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CD3C433C8;
	Mon, 16 Oct 2023 08:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446503;
	bh=XeEFsJCOy43kC0HBJMB+ivYMjBQtPQb7ZJxveeqKkWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WytpksL0fDMbvxEKc1raBR2v4MpKE/FLxHZ7+lyjHsDUBT///U8HiDM4xT7WQUkyy
	 DLKWkVdS3hQDcKvYuLOq4ctE9+B/IBsAMTbhh4Ikm16ydWJQFC6OfqhWM8PEiozi8x
	 t6HxCAGJlOJLr6gS4CQ8J3Em0DTXilJ/R3jqEWUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 016/131] irqchip: renesas-rzg2l: Fix logic to clear TINT interrupt source
Date: Mon, 16 Oct 2023 10:39:59 +0200
Message-ID: <20231016084000.473385396@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 9b8df572ba3f4e544366196820a719a40774433e upstream.

The logic to clear the TINT interrupt source in rzg2l_irqc_irq_disable()
is wrong as the mask is correct only for LSB on the TSSR register.
This issue is found when testing with two TINT interrupt sources. So fix
the logic for all TINTs by using the macro TSSEL_SHIFT() to multiply
tssr_offset with 8.

Fixes: 3fed09559cd8 ("irqchip: Add RZ/G2L IA55 Interrupt Controller driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230918122411.237635-2-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index 4bbfa2b0a4df..2cee5477be6b 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -118,7 +118,7 @@ static void rzg2l_irqc_irq_disable(struct irq_data *d)
 
 		raw_spin_lock(&priv->lock);
 		reg = readl_relaxed(priv->base + TSSR(tssr_index));
-		reg &= ~(TSSEL_MASK << tssr_offset);
+		reg &= ~(TSSEL_MASK << TSSEL_SHIFT(tssr_offset));
 		writel_relaxed(reg, priv->base + TSSR(tssr_index));
 		raw_spin_unlock(&priv->lock);
 	}
-- 
2.42.0



