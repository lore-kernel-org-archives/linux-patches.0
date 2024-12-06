Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D741474AF;
	Fri,  6 Dec 2024 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497510; cv=none; b=pbHhkTL8BaNoBWoq7hOnp6elwh+GfRILr5x5zPjhB4XbbSCZPUrRRe4Upo9LPrJ+fnkxmd1fht6wIT+qsgxOHtOhCJGIpo8DnFxjFb5EzUieaMRRtLSzTmh66hBJAfIvXVWeXKLNaYiWsxI+6ofgqW2pD+rnDv4GCSNcy11emIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497510; c=relaxed/simple;
	bh=NdQ+dcc9PvEud9yRSTVr7Tw0Fwxs03e4YrATzIyAoF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuC7sh0GGyUkyyQLcaX6C8s4G+KIb4gznh39TIKT78YR39+al2lvnWsRm/ZO+gIWf9ViLcKuwTcSR4WZo++lCiqwS7CVOM039Sb0qsDVJT9j6nRLOWBLkHmnZIPrFK23sL8ls8IWhniUy6bdceOR3Qa3CyCJWlVKcdp32PTSiJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suY4Remz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suY4Remz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27BDC4CED1;
	Fri,  6 Dec 2024 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497510;
	bh=NdQ+dcc9PvEud9yRSTVr7Tw0Fwxs03e4YrATzIyAoF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suY4Remz8sg59XoLeBHswYLiako905UttSSafxsr6GRdo9XVr0nlTN8322D76Sp+7
	 pMMVfbPlmliDFGd/SAX9thcDsOikQo8VBm9eZV5W6tFoFGBHVw2E9oMManD/OSbUEw
	 HL/xF+KeVQ17hdBcPmwvFui/OQFix1C1M4mWln4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 310/676] x86/tdx: Introduce wrappers to read and write TD metadata
Date: Fri,  6 Dec 2024 15:32:09 +0100
Message-ID: <20241206143705.449250439@linuxfoundation.org>
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

[ Upstream commit 5081e8fadb809253c911b349b01d87c5b4e3fec5 ]

The TDG_VM_WR TDCALL is used to ask the TDX module to change some
TD-specific VM configuration. There is currently only one user in the
kernel of this TDCALL leaf.  More will be added shortly.

Refactor to make way for more users of TDG_VM_WR who will need to modify
other TD configuration values.

Add a wrapper for the TDG_VM_RD TDCALL that requests TD-specific
metadata from the TDX module. There are currently no users for
TDG_VM_RD. Mark it as __maybe_unused until the first user appears.

This is preparation for enumeration and enabling optional TD features.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/all/20241104103803.195705-2-kirill.shutemov%40linux.intel.com
Stable-dep-of: f65aa0ad79fc ("x86/tdx: Dynamically disable SEPT violations from causing #VEs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdx.c           | 32 ++++++++++++++++++++++++++-----
 arch/x86/include/asm/shared/tdx.h |  1 +
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index d0d7a42230b84..0bb895344497e 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -74,6 +74,32 @@ static inline void tdcall(u64 fn, struct tdx_module_args *args)
 		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
 }
 
+/* Read TD-scoped metadata */
+static inline u64 __maybe_unused tdg_vm_rd(u64 field, u64 *value)
+{
+	struct tdx_module_args args = {
+		.rdx = field,
+	};
+	u64 ret;
+
+	ret = __tdcall_ret(TDG_VM_RD, &args);
+	*value = args.r8;
+
+	return ret;
+}
+
+/* Write TD-scoped metadata */
+static inline u64 tdg_vm_wr(u64 field, u64 value, u64 mask)
+{
+	struct tdx_module_args args = {
+		.rdx = field,
+		.r8 = value,
+		.r9 = mask,
+	};
+
+	return __tdcall(TDG_VM_WR, &args);
+}
+
 /**
  * tdx_mcall_get_report0() - Wrapper to get TDREPORT0 (a.k.a. TDREPORT
  *                           subtype 0) using TDG.MR.REPORT TDCALL.
@@ -767,10 +793,6 @@ static bool tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
 
 void __init tdx_early_init(void)
 {
-	struct tdx_module_args args = {
-		.rdx = TDCS_NOTIFY_ENABLES,
-		.r9 = -1ULL,
-	};
 	u64 cc_mask;
 	u32 eax, sig[3];
 
@@ -786,7 +808,7 @@ void __init tdx_early_init(void)
 	cc_set_mask(cc_mask);
 
 	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
-	tdcall(TDG_VM_WR, &args);
+	tdg_vm_wr(TDCS_NOTIFY_ENABLES, 0, -1ULL);
 
 	/*
 	 * All bits above GPA width are reserved and kernel treats shared bit
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 3606463ebf6fb..dfae78d2d4791 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -15,6 +15,7 @@
 #define TDG_VP_VEINFO_GET		3
 #define TDG_MR_REPORT			4
 #define TDG_MEM_PAGE_ACCEPT		6
+#define TDG_VM_RD			7
 #define TDG_VM_WR			8
 
 /* TDCS fields. To be used by TDG.VM.WR and TDG.VM.RD module calls */
-- 
2.43.0



