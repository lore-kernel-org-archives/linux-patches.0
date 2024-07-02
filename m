Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1670178381;
	Tue,  2 Jul 2024 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939963; cv=none; b=sVJRHXiAZ7ecinv/jCnrpt+b0Tq05e0uGRkIQ/fS8rlBtObacDTho+IyE+eRzMGf4gRuDNyifx8rj+Qrf0W9tHQN782wH4lkpgBwi5MW/YLnY0IcKRr82V7SjzlePfEMaqILsXuz1ioKYcAO1hHrlGbJx/9G1leHnSIyMtaQfwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939963; c=relaxed/simple;
	bh=2Xz1W0CcFTwSnyn6Yo3Aam48aSQjVJFw5SaG6KQx1Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lmq3rmga8KuYixcghWVvlM/RaDYM1Hw7A4hLGQhyyhnIfrk8GLp2aq/0GbGUhq0SI3t8R8MuEBafA/wpN3C1p3fxDK8RO8+3sCdQUsuselFoExiUahO10N6K6uHxXeYoqNzOwEMeIL4skQF82U9fj505DVzuQCvobUlTbnv+4jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hl0cwqQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hl0cwqQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7D4C116B1;
	Tue,  2 Jul 2024 17:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939962;
	bh=2Xz1W0CcFTwSnyn6Yo3Aam48aSQjVJFw5SaG6KQx1Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hl0cwqQmr+aGGGYewVWyz7Mi0XzHhxSb1D5Z/iAKaSzmd5XK2lpsVtxN6IYOcj1/o
	 Qpq9P2MCzXz9V+l57Wltg0vgUSgM1e1nT4vEUGjJB40m101gs7Ulnw0QU/tvXiPReF
	 GR52ZLxSf1k0hNLKnFJRbjYrwkFSKgxfSiQDQzJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 003/222] pinctrl: renesas: rzg2l: Use spin_{lock,unlock}_irq{save,restore}
Date: Tue,  2 Jul 2024 19:00:41 +0200
Message-ID: <20240702170244.099422936@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit a39741d38c048a48ae0d65226d9548005a088f5f ]

On PREEMPT_RT kernels the spinlock_t maps to an rtmutex. Using
raw_spin_lock_irqsave()/raw_spin_unlock_irqrestore() on
&pctrl->lock.rlock breaks the PREEMPT_RT builds. To fix this use
spin_lock_irqsave()/spin_unlock_irqrestore() on &pctrl->lock.

Fixes: 02cd2d3be1c3 ("pinctrl: renesas: rzg2l: Configure the interrupt type on resume")
Reported-by: Diederik de Haas <didi.debian@cknow.org>
Closes: https://lore.kernel.org/all/131999629.KQPSlr0Zke@bagend
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20240522055421.2842689-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 248ab71b9f9da..747b22cd38aea 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2071,11 +2071,11 @@ static void rzg2l_gpio_irq_restore(struct rzg2l_pinctrl *pctrl)
 		 * This has to be atomically executed to protect against a concurrent
 		 * interrupt.
 		 */
-		raw_spin_lock_irqsave(&pctrl->lock.rlock, flags);
+		spin_lock_irqsave(&pctrl->lock, flags);
 		ret = rzg2l_gpio_irq_set_type(data, irqd_get_trigger_type(data));
 		if (!ret && !irqd_irq_disabled(data))
 			rzg2l_gpio_irq_enable(data);
-		raw_spin_unlock_irqrestore(&pctrl->lock.rlock, flags);
+		spin_unlock_irqrestore(&pctrl->lock, flags);
 
 		if (ret)
 			dev_crit(pctrl->dev, "Failed to set IRQ type for virq=%u\n", virq);
-- 
2.43.0



