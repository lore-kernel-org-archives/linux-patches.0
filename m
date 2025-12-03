Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D73C2FF657;
	Wed,  3 Dec 2025 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779048; cv=none; b=SIF8QA9y7l1XyuB6Lmwl+dzn3J9p+x60EZP4X4PkLc1Nae9BCm0bea1xpMcJD8Yf4iQFfQUQLP4zRBFVb7CuvfFwPxZweOkpU82Oj0NTkuC9Pr/EWoqeZko3EwzutkSG2flSKNJGFe/XQP7vbxe6Uu4F0Kgs0B+H79NVzfn9Ors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779048; c=relaxed/simple;
	bh=AiZzK23agAM5wEApMcdQQRZfdeA+ImZCVoL2Y3i7VeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIiRhv88aqWJYUIQ5IWwM6o+x3semWQJjDC6gqCK6WacBR3sW0CnTQE0EcvmhkqsbfPzkFAv1P3KhUD9sxG3O/MY6QpHuspSM/TJFA4XNCVwnidHtk7QF4r5f3BI+lRty2eTx7kv2ix6itammU9AUjNfA2v6LkAiv3j0D4xejV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toEViSmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toEViSmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CC3C4CEF5;
	Wed,  3 Dec 2025 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779048;
	bh=AiZzK23agAM5wEApMcdQQRZfdeA+ImZCVoL2Y3i7VeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toEViSmut7Ps+5rSNwG0uVXpWQZ5HMtOYbV0z9op1I/9n4wDanWxNxJXk7ktGAI6d
	 ZyKQ+KmGEsdvN6wNKhLaIthGPutxAM06D22MPSpf0lJj2rinl1OfcHtJuDoEG2kr1k
	 /TYxk0JahP7BUgph56kblWFUmPEUaXdZ+AJq6Ax8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming01@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/568] irqchip/loongson-pch-lpc: Use legacy domain for PCH-LPC IRQ controller
Date: Wed,  3 Dec 2025 16:21:48 +0100
Message-ID: <20251203152444.618110633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Ming Wang <wangming01@loongson.cn>

[ Upstream commit c33c43f71bda362b292a6e57ac41b64342dc87b3 ]

On certain Loongson platforms, drivers attempting to request a legacy
ISA IRQ directly via request_irq() (e.g., IRQ 4) may fail. The
virtual IRQ descriptor is not fully initialized and lacks a valid irqchip.

This issue does not affect ACPI-enumerated devices described in DSDT,
as their interrupts are properly mapped via the GSI translation path.
This indicates the LPC irqdomain itself is functional but is not correctly
handling direct VIRQ-to-HWIRQ mappings.

The root cause is the use of irq_domain_create_linear(). This API sets
up a domain for dynamic, on-demand mapping, typically triggered by a GSI
request. It does not pre-populate the mappings for the legacy VIRQ range
(0-15). Consequently, if no ACPI device claims a specific GSI
(e.g., GSI 4), the corresponding VIRQ (e.g., VIRQ 4) is never mapped to
the LPC domain. A direct call to request_irq(4, ...) then fails because
the kernel cannot resolve this VIRQ to a hardware interrupt managed by
the LPC controller.

The PCH-LPC interrupt controller is an i8259-compatible legacy device
that requires a deterministic, static 1-to-1 mapping for IRQs 0-15 to
support legacy drivers.

Fix this by replacing irq_domain_create_linear() with
irq_domain_create_legacy(). This API is specifically designed for such
controllers. It establishes the required static 1-to-1 VIRQ-to-HWIRQ
mapping for the entire legacy range (0-15) immediately upon domain
creation. This ensures that any VIRQ in this range is always resolvable,
making direct calls to request_irq() for legacy IRQs function correctly.

Signed-off-by: Ming Wang <wangming01@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-pch-lpc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-pch-lpc.c b/drivers/irqchip/irq-loongson-pch-lpc.c
index bf2324910a75c..c11c645cce525 100644
--- a/drivers/irqchip/irq-loongson-pch-lpc.c
+++ b/drivers/irqchip/irq-loongson-pch-lpc.c
@@ -176,8 +176,13 @@ int __init pch_lpc_acpi_init(struct irq_domain *parent,
 		goto iounmap_base;
 	}
 
-	priv->lpc_domain = irq_domain_create_linear(irq_handle, LPC_COUNT,
-					&pch_lpc_domain_ops, priv);
+	/*
+	 * The LPC interrupt controller is a legacy i8259-compatible device,
+	 * which requires a static 1:1 mapping for IRQs 0-15.
+	 * Use irq_domain_create_legacy to establish this static mapping early.
+	 */
+	priv->lpc_domain = irq_domain_create_legacy(irq_handle, LPC_COUNT, 0, 0,
+						    &pch_lpc_domain_ops, priv);
 	if (!priv->lpc_domain) {
 		pr_err("Failed to create IRQ domain\n");
 		goto free_irq_handle;
-- 
2.51.0



