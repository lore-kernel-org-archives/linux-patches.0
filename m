Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3741DFE35;
	Wed,  6 Nov 2024 13:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898209; cv=none; b=eLklVr+vCOL8VJ/akuiIqruVFnDzjOB0h+rAflgLnFdNmqwgjUaks5Xkt1A04FIlvuQwcfymtqYLrNzmT8xlekgNKKEg106mwKNUwRGEfTjN2z2HgZMkDFvO2Q+WAXUwUqIYNnE12UmATT5yR3c8Iy+0nCVrec+eJX+0cEhiiEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898209; c=relaxed/simple;
	bh=HRJnP+0CEEN1VzOyoX7lQydoP8bWhNRYWm0vH1A5kVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSLJSOAliMceggYhcxjUJSf5cfaVhXW8ESn8GZdjPw0DLHXDqtTR9+F4gX7q6vpgUwiELttwada2+HjihgO5oj3dlElvwKsSD92/uMhnNXnRW9wFode3iwwSGTd8MqDSF7fo4gru+FneGl14fwVLORCGKN+qe6MejwQ6k7U5ZVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9DB5fq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9DB5fq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49331C4CED3;
	Wed,  6 Nov 2024 13:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898209;
	bh=HRJnP+0CEEN1VzOyoX7lQydoP8bWhNRYWm0vH1A5kVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9DB5fq/FtmbL2VSGT7kPYdwYpuChqgzWA0AUiG+4arORpkf5e9GkiiPuGRbeqoVc
	 eNhV5hOVY17oZPm0og2HMsPbgiJbLHlBLDWOL05io0lUc2J6BGBpPfQbTPqD5Ybysz
	 ke9+B+NvLGzMzqKcHyZ+/cMy2ebcUCBQrDcDxyBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/462] PCI: xilinx-nwl: Fix off-by-one in INTx IRQ handler
Date: Wed,  6 Nov 2024 13:00:55 +0100
Message-ID: <20241106120335.523068944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 0199d2f2bd8cd97b310f7ed82a067247d7456029 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-nwl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-xilinx-nwl.c b/drivers/pci/controller/pcie-xilinx-nwl.c
index eb23bb28221a8..f08606f25e3c8 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -389,7 +389,7 @@ static void nwl_mask_leg_irq(struct irq_data *data)
 	u32 mask;
 	u32 val;
 
-	mask = 1 << (data->hwirq - 1);
+	mask = 1 << data->hwirq;
 	raw_spin_lock_irqsave(&pcie->leg_mask_lock, flags);
 	val = nwl_bridge_readl(pcie, MSGF_LEG_MASK);
 	nwl_bridge_writel(pcie, (val & (~mask)), MSGF_LEG_MASK);
@@ -403,7 +403,7 @@ static void nwl_unmask_leg_irq(struct irq_data *data)
 	u32 mask;
 	u32 val;
 
-	mask = 1 << (data->hwirq - 1);
+	mask = 1 << data->hwirq;
 	raw_spin_lock_irqsave(&pcie->leg_mask_lock, flags);
 	val = nwl_bridge_readl(pcie, MSGF_LEG_MASK);
 	nwl_bridge_writel(pcie, (val | mask), MSGF_LEG_MASK);
-- 
2.43.0



