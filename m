Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B4314AD15;
	Tue, 20 Feb 2024 21:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463615; cv=none; b=lCn/IxHXmHAzJ52ZLfpC4QonS5Kg1PjpWVRf4SF/N9dGmxOlOW72FU5YkccO62jkjaSAWT8suoeN7imu/uSuasxBn8m9GtA6Ha7mv7sEOZeFTj+EbkhPpxRYFGBDvqK5/C9nAE1xNdA2sTKyX6xV4PA9Y8iMTZWBLFvo/k/nHSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463615; c=relaxed/simple;
	bh=4MwA4CWxWkmaRnQ46wklwj2D+uwWdtpfjYIB60rtoo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+37Ew/W/b4oWv2COUa7PeA0zDX/iKNMKagC7nchG9NsCfnnnF6d+0O4cbkkI9u9GXdYWm35uPzFqvEFikbdwQVzJqM7u/PoSLULNT0MZhaPJopE0pRRiFrNFTosIPwgfzRfUoyGiKUQ5o4zYTXiLC02d0gIEFvpxbSXT62APtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKlGinKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKlGinKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F98C433C7;
	Tue, 20 Feb 2024 21:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463614;
	bh=4MwA4CWxWkmaRnQ46wklwj2D+uwWdtpfjYIB60rtoo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKlGinKLYQmJWKC7MXalzSfiDlkuoVqDDDQGpE/fYHO6IvJOUhC6ZsDUiP2Xepeug
	 iPSHW1ex3lEDIVHtoMZYkl9hkdNGNCtyNHDtUWWViMTc0nzVsqpfeSEAqu6+KUiXOG
	 gBYCf7n4pm9Jp5fN1l1Xnw2ZlYsdTi04D9fiAB6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/331] irqchip/gic-v3-its: Handle non-coherent GICv4 redistributors
Date: Tue, 20 Feb 2024 21:53:35 +0100
Message-ID: <20240220205640.696097461@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 846297e11e8ae428f8b00156a0cfe2db58100702 ]

Although the GICv3 code base has gained some handling of systems failing to
handle the shareability attributes, the GICv4 side of things has been
firmly ignored.

This is unfortunate, as the new recent addition of the "dma-noncoherent" is
supposed to apply to all of the GICR tables, and not just the ones that are
common to v3 and v4.

Add some checks to handle the VPROPBASE/VPENDBASE shareability and
cacheability attributes in the same way we deal with the other GICR_BASE
registers, wrapping the flag check in a helper for improved readability.

Note that this has been found by inspection only, as I don't have access to
HW that suffers from this particular issue.

Fixes: 3a0fff0fb6a3 ("irqchip/gic-v3: Enable non-coherent redistributors/ITSes DT probing")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Link: https://lore.kernel.org/r/20240213101206.2137483-2-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 37 +++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 9a7a74239eab..bdc2c8330479 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -207,6 +207,11 @@ static bool require_its_list_vmovp(struct its_vm *vm, struct its_node *its)
 	return (gic_rdists->has_rvpeid || vm->vlpi_count[its->list_nr]);
 }
 
+static bool rdists_support_shareable(void)
+{
+	return !(gic_rdists->flags & RDIST_FLAGS_FORCE_NON_SHAREABLE);
+}
+
 static u16 get_its_list(struct its_vm *vm)
 {
 	struct its_node *its;
@@ -2710,10 +2715,12 @@ static u64 inherit_vpe_l1_table_from_its(void)
 			break;
 		}
 		val |= FIELD_PREP(GICR_VPROPBASER_4_1_ADDR, addr >> 12);
-		val |= FIELD_PREP(GICR_VPROPBASER_SHAREABILITY_MASK,
-				  FIELD_GET(GITS_BASER_SHAREABILITY_MASK, baser));
-		val |= FIELD_PREP(GICR_VPROPBASER_INNER_CACHEABILITY_MASK,
-				  FIELD_GET(GITS_BASER_INNER_CACHEABILITY_MASK, baser));
+		if (rdists_support_shareable()) {
+			val |= FIELD_PREP(GICR_VPROPBASER_SHAREABILITY_MASK,
+					  FIELD_GET(GITS_BASER_SHAREABILITY_MASK, baser));
+			val |= FIELD_PREP(GICR_VPROPBASER_INNER_CACHEABILITY_MASK,
+					  FIELD_GET(GITS_BASER_INNER_CACHEABILITY_MASK, baser));
+		}
 		val |= FIELD_PREP(GICR_VPROPBASER_4_1_SIZE, GITS_BASER_NR_PAGES(baser) - 1);
 
 		return val;
@@ -2936,8 +2943,10 @@ static int allocate_vpe_l1_table(void)
 	WARN_ON(!IS_ALIGNED(pa, psz));
 
 	val |= FIELD_PREP(GICR_VPROPBASER_4_1_ADDR, pa >> 12);
-	val |= GICR_VPROPBASER_RaWb;
-	val |= GICR_VPROPBASER_InnerShareable;
+	if (rdists_support_shareable()) {
+		val |= GICR_VPROPBASER_RaWb;
+		val |= GICR_VPROPBASER_InnerShareable;
+	}
 	val |= GICR_VPROPBASER_4_1_Z;
 	val |= GICR_VPROPBASER_4_1_VALID;
 
@@ -3126,7 +3135,7 @@ static void its_cpu_init_lpis(void)
 	gicr_write_propbaser(val, rbase + GICR_PROPBASER);
 	tmp = gicr_read_propbaser(rbase + GICR_PROPBASER);
 
-	if (gic_rdists->flags & RDIST_FLAGS_FORCE_NON_SHAREABLE)
+	if (!rdists_support_shareable())
 		tmp &= ~GICR_PROPBASER_SHAREABILITY_MASK;
 
 	if ((tmp ^ val) & GICR_PROPBASER_SHAREABILITY_MASK) {
@@ -3153,7 +3162,7 @@ static void its_cpu_init_lpis(void)
 	gicr_write_pendbaser(val, rbase + GICR_PENDBASER);
 	tmp = gicr_read_pendbaser(rbase + GICR_PENDBASER);
 
-	if (gic_rdists->flags & RDIST_FLAGS_FORCE_NON_SHAREABLE)
+	if (!rdists_support_shareable())
 		tmp &= ~GICR_PENDBASER_SHAREABILITY_MASK;
 
 	if (!(tmp & GICR_PENDBASER_SHAREABILITY_MASK)) {
@@ -3880,14 +3889,18 @@ static void its_vpe_schedule(struct its_vpe *vpe)
 	val  = virt_to_phys(page_address(vpe->its_vm->vprop_page)) &
 		GENMASK_ULL(51, 12);
 	val |= (LPI_NRBITS - 1) & GICR_VPROPBASER_IDBITS_MASK;
-	val |= GICR_VPROPBASER_RaWb;
-	val |= GICR_VPROPBASER_InnerShareable;
+	if (rdists_support_shareable()) {
+		val |= GICR_VPROPBASER_RaWb;
+		val |= GICR_VPROPBASER_InnerShareable;
+	}
 	gicr_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
 
 	val  = virt_to_phys(page_address(vpe->vpt_page)) &
 		GENMASK_ULL(51, 16);
-	val |= GICR_VPENDBASER_RaWaWb;
-	val |= GICR_VPENDBASER_InnerShareable;
+	if (rdists_support_shareable()) {
+		val |= GICR_VPENDBASER_RaWaWb;
+		val |= GICR_VPENDBASER_InnerShareable;
+	}
 	/*
 	 * There is no good way of finding out if the pending table is
 	 * empty as we can race against the doorbell interrupt very
-- 
2.43.0



