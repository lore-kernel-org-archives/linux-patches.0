Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7CE299943;
	Thu, 27 Nov 2025 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255172; cv=none; b=RtjdfLtLNhN/1irWYAmFXH0JW1CkYrVUU9tgx2lzx4HT5CW1dV3xXLl3dOEvi+a9D1aEjhkF9qz60M1S11rHb8YME/Q3wO7Ll3ijlWaAS2LjM+TfRgYqaMzBzWU4cacB8eIcWsJdk7eQeVood8PNvyvI/dHk6+11y4ln7X+Ixhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255172; c=relaxed/simple;
	bh=TzHJ0lBnOcgby6rHskoU0f9UI+W3SDTrvTNuYjMHipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyL91T2HKgn0KFW1d3scVtugM/iTfxaJvhK9l7ZbAPRI+T6fJa3fn9q2xveBG3AM+lTx47DbG0KYfsuMSsStAn3u26RadQxI8PL+PCCwImWOYtAu+mYPDMwzXF9yUL7FqOgG8WLVCZTkpDSb9XO22wIneat34G0oqYAPm+6k+kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHnFxCM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHnFxCM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF8CC113D0;
	Thu, 27 Nov 2025 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255171;
	bh=TzHJ0lBnOcgby6rHskoU0f9UI+W3SDTrvTNuYjMHipU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHnFxCM03ZQpGm6mQIlSELfvbNSTWvvP6dXU0eBnuzA0+LcFdcMExkTsj4sK7EqbB
	 JMGThK3NqOGjTyhXp7SBK5fjbRxMsiAUMrT7EbwGA+gjvyEjrzucDFwABsAiCz/+bl
	 Vq+MIrAmehXt0eLic+dzjrGkvhRwNKKrn++PT+4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 033/112] MIPS: Malta: Fix !EVA SOC-it PCI MMIO
Date: Thu, 27 Nov 2025 15:45:35 +0100
Message-ID: <20251127144034.050910101@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit ebd729fef31620e0bf74cbf8a4c7fda73a2a4e7e upstream.

Fix a regression that has caused accesses to the PCI MMIO window to
complete unclaimed in non-EVA configurations with the SOC-it family of
system controllers, preventing PCI devices from working that use MMIO.

In the non-EVA case PHYS_OFFSET is set to 0, meaning that PCI_BAR0 is
set with an empty mask (and PCI_HEAD4 matches addresses starting from 0
accordingly).  Consequently all addresses are matched for incoming DMA
accesses from PCI.  This seems to confuse the system controller's logic
and outgoing bus cycles targeting the PCI MMIO window seem not to make
it to the intended devices.

This happens as well when a wider mask is used with PCI_BAR0, such as
0x80000000 or 0xe0000000, that makes addresses match that overlap with
the PCI MMIO window, which starts at 0x10000000 in our configuration.

Set the mask in PCI_BAR0 to 0xf0000000 for non-EVA then, covering the
non-EVA maximum 256 MiB of RAM, which is what YAMON does and which used
to work correctly up to the offending commit.  Set PCI_P2SCMSKL to match
PCI_BAR0 as required by the system controller's specification, and match
PCI_P2SCMAPL to PCI_HEAD4 for identity mapping.

Verified with:

Core board type/revision =      0x0d (Core74K) / 0x01
System controller/revision =    MIPS SOC-it 101 OCP / 1.3   SDR-FW-4:1
Processor Company ID/options =  0x01 (MIPS Technologies, Inc.) / 0x1c
Processor ID/revision =         0x97 (MIPS 74Kf) / 0x4c

for non-EVA and with:

Core board type/revision =      0x0c (CoreFPGA-5) / 0x00
System controller/revision =    MIPS ROC-it2 / 0.0   FW-1:1 (CLK_unknown) GIC
Processor Company ID/options =  0x01 (MIPS Technologies, Inc.) / 0x00
Processor ID/revision =         0xa0 (MIPS interAptiv UP) / 0x20

for EVA/non-EVA, fixing:

defxx 0000:00:12.0: assign IRQ: got 10
defxx: v1.12 2021/03/10  Lawrence V. Stefani and others
0000:00:12.0: Could not read adapter factory MAC address!

vs:

defxx 0000:00:12.0: assign IRQ: got 10
defxx: v1.12 2021/03/10  Lawrence V. Stefani and others
0000:00:12.0: DEFPA at MMIO addr = 0x10142000, IRQ = 10, Hardware addr = 00-00-f8-xx-xx-xx
0000:00:12.0: registered as fddi0

for non-EVA and causing no change for EVA.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 422dd256642b ("MIPS: Malta: Allow PCI devices DMA to lower 2GB physical")
Cc: stable@vger.kernel.org # v4.9+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mti-malta/malta-init.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/arch/mips/mti-malta/malta-init.c
+++ b/arch/mips/mti-malta/malta-init.c
@@ -241,16 +241,22 @@ mips_pci_controller:
 #endif
 
 		/*
-		 * Setup the Malta max (2GB) memory for PCI DMA in host bridge
-		 * in transparent addressing mode.
+		 * Set up memory mapping in host bridge for PCI DMA masters,
+		 * in transparent addressing mode.  For EVA use the Malta
+		 * maximum of 2 GiB memory in the alias space at 0x80000000
+		 * as per PHYS_OFFSET.  Otherwise use 256 MiB of memory in
+		 * the regular space, avoiding mapping the PCI MMIO window
+		 * for DMA as it seems to confuse the system controller's
+		 * logic, causing PCI MMIO to stop working.
 		 */
-		mask = PHYS_OFFSET | PCI_BASE_ADDRESS_MEM_PREFETCH;
-		MSC_WRITE(MSC01_PCI_BAR0, mask);
-		MSC_WRITE(MSC01_PCI_HEAD4, mask);
+		mask = PHYS_OFFSET ? PHYS_OFFSET : 0xf0000000;
+		MSC_WRITE(MSC01_PCI_BAR0,
+			  mask | PCI_BASE_ADDRESS_MEM_PREFETCH);
+		MSC_WRITE(MSC01_PCI_HEAD4,
+			  PHYS_OFFSET | PCI_BASE_ADDRESS_MEM_PREFETCH);
 
-		mask &= MSC01_PCI_BAR0_SIZE_MSK;
 		MSC_WRITE(MSC01_PCI_P2SCMSKL, mask);
-		MSC_WRITE(MSC01_PCI_P2SCMAPL, mask);
+		MSC_WRITE(MSC01_PCI_P2SCMAPL, PHYS_OFFSET);
 
 		/* Don't handle target retries indefinitely.  */
 		if ((data & MSC01_PCI_CFG_MAXRTRY_MSK) ==


