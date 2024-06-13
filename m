Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737A21487E9;
	Thu, 13 Jun 2024 11:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279779; cv=none; b=jYLicvdtfBkkitvX/nW7CbjlLC/zWCyScEfkn1rnGDc1bcO0y5dHkmQlmAjb2uEoDD6Jc28yAI0RHqxBUiiXut5VxEP/qpTIdbzrXtQ4MfXuFuEWQYwEVamvDvm31XNI10zN9FYV7Ja6oPJwVLxplhGHkslg5xhvMo0fNVOqMFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279779; c=relaxed/simple;
	bh=pF3TsHBGGWTuCFFX4mFDG3tUGcs8fxFf8/TbWqRu+ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzeQ1JJSLwk6yz/tix2eM7AcG9wtqRqQcS3IEtxnd/bIAc7kr72u7EzD0gSC4pTe31wFm4JItETmiVx3mEILKhs/K1IOx+4+Dd3Giof9QoaeQhbXTfbLYiTCKcuTbVBoZUYGEDl7ZtRUCFZoWOARGfEu4Tj6WkanSdLzLPBMV0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJx0bxc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJx0bxc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC043C2BBFC;
	Thu, 13 Jun 2024 11:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279779;
	bh=pF3TsHBGGWTuCFFX4mFDG3tUGcs8fxFf8/TbWqRu+ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJx0bxc4CMVMg9kowGZO161diDXza8j3Tv+T08ulz0bH5xqHG+5LW/MVau/WDHJWj
	 Wj8Fpq1fbu3/jqsas8/CoTE3N9ejRRfuKYnoahTJSsnwqQuxtGPleVbrya53jRVsoa
	 aNpWqsreUZllGeIwzPq2aqUhdI1ELqb45TTT6uCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/202] irqchip/alpine-msi: Fix off-by-one in allocation error path
Date: Thu, 13 Jun 2024 13:32:12 +0200
Message-ID: <20240613113229.090768654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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



