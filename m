Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFB112C805;
	Tue, 30 Apr 2024 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476285; cv=none; b=ZsRyRyjhcd4juRc3C0WSnvYd+ajqW3zmjnHTctWfJRIqZ8UQ/WJIxr6ysa/A8ntw9wvgfBhYeXzD6bndZi20kbMQercaPpPUFACbq+etZiDFgEwQRNqZulNj/1E/Zwkr/07kuD0Zziy6UkDQSe0N2QD3nwW3f9GhcuAbHXF4Lhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476285; c=relaxed/simple;
	bh=3w+7MTX2Oeiz+dLzkrp7hAbf3xPwnTQC0QeW7SEIhfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnWYc68wufjY6sc83Q2vsX6ewwmt5d2eCfCsxljSVyBuT9gyY8YL0zMeq9FxXaeBCukb9skZsxZ3YPOTCCEGBiaSYp46XT9vTf3MtGiqf2h7ex0C5FVspUJBeIkk9YJvXYWwuLcCXLFbBSFQcupAHgJB1P+jWq+E4a+p5tXgOy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1tmHwHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1tmHwHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD1DC2BBFC;
	Tue, 30 Apr 2024 11:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476285;
	bh=3w+7MTX2Oeiz+dLzkrp7hAbf3xPwnTQC0QeW7SEIhfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1tmHwHBl1sbM5w5+IRYDk06/LBW5FSybxuk83W2+h+GfyifVtPY4bxxpXhS1tatq
	 u1hQgb9Lpw7nt/UC4rlUywptVLZPEcXy8mWoCcxrtSFJKcRDm+a/sQtDwTGOGLkefY
	 nk9Dtgyej9LVxQCgi9UZjQ+Q2gv92HNGOwAJ7EPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5.4 093/107] irqchip/gic-v3-its: Prevent double free on error
Date: Tue, 30 Apr 2024 12:40:53 +0200
Message-ID: <20240430103047.401784173@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

From: Guanrui Huang <guanrui.huang@linux.alibaba.com>

commit c26591afd33adce296c022e3480dea4282b7ef91 upstream.

The error handling path in its_vpe_irq_domain_alloc() causes a double free
when its_vpe_init() fails after successfully allocating at least one
interrupt. This happens because its_vpe_irq_domain_free() frees the
interrupts along with the area bitmap and the vprop_page and
its_vpe_irq_domain_alloc() subsequently frees the area bitmap and the
vprop_page again.

Fix this by unconditionally invoking its_vpe_irq_domain_free() which
handles all cases correctly and by removing the bitmap/vprop_page freeing
from its_vpe_irq_domain_alloc().

[ tglx: Massaged change log ]

Fixes: 7d75bbb4bc1a ("irqchip/gic-v3-its: Add VPE irq domain allocation/teardown")
Signed-off-by: Guanrui Huang <guanrui.huang@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240418061053.96803-2-guanrui.huang@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3121,13 +3121,8 @@ static int its_vpe_irq_domain_alloc(stru
 		set_bit(i, bitmap);
 	}
 
-	if (err) {
-		if (i > 0)
-			its_vpe_irq_domain_free(domain, virq, i);
-
-		its_lpi_free(bitmap, base, nr_ids);
-		its_free_prop_table(vprop_page);
-	}
+	if (err)
+		its_vpe_irq_domain_free(domain, virq, i);
 
 	return err;
 }


