Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B1C3438A8;
	Thu, 17 Sep 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660047; cv=none; b=uX96fZhkjRF1RzeRVk+FelipBUdr/9BWzJcc+c+2NXiAHwaudLliCQ786ik6F4nYf2Vaty0wlZGblhL651QixrJi3/2+FLtPLjcs3gkjfr1AzFPtTU8JX4PsBZPRCATaaYwNk5xgpT7qhXeaG5HIXZ7fe1HUb5EcqKQAejq9Uvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660047; c=relaxed/simple;
	bh=DUEtevrRnsHKhbcL12v+mNB4F9iIbDxYJ7LBNtjXidE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pxey7pUb9Lt7PKZet0jaKC6Mdvfx1A5+y7/BzjeL2ISVR4/b1njNRtXct+M42Gsd0AIXT7au62pb+rVrBfUbM42qRha4ONEQRyuiLkWEz2B16/TRnZ2N8j7c5XX1L15Rmx/wIoORfUtmHqOxgYvsRc7xBUR9T000UgZYN1dHP6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8JVFN5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8JVFN5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7C81F00893;
	Thu, 17 Sep 2026 15:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660041;
	bh=zxhXljTg9mi6TsIVg4OM99k8qBP7eHSOMcgecFpig2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8JVFN5+3GAiSPPWNf9PB6TP9odLtx519KBZtV3G7BMOwmIQOHggfD4S7HWkCoeFQ
	 iBiqB++Pn9Mzh0Quj2OO8Eraa4DkGKNGNUNKL7oVUqOvRHIPEG4ZTWa9ZWcKUZDSQh
	 T27xxFA61E1Rrrq8Awt05uyIgn9hkL+FynXGkFvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.2 452/733] powerpc: pci-ioda: Fix the stale irq chip reference
Date: Thu, 17 Sep 2026 16:12:40 +0100
Message-ID: <20260917151403.175235944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

commit d96171d911e3b89ca2957c04264019cf2f96287b upstream.

The commit f0ac60e6e311 ("powerpc/powernv/pci: Switch to use
msi_create_parent_irq_domain()") removed the legacy MSI irq chip
pnv_pci_msi_irq_chip but left behind the static definition of it and
its reference in is_pnv_opal_msi().

The KVM IRQ bypass for vfio devices is broken because the
comparision in is_pnv_opal_msi() fails on the comparision with
stale unused variable showing the below errors in dmesg.

 kvmppc_set_passthru_irq_hv: Could not assign IRQ map for (X,Y)
 kvmppc_set_passthru_irq (irq X, gsi Y) fails: -2
 vfio-pci A:B:C.D irq bypass producer (eventfd Z) registration fails: -2

The patch removes the stale variable definition and fixes the
is_pnv_opal_msi() by comparing against the chip name prefix.

Fixes: f0ac60e6e311 ("powerpc/powernv/pci: Switch to use msi_create_parent_irq_domain()")
Cc: stable@kernel.org
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Tested-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/178716225364.1437.6201568081502251835.stgit@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/pci-ioda.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1623,15 +1623,13 @@ int64_t pnv_opal_pci_msi_eoi(struct irq_
 	return opal_pci_msi_eoi(phb->opal_id, d->parent_data->hwirq);
 }
 
-static struct irq_chip pnv_pci_msi_irq_chip;
-
 /*
  * Returns true iff chip is something that we could call
  * pnv_opal_pci_msi_eoi for.
  */
 bool is_pnv_opal_msi(struct irq_chip *chip)
 {
-	return chip == &pnv_pci_msi_irq_chip;
+	return chip && chip->name && str_has_prefix(chip->name, "PNV-");
 }
 EXPORT_SYMBOL_GPL(is_pnv_opal_msi);
 
@@ -1728,7 +1726,7 @@ static const struct msi_parent_ops pnv_m
 	.chip_flags		= MSI_CHIP_FLAG_SET_EOI,
 	.bus_select_token	= DOMAIN_BUS_NEXUS,
 	.bus_select_mask	= MATCH_PCI_MSI,
-	.prefix			= "PNV-",
+	.prefix			= "PNV-", /* Note: is_pnv_opal_msi() uses this */
 	.init_dev_msi_info	= pnv_init_dev_msi_info,
 };
 


