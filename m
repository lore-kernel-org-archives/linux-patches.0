Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28B538C41E;
	Mon, 23 Mar 2026 14:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275223; cv=none; b=Y4GhcBoCFTHtqrn3HfcwA8/7F96cg/Oj7CykohWPYW8+ualI1U2hPVxyEpETZH2BShWo+Ganf2qM/nlMn8VW7/sMTyQJQ0Z38+LwfKh7iqg29Y8yT1Z9Z2W0wa+pXG8vVOwLWrSCNEHjMymxCovGCKiPV5teTF4SzA/RwTVxsJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275223; c=relaxed/simple;
	bh=hbQQazYbllQ1E9UEnDbJeFXTr0rAIPJGJeMg6EJJTOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiTEi8VJJBaBrptYXsgod9xjvtjcykQjc4MHuoST39BblQCHncICzfzwZAaxVEKSz1VVtS0iY+TyEQ8f1/t7luqG6HsNyj2/g2AbvDVczD/JwbcM8NmXRiT9zl7Km0KJwCThhxMeFW1bu3KWgOj9MKtIcTZQQr3WsmIxaK4MdbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqiAR50T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqiAR50T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8EFC4CEF7;
	Mon, 23 Mar 2026 14:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275222;
	bh=hbQQazYbllQ1E9UEnDbJeFXTr0rAIPJGJeMg6EJJTOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqiAR50TTWJ3xUJbOfzTGXHZXXZP0YdIS0AWTKRJMFM9vqYRSRKC2OjT+kDAuh2y7
	 LefuiJV34r+1UuZNXAQD2CgoZBQi68VZz8GaTNFUYRtsvBiBlvcXd3WJ08YaQKD4aN
	 /fh0rTcqkkDy4TEexiIvLqKUjcyK2pLwLu9cMGlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Collins <bcollins@kernel.org>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/460] kexec: Include kernel-end even without crashkernel
Date: Mon, 23 Mar 2026 14:40:14 +0100
Message-ID: <20260323134527.108173045@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Ben Collins <bcollins@kernel.org>

[ Upstream commit 38c64dfe0af12778953846df5f259e913275cfe5 ]

Certain versions of kexec don't even work without kernel-end being
added to the device-tree. Add it even if crash-kernel is disabled.

Signed-off-by: Ben Collins <bcollins@kernel.org>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/2025042122-inescapable-mandrill-8a5ff2@boujee-and-buff
Stable-dep-of: 20197b967a6a ("powerpc/kexec/core: use big-endian types for crash variables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/core.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
index 58a930a47422b..50e7cf4b992b1 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -22,6 +22,8 @@
 #include <asm/setup.h>
 #include <asm/firmware.h>
 
+#define cpu_to_be_ulong __PASTE(cpu_to_be, BITS_PER_LONG)
+
 #ifdef CONFIG_CRASH_DUMP
 void machine_crash_shutdown(struct pt_regs *regs)
 {
@@ -156,17 +158,10 @@ int __init overlaps_crashkernel(unsigned long start, unsigned long size)
 }
 
 /* Values we need to export to the second kernel via the device tree. */
-static phys_addr_t kernel_end;
 static phys_addr_t crashk_base;
 static phys_addr_t crashk_size;
 static unsigned long long mem_limit;
 
-static struct property kernel_end_prop = {
-	.name = "linux,kernel-end",
-	.length = sizeof(phys_addr_t),
-	.value = &kernel_end,
-};
-
 static struct property crashk_base_prop = {
 	.name = "linux,crashkernel-base",
 	.length = sizeof(phys_addr_t),
@@ -185,8 +180,6 @@ static struct property memory_limit_prop = {
 	.value = &mem_limit,
 };
 
-#define cpu_to_be_ulong	__PASTE(cpu_to_be, BITS_PER_LONG)
-
 static void __init export_crashk_values(struct device_node *node)
 {
 	/* There might be existing crash kernel properties, but we can't
@@ -210,6 +203,15 @@ static void __init export_crashk_values(struct device_node *node)
 	mem_limit = cpu_to_be_ulong(memory_limit);
 	of_update_property(node, &memory_limit_prop);
 }
+#endif /* CONFIG_CRASH_RESERVE */
+
+static phys_addr_t kernel_end;
+
+static struct property kernel_end_prop = {
+	.name = "linux,kernel-end",
+	.length = sizeof(phys_addr_t),
+	.value = &kernel_end,
+};
 
 static int __init kexec_setup(void)
 {
@@ -220,16 +222,17 @@ static int __init kexec_setup(void)
 		return -ENOENT;
 
 	/* remove any stale properties so ours can be found */
-	of_remove_property(node, of_find_property(node, kernel_end_prop.name, NULL));
+	of_remove_property(node, of_find_property(node, kernel_end_prop.name,
+						  NULL));
 
 	/* information needed by userspace when using default_machine_kexec */
 	kernel_end = cpu_to_be_ulong(__pa(_end));
 	of_add_property(node, &kernel_end_prop);
 
+#ifdef CONFIG_CRASH_RESERVE
 	export_crashk_values(node);
-
+#endif
 	of_node_put(node);
 	return 0;
 }
 late_initcall(kexec_setup);
-#endif /* CONFIG_CRASH_RESERVE */
-- 
2.51.0



