Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A348D1FB3;
	Tue, 27 May 2025 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368062; cv=none; b=gMF1hiO+dd2V9CnRRYL6B400HqsE4GozvGdZ44gTq+us/pbZ0TvXZBJUhUofyhkX4toPV324MVVZeRkDo3PL61N9GYoA5ckScKwpZOtvXnPHAAnCw0mmWqZDe9IXvs5xnZVkNylMprFpgDujspUvHfGzF4s5CEuE+/izXUyXN7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368062; c=relaxed/simple;
	bh=ydSAONpcerV/29sxV48HDR3DoZtY/TDZMORgQmAW6Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HURCifDWWleiQnJ1deZxPeY/RHO7LTzZBCGEvzzDNkp1Tr7GTcfncj3qCtMT8Tu3YjPCymwVkeK5dq8rwMDOfvp+pxzks9lmpyAJ3mMx8xA83JFGEg5VL9EoLArzIofbQprHCwKOmHuquBVzYw8lW7yRbJjhTrle0photLScbc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSIg/6rU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSIg/6rU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31338C4CEE9;
	Tue, 27 May 2025 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368062;
	bh=ydSAONpcerV/29sxV48HDR3DoZtY/TDZMORgQmAW6Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSIg/6rUU0hWR4s4i8oMWq9gmJODyGh42NRGi9Td15Wm1BdSCNpQlUZn1wRIcVmbE
	 n8ZV1wl/gfIbhRfRaRBU6BnGZ3ReG3EmkrLTYNq0IzYiuw1JKeU69KnBaSCYHvXQoO
	 RhkrOimUTW+P+JO1la1noqzVfifCrEk9PM7ZIvPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 587/783] irqchip/riscv-aplic: Add support for hart indexes
Date: Tue, 27 May 2025 18:26:24 +0200
Message-ID: <20250527162537.044317865@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>

[ Upstream commit b93afe8a3ac53ae52296d65acfaa9c5f582a48cc ]

RISC-V APLIC specification defines "hart index" in:

  https://github.com/riscv/riscv-aia

Within a given interrupt domain, each of the domain’s harts has a unique
index number in the range 0 to 2^14 − 1 (= 16,383). The index number a
domain associates with a hart may or may not have any relationship to the
unique hart identifier (“hart ID”) that the RISC-V Privileged Architecture
assigns to the hart. Two different interrupt domains may employ entirely
different index numbers for the same set of harts.

Further, this document says in "4.5 Memory-mapped control region for an
interrupt domain":

The array of IDC structures may include some for potential hart index
numbers that are not actual hart index numbers in the domain. For example,
the first IDC structure is always for hart index 0, but 0 is not
necessarily a valid index number for any hart in the domain.

Support arbitrary hart indices specified in an optional APLIC property
"riscv,hart-indexes" which is specified as an array of u32 elements, one
per interrupt target. If this property is not specified, fallback to use
logical hart indices within the domain.

Signed-off-by: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/all/20250129091637.1667279-3-vladimir.kondratiev@mobileye.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-aplic-direct.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-aplic-direct.c b/drivers/irqchip/irq-riscv-aplic-direct.c
index 7cd6b646774b9..205ad61d15e49 100644
--- a/drivers/irqchip/irq-riscv-aplic-direct.c
+++ b/drivers/irqchip/irq-riscv-aplic-direct.c
@@ -31,7 +31,7 @@ struct aplic_direct {
 };
 
 struct aplic_idc {
-	unsigned int		hart_index;
+	u32			hart_index;
 	void __iomem		*regs;
 	struct aplic_direct	*direct;
 };
@@ -219,6 +219,20 @@ static int aplic_direct_parse_parent_hwirq(struct device *dev, u32 index,
 	return 0;
 }
 
+static int aplic_direct_get_hart_index(struct device *dev, u32 logical_index,
+				       u32 *hart_index)
+{
+	const char *prop_hart_index = "riscv,hart-indexes";
+	struct device_node *np = to_of_node(dev->fwnode);
+
+	if (!np || !of_property_present(np, prop_hart_index)) {
+		*hart_index = logical_index;
+		return 0;
+	}
+
+	return of_property_read_u32_index(np, prop_hart_index, logical_index, hart_index);
+}
+
 int aplic_direct_setup(struct device *dev, void __iomem *regs)
 {
 	int i, j, rc, cpu, current_cpu, setup_count = 0;
@@ -265,8 +279,12 @@ int aplic_direct_setup(struct device *dev, void __iomem *regs)
 		cpumask_set_cpu(cpu, &direct->lmask);
 
 		idc = per_cpu_ptr(&aplic_idcs, cpu);
-		idc->hart_index = i;
-		idc->regs = priv->regs + APLIC_IDC_BASE + i * APLIC_IDC_SIZE;
+		rc = aplic_direct_get_hart_index(dev, i, &idc->hart_index);
+		if (rc) {
+			dev_warn(dev, "hart index not found for IDC%d\n", i);
+			continue;
+		}
+		idc->regs = priv->regs + APLIC_IDC_BASE + idc->hart_index * APLIC_IDC_SIZE;
 		idc->direct = direct;
 
 		aplic_idc_set_delivery(idc, true);
-- 
2.39.5



