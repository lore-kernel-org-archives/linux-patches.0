Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4962C3C10A7;
	Tue, 21 Jul 2026 21:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669567; cv=none; b=R2oa82Q4S6OCht/SJrVWVprrdFqeEM0iX7Hwb5WGCfTKEJGSoy8ulHuw4SHPul+1aziB6YABiMlIcIVt2e5Chm/ydnLO/Kaf/utKXSLS0+6HGe0Jxd0w7OllNLChA76XUXGIZTL/ozqOb2gG1m7jJfCuWe0dJcVwF6EzH19Yyr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669567; c=relaxed/simple;
	bh=Uus9jX0eCRkR9zurqporIvTd+Gf+hwkDKdPsJgIRbOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItSG1Bm/+3EbuqEJL7m/7jlHjNwXLMdVb6bxiDbNq+2aaurOrOTzX/HcoDxSpaOayQzazUGXVCwByUYs83pMx9n2qVseBktTosXcoYGcjWPxqdYqp+V5ED/++1tBN59xSMp1q1Yu5vsxhIB1IVOszBgLf3bCNDkTO6OO/3IAtBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoFk+wVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoFk+wVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21421F000E9;
	Tue, 21 Jul 2026 21:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669566;
	bh=27C49DvKAGADTFZWj5Ltf8IiU2BleTJEDg1m6DBidBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XoFk+wVb2pklPgNEYOu+/NL2pA7o5+ZxM3jS18HIAKd2ro8CbE0SirjsBRGEkydC0
	 uwN3vl+RkFFys7MKpvWT6Dtzn3RY1Fj8AmfJqlVnc3VuaowthQFYtMqMv0KClrQTQr
	 st5uj91QNSKEBbLju3PR4jjznRjJa34GKUo58GBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0601/1067] irqchip/crossbar: Fix parent domain resource leak
Date: Tue, 21 Jul 2026 17:20:02 +0200
Message-ID: <20260721152438.046786019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Bhargav Joshi <j.bhargav.u@gmail.com>

[ Upstream commit a1074dd62faa6572921d387e8a21589ccea00efc ]

irq_domain_alloc_irqs_parent() is called in allocate_gic_irq() but
irq_domain_free_irqs_parent() is never called which causes a resource leak.

Fix this by calling irq_domain_free_irqs_parent() in
crossbar_domain_free().

Fixes: 783d31863fb82 ("irqchip: crossbar: Convert dra7 crossbar to stacked domains")
Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260620-irq-crossbar-fix-v2-2-b8e8499f468a@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-crossbar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index a05a7501e10790..729492772ff46e 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -163,6 +163,7 @@ static void crossbar_domain_free(struct irq_domain *domain, unsigned int virq,
 		cb->write(d->hwirq, cb->safe_map);
 	}
 	raw_spin_unlock(&cb->lock);
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
 }
 
 static int crossbar_domain_translate(struct irq_domain *d,
-- 
2.53.0



