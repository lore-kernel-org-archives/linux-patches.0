Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6060E345750;
	Fri, 21 Nov 2025 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733378; cv=none; b=m5GNAw0UpwqdjlEsPv3xxakPdCvk0Ut+iSD5x8K9C41s6gM03ebzOu79XWNRXLvInwfDqtYmiINHiyNY+DMewL5384nZnrHrFvUnQrBwTJk576PrSqxRWy9QpgciOeoO2sNf8Sqve0qbuCuAFt2MSxYMPDW0OtW4xhFag7ibJdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733378; c=relaxed/simple;
	bh=zk1lcMnradzRA2sC+9vz1TpWnzRGEjt4EEG9Q4kiWWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ww2Uj6kGJ0nK11L6XPLxNmMcdQ9T/NguzXn7JDVN1lYPu5pZiONyEW8nj4UrKimd9ZsZNwGk6q6+IS39trJMuQzH7KR7L97N+z/a/GzeXwB/qc+5k0qS46J6qXxmu2WZpTOQonT3viBxnOfov/fXYd4rzNr9Ltt5f62BwQKM4g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VxNTfMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VxNTfMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF272C116D0;
	Fri, 21 Nov 2025 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733378;
	bh=zk1lcMnradzRA2sC+9vz1TpWnzRGEjt4EEG9Q4kiWWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VxNTfMKDx8HUwR6gJ7QuTW99nz3GmhARNUWHJaMk4FPyWMAmLp0roKL/abKfH6lA
	 hgcezinaqDw57ke0p12pWVYptCCgP0Lqk0Re8HLs5kDeIhIx2J7peAH1t9djN2csDg
	 OyqZa7VsAEKmb3CtjIhCj31blQHbm2L2fW2zfK7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Hu <nick.hu@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 448/529] irqchip/riscv-intc: Add missing free() callback in riscv_intc_domain_ops
Date: Fri, 21 Nov 2025 14:12:27 +0100
Message-ID: <20251121130246.951901153@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 627beae9649a2..84cb9cda365ad 100644
--- a/drivers/irqchip/irq-riscv-intc.c
+++ b/drivers/irqchip/irq-riscv-intc.c
@@ -149,7 +149,8 @@ static int riscv_intc_domain_alloc(struct irq_domain *domain,
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



