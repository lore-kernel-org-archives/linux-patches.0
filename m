Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9B24087C;
	Mon, 14 Oct 2024 15:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918305; cv=none; b=EWnz4fJg3XVDy2Ko1bzrOmurNHXKGd+gMwvelgflnkpHgNxN1E4GNdgLexhrI/N81Z8iV8h9tkq1IupEKuUJu47MlGkHeoq2/DH9cddEqN8pOTuZgBfHt0mwNgn4/JMS97w/fNWTMP9ti841ci/YP2tC2V+vo6LaAjLBHa2zZuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918305; c=relaxed/simple;
	bh=66DSo9FUd13orqdcljrxTm8Pfyje4XozOY+cE9Z+5JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1tHXv6h7uEOtSPqr7tp7vv6TQJuXwq2DwKtv853H+YC1hTYjmZyxf9+AsIeyX7vcguSIFVPpEFx6oqxdwRQTplozDf11eTkbK+Svn3eITRAKeqB92k3Ub8fu8xbl9K6GQKSJFl64BNcxe6mG35SZ5857LywQi0W2kiEMiUiX+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3rNHpl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3rNHpl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A578AC4CEC3;
	Mon, 14 Oct 2024 15:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918305;
	bh=66DSo9FUd13orqdcljrxTm8Pfyje4XozOY+cE9Z+5JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3rNHpl1nx1B8KMYZ4poBsgNTgQAjj13HMJrcmLkuW7AtmxUcIYLS9ggr0P3M6cS1
	 bwV3CC2RuEXICKs4jZ76zlw1c66vgrtMFArBqFAHRsE8r1L7V/S5nQOmPFtbI1klB7
	 JSX8U4BfyjxsT3HxT1lKyCTwN3w/jlD9ixEMf3gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 283/798] PCI: xilinx-nwl: Fix off-by-one in INTx IRQ handler
Date: Mon, 14 Oct 2024 16:13:57 +0200
Message-ID: <20241014141229.065594416@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

commit 0199d2f2bd8cd97b310f7ed82a067247d7456029 upstream.

MSGF_LEG_MASK is laid out with INTA in bit 0, INTB in bit 1, INTC in bit 2,
and INTD in bit 3. Hardware IRQ numbers start at 0, and we register
PCI_NUM_INTX IRQs. So to enable INTA (aka hwirq 0) we should set bit 0.
Remove the subtraction of one.

This bug would cause INTx interrupts not to be delivered, as enabling INTB
would actually enable INTA, and enabling INTA wouldn't enable anything at
all. It is likely that this got overlooked for so long since most PCIe
hardware uses MSIs. This fixes the following UBSAN error:

  UBSAN: shift-out-of-bounds in ../drivers/pci/controller/pcie-xilinx-nwl.c:389:11
  shift exponent 18446744073709551615 is too large for 32-bit type 'int'
  CPU: 1 PID: 61 Comm: kworker/u10:1 Not tainted 6.6.20+ #268
  Hardware name: xlnx,zynqmp (DT)
  Workqueue: events_unbound deferred_probe_work_func
  Call trace:
  dump_backtrace (arch/arm64/kernel/stacktrace.c:235)
  show_stack (arch/arm64/kernel/stacktrace.c:242)
  dump_stack_lvl (lib/dump_stack.c:107)
  dump_stack (lib/dump_stack.c:114)
  __ubsan_handle_shift_out_of_bounds (lib/ubsan.c:218 lib/ubsan.c:387)
  nwl_unmask_leg_irq (drivers/pci/controller/pcie-xilinx-nwl.c:389 (discriminator 1))
  irq_enable (kernel/irq/internals.h:234 kernel/irq/chip.c:170 kernel/irq/chip.c:439 kernel/irq/chip.c:432 kernel/irq/chip.c:345)
  __irq_startup (kernel/irq/internals.h:239 kernel/irq/chip.c:180 kernel/irq/chip.c:250)
  irq_startup (kernel/irq/chip.c:270)
  __setup_irq (kernel/irq/manage.c:1800)
  request_threaded_irq (kernel/irq/manage.c:2206)
  pcie_pme_probe (include/linux/interrupt.h:168 drivers/pci/pcie/pme.c:348)

Fixes: 9a181e1093af ("PCI: xilinx-nwl: Modify IRQ chip for legacy interrupts")
Link: https://lore.kernel.org/r/20240531161337.864994-3-sean.anderson@linux.dev
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-xilinx-nwl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -374,7 +374,7 @@ static void nwl_mask_leg_irq(struct irq_
 	u32 mask;
 	u32 val;
 
-	mask = 1 << (data->hwirq - 1);
+	mask = 1 << data->hwirq;
 	raw_spin_lock_irqsave(&pcie->leg_mask_lock, flags);
 	val = nwl_bridge_readl(pcie, MSGF_LEG_MASK);
 	nwl_bridge_writel(pcie, (val & (~mask)), MSGF_LEG_MASK);
@@ -388,7 +388,7 @@ static void nwl_unmask_leg_irq(struct ir
 	u32 mask;
 	u32 val;
 
-	mask = 1 << (data->hwirq - 1);
+	mask = 1 << data->hwirq;
 	raw_spin_lock_irqsave(&pcie->leg_mask_lock, flags);
 	val = nwl_bridge_readl(pcie, MSGF_LEG_MASK);
 	nwl_bridge_writel(pcie, (val | mask), MSGF_LEG_MASK);


