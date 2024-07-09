Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A15C14E2F4;
	Tue,  9 Jul 2024 11:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524202; cv=none; b=lW1NQFNgkFbyDUZzYhvHhu5yuLlgXR7U+h0fI35crQDHFSoWhS0iOd2Jy8kQYsVi+ufrIaCFaDiyxJ7yMTvgETA7CgrwgV0Dugy8xwsCu2+nw4LzodtMZx8g95lvP98qVQrWfCDHazWwEANdvp1/3oZOBHDdciVjP0LjeQaFx34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524202; c=relaxed/simple;
	bh=6eViaCiX1MnGOsTAxw9PySMg7LmlAqdyuG/XwCjaxdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFUYfKP4K80Yb2kVaH2cjohW+4qbMR8wBiwAFeDHRuC8HTtb/h3WOL/kvyclGk4ByeEdKViXkNL/RWyZ5Nd2WoF3cEyKj+9tcXavwhP9Wa1CR2H3iVSu7A8qB0Dxbp2I560ImNzIzuxWKpR7ixo8Kk/z6u9sdlFWOtBV4KAsgEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgJqOt2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgJqOt2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87110C3277B;
	Tue,  9 Jul 2024 11:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524201;
	bh=6eViaCiX1MnGOsTAxw9PySMg7LmlAqdyuG/XwCjaxdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgJqOt2P4oEOsuyn3DZJGT9BQ7p80sd9l6UDjMR5ivdTR1RZdzskvIRNeIehJI9pT
	 s9KokfCk6Y0UT0BZQoSlaBpay719/W7yV28kdT67zRBf0/JpQ2YRAB4maeZDTJk2RJ
	 uKle0CZg+khdt6uDfrJJI1yyo2TSjrz1nVE0EfKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 105/197] net: txgbe: add extra handle for MSI/INTx into thread irq handle
Date: Tue,  9 Jul 2024 13:09:19 +0200
Message-ID: <20240709110713.023365375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 1e1fa1723eb3a293d7d0b1c1a9ad8774c1ef0aa0 ]

Rename original txgbe_misc_irq_handle() to txgbe_misc_irq_thread_fn()
since it is the handle thread to wake up. And add the primary handler
to deal the case of MSI/INTx, because there is a schedule NAPI poll.

Fixes: aefd013624a1 ("net: txgbe: use irq_domain for interrupt controller")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/wangxun/txgbe/txgbe_irq.c    | 44 ++++++++++++++++---
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
index 1490fd6ddbdf9..a4cf682dca650 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
@@ -111,6 +111,36 @@ static const struct irq_domain_ops txgbe_misc_irq_domain_ops = {
 };
 
 static irqreturn_t txgbe_misc_irq_handle(int irq, void *data)
+{
+	struct wx_q_vector *q_vector;
+	struct txgbe *txgbe = data;
+	struct wx *wx = txgbe->wx;
+	u32 eicr;
+
+	if (wx->pdev->msix_enabled)
+		return IRQ_WAKE_THREAD;
+
+	eicr = wx_misc_isb(wx, WX_ISB_VEC0);
+	if (!eicr) {
+		/* shared interrupt alert!
+		 * the interrupt that we masked before the ICR read.
+		 */
+		if (netif_running(wx->netdev))
+			txgbe_irq_enable(wx, true);
+		return IRQ_NONE;        /* Not our interrupt */
+	}
+	wx->isb_mem[WX_ISB_VEC0] = 0;
+	if (!(wx->pdev->msi_enabled))
+		wr32(wx, WX_PX_INTA, 1);
+
+	/* would disable interrupts here but it is auto disabled */
+	q_vector = wx->q_vector[0];
+	napi_schedule_irqoff(&q_vector->napi);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t txgbe_misc_irq_thread_fn(int irq, void *data)
 {
 	struct txgbe *txgbe = data;
 	struct wx *wx = txgbe->wx;
@@ -157,6 +187,7 @@ void txgbe_free_misc_irq(struct txgbe *txgbe)
 
 int txgbe_setup_misc_irq(struct txgbe *txgbe)
 {
+	unsigned long flags = IRQF_ONESHOT;
 	struct wx *wx = txgbe->wx;
 	int hwirq, err;
 
@@ -170,14 +201,17 @@ int txgbe_setup_misc_irq(struct txgbe *txgbe)
 		irq_create_mapping(txgbe->misc.domain, hwirq);
 
 	txgbe->misc.chip = txgbe_irq_chip;
-	if (wx->pdev->msix_enabled)
+	if (wx->pdev->msix_enabled) {
 		txgbe->misc.irq = wx->msix_entry->vector;
-	else
+	} else {
 		txgbe->misc.irq = wx->pdev->irq;
+		if (!wx->pdev->msi_enabled)
+			flags |= IRQF_SHARED;
+	}
 
-	err = request_threaded_irq(txgbe->misc.irq, NULL,
-				   txgbe_misc_irq_handle,
-				   IRQF_ONESHOT,
+	err = request_threaded_irq(txgbe->misc.irq, txgbe_misc_irq_handle,
+				   txgbe_misc_irq_thread_fn,
+				   flags,
 				   wx->netdev->name, txgbe);
 	if (err)
 		goto del_misc_irq;
-- 
2.43.0



