Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869314AD35;
	Wed, 19 Jun 2024 13:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802075; cv=none; b=Ie9ZgqjnI1TAmymiZpMpZ4cHlmIsl5nOEG3O1xu3FqUNjykQ+qoyyW3dTfCCo6dJbA6VK8ndCfrBJkubIdugrPP/QmruVDZ05rWz/ihkIGwx8JYI2EjVk7xD+35OWUUWs8PR7abeV1GZrL42Nx4lWv2Y2pcWmegdSmTjKqk41Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802075; c=relaxed/simple;
	bh=gMID78jSTKl0Td8uTmdR4bSIXfKYo+vbLKYi/O+BY0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8zoYj9RmgWWewm98dnPp8Za1BYgs7kCZRqe1ZrmRxrGH4UWASvkvO+hYyCkqc/+a1c4l8kcFFiyMrgDGJWTqwQvztXJyvAlvbbaJ7IYA4ASfpGyJy+Rmb4tG2J901z3z/Afco6Ks17wD2FV2dPNec5qnjozZOMqvaZ7+rks4R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIHk3w0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIHk3w0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3BDC4AF1A;
	Wed, 19 Jun 2024 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802075;
	bh=gMID78jSTKl0Td8uTmdR4bSIXfKYo+vbLKYi/O+BY0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIHk3w0U9BOLToqeoEsWBztbpY+DaROQs8v6nOa5pybBOx6dXPT+YHuR6JYb0qlI8
	 yxu8n4lqHq6iWOXiQchZvlekLkXEYvweR+ZeqpDLUUKlx+Jekt0zK9/1bVaLKTNGM3
	 y7DD5hIw3RP7Pi9ajEI8kFiZC6Che/YcoefPp13U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil V L <sunilvl@ventanamicro.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/267] irqchip/riscv-intc: Prevent memory leak when riscv_intc_init_common() fails
Date: Wed, 19 Jun 2024 14:53:44 +0200
Message-ID: <20240619125609.158016261@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil V L <sunilvl@ventanamicro.com>

[ Upstream commit 0110c4b110477bb1f19b0d02361846be7ab08300 ]

When riscv_intc_init_common() fails, the firmware node allocated is not
freed. Add the missing free().

Fixes: 7023b9d83f03 ("irqchip/riscv-intc: Add ACPI support")
Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240527081113.616189-1-sunilvl@ventanamicro.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-intc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-intc.c b/drivers/irqchip/irq-riscv-intc.c
index 0cd6b48a5dbf9..627beae9649a2 100644
--- a/drivers/irqchip/irq-riscv-intc.c
+++ b/drivers/irqchip/irq-riscv-intc.c
@@ -232,8 +232,9 @@ IRQCHIP_DECLARE(andes, "andestech,cpu-intc", riscv_intc_init);
 static int __init riscv_intc_acpi_init(union acpi_subtable_headers *header,
 				       const unsigned long end)
 {
-	struct fwnode_handle *fn;
 	struct acpi_madt_rintc *rintc;
+	struct fwnode_handle *fn;
+	int rc;
 
 	rintc = (struct acpi_madt_rintc *)header;
 
@@ -252,7 +253,11 @@ static int __init riscv_intc_acpi_init(union acpi_subtable_headers *header,
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
-- 
2.43.0



