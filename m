Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060F8340295;
	Wed, 21 Jan 2026 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020269; cv=none; b=gRQIAt/xT5GVTZUzqSSKKa4D0w0xDw5J//KFWTbDQn7Auv6uN3Fwf+w6R9DUl5G1f+Vv15AcVLCINl+SWt3Tmj/DumCaDNJDoxkn6Bm+Sjf0M6Bz48sbY+jIzcjoaw0GfBgcSn1VVBM8eXqiojt9xB/R7jwwq2zKHqwEJh+3spM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020269; c=relaxed/simple;
	bh=rpdViSNzz0mvHzUTSc4pdvnpamX1j9yrJJOo9zTsAEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST6ymUF9kADMLv1k7eBvgUZDMpq6A2AtA1Y2bzURTFDwrLb4CQXZS4wdoU4VOCYPeWNKR+Acn//pWx1f44CIKlZ8NzmaA7LpjNUNWpaZJgoiCU/P8SY5B0TOp7+OG76y0MZYAtp3Q68CPNZJRt4ALHtZjpiSxIxAthZy7dmeXkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIGu5HjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIGu5HjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535FAC4CEF1;
	Wed, 21 Jan 2026 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020268;
	bh=rpdViSNzz0mvHzUTSc4pdvnpamX1j9yrJJOo9zTsAEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIGu5HjNC5MgLWO6YAWNYKhjnc6N41D2eOE9yw/AK4TENj1lJSTPt+FgP59GHhWja
	 op6oBUMB+OyX426LXZKnLuu7Jq3plVLIa8Xnnds0Edp5PgjsSUHUNJPbWOrXWe0daq
	 1GmbOO5jVy4X+oMs6MQOJ33cBBKRtxY53clhNC0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Yasunori Goto <y-goto@fujitsu.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.18 109/198] x86/kaslr: Recognize all ZONE_DEVICE users as physaddr consumers
Date: Wed, 21 Jan 2026 19:15:37 +0100
Message-ID: <20260121181422.475673827@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 269031b15c1433ff39e30fa7ea3ab8f0be9d6ae2 upstream.

Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
is too narrow. The effect being mitigated in that commit is caused by
ZONE_DEVICE which PCI_P2PDMA has a dependency. ZONE_DEVICE, in general,
lets any physical address be added to the direct-map. I.e. not only ACPI
hotplug ranges, CXL Memory Windows, or EFI Specific Purpose Memory, but
also any PCI MMIO range for the DEVICE_PRIVATE and PCI_P2PDMA cases. Update
the mitigation, limit KASLR entropy, to apply in all ZONE_DEVICE=y cases.

Distro kernels typically have PCI_P2PDMA=y, so the practical exposure of
this problem is limited to the PCI_P2PDMA=n case.

A potential path to recover entropy would be to walk ACPI and determine the
limits for hotplug and PCI MMIO before kernel_randomize_memory(). On
smaller systems that could yield some KASLR address bits. This needs
additional investigation to determine if some limited ACPI table scanning
can happen this early without an open coded solution like
arch/x86/boot/compressed/acpi.c needs to deploy.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Yasunori Goto <y-goto@fujitsu.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://patch.msgid.link/692e08b2516d4_261c1100a3@dwillia2-mobl4.notmuch
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/kaslr.c |   10 +++++-----
 drivers/pci/Kconfig |    6 ------
 mm/Kconfig          |   10 +++++++---
 3 files changed, 12 insertions(+), 14 deletions(-)

--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -115,12 +115,12 @@ void __init kernel_randomize_memory(void
 
 	/*
 	 * Adapt physical memory region size based on available memory,
-	 * except when CONFIG_PCI_P2PDMA is enabled. P2PDMA exposes the
-	 * device BAR space assuming the direct map space is large enough
-	 * for creating a ZONE_DEVICE mapping in the direct map corresponding
-	 * to the physical BAR address.
+	 * except when CONFIG_ZONE_DEVICE is enabled. ZONE_DEVICE wants to map
+	 * any physical address into the direct-map. KASLR wants to reliably
+	 * steal some physical address bits. Those design choices are in direct
+	 * conflict.
 	 */
-	if (!IS_ENABLED(CONFIG_PCI_P2PDMA) && (memory_tb < kaslr_regions[0].size_tb))
+	if (!IS_ENABLED(CONFIG_ZONE_DEVICE) && (memory_tb < kaslr_regions[0].size_tb))
 		kaslr_regions[0].size_tb = memory_tb;
 
 	/*
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -207,12 +207,6 @@ config PCI_P2PDMA
 	  P2P DMA transactions must be between devices behind the same root
 	  port.
 
-	  Enabling this option will reduce the entropy of x86 KASLR memory
-	  regions. For example - on a 46 bit system, the entropy goes down
-	  from 16 bits to 15 bits. The actual reduction in entropy depends
-	  on the physical address bits, on processor features, kernel config
-	  (5 level page table) and physical memory present on the system.
-
 	  If unsure, say N.
 
 config PCI_LABEL
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1135,10 +1135,14 @@ config ZONE_DEVICE
 	  Device memory hotplug support allows for establishing pmem,
 	  or other device driver discovered memory regions, in the
 	  memmap. This allows pfn_to_page() lookups of otherwise
-	  "device-physical" addresses which is needed for using a DAX
-	  mapping in an O_DIRECT operation, among other things.
+	  "device-physical" addresses which is needed for DAX, PCI_P2PDMA, and
+	  DEVICE_PRIVATE features among others.
 
-	  If FS_DAX is enabled, then say Y.
+	  Enabling this option will reduce the entropy of x86 KASLR memory
+	  regions. For example - on a 46 bit system, the entropy goes down
+	  from 16 bits to 15 bits. The actual reduction in entropy depends
+	  on the physical address bits, on processor features, kernel config
+	  (5 level page table) and physical memory present on the system.
 
 #
 # Helpers to mirror range of the CPU page tables of a process into device page


