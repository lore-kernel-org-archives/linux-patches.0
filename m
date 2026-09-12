Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717EB3806AF;
	Sat, 12 Sep 2026 09:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205074; cv=none; b=F3xWcyDqadLR46CcVttlrmBZBj59ocT/ILQvzT7UfrjfH3ogXJ01UnJyXDidRTDJPhLM/h2NAjKyMgkFXGYK/nhdS5oVuhQuXKbbpXAlKFz8T3imB2hUftedu37xXLiuM0212hcA8dAmK0et/Tk7ZS34HMv0U6YAEq4KDRwGJxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205074; c=relaxed/simple;
	bh=8kTOeudDoJmefhd7ISystpZGnVXZPcQgxsoHSicxhMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmEE9PrsBAlqQLpVVy7fWqEmh4gaQkgwmDWE+9ZzQvmVz8/x3nTgTYvk+7lC/8yfaAH1M6DH8iGjes0XmM2Ma21CmvWyFAiCS0SRxWHozynryunzR/pnaFHTXIq2PVm7MZJZQ0kVHIhxhuK6wBg9NxJZvvBSL8W3rA7akLyLfWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Z+DxytW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Z+DxytW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C951F000FF;
	Sat, 12 Sep 2026 09:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205073;
	bh=zGvv88MAC1L3AgF5MOPQYbsc1oHPNH9Vq5ilpwlqBYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Z+DxytWKrZDkv5GkvVvPiOzD7XLFDXH1CoqJpZNVLs7UXi2Yon2o4bylLiBfsGAF
	 ZSLKwfk9UufdF/LTQ4LX0otKAeRpje+xeKWaSY8wsrDn6H3dMIUWBXRhov4kgqO677
	 vQogwAtdn/r+pTcFspYTHVztlynviahnb/eJXcFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1700/1815] net: txgbe: fix MISC interrupt unmasking in non-MSI-X mode and device shutdown
Date: Sat, 12 Sep 2026 08:57:30 +0200
Message-ID: <20260912065728.889736575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8746318ad3bcb..5ad1ff7c3ce97 100644
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



