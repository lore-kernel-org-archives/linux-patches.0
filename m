Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248F91C28E;
	Tue, 11 Nov 2025 01:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822827; cv=none; b=kYUkm3fbQLkl7FHKMo19un286ipF2ENPom5gwcNMFlm7lqvBsGOkueZDO14uwiLqtbZPWMhiXw40IOAxkMr3NkBNCBAZYUj6bzV78jND8YEnumasv5yO+Lzu29IPDn3aPQdqWD1S+Vxel7AmLNmndJM6iPWIsFznLWPNqgy2XL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822827; c=relaxed/simple;
	bh=ag2gKjFIffvOWv2EW+bn/C+mCJMFpHAnH6gWL9/TcE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFc70odQAvczVVnVnXX7GKqbj+tiattKh5FEMhWhGDgFJZ1FcFC6SsnBfVyG2Txi4znQH8bDBTeBieUbOJVYiQkFTOnYnaEcs2wrmTwxgKZWBsv0siCAYNJl9RCpMroUrxFN0dOkAUDJ/MqTW3fdA9MuY5rfzwwJ125B/PeAkXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x76YPgo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x76YPgo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AADC116B1;
	Tue, 11 Nov 2025 01:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822827;
	bh=ag2gKjFIffvOWv2EW+bn/C+mCJMFpHAnH6gWL9/TcE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x76YPgo07v0nhfw55znHe2Qhhypk2zPzgERcmrXGdBzjxWDY6wRUDe0APkS1O45DB
	 Hn4hgKEQHOoJbUNFPUZpquteyB0V9ppOfP5y2skkp9RAo6UqTs0wtHNOYK6CunCq72
	 sO41kIb6Q78nsFSww1aH8eyUgaBE/QwQGbdNx85M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming01@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 165/849] irqchip/loongson-pch-lpc: Use legacy domain for PCH-LPC IRQ controller
Date: Tue, 11 Nov 2025 09:35:35 +0900
Message-ID: <20251111004540.423361664@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 2d4c3ec128b8f..912bf50a5c7ca 100644
--- a/drivers/irqchip/irq-loongson-pch-lpc.c
+++ b/drivers/irqchip/irq-loongson-pch-lpc.c
@@ -200,8 +200,13 @@ int __init pch_lpc_acpi_init(struct irq_domain *parent,
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



