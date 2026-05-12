Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3754C6FC5;
	Tue, 12 May 2026 18:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609520; cv=none; b=TG+6f1xKLq8ungbsy3v8PTrB8EDZCJF9AwxFCuCGuLJz4/HI0UcryVDaPPkD/9rdZvBAsl9nWSEorimkgpJjZrQ+8cszUPdKbXkBLoRf2bPechcYHQMPF3sW/iIUFsA7yjf/kDzo2LnQBywndalDHiwVcG9xJG/tuSiT5LxaQm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609520; c=relaxed/simple;
	bh=BNoB3oxIzE9HWSF5vrlQbZnKFeOH8bWv81HTXbfdeZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZESVbkGYuUpMSZ8NyXq1GTlnUqqP8u62Rc1W7D8IyYiW0WQGy8besYsfY13VJYoLNc1ZNjaACeirXmXmswuus/SAdJKnkwAatfk2adyDdB/m0uOvereaKK2mFkm+mBMxPXFj3kpIbasm/MyUwf6g+ACbY32eQAc6FqBaC5K7Efw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIpex2zF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIpex2zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32C9C2BCB0;
	Tue, 12 May 2026 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609520;
	bh=BNoB3oxIzE9HWSF5vrlQbZnKFeOH8bWv81HTXbfdeZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIpex2zFxFL/6cLQXeGkNXZSw+/qhsegt4ljSv6CbnOaZ7BzQpLlztLdsazMfQXrI
	 R7ggrxoLMAu9bibmgQvVhezn5keDKdZ93CJnqcRoz7jGTicW4FJvN5iloyxMo36NvM
	 l/q2tnFmvu7JsrjQfQgCrN9dLvxEzPMCmK7belRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Nam Cao <namcao@linutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.0 227/307] powerpc/xive: fix kmemleak caused by incorrect chip_data lookup
Date: Tue, 12 May 2026 19:40:22 +0200
Message-ID: <20260512173944.909500074@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

commit 6771c54728c278bf1e4bfdab4fddbbb186e33498 upstream.

The kmemleak reports the following memory leak:

Unreferenced object 0xc0000002a7fbc640 (size 64):
  comm "kworker/8:1", pid 540, jiffies 4294937872
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 09 04 00 04 00 00  ................
    00 00 a7 81 00 00 0a c0 00 00 08 04 00 04 00 00  ................
  backtrace (crc 177d48f6):
    __kmalloc_cache_noprof+0x520/0x730
    xive_irq_alloc_data.constprop.0+0x40/0xe0
    xive_irq_domain_alloc+0xd0/0x1b0
    irq_domain_alloc_irqs_parent+0x44/0x6c
    pseries_irq_domain_alloc+0x1cc/0x354
    irq_domain_alloc_irqs_parent+0x44/0x6c
    msi_domain_alloc+0xb0/0x220
    irq_domain_alloc_irqs_locked+0x138/0x4d0
    __irq_domain_alloc_irqs+0x8c/0xfc
    __msi_domain_alloc_irqs+0x214/0x4d8
    msi_domain_alloc_irqs_all_locked+0x70/0xf8
    pci_msi_setup_msi_irqs+0x60/0x78
    __pci_enable_msix_range+0x54c/0x98c
    pci_alloc_irq_vectors_affinity+0x16c/0x1d4
    nvme_pci_enable+0xac/0x9c0 [nvme]
    nvme_probe+0x340/0x764 [nvme]

This occurs when allocating MSI-X vectors for an NVMe device. During
allocation the XIVE code creates a struct xive_irq_data and stores it
in irq_data->chip_data.

When the MSI-X irqdomain is later freed, xive_irq_free_data() is
responsible for retrieving this structure and freeing it. However,
after commit cc0cc23babc9 ("powerpc/xive: Untangle xive from child
interrupt controller drivers"), xive_irq_free_data() retrieves the
chip_data using irq_get_chip_data(), which looks up the data through
the child domain.

This is incorrect because the XIVE-specific irq data is associated with
the XIVE (parent) domain. As a result the lookup fails and the allocated
struct xive_irq_data is never freed, leading to the kmemleak report
shown above.

Fix this by retrieving the irq_data from the correct domain using
irq_domain_get_irq_data() and then accessing the chip_data via
irq_data_get_irq_chip_data().

Cc: stable@vger.kernel.org
Fixes: cc0cc23babc9 ("powerpc/xive: Untangle xive from child interrupt controller drivers")
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260311134336.326996-1-nilay@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/sysdev/xive/common.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1038,13 +1038,19 @@ static struct xive_irq_data *xive_irq_al
 	return xd;
 }
 
-static void xive_irq_free_data(unsigned int virq)
+static void xive_irq_free_data(struct irq_domain *domain, unsigned int virq)
 {
-	struct xive_irq_data *xd = irq_get_chip_data(virq);
+	struct xive_irq_data *xd;
+	struct irq_data *data = irq_domain_get_irq_data(domain, virq);
+
+	if (!data)
+		return;
 
+	xd = irq_data_get_irq_chip_data(data);
 	if (!xd)
 		return;
-	irq_set_chip_data(virq, NULL);
+
+	irq_domain_reset_irq_data(data);
 	xive_cleanup_irq_data(xd);
 	kfree(xd);
 }
@@ -1305,7 +1311,7 @@ static int xive_irq_domain_map(struct ir
 
 static void xive_irq_domain_unmap(struct irq_domain *d, unsigned int virq)
 {
-	xive_irq_free_data(virq);
+	xive_irq_free_data(d, virq);
 }
 
 static int xive_irq_domain_xlate(struct irq_domain *h, struct device_node *ct,
@@ -1443,7 +1449,7 @@ static void xive_irq_domain_free(struct
 	pr_debug("%s %d #%d\n", __func__, virq, nr_irqs);
 
 	for (i = 0; i < nr_irqs; i++)
-		xive_irq_free_data(virq + i);
+		xive_irq_free_data(domain, virq + i);
 }
 #endif
 


