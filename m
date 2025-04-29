Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E7524A067;
	Tue, 29 Apr 2025 17:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946200; cv=none; b=UKkv5Qc0C8DRYWGAYCMOs4XnDJuTkbuTggpn+Hvtn47djqSyUQui7Nr9znkvmbSw0IIiWQVqvDpTL5rlzSY+zKPk5pH7TqdFf7F0t434eRGGOFl2qqFQn993IWEM99neYAfJiUhxELvEFTcjrGqn9i340HFGrNX+XV0VO3xrGSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946200; c=relaxed/simple;
	bh=jT9glb1yMrHJe1vyehPxi4WMARJBRZf6g7JbWc1WqJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xb21S5Kl6lkfzZSP7qP/vfCsYnzTQwEsdPFyPzy91Jtks/HR6XmshBT4gsby1T4CupKHbBMVjeGdNRY7AeGq2kNG+rkeVTQxdUPzx5wrxXWwDdDG2722jAj29c44BS3+7D1n9rqwt1YGp3hMQwLys4ReX9I68+v1cx9/wmrghpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnMiV97G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnMiV97G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BB3C4CEE3;
	Tue, 29 Apr 2025 17:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946200;
	bh=jT9glb1yMrHJe1vyehPxi4WMARJBRZf6g7JbWc1WqJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnMiV97G870jtOMWCYr2KJ6FB0w0tqJXEFpU3kCQ2cpPSh7OXnLOHFsF9/VKpdd23
	 u4OYGnH1APXDGeiF+oCt9bU8V6+h2Rc4meEH3yV6LkSDk6njH81S5NWTA9rCxYCTWX
	 T7DUSRNbvfhQ02qA63D+2thbwxuy0ZMkYn+AJBbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 181/311] MIPS: cm: Detect CM quirks from device tree
Date: Tue, 29 Apr 2025 18:40:18 +0200
Message-ID: <20250429161128.436557660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 23ce951f445bb..754e96dba256c 100644
--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -59,6 +59,16 @@ extern phys_addr_t mips_cm_l2sync_phys_base(void);
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
@@ -97,6 +107,18 @@ static inline bool mips_cm_present(void)
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
index 3eb2cfb893e19..9cfabaa94d010 100644
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
@@ -237,6 +239,18 @@ static void mips_cm_probe_l2sync(void)
 	mips_cm_l2sync_base = ioremap(addr, MIPS_CM_L2SYNC_SIZE);
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



