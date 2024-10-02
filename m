Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2631C8F5E;
	Wed,  2 Oct 2024 14:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880314; cv=none; b=qEpDKqB1rnWgoNhtvj1RA9ys6ZNOXJOznUqfhzgnoCEbhlGNdTPCq9jQ5wjVSSUArxXdrWNe9FqXfLywxFmiy7dyyBuJE1cKK5PLjoEyTUM+j3US243hiuVgQI1U5INdlWmlv6a8HzSZjg46AoMaJRZ6rZ+FpL5af7prG469m+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880314; c=relaxed/simple;
	bh=dZJVhubBSFYqSGP6sZA9k1EFvi7HFqFapHMlg9wasi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cd1Hrlp2q3sexud/POJO3T3kS2juoyjZPv+r36sD+byLwAIYkHpipoR+Pwu7ko1u9v539ngfHGDOnatsbEGAJ/NiaCGM2wWXAZaFMNsVyhCmhhM65iEPyirOjKBjWtgC8En6cFaPc7/jcMkAZhyU3tXqIlDNhB2Tz5zGGrDlXgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY8GRaXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY8GRaXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531DAC4CEC5;
	Wed,  2 Oct 2024 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880313;
	bh=dZJVhubBSFYqSGP6sZA9k1EFvi7HFqFapHMlg9wasi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY8GRaXRg5Mc5dc+DbOK1zAaV/I5Ee5GIXLpxefnGouuqgyrp2k4VAK762nt9wP8k
	 QNu58K7tiom7bQX4XlvEhRnt7debO9Wn38HHDKUHOiSOOYGS7ZZKomCf48W4RqgXLT
	 vBlHKhuLWyHY2xgZG/H9ohEg8EbPxWq8kzrJRb2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 399/538] PCI: xilinx-nwl: Fix off-by-one in INTx IRQ handler
Date: Wed,  2 Oct 2024 15:00:38 +0200
Message-ID: <20241002125808.188227898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -373,7 +373,7 @@ static void nwl_mask_leg_irq(struct irq_
 	u32 mask;
 	u32 val;
 
-	mask = 1 << (data->hwirq - 1);
+	mask = 1 << data->hwirq;
 	raw_spin_lock_irqsave(&pcie->leg_mask_lock, flags);
 	val = nwl_bridge_readl(pcie, MSGF_LEG_MASK);
 	nwl_bridge_writel(pcie, (val & (~mask)), MSGF_LEG_MASK);
@@ -387,7 +387,7 @@ static void nwl_unmask_leg_irq(struct ir
 	u32 mask;
 	u32 val;
 
-	mask = 1 << (data->hwirq - 1);
+	mask = 1 << data->hwirq;
 	raw_spin_lock_irqsave(&pcie->leg_mask_lock, flags);
 	val = nwl_bridge_readl(pcie, MSGF_LEG_MASK);
 	nwl_bridge_writel(pcie, (val | mask), MSGF_LEG_MASK);


