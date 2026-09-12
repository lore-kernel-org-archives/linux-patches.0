Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE634BEE32;
	Sat, 12 Sep 2026 11:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212180; cv=none; b=aMe7KeVqFTciAluIPNXCkChFqM580UASsTvjxyUoTREefDWBZIIoBcZ8LwrJeJP9DJQmZT2jtr/w/Rwkqm1qrE6/IWX+yUEJbHVNRjatcRel9MTDGNc/hdQS4mV4zbmYC+W5OJOnTlFUT9490pfYRx0QNk8rQH5H1+svizKGy1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212180; c=relaxed/simple;
	bh=BfjSIcTxpkdVkylpiivSAp9XGZK4Z2FOOWvRDZjBxIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB/qQPh7gO9/GHZL4fAW9weIfzUFSqodGi2WtFauBavDEEUAkA9iRbteGm15VnuKwTRGVBmvWlpm8tCyIzDAchI0NJpnl31xQ4nqLTwX5as/gMsJSVo/15TgDeGTlVIUxTuKTCgI+uAT6ujSx5UTHRu7s8ErtwrWcVyU918dd7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sadW6FR4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sadW6FR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7C11F000FF;
	Sat, 12 Sep 2026 11:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212179;
	bh=5KGr09/+rHr6eK59J1xOHx63gGQDJuQyg4OKSBCToLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sadW6FR4oL8kdjX0gatG3vyc0pL9nBeuZ7lPrZ9pUyvcA1TzRf7pmvuRy4hwA/YHw
	 l9N3YmgylVJk4xF8c+YZ9JhB9FGsLRBVie0JZHPiEizpSRbwzDRl6e5dReNHP8xhUU
	 fB2EDteyrfNy0lEAEYfSYCRTB5lMpeX0WhLmidlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1377/1518] net: txgbe: fix MISC interrupt unmasking in non-MSI-X mode and device shutdown
Date: Sat, 12 Sep 2026 08:59:06 +0200
Message-ID: <20260912065654.693700865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 7bf29145d7a9564162c6b18f8d23760e141e2d15 ]

In txgbe_misc_irq_thread_fn(), the driver unmasks the miscellaneous
interrupt at the end of the handler using TXGBE_INTR_MISC(wx) (which
resolves to BIT(wx->num_q_vectors)). While this is correct for MSI-X
mode, it is incorrect for legacy INTx or single MSI modes.

Due to hardware behavior, the WX_PX_MISC_IVAR register is completely
ignored by the hardware when MSI-X is disabled. In non-MSI-X mode, the
hardware forcibly merges all interrupt causes (both Queue and MISC) into
a single bit: BIT(0) of the interrupt register.

Unconditionally unmasking TXGBE_INTR_MISC(wx) (e.g., BIT(1)) in non-MSI-X
mode means the actual MISC interrupt bit (BIT(0)) is not unmasked
promptly at the end of the MISC thread. Instead, it remains masked until
NAPI completes its polling and unmasks the shared BIT(0). This delays the
assertion of subsequent MISC interrupts, preventing timely handling of
events like link state changes.

Fix this by explicitly checking `pdev->msix_enabled` and falling back
to BIT(0) as the interrupt mask for the MISC cause when MSI-X is disabled.

Additionally, unconditionally unmasking the interrupt at the end of the
thread introduces a race condition during device teardown. Guarding the
wx_intr_enable() call with a check for the WX_STATE_DOWN bit, to prevent
re-arming the interrupt during device shutdown.

Fixes: e37546ad1f9b ("net: wangxun: revert the adjustment of the IRQ vector sequence")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/56A53978B83EEDE9+20260818023026.6631-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
index 6f29d35b767f3..5ceca13eaa5bc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
@@ -164,6 +164,7 @@ static irqreturn_t txgbe_misc_irq_thread_fn(int irq, void *data)
 	struct wx *wx = txgbe->wx;
 	unsigned int nhandled = 0;
 	unsigned int sub_irq;
+	u64 misc_mask;
 	u32 eicr;
 
 	eicr = txgbe->eicr;
@@ -183,7 +184,9 @@ static irqreturn_t txgbe_misc_irq_thread_fn(int irq, void *data)
 		nhandled++;
 	}
 
-	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
+	misc_mask = wx->pdev->msix_enabled ? TXGBE_INTR_MISC(wx) : BIT(0);
+	if (!test_bit(WX_STATE_DOWN, wx->state))
+		wx_intr_enable(wx, misc_mask);
 	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
 }
 
-- 
2.53.0



