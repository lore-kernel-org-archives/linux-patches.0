Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A012BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B20C433D2;
	Tue,  7 Mar 2023 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214272;
	bh=uIYNMFmncTTRgN2qlNAyef2CpIPhlvxozbQrLYKfnyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQxs0k15JlQRQfB6JZlw+jjuSqWrsmJ8w0gzEHuRYAxT0W3Q8aG/z2G3cvY/49tAb
	 /VdDpAAOMwyNEDhTefbdlLePW0giegV2h9WVqL34dPHVMR1mOhHEIwrIaxQGHNT7JG
	 mW/uYxlUKUijPu+RQf7pAKfpo/Sk9C7zWdv+tpw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 777/885] irqdomain: Drop bogus fwspec-mapping error handling
Date: Tue,  7 Mar 2023 18:01:51 +0100
Message-Id: <20230307170035.697057192@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit e3b7ab025e931accdc2c12acf9b75c6197f1c062 upstream.

In case a newly allocated IRQ ever ends up not having any associated
struct irq_data it would not even be possible to dispose the mapping.

Replace the bogus disposal with a WARN_ON().

This will also be used to fix a shared-interrupt mapping race, hence the
CC-stable tag.

Fixes: 1e2a7d78499e ("irqdomain: Don't set type when mapping an IRQ")
Cc: stable@vger.kernel.org      # 4.8
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-4-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -853,13 +853,8 @@ unsigned int irq_create_fwspec_mapping(s
 	}
 
 	irq_data = irq_get_irq_data(virq);
-	if (!irq_data) {
-		if (irq_domain_is_hierarchy(domain))
-			irq_domain_free_irqs(virq, 1);
-		else
-			irq_dispose_mapping(virq);
+	if (WARN_ON(!irq_data))
 		return 0;
-	}
 
 	/* Store trigger type */
 	irqd_set_trigger_type(irq_data, type);


