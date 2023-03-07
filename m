Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAC5BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C93C433D2;
	Tue,  7 Mar 2023 19:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216125;
	bh=8iqDb8A50Fit+bU6TpV6GHH/ef8lYltVMLVwrAyQhpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0g44A5broc6ACRgWCMOrD5x3EZ0cxTBM3z7OHXMYn1GUY3LdnjdMc+4NEyRYkwySf
	 RC0xS5hfE8UKh2c+uVer5Oi4gEja6fhdAjd5qOEzE6vVMa8caPSRdSanLje7OeycvL
	 3qvw9btNiOq+en4N5iQk6gps6EmHU/1caBrFFzNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 484/567] irqdomain: Fix association race
Date: Tue,  7 Mar 2023 18:03:40 +0100
Message-Id: <20230307165926.902269907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

commit b06730a571a9ff1ba5bd6b20bf9e50e5a12f1ec6 upstream.

The sanity check for an already mapped virq is done outside of the
irq_domain_mutex-protected section which means that an (unlikely) racing
association may not be detected.

Fix this by factoring out the association implementation, which will
also be used in a follow-on change to fix a shared-interrupt mapping
race.

Fixes: ddaf144c61da ("irqdomain: Refactor irq_domain_associate_many()")
Cc: stable@vger.kernel.org      # 3.11
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -559,8 +559,8 @@ static void irq_domain_disassociate(stru
 	irq_domain_clear_mapping(domain, hwirq);
 }
 
-int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
-			 irq_hw_number_t hwirq)
+static int irq_domain_associate_locked(struct irq_domain *domain, unsigned int virq,
+				       irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 	int ret;
@@ -573,7 +573,6 @@ int irq_domain_associate(struct irq_doma
 	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
 		return -EINVAL;
 
-	mutex_lock(&irq_domain_mutex);
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
 	if (domain->ops->map) {
@@ -590,7 +589,6 @@ int irq_domain_associate(struct irq_doma
 			}
 			irq_data->domain = NULL;
 			irq_data->hwirq = 0;
-			mutex_unlock(&irq_domain_mutex);
 			return ret;
 		}
 
@@ -601,12 +599,23 @@ int irq_domain_associate(struct irq_doma
 
 	domain->mapcount++;
 	irq_domain_set_mapping(domain, hwirq, irq_data);
-	mutex_unlock(&irq_domain_mutex);
 
 	irq_clear_status_flags(virq, IRQ_NOREQUEST);
 
 	return 0;
 }
+
+int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq)
+{
+	int ret;
+
+	mutex_lock(&irq_domain_mutex);
+	ret = irq_domain_associate_locked(domain, virq, hwirq);
+	mutex_unlock(&irq_domain_mutex);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(irq_domain_associate);
 
 void irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,


