Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E385646D2D2;
	Tue, 21 Jul 2026 19:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661016; cv=none; b=HxXI7Zo0Z4q/KrsK0S8SXrnKuciWihLOYz2IC0DfaOOzatwT/bJ6KXYWd9yUzrq4cBEXz416VUfNwIQi/r9nXKurV7RRkYKh7drLe/m9ATa9D28MDgIlqZQyzW0GxnwbqYfVBbs/KHSUm/eIfGxV9eR4twjBVLYevMZEWVPSLAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661016; c=relaxed/simple;
	bh=UdXwa0Nq2VZ49MuWEwOZp0nybtef8B6Wn2RlVCVqWwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdcA7n6zb6n0Q8zC/mZzbHRUtq2bR07sesRCmiuOBwcp4BsunQNubUEORw2ygZmvkMX46/O1CugRqskEtA/QQfTENrzBjxEBysnjLGytnixv/hHiXREdF0ET3Ljn5IqJRGR5hxr4jVnF9Gm4MhUp9GQxpIlYb2MDc/Sj2IcKbmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGWvwC9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGWvwC9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488F71F000E9;
	Tue, 21 Jul 2026 19:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661015;
	bh=8VZpHd0mR8ky0cTo5T4LeuhFosU57r2r7CA4RUJYftQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGWvwC9bW3kwZMmLeSQLfTlfAcy4qvan1JoqO57sRvVHNy7XHTIImzlD4w+z1GJc/
	 uUhkJ1pxsqAg0kY9av8gjFiO6LKnRaACRfTAYnkJFGPmzht79XfZ3y4IPgNzTvVYyq
	 tCQ7tInksszwFEkY2gVyyuSghtGDF/KqNnSmhNtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1157/2077] irqchip/crossbar: Fix parent domain resource leak
Date: Tue, 21 Jul 2026 17:13:50 +0200
Message-ID: <20260721152620.110247957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index cd1134101ace03..3035f8ecfac855 100644
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



