Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E302FD1B0;
	Thu,  9 Oct 2025 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025679; cv=none; b=UJL4DHiEAT+hLpj5pIcvdEFGbkfXImyYwZllVgHJtsQvdgcQU856umMF2x4tl3dXddDt1074kD5KnHUuxWFoz1uUHz++qGQ70H3C5T1wrffGHZGcrLjtmpSzeFLada18pIDlIrVemvxM5YzkASG8t4lZB89t2ZFOBGU5gwx9Y+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025679; c=relaxed/simple;
	bh=LS4Di0SVWLjIXnJQxi162UfANheXec8aTie90chPKHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF7U+aluCsvqmlzexmb3EViXx3UyA62lAbcZEpKXX52kijRjbgDTSYIzrFJ7VwKTf/W55WlTdnwW72XKf3C38fBZhgBccFp4qk5+nZmsYwyElH5w0YASluK+PUHVq03v67ofFOCqSm/Y7pNVIgyuXGvemfGJKd0VEoxEnwsMjTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUtuniBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUtuniBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CEBC113D0;
	Thu,  9 Oct 2025 16:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025679;
	bh=LS4Di0SVWLjIXnJQxi162UfANheXec8aTie90chPKHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUtuniBj1+rHHbMBLsf4JjDBBTSPXcgRd6YrHbN74CVpMv9xALSA6qQJoluqZbv69
	 h8lpNdKKdimwRSSX7/MCM3LRcRfEpSqQbPgfYhPdakYiB/L00oMQTsO3WUu5Ioc1Vx
	 6YWNhDNgp0nIkzjq5wMqVr8wboGgLt6U+c61bXneg7EccvylXJ/ZzxqtVpWdNiDYIj
	 o6po1zo3aVSI5DkrEIrnSaykNOAtN3ugV2JVKhH7Id9VQzMA1dp8/jlPTIB4k3xKIS
	 KbCIV9tAkDmrsswI0d8TwPhRWvm0wzhN5/9QIjmtlNmCuapW8dHPG2q473I0Gqx9EF
	 aRTallovl6d5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Bruel <christian.bruel@foss.st.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment
Date: Thu,  9 Oct 2025 11:56:17 -0400
Message-ID: <20251009155752.773732-111-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Transfer-Encoding: 8bit

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit 2ef3886ce626dcdab0cbc452dbbebc19f57133d8 ]

The PCI Local Bus Specification 3.0 (section 6.8.1.6) allows modifying the
low-order bits of the MSI Message DATA register to encode nr_irqs interrupt
numbers in the log2(nr_irqs) bits for the domain.

The problem arises if the base vector (GICV2m base spi) is not aligned with
nr_irqs; in this case, the low-order log2(nr_irqs) bits from the base
vector conflict with the nr_irqs masking, causing the wrong MSI interrupt
to be identified.

To fix this, use bitmap_find_next_zero_area_off() instead of
bitmap_find_free_region() to align the initial base vector with nr_irqs.

Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/20250902091045.220847-1-christian.bruel@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit, the code changes, and
the historical context of similar fixes across the kernel:

## **Backport Status: YES**

### Detailed Analysis:

#### **Nature of the Bug:**

This commit fixes a **critical correctness bug** in Multi-MSI interrupt
allocation for GIC-v2m. The issue occurs when the base SPI (Shared
Peripheral Interrupt) vector is not properly aligned with the number of
requested interrupts (nr_irqs). According to the PCI Local Bus
Specification 3.0 (section 6.8.1.6), Multi-MSI uses the low-order
log2(nr_irqs) bits of the MSI DATA register to encode interrupt numbers.
When the base vector isn't aligned, these low-order bits conflict with
the hardware's interrupt encoding, causing **MSI interrupts to be
delivered to the wrong interrupt numbers**.

#### **Code Changes - Line by Line Analysis:**

**Lines 156-157**: Changes `offset` from `int` to `unsigned long` and
adds alignment mask calculation:
```c
- int hwirq, offset, i, err = 0;
+       int hwirq, i, err = 0;
+       unsigned long offset;
+       unsigned long align_mask = nr_irqs - 1;
```
The `align_mask` ensures power-of-2 alignment required by Multi-MSI (for
4 MSIs, align on 4-interrupt boundary).

**Lines 160-165**: Replaces `bitmap_find_free_region()` with
`bitmap_find_next_zero_area_off()`:
```c
- offset = bitmap_find_free_region(tmp->bm, tmp->nr_spis,
- get_count_order(nr_irqs));
- if (offset >= 0) {
+               unsigned long align_off = tmp->spi_start -
(tmp->spi_start & ~align_mask);
+
+               offset = bitmap_find_next_zero_area_off(tmp->bm,
tmp->nr_spis, 0,
+                                                       nr_irqs,
align_mask, align_off);
+               if (offset < tmp->nr_spis) {
                        v2m = tmp;
+                       bitmap_set(v2m->bm, offset, nr_irqs);
```

The critical change: `bitmap_find_next_zero_area_off()` allows
specifying an alignment offset (`align_off`) that accounts for the
`spi_start` base. This ensures the **final hardware IRQ number**
(spi_start + offset) is properly aligned, not just the bitmap offset.

#### **Pattern of Similar Bugs:**

This is part of a **systematic class of Multi-MSI alignment bugs**
across the kernel:

1. **irqchip/armada-370-xp** (d0a553502efd5, Nov 2021): Fixed identical
   issue, marked for stable with Cc: stable tag
2. **PCI: aardvark** (b0b0b8b897f8e, Jan 2022): Fixed alignment bug
   causing NVMe disks to freeze, backported to stable
3. **irqchip/gic-v3-its** (8208d1708b88b, Jan 2019): Fixed Multi-MSI
   allocation alignment with explicit Fixes: tag and Cc: stable
4. **PCI: hv**: Multiple stable backports for Multi-MSI interrupt
   mapping issues

All these commits fixed the same class of bug and were backported to
stable trees.

#### **Why This Qualifies for Stable:**

1. **Fixes Important Bug**: Misrouted interrupts can cause device
   malfunction, timeouts, or system hangs
2. **Small and Contained**: Only 13 lines changed in a single function
   (drivers/irqchip/irq-gic-v2m.c:151-194)
3. **No Architectural Changes**: Pure bugfix, doesn't add features or
   change APIs
4. **Affects Real Hardware**: Impacts ARM SoCs using GIC-v2m (STM32MP25,
   potentially others)
5. **Minimal Regression Risk**: Change is localized to allocation logic
   with clear semantics
6. **Well Reviewed**: Reviewed by Marc Zyngier (GIC maintainer), signed
   off by Thomas Gleixner (irq maintainer)

#### **Notable Observations:**

- **Missing Fixes: tag**: The commit lacks a `Fixes:` tag and `Cc:
  stable@vger.kernel.org`, which is unusual for this class of bug.
  However, this doesn't diminish the need for backporting - it may
  indicate the bug was newly discovered on recent hardware (STM32MP25)
  rather than affecting existing deployments.

- **Asymmetric bitmap operations**: The code now uses
  `bitmap_find_next_zero_area_off()` + `bitmap_set()` for allocation but
  keeps `bitmap_release_region()` for deallocation. This is intentional
  and correct - both approaches manipulate the same bitmap bits, just
  with different alignment guarantees.

- **Recent commit** (Sept 2, 2025): Very recent, but the fix is
  straightforward and follows established patterns from other drivers.

#### **Conclusion:**

This commit should be backported to stable kernel trees. It fixes a
correctness bug that could cause serious issues on systems using Multi-
MSI with GIC-v2m hardware, follows the same pattern as other
successfully backported Multi-MSI alignment fixes, and has minimal risk
of regression.

 drivers/irqchip/irq-gic-v2m.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index 24ef5af569fe4..8a3410c2b7b57 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -153,14 +153,19 @@ static int gicv2m_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 {
 	msi_alloc_info_t *info = args;
 	struct v2m_data *v2m = NULL, *tmp;
-	int hwirq, offset, i, err = 0;
+	int hwirq, i, err = 0;
+	unsigned long offset;
+	unsigned long align_mask = nr_irqs - 1;
 
 	spin_lock(&v2m_lock);
 	list_for_each_entry(tmp, &v2m_nodes, entry) {
-		offset = bitmap_find_free_region(tmp->bm, tmp->nr_spis,
-						 get_count_order(nr_irqs));
-		if (offset >= 0) {
+		unsigned long align_off = tmp->spi_start - (tmp->spi_start & ~align_mask);
+
+		offset = bitmap_find_next_zero_area_off(tmp->bm, tmp->nr_spis, 0,
+							nr_irqs, align_mask, align_off);
+		if (offset < tmp->nr_spis) {
 			v2m = tmp;
+			bitmap_set(v2m->bm, offset, nr_irqs);
 			break;
 		}
 	}
-- 
2.51.0

