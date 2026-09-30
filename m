Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF9B50EBFC;
	Wed, 30 Sep 2026 16:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785992; cv=none; b=P+in1iErpBNYK/KoAIHlHFrr0UmzrZs5BVYMIkDR6ahWr/FfJa1lBuow3OMOTmcxBYp4fvz/mHczXyjVx/5BsBYrTpvDrtRc+RUvDnMLZqtc6TQtHP6qChJE3lOH0TIyUSjUhCNfxrr2h4WLvkVfUfZ6dJzMzOeBtaH+J71h5TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785992; c=relaxed/simple;
	bh=owUoaluVTL5YSWmqKcTNtDTNr2Cqbsqnu+X58K+EgCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atNFOh4R48pYZbZDW4MJN09FkIzBlDupUfc2xFTnn0JRG+LgFbvj9bl5lWSX4UHG6sAOkdv1xElPa51r2kt+i4BwPWwANpzjLJdmp038QUCSzv0HBYludTD6GGZPyEyQF1sc5H0dJe3MNeWNgU0BWI6i5Ht9CKc6qwnE9H7IIPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiydgBep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiydgBep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA88A1F000FF;
	Wed, 30 Sep 2026 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785991;
	bh=AgBiiQluIJBJWgzab3iK2Nse/OeZG6daSqo8491RUnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiydgBepIn3YYGgDm9Qh7KRsqilu27BbsOXYH42dm6jv1fb+oLyJq48LZ7vWjWyju
	 VsPTMiVFuI+5PsusZLR+pUb6WkgltbTu/dAHjqjOybLGIyPmid7w51InP4JRgZ6K4a
	 7jwk5puH4+Lei7Gfr9bC7bBYZ+TWwmfOYl5LYfkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 687/982] net: ethernet: cortina: Ack RX overrun interrupt correctly
Date: Wed, 30 Sep 2026 17:23:43 +0200
Message-ID: <20260930152431.519092986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 1dd85662fee6e2ac580b1c4f9a0c0a7ae6e31f0e ]

The RX overrun interrupt is reported in interrupt status register 4, but
gmac_irq() acknowledges it using the RX descriptor error bit from status
register 0. For GMAC0 this writes the GMAC1 overrun bit, while for GMAC1
the shift leaves no bit in the 32-bit register.

Acknowledge the same per-port RX overrun bit that was detected.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260914-b4-gemini-ethernet-fixes-2-v2-1-5ab39a047b90@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index fcc6018067226..58189d46b9fb1 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1803,7 +1803,7 @@ static irqreturn_t gmac_irq(int irq, void *data)
 
 	if (val & (GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8))) {
 		spin_lock(&geth->irq_lock);
-		writel(GMAC0_RXDERR_INT_BIT << (netdev->dev_id * 8),
+		writel(GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8),
 		       geth->base + GLOBAL_INTERRUPT_STATUS_4_REG);
 		u64_stats_update_begin(&port->ir_stats_syncp);
 		++port->stats.rx_fifo_errors;
-- 
2.53.0



