Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9943F4FECCF;
	Wed, 30 Sep 2026 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788516; cv=none; b=rKE3c0UgUa6scgeoEyxBfkRFnSsDHA+GSjJtDHoHp7WGYRw7K5MQSjvFHQoYGeYL6utqOcra6hQaWYVmJB0MiYQQlPPMeXtb8zn8wMQDMRCLH7vQ2RRbFzr1VS7rRdm+skpGisd2d4BLJVWfB3HQmaYKi4t8ni3bA07OOpbInIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788516; c=relaxed/simple;
	bh=lGC5dhMFB5i0vd/WwQ5L/2JIEJt9ZysnZsCQk/2BYCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAhcPeSKCTKGiyVoXQcHmdp7V1Iy5RW2DszhM65Gx+ZoHH5yB//nGQ5HK3UWzE7lRz3ZTQVMQ0/yoA7yii2MFJpznRSXz+OJT4KGfeK1yZUozF4Ae985fT7FNXdNU7fXXCwJtjVmKOEjlYS7WiGmLnQF5FIIgqbhD3m1GhCbf3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFVZI2aD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFVZI2aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA85F1F000FF;
	Wed, 30 Sep 2026 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788515;
	bh=hDx/XoxvFIs3pHsQIyLojd+Q32U5zSt75i+r9Xmotvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFVZI2aD+b66bGVkhU//FzV+hc/Ga52zIufzbaZUT6YGWcwtYdOA7DlCC242O28If
	 eYLJnCwsMlT07PO9w+czebkHq4Vjy0waey+82K9k182yabSTPd9yriOBr7hc2xgm/a
	 PM5xUlIeuo/EhVeJrt9pDhqdkBPYti9/fh7E4a1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/877] net: ethernet: cortina: Ack RX overrun interrupt correctly
Date: Wed, 30 Sep 2026 17:17:41 +0200
Message-ID: <20260930152417.959080478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 96fd27545b29b..1b81798914acc 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1798,7 +1798,7 @@ static irqreturn_t gmac_irq(int irq, void *data)
 
 	if (val & (GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8))) {
 		spin_lock(&geth->irq_lock);
-		writel(GMAC0_RXDERR_INT_BIT << (netdev->dev_id * 8),
+		writel(GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8),
 		       geth->base + GLOBAL_INTERRUPT_STATUS_4_REG);
 		u64_stats_update_begin(&port->ir_stats_syncp);
 		++port->stats.rx_fifo_errors;
-- 
2.53.0



