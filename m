Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F0D3CC7EB;
	Wed, 30 Sep 2026 19:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796172; cv=none; b=hh67XWRioYblSnaPuwWfwPcW6G7f6kCxQHPAR15qUAB50P2+x5x9P5CNJxPVlOwLEz4xKXh8YNJsmJRI6+ZluFqeSOgBuD4oOiz9aXOV+G6PCKn6WnYBESI6Ywo82p724jQZjg7rAEOPE2VBGoG0N4xA01YARkTZtpXzOROHVAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796172; c=relaxed/simple;
	bh=VMdfaXvqk8PRR7IxYK9df10BJE5TttE+a2eFVb9/IGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3KUkqed8jwi6ZzeMpLE5bUhqapckSVQz+M1ckfPiF2jHUqa8PBULF7KrhBKWrR+QWucUZBwmudAOYuuzxOnmUW8JLTFLkQDcOshHrM4BU6+fpHIW3P0OiYMODv8DTWXeGJs9CULWlQt9mV5blQmDDV2RBscD4zIUGTtlg6QRyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHDBAf4d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHDBAf4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964691F000FF;
	Wed, 30 Sep 2026 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796171;
	bh=SYatFjA4t2DGjXIKiwumNTS5sWr4PdKic4xF0z9iSy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHDBAf4daRZMRVp4h5rfaK/oiam6/URJq9vlYxP7KMp5b4rx5hU9XN1mHFZ10H1mb
	 uMxgjDtGrfnTLJEDr35XHYqAP5Ym2mqVwW8XRRch3ruZ5nB885qzH1CD+zVuxH1R0Y
	 a83EFN6r7SnDAnz1waZrGYbs/01kqJhpU7yWwAV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0820/1193] net: ethernet: cortina: Ack RX overrun interrupt correctly
Date: Wed, 30 Sep 2026 17:25:04 +0200
Message-ID: <20260930152452.464699110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 96b8e3209bbd5..df279b360ac1d 100644
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



