Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57CE356A12;
	Tue, 21 Jul 2026 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666605; cv=none; b=a4D+wO24h5LvYHSBWZ9sP4lCLZSTpK4w1d9w7fNlomW1Wq+GnBeKIpD/zJCUU27YQByKuhiTHi1jJfrVnFjdXMkYY9pBr0W2/y33kkRF6PID/gOboRFlzS0CgOqJJD9nXJ9DEWUsLSm0D+uH3ikfO+rb2umYR85a8IdS0qVCXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666605; c=relaxed/simple;
	bh=85o4P55lTYlWuZkSu8r071/4QKEOvdL+KlWAbV8LGDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FInoW1BKU0Gn1uKZMbrmv6+NXK8J1hFdZpu/EjLHRk43Q+oKusxXMURoOHP3VhgXv/T2+XNt4mZ1e7EQkyd8YFj8CYyZpa11mk9FmrCR7BJ6zlaqfnBccQYo5omnKLkcy4rkRfBkkzh1qL6NufwqMf+AUgus90hhlNMxeFiMRPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Dd6kSKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Dd6kSKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221E11F000E9;
	Tue, 21 Jul 2026 20:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666604;
	bh=oMY8g+wQlyyzJyvMsu42Y4bN4acg2bpc77K8AzuEZBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Dd6kSKlOc7HDwkoCHkbZC0IgMUESRCop24eGTGD5nss87DVRPn90wKX0IuqPtbSZ
	 HtdJENF/OFz/ig0PKNS11pkQI+KBwQS8dlNSrEnnSdLXAEsa/PXcP80oe/+4HXTPQ/
	 yc9cTKXC1h0c8w19df2osSKMZU6Ir5kE3WOjsHJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0747/1266] irqchip/crossbar: Fix parent domain resource leak
Date: Tue, 21 Jul 2026 17:19:44 +0200
Message-ID: <20260721152458.586361157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



