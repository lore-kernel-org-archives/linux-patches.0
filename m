Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3AB148314;
	Fri,  6 Dec 2024 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497657; cv=none; b=SocPiXmLfIDGl3Wjo9VCw13XZyZFK+JrxpQ/ynP3jcgnPcseHDC1qTUPREY60nlh0lHOos8hj6Qgpa10izjEiQIze/nOzzyaCviu9EjsxUAl4YZxNBgPVTZICzsQyXGcIkt2KgbQsV2pxIn9DG7URQ6fdlYzeYbRyLZkN6/YOhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497657; c=relaxed/simple;
	bh=AcK6XSKMuKiLwMoBUBTDoRIhkI+unKhigDzpP08fC8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUj8LqSjV6cUboN4VUeyrmIE0kZthcQr8g1vSOeEm0GvtOEKqNAV9c6R81xIQO0OHP/1P8YP98cJju5DL4RHQNCUcsAJwnf4OtKOZXOguQ7EN/S7EA1oK54su+fTr2K2kkfdRq+raPU0xTdG/0cJJjnCaHk+zFO9AYaQBiBHkhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKDxxWvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKDxxWvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7917C4CED1;
	Fri,  6 Dec 2024 15:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497657;
	bh=AcK6XSKMuKiLwMoBUBTDoRIhkI+unKhigDzpP08fC8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKDxxWvMMLPBmYePqUx6gNXrwAj7oele2dMOp2eUd9BiIVxtM/d/sOqXcDFTIjRt2
	 7IHvJZORDq+pS4N9lFOcfTAtByUG37bml+YiqgFwAg86Dtr2vmBjEzreYlFigNnMr6
	 IhtoRa2Yi3v1eyzx8ylEly2XfezMH6j6ObU/bI2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 312/676] x86/tdx: Dynamically disable SEPT violations from causing #VEs
Date: Fri,  6 Dec 2024 15:32:11 +0100
Message-ID: <20241206143705.525416699@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index de4ff833fcf00..2f67e196a2ead 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -75,7 +75,7 @@ static inline void tdcall(u64 fn, struct tdx_module_args *args)
 }
 
 /* Read TD-scoped metadata */
-static inline u64 __maybe_unused tdg_vm_rd(u64 field, u64 *value)
+static inline u64 tdg_vm_rd(u64 field, u64 *value)
 {
 	struct tdx_module_args args = {
 		.rdx = field,
@@ -169,6 +169,60 @@ static void __noreturn tdx_panic(const char *msg)
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
@@ -194,24 +248,12 @@ static void tdx_setup(u64 *cc_mask)
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
index dfae78d2d4791..aed99fb099d9c 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -18,9 +18,17 @@
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
 #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
-- 
2.43.0



