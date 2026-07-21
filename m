Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752D046EC75;
	Tue, 21 Jul 2026 18:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658826; cv=none; b=er4BwihIDEL0KO/9OzeD3Xj8WGIn8JZp5KsspMcn30e/zspMIlf5kEZHWnCjGid3rRJh9aFkaChhyfMQuoWm2DijAN5oXCO8QUf6ClcM5BMrhNW0kitv260HywqO10VRj/SSJa3c6QZYsam+kBvZXoq0QoP5/58s8QbaLRybklE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658826; c=relaxed/simple;
	bh=haKR90YWBnAeHIA8N92cZWO6lphKqhj93nvRx37LYSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTFOAU1vyGU0kgtOzE8TaDqhJb7DbK2GBTnkAXD39/xcVNIomtdAKbJO37S70TJSzKeC9u24yz9sQsy/LS0yvLLbrPU5zALiM1C46psLECtHeL2q25hT5uvdlqoRX/qCOwfyGfkCBzBthskr0BucTGZ/HN09c/T2OgAux65WqkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZHmR937; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZHmR937"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7301F000E9;
	Tue, 21 Jul 2026 18:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658825;
	bh=Uf01GFylVGm29wHEC9DPQ9rUSmK2awUF/uRv0AUhJa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZHmR937IRRIyD5kTWKqnvmD+hZ1n3f/ceKMrukpa0VBRhOUYU9OmxCP3LeuBk4vJ
	 ovuNEfQ0EYFHwneyuQjX3L0+kIUMbscom1MjfluZTtKu/Ehigt74IdsqFTGStR4Zo6
	 YSg+v7mZSDuWYfj6XJKptnanr3Snuxzftfh2QyRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 1289/1611] irqchip/crossbar: Use correct index in crossbar_domain_free()
Date: Tue, 21 Jul 2026 17:23:25 +0200
Message-ID: <20260721152544.436156140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


