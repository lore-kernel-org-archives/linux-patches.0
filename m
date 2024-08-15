Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA401E526;
	Thu, 15 Aug 2024 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731511; cv=none; b=K/wZL5D3sK9LphVHBmST7s9/ENKOV/idB8dTApcSxECME7WKWW+ZEywaW+72GCDOfZ9pK9KK29eAjh2YVzLXnI4SuME1xGDB+I9hO+my0w8614eDmq/73hpVQ3OOHsvgVwI7TWk93SUvSw8H12PYJ2k2dwkkC+/H9h6tzLZ4v2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731511; c=relaxed/simple;
	bh=ldId1vg9iQEcUDfTRryjcNUnUPys5Dz55RLsYpngSTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHZzWJznD5X5C5rUgQR8u5/gWYqtVddZJHnq1dRvrnxmrZaYcoKQCfIvgm3GovBHMGioqR5924Ig++h437EqcKwE5QrxhsI+Z94uChCTlLVfvMtZi2LHawNEPNMEaQluTUnHMA+EkjeYsU4fGwkkITHY3Bzy6Yg/Ms98/ve1DmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3as8XTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3as8XTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73700C32786;
	Thu, 15 Aug 2024 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731510;
	bh=ldId1vg9iQEcUDfTRryjcNUnUPys5Dz55RLsYpngSTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3as8XTs35y7MC16br/w2h5IsyUX5DwVI9/PTY3gOdcRgCHjp4cnzaB3n531BAM+M
	 quk2VbFaDhK1uwytoUMOix6vQQw9Mhz9Ct0wKuWOoUPae/mH9S8DnLvckp+1qc3BWt
	 P6UssHJ/oLesW5QwbVvMaSg1S53wyoRFTvuVBW8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/259] s390/pci: fix CPU address in MSI for directed IRQ
Date: Thu, 15 Aug 2024 15:24:45 +0200
Message-ID: <20240815131908.656419305@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit a2bd4097b3ec242f4de4924db463a9c94530e03a ]

The directed MSIs are delivered to CPUs whose address is
written to the MSI message address. The current code assumes
that a CPU logical number (as it is seen by the kernel)
is also the CPU address.

The above assumption is not correct, as the CPU address
is rather the value returned by STAP instruction. That
value does not necessarily match the kernel logical CPU
number.

Fixes: e979ce7bced2 ("s390/pci: provide support for CPU directed interrupts")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: ab42fcb511fd ("s390/pci: Allow allocation of more than 1 MSI interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 743f257cf2cbd..75217fb63d7b3 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -103,9 +103,10 @@ static int zpci_set_irq_affinity(struct irq_data *data, const struct cpumask *de
 {
 	struct msi_desc *entry = irq_get_msi_desc(data->irq);
 	struct msi_msg msg = entry->msg;
+	int cpu_addr = smp_cpu_get_cpu_address(cpumask_first(dest));
 
 	msg.address_lo &= 0xff0000ff;
-	msg.address_lo |= (cpumask_first(dest) << 8);
+	msg.address_lo |= (cpu_addr << 8);
 	pci_write_msi_msg(data->irq, &msg);
 
 	return IRQ_SET_MASK_OK;
@@ -238,6 +239,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	unsigned long bit;
 	struct msi_desc *msi;
 	struct msi_msg msg;
+	int cpu_addr;
 	int rc, irq;
 
 	zdev->aisb = -1UL;
@@ -287,9 +289,15 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 					 handle_percpu_irq);
 		msg.data = hwirq - bit;
 		if (irq_delivery == DIRECTED) {
+			if (msi->affinity)
+				cpu = cpumask_first(&msi->affinity->mask);
+			else
+				cpu = 0;
+			cpu_addr = smp_cpu_get_cpu_address(cpu);
+
 			msg.address_lo = zdev->msi_addr & 0xff0000ff;
-			msg.address_lo |= msi->affinity ?
-				(cpumask_first(&msi->affinity->mask) << 8) : 0;
+			msg.address_lo |= (cpu_addr << 8);
+
 			for_each_possible_cpu(cpu) {
 				airq_iv_set_data(zpci_ibv[cpu], hwirq, irq);
 			}
-- 
2.43.0



