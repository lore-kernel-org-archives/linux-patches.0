Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADB030C37D;
	Mon, 13 Oct 2025 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368930; cv=none; b=OFjKtwwy5E/Fll5L6e+Nq4GlxA4mJqYGjgjY8BUDP7667tPXdWJMksmrR0kySlc7aIbZvdUt+ktrsTF8PLtzlnLf0r5MyGsABpNlbFzoY3X9aWAIllfVZWeuHZMuIZC0fN5yc3aOIhq6gOvvvPqH7ritghVHXYofHEsaE2jj/Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368930; c=relaxed/simple;
	bh=xr7vP+jSfK6pT9J/+yVYGZ0nrOrfHFnZ5PB9Egam4aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qni3a0ZbNhSDIhBbeC+ucVpEgsTeK7r3S97A3OycXARRO9IeJf6vcrq8Fa6OodcFOiQ3OmjRhws+uBjiz6ZRkS6TDg72+3NgewZR04YoxAQAg7WphjAJCONBZ+6V5XPZDAM479PdD4E2CxPoQuHPjkgy8CADltq9NM0hESdZovo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IViqpjlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IViqpjlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D682BC4CEE7;
	Mon, 13 Oct 2025 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368930;
	bh=xr7vP+jSfK6pT9J/+yVYGZ0nrOrfHFnZ5PB9Egam4aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IViqpjlbRKjtmiELR/ydUW4spQIRrMi5YZotth1nXm+26yHgM+U5yN86KZPJI1mQ+
	 hi9djNR0DIjcN4YlQpWONpuLZ8LBKogFW4DlT1j3rR8WkggTE4IiVwKssJd5jDcKIS
	 zQ5mCgSVJA4DvXSg5fQdEkEEklknUKOByJZxN5WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 069/563] irqchip/sg2042-msi: Fix broken affinity setting
Date: Mon, 13 Oct 2025 16:38:50 +0200
Message-ID: <20251013144413.791453540@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 9d8c41816bac518b4824f83b346ae30a1be83f68 ]

When using NVME on SG2044, the NVME drvier always complains about "I/O tag
XXX (XXX) QID XX timeout, completion polled", which is caused by the broken
affinity setting mechanism of the sg2042-msi driver.

The PLIC driver can only the set the affinity when enabled, but the
sg2042-msi driver invokes the affinity setter in disabled state, which
causes the change to be lost.

Cure this by implementing the irq_startup()/shutdown() callbacks, which
allow to startup (enabled) the underlying PLIC first.

Fixes: e96b93a97c90 ("irqchip/sg2042-msi: Add the Sophgo SG2044 MSI interrupt controller")
Reported-by: Han Gao <rabenda.cn@gmail.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Chen Wang <unicorn_wang@outlook.com> # Pioneerbox
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Link: https://lore.kernel.org/all/20250813232835.43458-4-inochiama@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sg2042-msi.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-sg2042-msi.c b/drivers/irqchip/irq-sg2042-msi.c
index bcfddc51bc6a1..2fd4d94f9bd76 100644
--- a/drivers/irqchip/irq-sg2042-msi.c
+++ b/drivers/irqchip/irq-sg2042-msi.c
@@ -85,6 +85,8 @@ static void sg2042_msi_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *m
 
 static const struct irq_chip sg2042_msi_middle_irq_chip = {
 	.name			= "SG2042 MSI",
+	.irq_startup		= irq_chip_startup_parent,
+	.irq_shutdown		= irq_chip_shutdown_parent,
 	.irq_ack		= sg2042_msi_irq_ack,
 	.irq_mask		= irq_chip_mask_parent,
 	.irq_unmask		= irq_chip_unmask_parent,
@@ -114,6 +116,8 @@ static void sg2044_msi_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *m
 
 static struct irq_chip sg2044_msi_middle_irq_chip = {
 	.name			= "SG2044 MSI",
+	.irq_startup		= irq_chip_startup_parent,
+	.irq_shutdown		= irq_chip_shutdown_parent,
 	.irq_ack		= sg2044_msi_irq_ack,
 	.irq_mask		= irq_chip_mask_parent,
 	.irq_unmask		= irq_chip_unmask_parent,
@@ -185,8 +189,10 @@ static const struct irq_domain_ops sg204x_msi_middle_domain_ops = {
 	.select	= msi_lib_irq_domain_select,
 };
 
-#define SG2042_MSI_FLAGS_REQUIRED (MSI_FLAG_USE_DEF_DOM_OPS |	\
-				   MSI_FLAG_USE_DEF_CHIP_OPS)
+#define SG2042_MSI_FLAGS_REQUIRED (MSI_FLAG_USE_DEF_DOM_OPS |		\
+				   MSI_FLAG_USE_DEF_CHIP_OPS |		\
+				   MSI_FLAG_PCI_MSI_MASK_PARENT |	\
+				   MSI_FLAG_PCI_MSI_STARTUP_PARENT)
 
 #define SG2042_MSI_FLAGS_SUPPORTED MSI_GENERIC_FLAGS_MASK
 
@@ -200,10 +206,12 @@ static const struct msi_parent_ops sg2042_msi_parent_ops = {
 	.init_dev_msi_info	= msi_lib_init_dev_msi_info,
 };
 
-#define SG2044_MSI_FLAGS_REQUIRED (MSI_FLAG_USE_DEF_DOM_OPS |	\
-				   MSI_FLAG_USE_DEF_CHIP_OPS)
+#define SG2044_MSI_FLAGS_REQUIRED (MSI_FLAG_USE_DEF_DOM_OPS |		\
+				   MSI_FLAG_USE_DEF_CHIP_OPS |		\
+				   MSI_FLAG_PCI_MSI_MASK_PARENT |	\
+				   MSI_FLAG_PCI_MSI_STARTUP_PARENT)
 
-#define SG2044_MSI_FLAGS_SUPPORTED (MSI_GENERIC_FLAGS_MASK |	\
+#define SG2044_MSI_FLAGS_SUPPORTED (MSI_GENERIC_FLAGS_MASK |		\
 				    MSI_FLAG_PCI_MSIX)
 
 static const struct msi_parent_ops sg2044_msi_parent_ops = {
-- 
2.51.0



