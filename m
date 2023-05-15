Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0046FFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EE8C433EF;
	Mon, 15 May 2023 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170638;
	bh=O5Og/VhS5c+1C948jlT/tSohK77NsFpWdTOU+CBT02k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjT+MTH5sYnjD3mQYL8ZV4RMfVw2oL/6V1iAGf2dCqe0IWucQjt4PRsmCaCFwnuDa
	 vhJhfoTgzQl1+GDD0zVwnHY/sxLqlVwetl3IRxzZ+NKER+c+taqpVMZw7y0MvwpD3g
	 hDG4VYxl2uQqgQOotrftUfZAo1CbfaQ9E4akEGXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/239] irqchip/loongson-eiointc: Fix registration of syscore_ops
Date: Mon, 15 May 2023 18:27:38 +0200
Message-Id: <20230515161727.585103467@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianmin Lv <lvjianmin@loongson.cn>

[ Upstream commit bdd60211eebb43ba1c4c14704965f4d4b628b931 ]

When support suspend/resume for loongson-eiointc, the syscore_ops
is registered twice in dual-bridges machines where there are two
eiointc IRQ domains. Repeated registration of an same syscore_ops
broke syscore_ops_list. Also, cpuhp_setup_state_nocalls is only
needed to call for once. So the patch will corret them.

Fixes: a90335c2dfb4 ("irqchip/loongson-eiointc: Add suspend/resume support")
Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230407083453.6305-4-lvjianmin@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-eiointc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index 768ed36f5f663..ac04aeaa2d308 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -390,9 +390,11 @@ int __init eiointc_acpi_init(struct irq_domain *parent,
 	parent_irq = irq_create_mapping(parent, acpi_eiointc->cascade);
 	irq_set_chained_handler_and_data(parent_irq, eiointc_irq_dispatch, priv);
 
-	cpuhp_setup_state_nocalls(CPUHP_AP_IRQ_LOONGARCH_STARTING,
+	if (nr_pics == 1) {
+		cpuhp_setup_state_nocalls(CPUHP_AP_IRQ_LOONGARCH_STARTING,
 				  "irqchip/loongarch/intc:starting",
 				  eiointc_router_init, NULL);
+	}
 
 	if (cpu_has_flatmode)
 		node = cpu_to_node(acpi_eiointc->node * CORES_PER_EIO_NODE);
-- 
2.39.2



