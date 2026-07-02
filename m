Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7710F3B3BF2;
	Thu,  2 Jul 2026 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009743; cv=none; b=Cl2uMeDHyNh5Lh+aMzpDRvtXSME0eJLKIrO2n9ihIIjR2+s/DwFeUioyDu+92CYSYATv+0/Qo14trKpotsOWd/wzv9rY0v+0yXFkIumzixqoTq6eMwqn7dVSeXFqpm0c1h4d5emAyJj8ANB0PigeeH4kXFY67EET/3y8dIjoc98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009743; c=relaxed/simple;
	bh=VQ3Nqy7lolxFcGRmSzMP5Ltvp0rQ/GOq6tidXIGzkjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQx738n5bUV3WGn5/Ip+tA5+jvrtPjk2TS3+F8Nz4Mwft5GS6cldo/yGDo2RhloscgyHd4g6QjVWkNCrj7auqOgniUM+agOpdgdpcyJqMCh9TCIov1ZwXizDKH3KGzKf5grln5AbWHhzE9D/4JIZiPOoSaDqaJP0No34DiFxRd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sC8yYGgt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sC8yYGgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA50D1F000E9;
	Thu,  2 Jul 2026 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009741;
	bh=mhJypw/6zL2hSrVGS9AQNS3HJbW7YEXraIZTXoDLQp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sC8yYGgtgmuq6OCsp856c27Tf9GFReVOWjfPXdbjkuzDapabLYDfc7Jd+5LD+PdhF
	 Q9j4TbOwbu/0N8pFCwAOQCXyHY5EN0JC99C0VjGp24QL7hrkD1Njf3ODbPkw1ZyS0l
	 9cLkdqJg1PNXSey9XXKGH13C1MWODAhFDEX1pIU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.15 70/95] irqchip/imgpdc: Fix resource leak, add missing chained handler cleanup on remove
Date: Thu,  2 Jul 2026 18:20:13 +0200
Message-ID: <20260702155110.686771035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


