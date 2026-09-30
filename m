Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F01502D5B;
	Wed, 30 Sep 2026 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783479; cv=none; b=YcDlMDA4WX0YZu/pVAGgUuudRnjaM8VQZQWcHuBFo3QbkEVG5C6b6vz1Tj4JzQnSOkTL2aRKYUZi6VYLocJ6c4yKLETkO//hgh+ucDoLpbhq1uP/aX+CRJVhu2ehcC43P4+YQuz766fzvrNpBd/LJio+wNn4XhuMOU4T8zr4PNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783479; c=relaxed/simple;
	bh=MtHUqi2wgTv/j/cS+QoKDDLSWMdPqzukmSfdYVZ/uxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8d4T6BWDr2RjEr92ZTAw8Uag4UpFf3fll1+DLhUqF5XzD5ERh+6sumHp0Zi+gi3bLIJGXT1Mj1ZtKpUGFW8RprWKxzwXoh1hHOh3aP7gcxR4L1wmtIS9euwlIDmJNUHzLh3dn0ZDle1tL8EEF+pGL53Mwa8OeYe4WpLz0fPlNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8AgLBg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8AgLBg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2CB1F00898;
	Wed, 30 Sep 2026 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783475;
	bh=2tx8QPI0NfPSS0+Qr58P+WbrrS46TI3eo/+4719Rl3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8AgLBg8UMA3wijyYG6/OkDZ9PYS2Xe37wHR3YSiLXqcvhLzeAtSrbExUB/nDUc7q
	 cwji+XTkxJClSoMCB8RsuVMIuGoNIsTUUIh1dwLJiuK554/1yEU6l915OuEa/xUDEf
	 HWfF9twGKbTBiQzU52I2oyTjEi/IxkndDf0QA6eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 413/595] net: ethernet: cortina: Ack RX overrun interrupt correctly
Date: Wed, 30 Sep 2026 17:25:06 +0200
Message-ID: <20260930152356.561513757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d7101b21f80f..c66d2ea4e5411 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1768,7 +1768,7 @@ static irqreturn_t gmac_irq(int irq, void *data)
 
 	if (val & (GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8))) {
 		spin_lock(&geth->irq_lock);
-		writel(GMAC0_RXDERR_INT_BIT << (netdev->dev_id * 8),
+		writel(GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8),
 		       geth->base + GLOBAL_INTERRUPT_STATUS_4_REG);
 		u64_stats_update_begin(&port->ir_stats_syncp);
 		++port->stats.rx_fifo_errors;
-- 
2.53.0



