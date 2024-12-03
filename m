Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985211F7063;
	Tue,  3 Dec 2024 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241458; cv=none; b=XpDnOfj9BfSGw/TS+evC1oSDyWvrRX1ye7s1llHanTIcaWdpyMdVoYmFmXyjTdPg6Mb1dN2XAayHMFqIbs+tEqK9IRy+UlqW1egA03u0CNBqz454g52aCjvCri9ChOGLlOcDdG8lOt6WOqR/YyjsVkFtlzcoq5Nn/V2DYR50ch4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241458; c=relaxed/simple;
	bh=qLDqp3exu06jfRzRMn8lltClrY2BrzUz7zGu7M+kdi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqbLT/QOG9D4d752+q7RfrZ4UJNoAdmN9qjBK/BzDFTndoqkqWcF4giX/yArnFFh5C3K8AsXjmQE76hAhppzGH/ZXR58SHQxPgp9v9Ep7le90deyBFYRxHoeWJ0IOatjo1hqvhzdL9zQXyntlKJUPLhGTX1wbZLJOlDdeZbydgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/SOmt2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/SOmt2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23208C4CECF;
	Tue,  3 Dec 2024 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241458;
	bh=qLDqp3exu06jfRzRMn8lltClrY2BrzUz7zGu7M+kdi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/SOmt2Cah59RqoTr7VVa7RWv/TDF+XXsbLd4rvgs83X2T+TpNdL7EPhwWqK4NgwB
	 G7ynZkZU72oMfY+cPPluOAV/PHjsFpDMJCnK4AqmWfuyEQraBNO7tMGuOFdhk9xVWk
	 OnNUqfVwnjNTLVAI7uBjzHzNIURhUUHnfRW4UwcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 425/826] x86/tdx: Dynamically disable SEPT violations from causing #VEs
Date: Tue,  3 Dec 2024 15:42:32 +0100
Message-ID: <20241203144800.341139924@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit f65aa0ad79fca4ace921da0701644f020129043d ]

Memory access #VEs are hard for Linux to handle in contexts like the
entry code or NMIs.  But other OSes need them for functionality.
There's a static (pre-guest-boot) way for a VMM to choose one or the
other.  But VMMs don't always know which OS they are booting, so they
choose to deliver those #VEs so the "other" OSes will work.  That,
unfortunately has left us in the lurch and exposed to these
hard-to-handle #VEs.

The TDX module has introduced a new feature. Even if the static
configuration is set to "send nasty #VEs", the kernel can dynamically
request that they be disabled. Once they are disabled, access to private
memory that is not in the Mapped state in the Secure-EPT (SEPT) will
result in an exit to the VMM rather than injecting a #VE.

Check if the feature is available and disable SEPT #VE if possible.

If the TD is allowed to disable/enable SEPT #VEs, the ATTR_SEPT_VE_DISABLE
attribute is no longer reliable. It reflects the initial state of the
control for the TD, but it will not be updated if someone (e.g. bootloader)
changes it before the kernel starts. Kernel must check TDCS_TD_CTLS bit to
determine if SEPT #VEs are enabled or disabled.

[ dhansen: remove 'return' at end of function ]

Fixes: 373e715e31bf ("x86/tdx: Panic on bad configs that #VE on "private" memory access")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/all/20241104103803.195705-4-kirill.shutemov%40linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdx.c           | 74 ++++++++++++++++++++++++-------
 arch/x86/include/asm/shared/tdx.h | 10 ++++-
 2 files changed, 67 insertions(+), 17 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 28b321a95a5e8..2f85ed005c42f 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -79,7 +79,7 @@ static inline void tdcall(u64 fn, struct tdx_module_args *args)
 }
 
 /* Read TD-scoped metadata */
-static inline u64 __maybe_unused tdg_vm_rd(u64 field, u64 *value)
+static inline u64 tdg_vm_rd(u64 field, u64 *value)
 {
 	struct tdx_module_args args = {
 		.rdx = field,
@@ -194,6 +194,60 @@ static void __noreturn tdx_panic(const char *msg)
 		__tdx_hypercall(&args);
 }
 
+/*
+ * The kernel cannot handle #VEs when accessing normal kernel memory. Ensure
+ * that no #VE will be delivered for accesses to TD-private memory.
+ *
+ * TDX 1.0 does not allow the guest to disable SEPT #VE on its own. The VMM
+ * controls if the guest will receive such #VE with TD attribute
+ * ATTR_SEPT_VE_DISABLE.
+ *
+ * Newer TDX modules allow the guest to control if it wants to receive SEPT
+ * violation #VEs.
+ *
+ * Check if the feature is available and disable SEPT #VE if possible.
+ *
+ * If the TD is allowed to disable/enable SEPT #VEs, the ATTR_SEPT_VE_DISABLE
+ * attribute is no longer reliable. It reflects the initial state of the
+ * control for the TD, but it will not be updated if someone (e.g. bootloader)
+ * changes it before the kernel starts. Kernel must check TDCS_TD_CTLS bit to
+ * determine if SEPT #VEs are enabled or disabled.
+ */
+static void disable_sept_ve(u64 td_attr)
+{
+	const char *msg = "TD misconfiguration: SEPT #VE has to be disabled";
+	bool debug = td_attr & ATTR_DEBUG;
+	u64 config, controls;
+
+	/* Is this TD allowed to disable SEPT #VE */
+	tdg_vm_rd(TDCS_CONFIG_FLAGS, &config);
+	if (!(config & TDCS_CONFIG_FLEXIBLE_PENDING_VE)) {
+		/* No SEPT #VE controls for the guest: check the attribute */
+		if (td_attr & ATTR_SEPT_VE_DISABLE)
+			return;
+
+		/* Relax SEPT_VE_DISABLE check for debug TD for backtraces */
+		if (debug)
+			pr_warn("%s\n", msg);
+		else
+			tdx_panic(msg);
+		return;
+	}
+
+	/* Check if SEPT #VE has been disabled before us */
+	tdg_vm_rd(TDCS_TD_CTLS, &controls);
+	if (controls & TD_CTLS_PENDING_VE_DISABLE)
+		return;
+
+	/* Keep #VEs enabled for splats in debugging environments */
+	if (debug)
+		return;
+
+	/* Disable SEPT #VEs */
+	tdg_vm_wr(TDCS_TD_CTLS, TD_CTLS_PENDING_VE_DISABLE,
+		  TD_CTLS_PENDING_VE_DISABLE);
+}
+
 static void tdx_setup(u64 *cc_mask)
 {
 	struct tdx_module_args args = {};
@@ -219,24 +273,12 @@ static void tdx_setup(u64 *cc_mask)
 	gpa_width = args.rcx & GENMASK(5, 0);
 	*cc_mask = BIT_ULL(gpa_width - 1);
 
+	td_attr = args.rdx;
+
 	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
 	tdg_vm_wr(TDCS_NOTIFY_ENABLES, 0, -1ULL);
 
-	/*
-	 * The kernel can not handle #VE's when accessing normal kernel
-	 * memory.  Ensure that no #VE will be delivered for accesses to
-	 * TD-private memory.  Only VMM-shared memory (MMIO) will #VE.
-	 */
-	td_attr = args.rdx;
-	if (!(td_attr & ATTR_SEPT_VE_DISABLE)) {
-		const char *msg = "TD misconfiguration: SEPT_VE_DISABLE attribute must be set.";
-
-		/* Relax SEPT_VE_DISABLE check for debug TD. */
-		if (td_attr & ATTR_DEBUG)
-			pr_warn("%s\n", msg);
-		else
-			tdx_panic(msg);
-	}
+	disable_sept_ve(td_attr);
 }
 
 /*
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 7e12cfa28bec9..fecb2a6e864be 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -19,9 +19,17 @@
 #define TDG_VM_RD			7
 #define TDG_VM_WR			8
 
-/* TDCS fields. To be used by TDG.VM.WR and TDG.VM.RD module calls */
+/* TDX TD-Scope Metadata. To be used by TDG.VM.WR and TDG.VM.RD */
+#define TDCS_CONFIG_FLAGS		0x1110000300000016
+#define TDCS_TD_CTLS			0x1110000300000017
 #define TDCS_NOTIFY_ENABLES		0x9100000000000010
 
+/* TDCS_CONFIG_FLAGS bits */
+#define TDCS_CONFIG_FLEXIBLE_PENDING_VE	BIT_ULL(1)
+
+/* TDCS_TD_CTLS bits */
+#define TD_CTLS_PENDING_VE_DISABLE	BIT_ULL(0)
+
 /* TDX hypercall Leaf IDs */
 #define TDVMCALL_MAP_GPA		0x10001
 #define TDVMCALL_GET_QUOTE		0x10002
-- 
2.43.0



