Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168B91F09B3;
	Fri, 21 Nov 2025 13:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731921; cv=none; b=TT3zMZxGKO9tlStifxOjkCKGdPHDbM95RynCwob4ZFzUWBDbLyNtB4HN/Odbj/AechhAKN6AUnd7DDCMdOTMn0M1U0ar8deyY5OjzPxhELUGUIf47ALBwXUfBc2PszU40aI7qxqmqSfjJMwHc+f+AghGoF3q4BQ0cE9sMbnLXdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731921; c=relaxed/simple;
	bh=QTr9aqBHOSH8dOUzFZLEVQ+Va/kFaCuTolAnIZ54LP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLYKEyNM/TMFwT1nVX811kyZALNQHxH/ypJ8kVLztF8MRzSRLEcBbPD5noD/w56bcpAHd8yxRKRkBoWjuk2EbR1yZ4pWXcdZlBgMlyFbZSoae/Wb7++Xw+ozjmoPTfyjq//7A5Oaa79ZtgbGdeScBsrI87ARMBW/kHv4SJFcEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljPny212; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljPny212"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99515C4CEF1;
	Fri, 21 Nov 2025 13:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731921;
	bh=QTr9aqBHOSH8dOUzFZLEVQ+Va/kFaCuTolAnIZ54LP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljPny212hMiekBar/4IQ/wlkjAydr5Sj1Muq3yRrKEmljND7PJM3DxGvq0uMCYd0a
	 P2rkHM1hRHMX8o7nDdSSMfLalP68a5XxvJVfHyHb4OLzDexd114h4KUbzmLd51ppjN
	 Usv9ThgwO74rAob4IKZ4JbvRStFw5nYi0qX3U1Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Hu <nick.hu@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/185] irqchip/riscv-intc: Add missing free() callback in riscv_intc_domain_ops
Date: Fri, 21 Nov 2025 14:11:51 +0100
Message-ID: <20251121130146.900059826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
index f653c13de62b5..a02ef98848d36 100644
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



