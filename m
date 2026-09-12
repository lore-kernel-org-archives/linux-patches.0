Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689B1386C21;
	Sat, 12 Sep 2026 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215352; cv=none; b=Qa41mjiSA/nkZoy2iHSGc4eQ04OLQTY+kKY4HjW3vEJtjX6f38FCRZymP13LH8xIO0Z9bk1cNdSTZ3mkDlKjIsoV6mPN0ZdACca4VqOc1ouiD0pRMP8xoT4ZZ6LwsJWlfTN+3nJlOT1K4PDubba3/wYpJ+a9s9VjD8j0kru4Ays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215352; c=relaxed/simple;
	bh=w9I8xtxBqtA3MURB24m0RLxCJbOpiQSqrPh4sowU+6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glI8kbdxpgIxr55+IQS7nPkAGoXP4C+v7JjvMUb6R5zK4oxuXofmx+PejgcVIwz7nj1FvZho9JWpQOifQoI0680K2XLYpYn4rjAENF5xtdh2heJXkip7/TWVzj3uCWentO38mqVoEmQvfaDOlYwcaIp08yqK2deZLGfLkDR0wcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkoCY3r4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkoCY3r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088821F000FF;
	Sat, 12 Sep 2026 12:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215351;
	bh=ouMdddhUWUELlVf0DAdRPSmrleIuLOPVMjGTy1np5ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkoCY3r4PHyJxlVuLTTQqbAWh3PLMZ6UMDGfx0pJKIeXGjzZ57q15ic/+YSEWkO9D
	 u30OCt48ggURS3Lgfyb1H1tO5BSN16IBa23PP1XykdNPRjDZJNFdegFo/C9117YOt4
	 V1HtPyODhhFXtgLc09hAJpfszpZsG3YZTeFwa8/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sunil V L <sunilvl@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0471/1376] ACPI: RISC-V: Fix riscv_acpi_irq_get_dep() loop termination
Date: Sat, 12 Sep 2026 08:48:17 +0200
Message-ID: <20260912065618.031156729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 64ae310bffa477cd11029c818bec489f4b8a845e ]

In riscv_acpi_add_irq_dep() the main loop condition would currently stop
the loop if an interrupt descriptor contains an interrupt for which the
respective GSI handle is NULL, which is not correct because subsequent
interrupts in the interrupt descriptor might still have a GSI dependency
that must not be skipped.

Rework riscv_acpi_add_irq_dep() and the riscv_acpi_irq_get_dep() call chain
to fix it - by not forcing the loop to stop in order to guarantee
dependency detection for all the interrupt entries in the CRS descriptor.

Fixes: 1b173cc4bfcd ("ACPI: RISC-V: Implement function to add implicit dependencies")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Tested-by: Sunil V L <sunilvl@oss.qualcomm.com>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
Link: https://patch.msgid.link/20260709-gic-v5-acpi-iwb-probe-deferral-v4-2-48dae790f871@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/riscv/irq.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/riscv/irq.c b/drivers/acpi/riscv/irq.c
index cced960c2aeff..e24266ce8a14f 100644
--- a/drivers/acpi/riscv/irq.c
+++ b/drivers/acpi/riscv/irq.c
@@ -230,6 +230,7 @@ static acpi_status riscv_acpi_irq_get_parent(struct acpi_resource *ares, void *c
 			return AE_OK;
 
 		ctx->handle = riscv_acpi_get_gsi_handle(eirq->interrupts[ctx->index]);
+		ctx->rc = 0;
 		return AE_CTRL_TERMINATE;
 	}
 
@@ -245,10 +246,8 @@ static int riscv_acpi_irq_get_dep(acpi_handle handle, unsigned int index, acpi_h
 
 	acpi_walk_resources(handle, METHOD_NAME__CRS, riscv_acpi_irq_get_parent, &ctx);
 	*gsi_handle = ctx.handle;
-	if (*gsi_handle)
-		return 1;
 
-	return 0;
+	return ctx.rc;
 }
 
 static u32 riscv_acpi_add_prt_dep(acpi_handle handle)
@@ -310,8 +309,11 @@ static u32 riscv_acpi_add_irq_dep(acpi_handle handle)
 	int i;
 
 	for (i = 0;
-	     riscv_acpi_irq_get_dep(handle, i, &gsi_handle);
+	     !riscv_acpi_irq_get_dep(handle, i, &gsi_handle);
 	     i++) {
+		if (!gsi_handle)
+			continue;
+
 		dep_devices.count = 1;
 		dep_devices.handles = kcalloc(1, sizeof(*dep_devices.handles), GFP_KERNEL);
 		if (!dep_devices.handles) {
-- 
2.53.0



