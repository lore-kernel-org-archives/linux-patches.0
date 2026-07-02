Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16130C146;
	Thu,  2 Jul 2026 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010070; cv=none; b=UafG7bbNVXVvWvN29huGWFrVp9pdOcPXKvsqiTNgjAFGBlDhf2bH2ISutD+DsG9fDoN3Xa0Dv9pSJzpED/awlm4Qgtm1/EZZp5mbgdOBS4NVfO/aEmtqrDgeHwSAAvx4m8uSSZllYHQAP/BCeDT51YxEmxAok0eqjCT0t1gRczU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010070; c=relaxed/simple;
	bh=gtpJKb+5Tt9S26PPrKuPBa//Ck3hhOc9mQUkd5n+3jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJjLctEGGirjj5FrzUsnrbHWYJtGtMlYrsANgTmhT89jXEFc9gbOJBAL/IEN/ZZOkktO8o6UrlsH3XP9wb/s0GzQUVdm67x3yzr4Uic0cBHbhdVtqGdA2IjqHtxTQHJbvwSNLnhFm44hI9ujDxYYWxcLnS6bwlVeAmfVF9lkc+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJr5e0dX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJr5e0dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377231F000E9;
	Thu,  2 Jul 2026 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010069;
	bh=LPoXDF9d9HC6RMGG2VM3aA1GEmOcz4spkhQ/N59rXuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJr5e0dXWLBSTGoWIeid2z/KQmniGC4TEvMCQvz4UUsBY7+Nht2hXSjW266+gXgh8
	 QRbQYuPofx3KpCOsw5NMiMt2xW3qGBMbXvKY/ab0rxtZPyREJc1+Vi3r6DzPLGD7j0
	 QRym+1DI5EaMOR66xeqnfAOHi/9Zr7nv/x9HnEbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.1 097/129] irqchip/imgpdc: Fix resource leak, add missing chained handler cleanup on remove
Date: Thu,  2 Jul 2026 18:20:16 +0200
Message-ID: <20260702155114.149694808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

commit 37738fdf2ab1e504d1c63ce5bc0aeb6452d8f057 upstream.

The driver allocates domain generic chips using
irq_alloc_domain_generic_chips() during probe and sets up chained
handlers using irq_set_chained_handler_and_data(). However, on driver
removal, the generic chips are not freed and the chained handlers are
not removed.

The generic chips remain on the global gc_list and may later be accessed by
generic interrupt chip suspend, resume, or shutdown callbacks after the
driver has been removed, potentially resulting in a use-after-free and
kernel crash.

The chained handlers that were installed in probe for peripheral and
syswake interrupts are also left dangling, which can lead to spurious
interrupts accessing freed memory.

Fix these issues by:

  - Setting IRQ_DOMAIN_FLAG_DESTROY_GC flag in domain->flags, so the
    core code automatically removes generic chips when irq_domain_remove()
    is called

  - Clearing all chained handlers with NULL in pdc_intc_remove()

Fixes: b6ef9161e43a ("irq-imgpdc: add ImgTec PDC irqchip driver")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260618021352.661773-1-fffsqian@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-imgpdc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/irqchip/irq-imgpdc.c
+++ b/drivers/irqchip/irq-imgpdc.c
@@ -378,6 +378,7 @@ static int pdc_intc_probe(struct platfor
 		dev_err(&pdev->dev, "cannot add IRQ domain\n");
 		return -ENOMEM;
 	}
+	priv->domain->flags |= IRQ_DOMAIN_FLAG_DESTROY_GC;
 
 	/*
 	 * Set up 2 generic irq chips with 2 chip types.
@@ -465,6 +466,11 @@ static int pdc_intc_remove(struct platfo
 {
 	struct pdc_intc_priv *priv = platform_get_drvdata(pdev);
 
+	for (unsigned int i = 0; i < priv->nr_perips; ++i)
+		irq_set_chained_handler_and_data(priv->perip_irqs[i], NULL, NULL);
+
+	irq_set_chained_handler_and_data(priv->syswake_irq, NULL, NULL);
+
 	irq_domain_remove(priv->domain);
 	return 0;
 }


