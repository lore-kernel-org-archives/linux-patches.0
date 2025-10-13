Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91FC30C37D;
	Mon, 13 Oct 2025 15:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368924; cv=none; b=c7mm1C5c4Vgv7O4mpo4DksfeEAYQR2ZS07CUg2buBK0O+socpF04958lZOhPKG8WygzOpuGHyQ2c8h+QRipTWbIKTvwEpRgSCO7HsiHEJi945nafMM7iqs7IiWlVgtwp+eu8I005rGQl3pOWc092v0vjzOyTBeBZ6vgp6W+o0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368924; c=relaxed/simple;
	bh=Ydgg+yZKId6TwdwmpgGdkVuTt7XuK65Wi89xuN9MsM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EavRWy4ke3vhU8BuSNvBQK/vjvPlY/t+F99UWUXNjqSygfb166wAIcCIJwHs77l0ym7PKR7qiRoZl4FgZptUjjMV93O98IVzFpu98P3n95WnwLkQQnVXqSsrUrywBVsNwzgl0EfTOmNcK0Ui28ECRzfYk3QVDdlkwSrnKV8k3x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBq8sq4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBq8sq4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E394C4CEE7;
	Mon, 13 Oct 2025 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368924;
	bh=Ydgg+yZKId6TwdwmpgGdkVuTt7XuK65Wi89xuN9MsM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBq8sq4HHQi7BlrHrRl5UpbcbtHf98WLGI7xS+8yrYx8sBheM411zvHGZoWcZA3qC
	 vWlSxoJ+UsDftwYh2q7ASQmC5ZficNeQOWhNUZV5un3KexyKZU9Ik/sqYd0abh5Lu7
	 eAADRdvFze5sQnsLID7DXR+6Tl2htPqh8JTIOfuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 067/563] genirq: Add irq_chip_(startup/shutdown)_parent()
Date: Mon, 13 Oct 2025 16:38:48 +0200
Message-ID: <20251013144413.715721024@linuxfoundation.org>
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

[ Upstream commit 7a721a2fee2bce01af26699a87739db8ca8ea3c8 ]

As the MSI controller on SG2044 uses PLIC as the underlying interrupt
controller, it needs to call irq_enable() and irq_disable() to
startup/shutdown interrupts. Otherwise, the MSI interrupt can not be
startup correctly and will not respond any incoming interrupt.

Introduce irq_chip_startup_parent() and irq_chip_shutdown_parent() to allow
the interrupt controller to call the irq_startup()/irq_shutdown() callbacks
of the parent interrupt chip.

In case the irq_startup()/irq_shutdown() callbacks are not implemented for
the parent interrupt chip, this will fallback to irq_chip_enable_parent()
or irq_chip_disable_parent().

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Chen Wang <unicorn_wang@outlook.com> # Pioneerbox
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Link: https://lore.kernel.org/all/20250813232835.43458-2-inochiama@gmail.com
Link: https://lore.kernel.org/lkml/20250722224513.22125-1-inochiama@gmail.com/
Stable-dep-of: 9d8c41816bac ("irqchip/sg2042-msi: Fix broken affinity setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq.h |  2 ++
 kernel/irq/chip.c   | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 1d6b606a81efe..890e1371f5d4c 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -669,6 +669,8 @@ extern int irq_chip_set_parent_state(struct irq_data *data,
 extern int irq_chip_get_parent_state(struct irq_data *data,
 				     enum irqchip_irq_state which,
 				     bool *state);
+extern void irq_chip_shutdown_parent(struct irq_data *data);
+extern unsigned int irq_chip_startup_parent(struct irq_data *data);
 extern void irq_chip_enable_parent(struct irq_data *data);
 extern void irq_chip_disable_parent(struct irq_data *data);
 extern void irq_chip_ack_parent(struct irq_data *data);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 0d0276378c707..3ffa0d80ddd19 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -1259,6 +1259,43 @@ int irq_chip_get_parent_state(struct irq_data *data,
 }
 EXPORT_SYMBOL_GPL(irq_chip_get_parent_state);
 
+/**
+ * irq_chip_shutdown_parent - Shutdown the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ *
+ * Invokes the irq_shutdown() callback of the parent if available or falls
+ * back to irq_chip_disable_parent().
+ */
+void irq_chip_shutdown_parent(struct irq_data *data)
+{
+	struct irq_data *parent = data->parent_data;
+
+	if (parent->chip->irq_shutdown)
+		parent->chip->irq_shutdown(parent);
+	else
+		irq_chip_disable_parent(data);
+}
+EXPORT_SYMBOL_GPL(irq_chip_shutdown_parent);
+
+/**
+ * irq_chip_startup_parent - Startup the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ *
+ * Invokes the irq_startup() callback of the parent if available or falls
+ * back to irq_chip_enable_parent().
+ */
+unsigned int irq_chip_startup_parent(struct irq_data *data)
+{
+	struct irq_data *parent = data->parent_data;
+
+	if (parent->chip->irq_startup)
+		return parent->chip->irq_startup(parent);
+
+	irq_chip_enable_parent(data);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_chip_startup_parent);
+
 /**
  * irq_chip_enable_parent - Enable the parent interrupt (defaults to unmask if
  * NULL)
-- 
2.51.0



