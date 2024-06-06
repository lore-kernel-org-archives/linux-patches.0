Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C8F1993AE;
	Thu,  6 Jun 2024 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683235; cv=none; b=eqph8bpg056pDepOtHg/4hr2Vd4i7PISVna5NZ8t52urLoIXc1hdTYtSOFG1pB2qlRnBNADoPeP8jJolR/CORnJLCDb2XtvrUTvDPttv2RErpV3SPOtw6uQ4X7tJ9HGRJlPUQTYvw8sg1Q+AifeU/i+FD9Vhepthoedul/++pRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683235; c=relaxed/simple;
	bh=s1raG3BH/Pu5PRvp8spqtN/YJIULFZH5MRlNwdwWejQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8PcZa7sDjHvKXILzls267Lr7Mx7Lar2RfaihUeNPjAn8+aOlvffUD6xyEzhYaRJhX4ewOmDbuIPdLtwAzGRjH5Wqc2nS0vXKnjXSXheCCZTrrE62ODdmoXz9dtMBJbBfgibMYmKrvSLczl+wUeYzQCzQgp0MnQ8lge1NvPr0Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBR87o3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBR87o3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85005C2BD10;
	Thu,  6 Jun 2024 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683235;
	bh=s1raG3BH/Pu5PRvp8spqtN/YJIULFZH5MRlNwdwWejQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBR87o3yUcNcAIa5ohE1b3UGy8WjJSahursv4ngrVWTomx+KJ3DHX5qQ/Gdi/JAqB
	 kAdLbyX5qbekx5ppLFO50s7eA8LNk/2jY5/qz9II+59s6CvS7RHykPcdy4mhe0TrWV
	 5fjYPDQHX8M4R+eft64PhmAhuOLzBzZkqVguuui0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/473] irqchip/alpine-msi: Fix off-by-one in allocation error path
Date: Thu,  6 Jun 2024 16:00:42 +0200
Message-ID: <20240606131703.671441339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



