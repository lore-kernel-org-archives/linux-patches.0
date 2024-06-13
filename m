Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA4E1422B5;
	Thu, 13 Jun 2024 11:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278693; cv=none; b=qK685u5FRU+K016V7qYPKxUs5QDkDCe+PuWZzPMkBb9YePPekenKkAPDJ4W2u3ty4ANkoEOC6FhG/Ub0Kc/w3Wa7Q4BKsLUy9ydBinTH4KrHY5umLSa+FycGBAwmhMUokBo6A9IA83Ta9qjkNFPO+ve6HPL33Ant/xVCTx0+5I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278693; c=relaxed/simple;
	bh=XjysYyWwOIGK/613pxRt1Ia5wkpFdpbE+kBVXWHBGLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oODyFWbSMNg9vFWMHhBymgq8FT7FFyBYKCL6b+PLcpo/3veEWa0UZvItjxxOpWXyt+11IASauH50vMJ0Fn/PjYsbwidYYD6brA2AEMDyH6Pn8okca6LbU+yXdlEoAfu4cCpuUa5AWN6oX/s3qxGrjuAIqc91AE6oZHaqGfJiLJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBQeDPI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBQeDPI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD0EC2BBFC;
	Thu, 13 Jun 2024 11:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278692;
	bh=XjysYyWwOIGK/613pxRt1Ia5wkpFdpbE+kBVXWHBGLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBQeDPI0q78GAc5iRfEqr0/e35OI+Blui3UdzQYmwde/LrXv7c4M5Q1K0R9pvjWtu
	 rAtJnmXVKU2KYlW4+Fg6Ey9BCDMTE5tFx6uUk/MhiGv+teB1jtMrF+NqQZ1jzyErTA
	 0MYPjh+sXLVCKtCxl8HnYkDoGqaFRjDsLGwJM1GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/213] irqchip/alpine-msi: Fix off-by-one in allocation error path
Date: Thu, 13 Jun 2024 13:31:25 +0200
Message-ID: <20240613113229.431315309@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit ff3669a71afa06208de58d6bea1cc49d5e3fcbd1 ]

When alpine_msix_gic_domain_alloc() fails, there is an off-by-one in the
number of interrupts to be freed.

Fix it by passing the number of successfully allocated interrupts, instead
of the relative index of the last allocated one.

Fixes: 3841245e8498 ("irqchip/alpine-msi: Fix freeing of interrupts on allocation error path")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240327142305.1048-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-alpine-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-alpine-msi.c b/drivers/irqchip/irq-alpine-msi.c
index 1819bb1d27230..aedbc4befcdf0 100644
--- a/drivers/irqchip/irq-alpine-msi.c
+++ b/drivers/irqchip/irq-alpine-msi.c
@@ -165,7 +165,7 @@ static int alpine_msix_middle_domain_alloc(struct irq_domain *domain,
 	return 0;
 
 err_sgi:
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 	alpine_msix_free_sgi(priv, sgi, nr_irqs);
 	return err;
 }
-- 
2.43.0



