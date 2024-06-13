Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131FBEC4;
	Thu, 13 Jun 2024 12:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281816; cv=none; b=kIHb0Dzi0qjoU/uAke2g+kpVo9PQD/HLHZTTvGMRKFaB1+0fjeIbGuFE2MAztBZ/DPh882mY2Kn7bwaO0a5NBLWM79SbH3lGnZ1keyARLiWKOBh9mNsMylE4iIdg6/ALhEHmckC9IgEFBDdnSywkZ3y/wmEq9emm48HaWappxqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281816; c=relaxed/simple;
	bh=jlMNHDP5DQ1bI2vdG4iqo/x7EIQkVYTBHe0rawOgnQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZirfC2DyCg1clxbAg8bdUds96xCkTR/xJiLFrQW6/wGevpYeQBFn0nIEiB4UuJBSudpkG1S6dMXUSuRY3sykwFNiN+eOBwVGJ8mB8tUR6K9sJ4yG6G0jYGg5A9vJlhQ7M+rZF7iihhhK86CGj9S0iXSEe5M5hccxgysp4BZZIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hols4l6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hols4l6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87044C2BBFC;
	Thu, 13 Jun 2024 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281815;
	bh=jlMNHDP5DQ1bI2vdG4iqo/x7EIQkVYTBHe0rawOgnQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hols4l6W7PgzsU7/DUh3hW+BI7kPSRBDtPH1aUi6oow7CRQ+IFoeUB4Vp13yEZ7N4
	 Hh52kxuxjLAUYLTw+4O3k5Y27yngJKTxAxIMbTkt6/z8UCCkoQrAJ9QmQZRC7nkGSZ
	 mDAmzO6LwkYBwg6KdbzR6WXNOgN0rB18d1uQfpks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/402] irqchip/alpine-msi: Fix off-by-one in allocation error path
Date: Thu, 13 Jun 2024 13:30:23 +0200
Message-ID: <20240613113304.711155822@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fc1ef7de37973..c9ffd69dfc756 100644
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



