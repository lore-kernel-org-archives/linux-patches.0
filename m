Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B802FA642;
	Tue, 17 Jun 2025 16:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178754; cv=none; b=tC0jPpVDhIyVHMYGNvfPqNxRp1XRH5bBG9nKcY7GWX1Mp20KQI9JDq02KbRqZdwNlGJsaDids2kW2cfOckrnV4gvD+ezPZVhTk3oOyqC7KU/rLXA4pxrIip9fgIU0pndrzesNxnYzWGita45GpsyMXYZH67L1Ar9ZX76FcOMFjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178754; c=relaxed/simple;
	bh=AEMy/fWeDQnKC5gqbSavomUTEomQ7ebeSauZ1lVocQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld0u0VycedJe4+Wq6l5UC5TD14+eSx0VhLPgfzob0bZbrwzvhQ5RZhKFecbZP7bW4rVJPUeZQNXINT7PlBPgVjIDOvUX5opZAMl4SJQ2U/ceVibTd5g9iGoLBhP4SmSfsW0CjghkpHu4MBPMVAK5o0zairLCCXvvo7JFDbha970=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZxTjsb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZxTjsb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E388CC4CEE3;
	Tue, 17 Jun 2025 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178754;
	bh=AEMy/fWeDQnKC5gqbSavomUTEomQ7ebeSauZ1lVocQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZxTjsb1a7sUKeHWSek4V0gSaXuoxRM2WKqhdeFfNg10+sociTAIfKHGtSJq1V8qt
	 QV/vTllYy5Q0hqY2MaPYpnFhwKf1qAzOf+dwAANzQixSAHDjFAS+Q2s1vniV8zeJn4
	 5nn+PzcoRSpPK/1ltP3UnN5k61RHTrR7luMT+zeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 513/780] PCI: endpoint: Retain fixed-size BAR size as well as aligned size
Date: Tue, 17 Jun 2025 17:23:41 +0200
Message-ID: <20250617152512.404134154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 793908d60b8745c386b9f4e29eb702f74ceb0886 ]

When allocating space for an endpoint function on a BAR with a fixed size,
the size saved in 'struct pci_epf_bar.size' should be the fixed size as
expected by pci_epc_set_bar().

However, if pci_epf_alloc_space() increased the allocation size to
accommodate iATU alignment requirements, it previously saved the larger
aligned size in .size, which broke pci_epc_set_bar().

To solve this, keep the fixed BAR size in .size and save the aligned size
in a new .aligned_size for use when deallocating it.

Fixes: 2a9a801620ef ("PCI: endpoint: Add support to specify alignment for buffers allocated to BARs")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
[mani: commit message fixup]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[bhelgaas: more specific subject, commit log, wrap comment to match file]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20250424-pci-ep-size-alignment-v5-1-2d4ec2af23f5@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-epf-core.c | 22 +++++++++++++++-------
 include/linux/pci-epf.h             |  3 +++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/endpoint/pci-epf-core.c b/drivers/pci/endpoint/pci-epf-core.c
index 394395c7f8dec..577a9e490115c 100644
--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -236,12 +236,13 @@ void pci_epf_free_space(struct pci_epf *epf, void *addr, enum pci_barno bar,
 	}
 
 	dev = epc->dev.parent;
-	dma_free_coherent(dev, epf_bar[bar].size, addr,
+	dma_free_coherent(dev, epf_bar[bar].aligned_size, addr,
 			  epf_bar[bar].phys_addr);
 
 	epf_bar[bar].phys_addr = 0;
 	epf_bar[bar].addr = NULL;
 	epf_bar[bar].size = 0;
+	epf_bar[bar].aligned_size = 0;
 	epf_bar[bar].barno = 0;
 	epf_bar[bar].flags = 0;
 }
@@ -264,7 +265,7 @@ void *pci_epf_alloc_space(struct pci_epf *epf, size_t size, enum pci_barno bar,
 			  enum pci_epc_interface_type type)
 {
 	u64 bar_fixed_size = epc_features->bar[bar].fixed_size;
-	size_t align = epc_features->align;
+	size_t aligned_size, align = epc_features->align;
 	struct pci_epf_bar *epf_bar;
 	dma_addr_t phys_addr;
 	struct pci_epc *epc;
@@ -285,12 +286,18 @@ void *pci_epf_alloc_space(struct pci_epf *epf, size_t size, enum pci_barno bar,
 			return NULL;
 		}
 		size = bar_fixed_size;
+	} else {
+		/* BAR size must be power of two */
+		size = roundup_pow_of_two(size);
 	}
 
-	if (align)
-		size = ALIGN(size, align);
-	else
-		size = roundup_pow_of_two(size);
+	/*
+	 * Allocate enough memory to accommodate the iATU alignment
+	 * requirement.  In most cases, this will be the same as .size but
+	 * it might be different if, for example, the fixed size of a BAR
+	 * is smaller than align.
+	 */
+	aligned_size = align ? ALIGN(size, align) : size;
 
 	if (type == PRIMARY_INTERFACE) {
 		epc = epf->epc;
@@ -301,7 +308,7 @@ void *pci_epf_alloc_space(struct pci_epf *epf, size_t size, enum pci_barno bar,
 	}
 
 	dev = epc->dev.parent;
-	space = dma_alloc_coherent(dev, size, &phys_addr, GFP_KERNEL);
+	space = dma_alloc_coherent(dev, aligned_size, &phys_addr, GFP_KERNEL);
 	if (!space) {
 		dev_err(dev, "failed to allocate mem space\n");
 		return NULL;
@@ -310,6 +317,7 @@ void *pci_epf_alloc_space(struct pci_epf *epf, size_t size, enum pci_barno bar,
 	epf_bar[bar].phys_addr = phys_addr;
 	epf_bar[bar].addr = space;
 	epf_bar[bar].size = size;
+	epf_bar[bar].aligned_size = aligned_size;
 	epf_bar[bar].barno = bar;
 	if (upper_32_bits(size) || epc_features->bar[bar].only_64bit)
 		epf_bar[bar].flags |= PCI_BASE_ADDRESS_MEM_TYPE_64;
diff --git a/include/linux/pci-epf.h b/include/linux/pci-epf.h
index 879d19cebd4fc..749cee0bcf2cc 100644
--- a/include/linux/pci-epf.h
+++ b/include/linux/pci-epf.h
@@ -114,6 +114,8 @@ struct pci_epf_driver {
  * @phys_addr: physical address that should be mapped to the BAR
  * @addr: virtual address corresponding to the @phys_addr
  * @size: the size of the address space present in BAR
+ * @aligned_size: the size actually allocated to accommodate the iATU alignment
+ *                requirement
  * @barno: BAR number
  * @flags: flags that are set for the BAR
  */
@@ -121,6 +123,7 @@ struct pci_epf_bar {
 	dma_addr_t	phys_addr;
 	void		*addr;
 	size_t		size;
+	size_t		aligned_size;
 	enum pci_barno	barno;
 	int		flags;
 };
-- 
2.39.5



