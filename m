Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211544C97;
	Tue, 11 Nov 2025 00:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822546; cv=none; b=Id5tP8K7vnFn/hbRbeQZJbyXZ1+4d5lx85JURSbWE3GZEF5jvSpmDvED/Oe2oAWxSPUPDE3fn5ygGQPAl7PRdlqucENlz6GNdDi/sbXCK6ghQPTi7mWvoXXeW3eoUjURyvm2intzBsbOir8bKq0GYaLdqIj1XcuNYHd+xlDyKv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822546; c=relaxed/simple;
	bh=SldQBF/ilFkfxy1LRItgKUisXuXzSeKYWfjEYG7bYAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTaOtZnDV45BC0QDm3DI+FPa2Uj6OYLCXRVfDti5u2djgMovodSk3uVdKqfV+GntoPp+/Z5OcDVEglQ7JflW5aaJRC8t/O4kbdm6aLxxGlJQeOMmdzywdrump29IZxWe135XztK47dDF7VWvyrkwn8i2Xr+vk3Cxs1BG8298cC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jc6LZOoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jc6LZOoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82232C113D0;
	Tue, 11 Nov 2025 00:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822545;
	bh=SldQBF/ilFkfxy1LRItgKUisXuXzSeKYWfjEYG7bYAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jc6LZOoSH7rYoR8anJUsgS96tBlYngB7KEo3Pt17igVlV5GUPkSaJcURuNF81Wc8K
	 vAaoLq6TlY796TMjFdh8PfJEooBNAdUAdIrQonMeIYbvij7fGUDUrx9S6gwx5UPAIK
	 7oesH+HyVBYA2AMfmLdNDJYNXTjhGJinAsNq9EBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 134/849] irqchip/loongson-eiointc: Route interrupt parsed from bios table
Date: Tue, 11 Nov 2025 09:35:04 +0900
Message-ID: <20251111004539.637001236@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 7fb83eb664e9b3a0438dd28859e9f0fd49d4c165 ]

Interrupt controller eiointc routes interrupts to CPU interface IP0 - IP7.

It is currently hard-coded that eiointc routes interrupts to the CPU
starting from IP1, but it should base that decision on the parent
interrupt, which is provided by ACPI or DTS.

Retrieve the parent's hardware interrupt number and store it in the
descriptor of the eointc instance, so that the routing function can utilize
it for the correct route settings.

[ tglx: Massaged change log ]

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250804081946.1456573-2-maobibo@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-eiointc.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index b2860eb2d32c5..baa406904de55 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -68,6 +68,7 @@ struct eiointc_priv {
 	struct fwnode_handle	*domain_handle;
 	struct irq_domain	*eiointc_domain;
 	int			flags;
+	irq_hw_number_t		parent_hwirq;
 };
 
 static struct eiointc_priv *eiointc_priv[MAX_IO_PICS];
@@ -211,7 +212,12 @@ static int eiointc_router_init(unsigned int cpu)
 		}
 
 		for (i = 0; i < eiointc_priv[0]->vec_count / 32 / 4; i++) {
-			bit = BIT(1 + index); /* Route to IP[1 + index] */
+			/*
+			 * Route to interrupt pin, relative offset used here
+			 * Offset 0 means routing to IP0 and so on
+			 * Every 32 vector routing to one interrupt pin
+			 */
+			bit = BIT(eiointc_priv[index]->parent_hwirq - INT_HWI0);
 			data = bit | (bit << 8) | (bit << 16) | (bit << 24);
 			iocsr_write32(data, EIOINTC_REG_IPMAP + i * 4);
 		}
@@ -495,7 +501,7 @@ int __init eiointc_acpi_init(struct irq_domain *parent,
 
 	priv->vec_count = VEC_COUNT;
 	priv->node = acpi_eiointc->node;
-
+	priv->parent_hwirq = acpi_eiointc->cascade;
 	parent_irq = irq_create_mapping(parent, acpi_eiointc->cascade);
 
 	ret = eiointc_init(priv, parent_irq, acpi_eiointc->node_map);
@@ -527,8 +533,9 @@ int __init eiointc_acpi_init(struct irq_domain *parent,
 static int __init eiointc_of_init(struct device_node *of_node,
 				  struct device_node *parent)
 {
-	int parent_irq, ret;
 	struct eiointc_priv *priv;
+	struct irq_data *irq_data;
+	int parent_irq, ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -544,6 +551,12 @@ static int __init eiointc_of_init(struct device_node *of_node,
 	if (ret < 0)
 		goto out_free_priv;
 
+	irq_data = irq_get_irq_data(parent_irq);
+	if (!irq_data) {
+		ret = -ENODEV;
+		goto out_free_priv;
+	}
+
 	/*
 	 * In particular, the number of devices supported by the LS2K0500
 	 * extended I/O interrupt vector is 128.
@@ -552,7 +565,7 @@ static int __init eiointc_of_init(struct device_node *of_node,
 		priv->vec_count = 128;
 	else
 		priv->vec_count = VEC_COUNT;
-
+	priv->parent_hwirq = irqd_to_hwirq(irq_data);
 	priv->node = 0;
 	priv->domain_handle = of_fwnode_handle(of_node);
 
-- 
2.51.0



