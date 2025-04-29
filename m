Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F3A247291;
	Tue, 29 Apr 2025 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945574; cv=none; b=JgYNheDd+ZtJAgSeFAGylrt7yyEJW3RlYgk4+89G10abSTbBsThJ/ClLcAiUz5uIlnJIJJD1V1Q8JvJf38Q4YK62HzeenJhX18RC1SuCTsbmrmPoOl4MajjOF4SZY0DWrfJTKJUeHyrNtRffQT2oleXNE1eCVqwyzE11vyOq9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945574; c=relaxed/simple;
	bh=Ruq+zF/1mWmPfqPgPkaCbVgj5w2omGcA52QkM7UOrHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3scDAcuBV49qStuavcBqPuJwNDdT7FjZGTpzdiZ/nQU9dTeKJqbCkEE/Ng5jmZ0lXRfyNMOON2fEfRal9E0Fkks95JqVA8rel7nD0bS9+FpyD5C6GU0vbK5fNpcI1uyRigTdjrCrFX62XMe+ClBBvs8mlnVHdF1euLc1fXvpp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkyU+6oH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkyU+6oH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C08DC4CEE3;
	Tue, 29 Apr 2025 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945574;
	bh=Ruq+zF/1mWmPfqPgPkaCbVgj5w2omGcA52QkM7UOrHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkyU+6oHmWSYJmPuTczuDj8heUsN9jhUtIM828X0Lq+V/AJ/a3/iA3iDiVM6oEv1M
	 MZOo47QHhalRWORt+wsDCtlS2aa8lJM8uUx6JMwMIP+eNWlXBxYjCGtluew6AxqOoB
	 vW0INrwCONoQdTxgEiTkW1zLiHhSDD9FLo3uFstw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/179] MIPS: cm: Detect CM quirks from device tree
Date: Tue, 29 Apr 2025 18:41:40 +0200
Message-ID: <20250429161055.813048620@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit e27fbe16af5cfc40639de4ced67d1a866a1953e9 ]

Some information that should be retrieved at runtime for the Coherence
Manager can be either absent or wrong. This patch allows checking if
some of this information is available from the device tree and updates
the internal variable accordingly.

For now, only the compatible string associated with the broken HCI is
being retrieved.

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mips-cm.h | 22 ++++++++++++++++++++++
 arch/mips/kernel/mips-cm.c      | 14 ++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/arch/mips/include/asm/mips-cm.h b/arch/mips/include/asm/mips-cm.h
index 696b40beb774f..0f31324998c0a 100644
--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -47,6 +47,16 @@ extern phys_addr_t __mips_cm_phys_base(void);
  */
 extern int mips_cm_is64;
 
+/*
+ * mips_cm_is_l2_hci_broken  - determine if HCI is broken
+ *
+ * Some CM reports show that Hardware Cache Initialization is
+ * complete, but in reality it's not the case. They also incorrectly
+ * indicate that Hardware Cache Initialization is supported. This
+ * flags allows warning about this broken feature.
+ */
+extern bool mips_cm_is_l2_hci_broken;
+
 /**
  * mips_cm_error_report - Report CM cache errors
  */
@@ -85,6 +95,18 @@ static inline bool mips_cm_present(void)
 #endif
 }
 
+/**
+ * mips_cm_update_property - update property from the device tree
+ *
+ * Retrieve the properties from the device tree if a CM node exist and
+ * update the internal variable based on this.
+ */
+#ifdef CONFIG_MIPS_CM
+extern void mips_cm_update_property(void);
+#else
+static void mips_cm_update_property(void) {}
+#endif
+
 /**
  * mips_cm_has_l2sync - determine whether an L2-only sync region is present
  *
diff --git a/arch/mips/kernel/mips-cm.c b/arch/mips/kernel/mips-cm.c
index 611ef512c0b81..159354ac9335b 100644
--- a/arch/mips/kernel/mips-cm.c
+++ b/arch/mips/kernel/mips-cm.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/of.h>
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 
@@ -14,6 +15,7 @@
 void __iomem *mips_gcr_base;
 void __iomem *mips_cm_l2sync_base;
 int mips_cm_is64;
+bool mips_cm_is_l2_hci_broken;
 
 static char *cm2_tr[8] = {
 	"mem",	"gcr",	"gic",	"mmio",
@@ -196,6 +198,18 @@ static void mips_cm_probe_l2sync(void)
 	mips_cm_l2sync_base = ioremap_nocache(addr, MIPS_CM_L2SYNC_SIZE);
 }
 
+void mips_cm_update_property(void)
+{
+	struct device_node *cm_node;
+
+	cm_node = of_find_compatible_node(of_root, NULL, "mobileye,eyeq6-cm");
+	if (!cm_node)
+		return;
+	pr_info("HCI (Hardware Cache Init for the L2 cache) in GCR_L2_RAM_CONFIG from the CM3 is broken");
+	mips_cm_is_l2_hci_broken = true;
+	of_node_put(cm_node);
+}
+
 int mips_cm_probe(void)
 {
 	phys_addr_t addr;
-- 
2.39.5



