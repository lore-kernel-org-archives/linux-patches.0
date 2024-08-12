Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFF21494B8;
	Mon, 12 Aug 2024 16:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480607; cv=none; b=umrzduTo10PASQZZk4ZLWsqUjOg9gQUV7gvho//xTx9jn//R6TTtAeh2hecTf8WUU23HhnOyzN5iUpyQKId6v6i+jBCVF8GXuia68A4k+Z9793qlrv8QffwkmbZyy8lqbezu0TkgpTJYCwrCyrxYf/GKPdl1x4IQXml/jwc9uko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480607; c=relaxed/simple;
	bh=vhSjhNGIT7lmdxYAbd9X2TJLjpuZc/oizdtBY2FxHC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA8VD2AvTq4umSoj31CHQSYx67iFmaW7Bu7NLRzbMLWYSpiOOFXgB0KFTGjkFyiM5ziRNFAZLPICJf2P27nVNJV3iP746x1W0Y/Zq+UFQCFK2JJxevtk3JxyKNstukdYNl9+t9gxD/Q69uKdzyhfdzygpac1Aj0JEL+nerZyvPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmGoEqUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmGoEqUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D486C32782;
	Mon, 12 Aug 2024 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480606;
	bh=vhSjhNGIT7lmdxYAbd9X2TJLjpuZc/oizdtBY2FxHC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmGoEqUiP95wuI04eRrRU5X5v8wcd8CJ3GAbg664DrYc/Lbsy74x5Z8q/XiwRYww8
	 iWsM6GSignk6G86jzP5wq5bYUjkhUe7ajTVrzMa0RIakDHHGL+eA+wgSvhmlvmJru4
	 9KpLk2g5RgryWlCbKpHzSSIyPqiJbq1Mcxu85YDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vincent Chen <vincent.chen@sifive.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.10 220/263] irqchip/riscv-aplic: Retrigger MSI interrupt on source configuration
Date: Mon, 12 Aug 2024 18:03:41 +0200
Message-ID: <20240812160154.961495199@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

commit 03f9885c60adf73488fe32aab628ee3d4a39598e upstream.

The section 4.5.2 of the RISC-V AIA specification says that "any write
to a sourcecfg register of an APLIC might (or might not) cause the
corresponding interrupt-pending bit to be set to one if the rectified
input value is high (= 1) under the new source mode."

When the interrupt type is changed in the sourcecfg register, the APLIC
device might not set the corresponding pending bit, so the interrupt might
never become pending.

To handle sourcecfg register changes for level-triggered interrupts in MSI
mode, manually set the pending bit for retriggering interrupt so it gets
retriggered if it was already asserted.

Fixes: ca8df97fe679 ("irqchip/riscv-aplic: Add support for MSI-mode")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240809071049.2454-1-yongxuan.wang@sifive.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-riscv-aplic-msi.c | 32 +++++++++++++++++++++------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-aplic-msi.c b/drivers/irqchip/irq-riscv-aplic-msi.c
index 028444af48bd..d7773f76e5d0 100644
--- a/drivers/irqchip/irq-riscv-aplic-msi.c
+++ b/drivers/irqchip/irq-riscv-aplic-msi.c
@@ -32,15 +32,10 @@ static void aplic_msi_irq_unmask(struct irq_data *d)
 	aplic_irq_unmask(d);
 }
 
-static void aplic_msi_irq_eoi(struct irq_data *d)
+static void aplic_msi_irq_retrigger_level(struct irq_data *d)
 {
 	struct aplic_priv *priv = irq_data_get_irq_chip_data(d);
 
-	/*
-	 * EOI handling is required only for level-triggered interrupts
-	 * when APLIC is in MSI mode.
-	 */
-
 	switch (irqd_get_trigger_type(d)) {
 	case IRQ_TYPE_LEVEL_LOW:
 	case IRQ_TYPE_LEVEL_HIGH:
@@ -59,6 +54,29 @@ static void aplic_msi_irq_eoi(struct irq_data *d)
 	}
 }
 
+static void aplic_msi_irq_eoi(struct irq_data *d)
+{
+	/*
+	 * EOI handling is required only for level-triggered interrupts
+	 * when APLIC is in MSI mode.
+	 */
+	aplic_msi_irq_retrigger_level(d);
+}
+
+static int aplic_msi_irq_set_type(struct irq_data *d, unsigned int type)
+{
+	int rc = aplic_irq_set_type(d, type);
+
+	if (rc)
+		return rc;
+	/*
+	 * Updating sourcecfg register for level-triggered interrupts
+	 * requires interrupt retriggering when APLIC is in MSI mode.
+	 */
+	aplic_msi_irq_retrigger_level(d);
+	return 0;
+}
+
 static void aplic_msi_write_msg(struct irq_data *d, struct msi_msg *msg)
 {
 	unsigned int group_index, hart_index, guest_index, val;
@@ -130,7 +148,7 @@ static const struct msi_domain_template aplic_msi_template = {
 		.name			= "APLIC-MSI",
 		.irq_mask		= aplic_msi_irq_mask,
 		.irq_unmask		= aplic_msi_irq_unmask,
-		.irq_set_type		= aplic_irq_set_type,
+		.irq_set_type		= aplic_msi_irq_set_type,
 		.irq_eoi		= aplic_msi_irq_eoi,
 #ifdef CONFIG_SMP
 		.irq_set_affinity	= irq_chip_set_affinity_parent,
-- 
2.46.0



