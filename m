Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97541FCFFC;
	Sat, 12 Sep 2026 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223307; cv=none; b=u1p4NS56UOCZUlreswdFKxZ9LcuxALUHkN92G1brQwFW1hRZK00cVlRBOepDg4NnvQqpXtAfvJtwO12xkVAT1F4VjAE+wRWGd01RFMDXEixV6+5liJ223BKyWLLhWjj5cj6uyxUhcyJ0Bhno7uww8W5VhzccKzH2hGh+oFp4/aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223307; c=relaxed/simple;
	bh=Tve6+ibdjt/HEXqL2O8KzYfLWyMAsPKk1D8Q7ImIR/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slO9Pn4d1az/xSdRJVPxIer8s1vhMJedVIp8Ym9sD/CTtpF2HyS+mYtomapbbWxOWoffpuZ9XChBMTpnjmEixnITy8jiTytTzbPIXuTeb8xXkaBb2S6J4ucijdOvdMQEmj7VCurn9c/WwO1GnaVScUo1Kb0wbf87sVdiNjIJYfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOL69AFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOL69AFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697661F000FF;
	Sat, 12 Sep 2026 14:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223306;
	bh=XDIv/IZ1lcRBynpA5wiEkAcakJghWNkUsIeiTK08CYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOL69AFvKw4eZZleou1M1fi/61jU+Bv/WCqSTrkynQz/rDCbCMhgqvUyNxxvI8vZ4
	 iN5XceOVMzKMXoItx9Zv9cgj8RYp5k5MgK0jakjDnsSWweRwdaxmpO/1+IorI4nzD4
	 Z719ZQr4YnpK/vNJ2YiPHR3LaCvU9KYIT8OSksKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0761/1424] irqdomain: Introduce irq_domain_free()
Date: Sat, 12 Sep 2026 08:53:13 +0200
Message-ID: <20260912065624.339214814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 89b37541ca38954f8ac01c2ca25405b140cfc8eb ]

In preparation of the introduction of the irq domain instantiation,
introduce irq_domain_free() to avoid code duplication on later
modifications.

This new function is an extraction of the current operations performed
to free the irq domain. No functional change intended.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240614173232.1184015-2-herve.codina@bootlin.com
Stable-dep-of: 616dd89d81ad ("irqchip/renesas-irqc: Fix generic interrupt chip leak on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index ddaaccdc09fae..697b5280f4bff 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -236,6 +236,15 @@ static void __irq_domain_publish(struct irq_domain *domain)
 	pr_debug("Added domain %s\n", domain->name);
 }
 
+static void irq_domain_free(struct irq_domain *domain)
+{
+	fwnode_dev_initialized(domain->fwnode, false);
+	fwnode_handle_put(domain->fwnode);
+	if (domain->flags & IRQ_DOMAIN_NAME_ALLOCATED)
+		kfree(domain->name);
+	kfree(domain);
+}
+
 /**
  * __irq_domain_add() - Allocate a new irq_domain data structure
  * @fwnode: firmware node for the interrupt controller
@@ -291,12 +300,7 @@ void irq_domain_remove(struct irq_domain *domain)
 	mutex_unlock(&irq_domain_mutex);
 
 	pr_debug("Removed domain %s\n", domain->name);
-
-	fwnode_dev_initialized(domain->fwnode, false);
-	fwnode_handle_put(domain->fwnode);
-	if (domain->flags & IRQ_DOMAIN_NAME_ALLOCATED)
-		kfree(domain->name);
-	kfree(domain);
+	irq_domain_free(domain);
 }
 EXPORT_SYMBOL_GPL(irq_domain_remove);
 
-- 
2.53.0



