Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB72C3C01;
	Tue, 27 May 2025 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367406; cv=none; b=gPoIRGFihCpay5SP/8FrcM6xWeK1cgmr2+8RLwFmgFxTKPR46n61o5yp0AGWMfvPVL/L1X7IxMnvCPx0ByZ/aivdO8v9++NZWLW3dQNhr19w1TuJzRtgvAs8pnoFDezw/7yDZPKocbFbOhLWbFPjiIZ3rnPneoxZdbOGpU5ghrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367406; c=relaxed/simple;
	bh=rUh5y+fksvRLHqpqxHnxoqX60LszluTlNbhL/cQ7xbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+1faYkA9E6yXFibBWY/b12PEMOUrV4zeYsIFtQpSHZqnUGqe/gW3ob5q5zVUKKKtcWCS7kilmtU+8vnn4tWL09O12XB5F8QS9Q1UWzSSorzF6OW/LkuT6EPTvAxGHwmOIWCvCxjCeL1HcrfIR4+u4uHx912dx8/InWu+SnSIqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3fREAaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3fREAaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C2EC4CEE9;
	Tue, 27 May 2025 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367406;
	bh=rUh5y+fksvRLHqpqxHnxoqX60LszluTlNbhL/cQ7xbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3fREAaCh1Ys5juHSJqbuHxc/frqx900/GHWc2XRJMWO2/B3Gvr64tEdUnsGUjmw9
	 lRBi4bNvqZvNGbk5Pc6TDZv/7a0kBuscrqsXgT2l7Isc68HP2jkJcj2YfytNV0aPyE
	 dH1yR+JYH7iw9w7qv2C1zCd/1qTnZ1tpdcwXOlZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balbir Singh <balbirs@nvidia.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.14 376/783] x86/kaslr: Reduce KASLR entropy on most x86 systems
Date: Tue, 27 May 2025 18:22:53 +0200
Message-ID: <20250527162528.401538248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balbir Singh <balbirs@nvidia.com>

[ Upstream commit 7ffb791423c7c518269a9aad35039ef824a40adb ]

When CONFIG_PCI_P2PDMA=y (which is basically enabled on all
large x86 distros), it maps the PFN's via a ZONE_DEVICE
mapping using devm_memremap_pages(). The mapped virtual
address range corresponds to the pci_resource_start()
of the BAR address and size corresponding to the BAR length.

When KASLR is enabled, the direct map range of the kernel is
reduced to the size of physical memory plus additional padding.
If the BAR address is beyond this limit, PCI peer to peer DMA
mappings fail.

Fix this by not shrinking the size of the direct map when
CONFIG_PCI_P2PDMA=y.

This reduces the total available entropy, but it's better than
the current work around of having to disable KASLR completely.

[ mingo: Clarified the changelog to point out the broad impact ... ]

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com> # drivers/pci/Kconfig
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/lkml/20250206023201.1481957-1-balbirs@nvidia.com/
Link: https://lore.kernel.org/r/20250206234234.1912585-1-balbirs@nvidia.com
--
 arch/x86/mm/kaslr.c | 10 ++++++++--
 drivers/pci/Kconfig |  6 ++++++
 2 files changed, 14 insertions(+), 2 deletions(-)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/kaslr.c | 10 ++++++++--
 drivers/pci/Kconfig |  6 ++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 11a93542d1983..3c306de52fd4d 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -113,8 +113,14 @@ void __init kernel_randomize_memory(void)
 	memory_tb = DIV_ROUND_UP(max_pfn << PAGE_SHIFT, 1UL << TB_SHIFT) +
 		CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
 
-	/* Adapt physical memory region size based on available memory */
-	if (memory_tb < kaslr_regions[0].size_tb)
+	/*
+	 * Adapt physical memory region size based on available memory,
+	 * except when CONFIG_PCI_P2PDMA is enabled. P2PDMA exposes the
+	 * device BAR space assuming the direct map space is large enough
+	 * for creating a ZONE_DEVICE mapping in the direct map corresponding
+	 * to the physical BAR address.
+	 */
+	if (!IS_ENABLED(CONFIG_PCI_P2PDMA) && (memory_tb < kaslr_regions[0].size_tb))
 		kaslr_regions[0].size_tb = memory_tb;
 
 	/*
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 2fbd379923fd1..5c3054aaec8c1 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -203,6 +203,12 @@ config PCI_P2PDMA
 	  P2P DMA transactions must be between devices behind the same root
 	  port.
 
+	  Enabling this option will reduce the entropy of x86 KASLR memory
+	  regions. For example - on a 46 bit system, the entropy goes down
+	  from 16 bits to 15 bits. The actual reduction in entropy depends
+	  on the physical address bits, on processor features, kernel config
+	  (5 level page table) and physical memory present on the system.
+
 	  If unsure, say N.
 
 config PCI_LABEL
-- 
2.39.5



