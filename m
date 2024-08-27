Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0BB1CC889;
	Tue, 27 Aug 2024 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772386; cv=none; b=fASRMZ1RoxU9hpggHzO+RDtGrm0S0bWgBt32mPSiPPi5P4XZU/D2fORi1nXZ7AfYvFIsO7c3U/hZufUNO/goVrGLeQXvAsY4ghe0ZLEQN0pD++/3x+iArfyG27Nzh37Hj42F3eW+wYjKEPwMmgUNwoaNLU3IcVg0pMhjimIUrWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772386; c=relaxed/simple;
	bh=htQKbMhhXjS/8+bPrWROjYPKDzv8LGSuamwP4d4NJpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUqFy6gTF31oQyEDOjRtolN0gKNKv4tSnVsxWgerTIN+wsS0StVmqfMdUo0WsfXsYMjw2FEHN1nftjWtAIRrvVJ1+LRk3WGj6gDuAaarkGTCamMxg4FCyDMQhDt+77DO28fCGo5b2QpQkkvxp9gcRJf5xsEGfgL+VHrgg4uT1xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZllKIVwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZllKIVwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF17C6107C;
	Tue, 27 Aug 2024 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772386;
	bh=htQKbMhhXjS/8+bPrWROjYPKDzv8LGSuamwP4d4NJpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZllKIVwLVWoxDytfdYMvOtNH4tX14R9Bz6IIFXAQQ9rX0NvGxk861wod6Q7S2OIfG
	 PCqJVk2fjrdAvB3cXMM8CSCviIJYD1IFiKClwbl1RP136yastmr214iKT5ucscuOsk
	 NLmCyLfUJB1K/ls+KoW6/ukbdBprRqN/CwqeQ1hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/321] irqchip/renesas-rzg2l: Do not set TIEN and TINT source at the same time
Date: Tue, 27 Aug 2024 16:38:26 +0200
Message-ID: <20240827143845.769493379@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

[ Upstream commit dce0919c83c325ac9dec5bc8838d5de6d32c01b1 ]

As per the hardware team, TIEN and TINT source should not set at the same
time due to a possible hardware race leading to spurious IRQ.

Currently on some scenarios hardware settings for TINT detection is not in
sync with TINT source as the enable/disable overrides source setting value
leading to hardware inconsistent state. For eg: consider the case GPIOINT0
is used as TINT interrupt and configuring GPIOINT5 as edge type. During
rzg2l_irq_set_type(), TINT source for GPIOINT5 is set. On disable(),
clearing of the entire bytes of TINT source selection for GPIOINT5 is same
as GPIOINT0 with TIEN disabled. Apart from this during enable(), the
setting of GPIOINT5 with TIEN results in spurious IRQ as due to a HW race,
it is possible that IP can use the TIEN with previous source value
(GPIOINT0).

So, just update TIEN during enable/disable as TINT source is already set
during rzg2l_irq_set_type(). This will make the consistent hardware
settings for detection method tied with TINT source and allows to simplify
the code.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index be71459c7465a..70279ca7e6278 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -132,7 +132,7 @@ static void rzg2l_irqc_irq_disable(struct irq_data *d)
 
 		raw_spin_lock(&priv->lock);
 		reg = readl_relaxed(priv->base + TSSR(tssr_index));
-		reg &= ~(TSSEL_MASK << TSSEL_SHIFT(tssr_offset));
+		reg &= ~(TIEN << TSSEL_SHIFT(tssr_offset));
 		writel_relaxed(reg, priv->base + TSSR(tssr_index));
 		raw_spin_unlock(&priv->lock);
 	}
@@ -145,7 +145,6 @@ static void rzg2l_irqc_irq_enable(struct irq_data *d)
 
 	if (hw_irq >= IRQC_TINT_START && hw_irq < IRQC_NUM_IRQ) {
 		struct rzg2l_irqc_priv *priv = irq_data_to_priv(d);
-		unsigned long tint = (uintptr_t)d->chip_data;
 		u32 offset = hw_irq - IRQC_TINT_START;
 		u32 tssr_offset = TSSR_OFFSET(offset);
 		u8 tssr_index = TSSR_INDEX(offset);
@@ -153,7 +152,7 @@ static void rzg2l_irqc_irq_enable(struct irq_data *d)
 
 		raw_spin_lock(&priv->lock);
 		reg = readl_relaxed(priv->base + TSSR(tssr_index));
-		reg |= (TIEN | tint) << TSSEL_SHIFT(tssr_offset);
+		reg |= TIEN << TSSEL_SHIFT(tssr_offset);
 		writel_relaxed(reg, priv->base + TSSR(tssr_index));
 		raw_spin_unlock(&priv->lock);
 	}
-- 
2.43.0



