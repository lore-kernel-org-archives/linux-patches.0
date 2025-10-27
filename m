Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4101321431;
	Mon, 27 Oct 2025 19:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592135; cv=none; b=pC5d5Cbr+fwwqmSjJrwH4RIBsEuBW4oVWaSeWA8qp0G1wPrYoRN6/Gjsh9DOAMyPkw2+Y0ULS72Y+/Wcfm4uK7ZwTZJFpxUT7rhpoNYWgxFQrt0MmAYwi0oj77Xxmd99vqYLcOn0f5sc6SsVl6i6X66r1yEOFIy3VJxEmfs8NIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592135; c=relaxed/simple;
	bh=OA0TAMm4vOIPTGTeG2jfnC84hlAavi51U9nZGJwJFPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVpcQOPetsFl1yA9TvlBN78woRtQD++mrRT1ju5RxTEzRKf8Ffo52J3azNlIOVCnLvE+HcY6+m6vH6fdoIFPVZ8dzwJj+Rn/86PH5tRLkhbZC/O28jErvjXK2ZZsXnQFVelANrCwWGbSLt0VRwzUZ5sOpzSdhFTdBVSMfc4RNr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrNsb1qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrNsb1qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8574CC4CEF1;
	Mon, 27 Oct 2025 19:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592134;
	bh=OA0TAMm4vOIPTGTeG2jfnC84hlAavi51U9nZGJwJFPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrNsb1qtLrZX7e6Yjf6makWnhI+KJAaiyN9wJKeRyWZcgBaDDMMmP1oju1tmTpmiJ
	 kCjlvJrE9TwTYeZZCkjhtpljnTi3eeSdj6wYqq2MhFYRJmv1hwtkWreEV2726j23Z0
	 ltQsHMSHhu4bvMs2lrzdkj3B5wGcoV89s1KD6E0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/123] PCI: rcar-host: Convert struct rcar_msi mask_lock into raw spinlock
Date: Mon, 27 Oct 2025 19:36:25 +0100
Message-ID: <20251027183449.201314197@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 5ed35b4d490d8735021cce9b715b62a418310864 ]

The rcar_msi_irq_unmask() function may be called from a PCI driver
request_threaded_irq() function. This triggers kernel/irq/manage.c
__setup_irq() which locks raw spinlock &desc->lock descriptor lock
and with that descriptor lock held, calls rcar_msi_irq_unmask().

Since the &desc->lock descriptor lock is a raw spinlock, and the rcar_msi
.mask_lock is not a raw spinlock, this setup triggers 'BUG: Invalid wait
context' with CONFIG_PROVE_RAW_LOCK_NESTING=y.

Use scoped_guard() to simplify the locking.

Fixes: 83ed8d4fa656 ("PCI: rcar: Convert to MSI domains")
Reported-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Reported-by: Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250909162707.13927-2-marek.vasut+renesas@mailbox.org
[ replaced scoped_guard() with explicit raw_spin_lock_irqsave()/raw_spin_unlock_irqrestore() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rcar-host.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -38,7 +38,7 @@ struct rcar_msi {
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
 	struct mutex map_lock;
-	spinlock_t mask_lock;
+	raw_spinlock_t mask_lock;
 	int irq1;
 	int irq2;
 };
@@ -559,11 +559,11 @@ static void rcar_msi_irq_mask(struct irq
 	unsigned long flags;
 	u32 value;
 
-	spin_lock_irqsave(&msi->mask_lock, flags);
+	raw_spin_lock_irqsave(&msi->mask_lock, flags);
 	value = rcar_pci_read_reg(pcie, PCIEMSIIER);
 	value &= ~BIT(d->hwirq);
 	rcar_pci_write_reg(pcie, value, PCIEMSIIER);
-	spin_unlock_irqrestore(&msi->mask_lock, flags);
+	raw_spin_unlock_irqrestore(&msi->mask_lock, flags);
 }
 
 static void rcar_msi_irq_unmask(struct irq_data *d)
@@ -573,11 +573,11 @@ static void rcar_msi_irq_unmask(struct i
 	unsigned long flags;
 	u32 value;
 
-	spin_lock_irqsave(&msi->mask_lock, flags);
+	raw_spin_lock_irqsave(&msi->mask_lock, flags);
 	value = rcar_pci_read_reg(pcie, PCIEMSIIER);
 	value |= BIT(d->hwirq);
 	rcar_pci_write_reg(pcie, value, PCIEMSIIER);
-	spin_unlock_irqrestore(&msi->mask_lock, flags);
+	raw_spin_unlock_irqrestore(&msi->mask_lock, flags);
 }
 
 static int rcar_msi_set_affinity(struct irq_data *d, const struct cpumask *mask, bool force)
@@ -693,7 +693,7 @@ static int rcar_pcie_enable_msi(struct r
 	int err;
 
 	mutex_init(&msi->map_lock);
-	spin_lock_init(&msi->mask_lock);
+	raw_spin_lock_init(&msi->mask_lock);
 
 	err = of_address_to_resource(dev->of_node, 0, &res);
 	if (err)


