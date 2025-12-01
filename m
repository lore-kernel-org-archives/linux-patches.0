Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BA230147E;
	Mon,  1 Dec 2025 11:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588398; cv=none; b=MDiMjf8FHB7jwhPEVkUUvU0H6/7iEKhFWE28vmrhSBbLY9YvXq8OPFzFFFQuKEMZstt25y1Bq776K0IaDfOfg/p6Q9SnFv84vAKMnnbRb74S7i8xOv8KyiIS+HlrdEcN2H2aQWR/cTV4CwJTaoAT5JEnPgdkN7bkKM8P4UqTIaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588398; c=relaxed/simple;
	bh=QrDdtFbRxzd/TvgbkumeWcamqeA/V0HR2Y/NEiVeAKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGYX5QJXgsnet1QD0iC3kAab3ZQwfGjrb53k2wHdVc4dIlDMdvFO3z4+F6mSlgXG1uAlHbo/cpn9IvPYoqMYW5Sti36NOeDj2G3Z7Rn64yHD+TcCoCXIf4Z1jP8oGTdMpRa8xJ+zRipuR2iH0aNZOmAqrE9aGfGjdwlDUAHR1wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUkd+ObI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUkd+ObI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6E0C4CEF1;
	Mon,  1 Dec 2025 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588398;
	bh=QrDdtFbRxzd/TvgbkumeWcamqeA/V0HR2Y/NEiVeAKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUkd+ObIttS6KhglpYe+nPJFbxZrhhFlTAO5y10ycZuhNxDQH6PaOvR/x+QSsS2Fr
	 dgSaLW1KwBXhNr6eP7nnqB8PCSq5zQAaPrpjE6VKoEmfQ0laxbONAqrgcaHNc/UriE
	 ofvdseH0YuI9qxZ0fLcrT4ZNZ2KMObgE14UpV8Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/187] irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment
Date: Mon,  1 Dec 2025 12:22:22 +0100
Message-ID: <20251201112242.484210512@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/irqchip/irq-gic-v2m.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index 2468b285c77c2..1a209869b7f5b 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -178,14 +178,19 @@ static int gicv2m_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
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



