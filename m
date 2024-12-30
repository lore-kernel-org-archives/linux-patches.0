Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7320615E8B;
	Mon, 30 Dec 2024 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574286; cv=none; b=D4cAbXZIJ5pKS7JDaWOLm2NWS//yGbP6sm/pT474H8OPHhy/FULOoHd+3uql88QSxIEm1HZu6HzPb8FahA+W8RvyBK8OEh+DjaNZLii+s08HhxOAczmiQYE5tTUvUlwCNJvKKbUgLP9IA6+OQ8az2rMwofkxLvmvP+ZtN6pelRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574286; c=relaxed/simple;
	bh=voTdoOKJ1kyCQmN25rxspeoYOTYKQC3N5XSG8RYG8YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/tZz5SqYjNgIbigju++kogmnXbJj2lbq8NN+JbDLwGPD0unO9kD8jTAfger63O7QdD8Ns+r/yiM2MRppHdawBPzwJAlHDqNA60bab3AYpw+xBgrhEMmisOhbX6jFFbjyqSuCurMNmv9EE8m3KjHmkmnXkoilXwtlFBRfO8ay9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfAGPDl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfAGPDl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1ACC4CED0;
	Mon, 30 Dec 2024 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574286;
	bh=voTdoOKJ1kyCQmN25rxspeoYOTYKQC3N5XSG8RYG8YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfAGPDl+E2QJowHY0m30aqDnzR7h2j/gNj/uyi9SgF0+Z/F7dUT+HAilCJ788kWK2
	 BslwIQ9wmRF5S4czm2FO2r6ojTW5TLND/YN5rLbgKCs8M75CnZs/tf2/nqH3XrWI+f
	 vZSk43fu3slyxQjQjyBPxz/qcNDG5C8ErZHWrPTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 092/114] PCI/MSI: Handle lack of irqdomain gracefully
Date: Mon, 30 Dec 2024 16:43:29 +0100
Message-ID: <20241230154221.639890793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit a60b990798eb17433d0283788280422b1bd94b18 upstream.

Alexandre observed a warning emitted from pci_msi_setup_msi_irqs() on a
RISCV platform which does not provide PCI/MSI support:

 WARNING: CPU: 1 PID: 1 at drivers/pci/msi/msi.h:121 pci_msi_setup_msi_irqs+0x2c/0x32
 __pci_enable_msix_range+0x30c/0x596
 pci_msi_setup_msi_irqs+0x2c/0x32
 pci_alloc_irq_vectors_affinity+0xb8/0xe2

RISCV uses hierarchical interrupt domains and correctly does not implement
the legacy fallback. The warning triggers from the legacy fallback stub.

That warning is bogus as the PCI/MSI layer knows whether a PCI/MSI parent
domain is associated with the device or not. There is a check for MSI-X,
which has a legacy assumption. But that legacy fallback assumption is only
valid when legacy support is enabled, but otherwise the check should simply
return -ENOTSUPP.

Loongarch tripped over the same problem and blindly enabled legacy support
without implementing the legacy fallbacks. There are weak implementations
which return an error, so the problem was papered over.

Correct pci_msi_domain_supports() to evaluate the legacy mode and add
the missing supported check into the MSI enable path to complete it.

Fixes: d2a463b29741 ("PCI/MSI: Reject multi-MSI early")
Reported-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/87ed2a8ow5.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi/irqdomain.c |    7 +++++--
 drivers/pci/msi/msi.c       |    4 ++++
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/pci/msi/irqdomain.c
+++ b/drivers/pci/msi/irqdomain.c
@@ -350,8 +350,11 @@ bool pci_msi_domain_supports(struct pci_
 
 	domain = dev_get_msi_domain(&pdev->dev);
 
-	if (!domain || !irq_domain_is_hierarchy(domain))
-		return mode == ALLOW_LEGACY;
+	if (!domain || !irq_domain_is_hierarchy(domain)) {
+		if (IS_ENABLED(CONFIG_PCI_MSI_ARCH_FALLBACKS))
+			return mode == ALLOW_LEGACY;
+		return false;
+	}
 
 	if (!irq_domain_is_msi_parent(domain)) {
 		/*
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -433,6 +433,10 @@ int __pci_enable_msi_range(struct pci_de
 	if (WARN_ON_ONCE(dev->msi_enabled))
 		return -EINVAL;
 
+	/* Test for the availability of MSI support */
+	if (!pci_msi_domain_supports(dev, 0, ALLOW_LEGACY))
+		return -ENOTSUPP;
+
 	nvec = pci_msi_vec_count(dev);
 	if (nvec < 0)
 		return nvec;


