Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDB9197A68;
	Thu,  6 Jun 2024 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683218; cv=none; b=iDwsMveq75k6XM5a3lt6b3JxEtbwSriUyElol3WIaoXu5ubmagPQuxYB9g3x4Qqk+9nbqjp2+N1MA2y3X6h3hmKBTAKBXytUjzWkYffmQmU87RpsWFUGuKNKR9d7+1Et47DKwdsBrUy8b8mlydF77rQuh7RGtuCw4gfmfdyKGSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683218; c=relaxed/simple;
	bh=oKCvuBnfzHPU8bmx0elSLGpiwblT3u8GLWnjKIUSSyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1mIdLtmlLwqt5lPdavDcMNSmmc+eT/bfMdRGV2hqDyJ/bPN09ib6x49a43tYGsr6pOIlV2ActH2Eg214rSn8KQ7bWsRlsrte8WLxHFaWZOexP38tSGc/MLQW1RbZ1Ot4v+2Q+qecKkzsmUX0cjechoXMY+fvNe0TBskCOmepmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2BFZmRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2BFZmRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D79C2BD10;
	Thu,  6 Jun 2024 14:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683218;
	bh=oKCvuBnfzHPU8bmx0elSLGpiwblT3u8GLWnjKIUSSyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2BFZmREOYKvBpyj4GHoB2FkfIPd0YXzRKAWcWRqbg7ALEjkPh7g9/AjGP0pJrh4x
	 YB6D53tswpmXnCqrdo96/FVCwrclf0PPlJqXpHbUIN/VIwc5P2csWP/4AGWSUv9k+o
	 GgkrH/sq8pf46TavIN5LjaE2USeA2EOsWJlGfXEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/744] irqchip/alpine-msi: Fix off-by-one in allocation error path
Date: Thu,  6 Jun 2024 15:57:12 +0200
Message-ID: <20240606131737.555946733@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 9c8b1349ee17b..a1430ab60a8a3 100644
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



