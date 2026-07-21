Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DCD347BC6;
	Tue, 21 Jul 2026 22:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674311; cv=none; b=T5YWNEsGwQaOGm9Um84Bipjbh1cvWmY+iHG3DbXJ5zkTq3kRSt1MdvKWQCtt7xAJ9bziCm3VW7RCkBU7x37tN4/IdT4c+jkN2Xjy3jE/u4hTRRT6RmeWds3GgfpZEdAHDDIO9RgJKvobqaR++tviKeJUu0rdMsqZGduQJzAalqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674311; c=relaxed/simple;
	bh=4pSKzMgCjKWV4NP6UWNLvt6/uUQLohDO2SPQg4jWXAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzOhhWD+HQi23UeQnvDy9hzXScbEuw78MHIGwiPLo5fhhJcG0P8Tajf/AuV2F0NOsbRpuJfvMxFVbP1skk6FYxHDcA5D2TjzICGPW4tgLLeakM+OAXCK33xPKNd7/9aFcDeMGWbqS38Knj5sbMf/FQVnp+f33Z5kjtBWu8VOlUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lddPFGtG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lddPFGtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB461F000E9;
	Tue, 21 Jul 2026 22:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674310;
	bh=HnwWbMACZ1cjaePG8mxQSyBXEuXAVNw9+WOawNsTP+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lddPFGtGymjLkuNXUXaNHWqu2YY9eS4Arbpsdu/9j0nNYdOW4ZSsp9F9fxZhnwIIw
	 Py/7GRzi+86dmkJ1kQsqCLfNez43dUe32Lv9D33qOVd1oyVsSR+XJ2PLhUT9didFDp
	 xAlEvhOTyCUeWlhL2MDcZjeFWLmBl90p9mED2DCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.10 491/699] irqchip/crossbar: Use correct index in crossbar_domain_free()
Date: Tue, 21 Jul 2026 17:24:10 +0200
Message-ID: <20260721152406.773236713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhargav Joshi <j.bhargav.u@gmail.com>

commit 043db005a8d6932dc7d217c86307e9af0bc10ddc upstream.

crossbar_domain_free() resets the domain data and then uses the nulled
out irq_data->hwirq member as index to reset the irq_map[] entry and to
write the relevant crossbar register with a safe entry. That means it
never frees the correct index and keeps the crossbar register connection
to the source interrupt active.

If it would not reset the domain data, then this would be even worse as
irq_data->hwirq holds the source interrupt number, but both the map and
register index need the corresponding GIC SPI number and not the source
interrupt number. This might even result in an out of bounds access as
the source interrupt number can be higher than the maximal index space.

Fix this by using the GIC SPI index from the parent domain's irq_data.

Fixes: 783d31863fb82 ("irqchip: crossbar: Convert dra7 crossbar to stacked domains")
Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260620-irq-crossbar-fix-v2-1-b8e8499f468a@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-crossbar.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -158,9 +158,14 @@ static void crossbar_domain_free(struct
 	for (i = 0; i < nr_irqs; i++) {
 		struct irq_data *d = irq_domain_get_irq_data(domain, virq + i);
 
+		/*
+		 * irq_map[] is indexed by GIC SPI number. The parent domain's
+		 * hwirq contains the GIC interrupt number (GIC SPI +
+		 * GIC_IRQ_START).
+		 */
+		cb->irq_map[d->parent_data->hwirq - GIC_IRQ_START] = IRQ_FREE;
+		cb->write(d->parent_data->hwirq - GIC_IRQ_START, cb->safe_map);
 		irq_domain_reset_irq_data(d);
-		cb->irq_map[d->hwirq] = IRQ_FREE;
-		cb->write(d->hwirq, cb->safe_map);
 	}
 	raw_spin_unlock(&cb->lock);
 	irq_domain_free_irqs_parent(domain, virq, nr_irqs);


