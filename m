Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B5A4E73B2;
	Tue, 13 Oct 2026 12:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894072; cv=none; b=NR4Y0tJZ7LpIIYA0RRSWt5BMpybrf2QoxrSPcyOuUl8pe5FnnCsPd5i4N3FyqSztqWDth4SwnsWekCHjL/TlrFXnyEeZefCtxgfXVz8GEZ/cVqeH5Mh6piTaSP7yfdJSUWubKEAAsfX+Q7dSmwSvUJ+ie65SkHRcIHDMY1BAFtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894072; c=relaxed/simple;
	bh=wEgWg/drxwXBngLC63JOd5mswsBYGSanvKNnV/jNu3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usD/tRfPNMi8O32K0qMDdAUOBNXZnR1wiGnxNm85Zr6NnHAnYNCfhX1MvZBWou1u47jwfvB/kELjgT5eORyQW3hZhlPuiYyqS55ry9EcciuFWN4GTsxFR9edErwioJi3azgvlHxQ4huWKcf9enGiMbRJJrRGtQCd0W74NWwX/o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxzoeHBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxzoeHBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658BD1F000FF;
	Tue, 13 Oct 2026 12:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894070;
	bh=zkxhupLjrI9v6G8jwgEDXcOMHP3m2sVBgV+MyzSnbmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxzoeHBVi0VQVW/auBkI6D45vxE+f7AAuzs8t2qWFIUxCDniAXonuFgyjDCwczoO2
	 6HbNS4F10CYacRe1y+t4B91v8O4f1I9oYfbvT83/i0IP/UoEx1rALiA1yujmqjCFls
	 /09FoHPfDifOxwMOn0olGLQeyGZtpYcwNs64gGRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Zeng Chi <zengchi@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 393/621] LoongArch: KVM: Validate MSI data before routing it to EIOINTC
Date: Tue, 13 Oct 2026 13:36:28 +0200
Message-ID: <20261013112930.168796510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Chi <zengchi@kylinos.cn>

[ Upstream commit 501514d6ebd2111c353a1296f25dbe22fbd64657 ]

pch_msi_set_irq() passes e->msi.data straight into eiointc_set_irq() as
the irq number. The MSI data comes from userspace, that either via a
KVM_IRQ_ROUTING_MSI entry set with KVM_SET_GSI_ROUTING (used by irqfd
and KVM_IRQ_LINE) or directly via KVM_SIGNAL_MSI, and is never checked
against EIOINTC_IRQS.

eiointc_set_irq() uses the value with __set_bit()/__clear_bit() on the
256-bit isr bitmap, eiointc_update_irq() then indexes sw_coremap[] and
the per-cpu coreisr/sw_coreisr bitmaps with it. Therefore a data value
>= 256 reads and writes memory past the end of those arrays, i.e. any
process holding a VM fd can corrupt kernel memory beyond the allocation
of loongarch_eiointc.

Reject MSI data that doesn't fit in the EIOINTC irq space. The DMSINTC
path is unaffected as it decodes the vector from the address and masks
it.

Cc: stable@vger.kernel.org
Fixes: 1928254c5ccb ("LoongArch: KVM: Add irqfd support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260531140921.1B1181F00893@smtp.kernel.org/
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/intc/pch_pic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index c0adabfd50793..ab336cde24f6d 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -69,6 +69,9 @@ void pch_pic_set_irq(struct loongarch_pch_pic *s, int irq, int level)
 /* msi irq handler */
 void pch_msi_set_irq(struct kvm *kvm, int irq, int level)
 {
+	if (irq < 0 || irq >= EIOINTC_IRQS)
+		return;
+
 	eiointc_set_irq(kvm->arch.eiointc, irq, level);
 }
 
-- 
2.53.0



