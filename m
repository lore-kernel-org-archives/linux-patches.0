Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE5914A623;
	Thu, 13 Jun 2024 11:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279525; cv=none; b=ZiuR53WceBby5ciHZxyCdFRi43AAVlZjsqrfuxeLddDR80TpNjQfEtKaN2JnWOPmIVT7YY1q8mQp2P15oZAzes6iM6lYuM8UTwIgzCokMTcy/79V0rAA4ZwD50g3y4jowLg3R8pJJMdsHEtEYhzfGDjbaY4FXfF7br9mMW76EZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279525; c=relaxed/simple;
	bh=jfhVh1Jxae1yAOJJs/qfkyThE12OBAeG3zVTRH+tGh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9CjxIkiX5HqeL7x1kJ6YV8FwFTQGajVHTknBzJZmZM8jYiw1A97yGCaJpyG4OJHTfLjcerbs6dtVlOk0vc/Xj/14c1TXe4VcsQOkAeRMom9qbkBxjR+4JdLDNWwd3OHjTP4njFfe4rqwA6e9SAo4Z65SMJPKU4WtenyI16pYFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcxiU4AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcxiU4AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2461AC32786;
	Thu, 13 Jun 2024 11:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279525;
	bh=jfhVh1Jxae1yAOJJs/qfkyThE12OBAeG3zVTRH+tGh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcxiU4AT+BO7TSEIkjvVj/2eBAcj/jogOJyG3B5DunL4JpkXbPkIpVk4wIDAsOR8z
	 sQtnnkhH7DVHvgVYO15Xh8mpY1KxC5xTOctNi279TmMk38H8uAAH6+3CeOEt6yzox6
	 vdAIHW2GFA46AV8A31UQFjenXk1vUjSW76Ie9/6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil V L <sunilvl@ventanamicro.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.9 106/157] irqchip/riscv-intc: Prevent memory leak when riscv_intc_init_common() fails
Date: Thu, 13 Jun 2024 13:33:51 +0200
Message-ID: <20240613113231.520366907@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil V L <sunilvl@ventanamicro.com>

commit 0110c4b110477bb1f19b0d02361846be7ab08300 upstream.

When riscv_intc_init_common() fails, the firmware node allocated is not
freed. Add the missing free().

Fixes: 7023b9d83f03 ("irqchip/riscv-intc: Add ACPI support")
Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240527081113.616189-1-sunilvl@ventanamicro.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-riscv-intc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-riscv-intc.c
+++ b/drivers/irqchip/irq-riscv-intc.c
@@ -253,8 +253,9 @@ IRQCHIP_DECLARE(andes, "andestech,cpu-in
 static int __init riscv_intc_acpi_init(union acpi_subtable_headers *header,
 				       const unsigned long end)
 {
-	struct fwnode_handle *fn;
 	struct acpi_madt_rintc *rintc;
+	struct fwnode_handle *fn;
+	int rc;
 
 	rintc = (struct acpi_madt_rintc *)header;
 
@@ -273,7 +274,11 @@ static int __init riscv_intc_acpi_init(u
 		return -ENOMEM;
 	}
 
-	return riscv_intc_init_common(fn, &riscv_intc_chip);
+	rc = riscv_intc_init_common(fn, &riscv_intc_chip);
+	if (rc)
+		irq_domain_free_fwnode(fn);
+
+	return rc;
 }
 
 IRQCHIP_ACPI_DECLARE(riscv_intc, ACPI_MADT_TYPE_RINTC, NULL,


