Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28CD264612;
	Fri, 21 Nov 2025 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731281; cv=none; b=abUSt/7SMXLmrYRFKbeiz+GxHifoMwpuC+DgYs+N6RHyo6UbRHvKaheY9bBEdAYRGJ9y7vh/9ycDqM+z1cCGhoL/asLP8aRY0mywAWycmzz4WXg1m9o0e0OORq4t2fLbBr6hTgsGzTqygnzvqEXNNQ1V1MOCawaew47LbEwekPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731281; c=relaxed/simple;
	bh=VJcST6xD0RE88+R08zXmA8kIl39qXrhkyf6LmjsDEQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDuuOhDNdjXee8dO0L7n8MHLlX4oNcxKB2Do3IlwxplIIRHmMqWIvVeTlrxJeTeD8ymqOZ1ciRRhmtOZKhxdNXir5RhKDBJswnluUrcJ9y7gAOENHZ5fKXh2awRJiVUBjFxalyjrsblw4KBIcADTUXHBBaR92ie7RgpMoA9KKu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjXX7BIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjXX7BIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288E5C4CEF1;
	Fri, 21 Nov 2025 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731281;
	bh=VJcST6xD0RE88+R08zXmA8kIl39qXrhkyf6LmjsDEQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjXX7BIumLilpy60jZ2rqpIwgUq+wgG+hJ4MRPdAGDridwB/sOQpb+KNxJqKBe878
	 JYfLDOJRMThQ86p9xc6d7cRwHfLnx0+ln+Ozuy9ul4iTLIcZ5sbkX1nhDXxyZ9Fbs3
	 g6mZbckwwRS7mGwSGgBV+Ov6clWfgBvwaovucuaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Hu <nick.hu@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 120/247] irqchip/riscv-intc: Add missing free() callback in riscv_intc_domain_ops
Date: Fri, 21 Nov 2025 14:11:07 +0100
Message-ID: <20251121130158.890712977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit 14473a1f88596fd729e892782efc267c0097dd1d ]

The irq_domain_free_irqs() helper requires that the irq_domain_ops->free
callback is implemented. Otherwise, the kernel reports the warning message
"NULL pointer, cannot free irq" when irq_dispose_mapping() is invoked to
release the per-HART local interrupts.

Set irq_domain_ops->free to irq_domain_free_irqs_top() to cure that.

Fixes: 832f15f42646 ("RISC-V: Treat IPIs as normal Linux IRQs")
Signed-off-by: Nick Hu <nick.hu@sifive.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251114-rv-intc-fix-v1-1-a3edd1c1a868@sifive.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-intc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-riscv-intc.c b/drivers/irqchip/irq-riscv-intc.c
index e5805885394ee..70290b35b3173 100644
--- a/drivers/irqchip/irq-riscv-intc.c
+++ b/drivers/irqchip/irq-riscv-intc.c
@@ -166,7 +166,8 @@ static int riscv_intc_domain_alloc(struct irq_domain *domain,
 static const struct irq_domain_ops riscv_intc_domain_ops = {
 	.map	= riscv_intc_domain_map,
 	.xlate	= irq_domain_xlate_onecell,
-	.alloc	= riscv_intc_domain_alloc
+	.alloc	= riscv_intc_domain_alloc,
+	.free	= irq_domain_free_irqs_top,
 };
 
 static struct fwnode_handle *riscv_intc_hwnode(void)
-- 
2.51.0



