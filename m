Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5382580F9;
	Mon,  1 Dec 2025 11:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588766; cv=none; b=T4KFKszxVQXm0jSNSpCkk1js1n05cw4IBkCBK0Q3cwPS6XE/0D7FtPL+t+NP2qQ3HZfj9TIemE9jprCnwy/WI7H3aUtnydTeOEwU9S01o8HA+6Fx6kNBfaO1Sau2wZsExB8CnbNp7dc/wt5OVrElNfzqwz8gcONWABhZSddpFOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588766; c=relaxed/simple;
	bh=O4h1J8c1BSrUhnbQBl4ti0KklpyrqQjHmUTiB65evB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq/HdspCICQoucBi7Qh27WdVblYNvwHDpYccePCqcB5dIU6qQrh7VauIrwgKyxm8wSEDaMZiXOSMI65cavehh4rAOMiSwlOAXWaMhcIIRcYlBnb+r8Blzc36/Mhqq7dgRoPulbqIqyoEzsT4XjKiRMvXA0omInlhFzFdnbqbf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHVikybx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHVikybx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0B4C4CEF1;
	Mon,  1 Dec 2025 11:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588766;
	bh=O4h1J8c1BSrUhnbQBl4ti0KklpyrqQjHmUTiB65evB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHVikybxu4yjvMKL2OA7hFPyZxH45/9Qk/2UFg2+nuzERDF3NYUD6fJUtOVqu7pBs
	 dFxjMF8dhk9Vevm97d9TixIWTSMI31sWMsNwCPsLagEpBchpm3XSlme/lmXu7qj0Z9
	 TH2UddfM4MgBFYzeByjr5l1QqDO65v9wKb4Z2/Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 164/187] MIPS: Malta: Fix !EVA SOC-it PCI MMIO
Date: Mon,  1 Dec 2025 12:24:32 +0100
Message-ID: <20251201112247.137525372@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -242,16 +242,22 @@ mips_pci_controller:
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


