Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B491E3DF9;
	Tue,  3 Dec 2024 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238782; cv=none; b=k6B4IZj+jg2YaPCX43q3h6U80OCZkFy3cR5cYpfFsaDxka4mQHGc4r0MA09y39e6Lkn4Cp3soOk362oWY3ye03vcFcgEzH1NX87OltPJ3LwLMA2774WwKH5ZmNPADCaFCk2/WCJ1wxJzeHBHe7Mb5goEdGf2AZBLCFgex7QGf+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238782; c=relaxed/simple;
	bh=1E+YfR9w/BaOiH+2dxh95YF7mUL2ZTo78V3mAaehRjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIeof8rMqougaOOQX2oMOdta3ZiJIBvXXmXefCSbXEdJ5DjZVWzQ1xQW9NLXku2ybhSqTG/Y9w+FmjTAnuXfM/8vfdYchv2JM8+kNEPHpBJ4WwwLzytPCXE0U54Z5CiRu4bm/SvHnShw5qXMBHDYm7tGwigjDUH4ecZ2rwcCA98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyiOsMeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyiOsMeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A88C4CECF;
	Tue,  3 Dec 2024 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238782;
	bh=1E+YfR9w/BaOiH+2dxh95YF7mUL2ZTo78V3mAaehRjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyiOsMeHHfZkCgYkNSU1PuBZf/omn5rOOLkXcsPf6vI0207dvQKOrOHXYBgXUGvMv
	 66F1oL4IUUTHQzwLSeYqTdl4bTGVQo9y71UcNtw30Ii0pbHUHkeBHpp7a7hsh5sQt9
	 082SvNe1ObOqm5i8jkM+T8MYx4aZsRw3WoEafmNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 394/817] regmap: Allow setting IRQ domain name suffix
Date: Tue,  3 Dec 2024 15:39:26 +0100
Message-ID: <20241203144011.252382309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit dde286ee57704226b500cb9eb59547fec07aad3d ]

When multiple IRQ domains are created from the same device-tree node they
will get the same name based on the device-tree path. This will cause a
naming collision in debugFS when IRQ domain specific entries are created.

The regmap-IRQ creates per instance IRQ domains. This will lead to a
domain name conflict when a device which provides more than one
interrupt line uses the regmap-IRQ.

Add support for specifying an IRQ domain name suffix when creating a
regmap-IRQ controller.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/776bc4996969e5081bcf61b9bdb5517e537147a3.1723120028.git.mazziesaccount@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3727c0b4ff6b ("mfd: intel_soc_pmic_bxtwc: Fix IRQ domain names duplication")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-irq.c | 37 ++++++++++++++++++++++----------
 include/linux/regmap.h           |  4 ++++
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 250b2cc1e5d87..6981e5f974e9a 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -612,6 +612,30 @@ int regmap_irq_set_type_config_simple(unsigned int **buf, unsigned int type,
 }
 EXPORT_SYMBOL_GPL(regmap_irq_set_type_config_simple);
 
+static int regmap_irq_create_domain(struct fwnode_handle *fwnode, int irq_base,
+				    const struct regmap_irq_chip *chip,
+				    struct regmap_irq_chip_data *d)
+{
+	struct irq_domain_info info = {
+		.fwnode = fwnode,
+		.size = chip->num_irqs,
+		.hwirq_max = chip->num_irqs,
+		.virq_base = irq_base,
+		.ops = &regmap_domain_ops,
+		.host_data = d,
+		.name_suffix = chip->domain_suffix,
+	};
+
+	d->domain = irq_domain_instantiate(&info);
+	if (IS_ERR(d->domain)) {
+		dev_err(d->map->dev, "Failed to create IRQ domain\n");
+		return PTR_ERR(d->domain);
+	}
+
+	return 0;
+}
+
+
 /**
  * regmap_add_irq_chip_fwnode() - Use standard regmap IRQ controller handling
  *
@@ -860,18 +884,9 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 		}
 	}
 
-	if (irq_base)
-		d->domain = irq_domain_create_legacy(fwnode, chip->num_irqs,
-						     irq_base, 0,
-						     &regmap_domain_ops, d);
-	else
-		d->domain = irq_domain_create_linear(fwnode, chip->num_irqs,
-						     &regmap_domain_ops, d);
-	if (!d->domain) {
-		dev_err(map->dev, "Failed to create IRQ domain\n");
-		ret = -ENOMEM;
+	ret = regmap_irq_create_domain(fwnode, irq_base, chip, d);
+	if (ret)
 		goto err_alloc;
-	}
 
 	ret = request_threaded_irq(irq, NULL, regmap_irq_thread,
 				   irq_flags | IRQF_ONESHOT,
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 122e38161acb8..f9ccad32fc5cb 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -1521,6 +1521,9 @@ struct regmap_irq_chip_data;
  * struct regmap_irq_chip - Description of a generic regmap irq_chip.
  *
  * @name:        Descriptive name for IRQ controller.
+ * @domain_suffix: Name suffix to be appended to end of IRQ domain name. Needed
+ *		   when multiple regmap-IRQ controllers are created from same
+ *		   device.
  *
  * @main_status: Base main status register address. For chips which have
  *		 interrupts arranged in separate sub-irq blocks with own IRQ
@@ -1606,6 +1609,7 @@ struct regmap_irq_chip_data;
  */
 struct regmap_irq_chip {
 	const char *name;
+	const char *domain_suffix;
 
 	unsigned int main_status;
 	unsigned int num_main_status_bits;
-- 
2.43.0



