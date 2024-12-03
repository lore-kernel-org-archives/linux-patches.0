Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB42D7BF;
	Tue,  3 Dec 2024 15:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239014; cv=none; b=cQ1GTFZWD9TEkLoijHXKFQL5/GumCn+PFMxRiwEOQ3vidfZi8CfX/SIjbciC7r6PYyEtfrrWKn/O1ABcSsh+pZWsq9iFHDI4fUYFAiDdrYC07PuSFo0IpkVnUNec2bV6CQDXMk9MiNxaUZBQ+U9HuSh5h0fQ4nGhlKYGbYR0wjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239014; c=relaxed/simple;
	bh=mdd7uhlHeB9cufuZuyNp4lZ0szW4IsQYE4XWi2o0g/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4esQ6pQ+AJchk3MFwc7cvsGKsVGzaNT7dvq1FTI91fNOVQkbyXrZsa1uYTgbj3nOa/7aTyVKOuJS6UI7Otvi/vwANDpwXx4SEQOwsO3Cc8EFekChQyih1fzso7EZaDJ/oKuvAKoM5aFA2GqztQhDnzy7+XJp3kJH65mamUQeiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfoHkI6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfoHkI6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC16C4CECF;
	Tue,  3 Dec 2024 15:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239013;
	bh=mdd7uhlHeB9cufuZuyNp4lZ0szW4IsQYE4XWi2o0g/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfoHkI6KmSeW2zDdrjv+Ssikfc2DlEidgIiyVWo/AlTHkDF1sQKtra4iOvImXJDGz
	 N+Ut/js8aYEXoosnGUGcuBtIqJKvNtugZdxcQ9Lt9dGkegihZEX6/sIxpvgdlKoEy6
	 KzWHNIAEMnTyYctkwH3tjnhvEqKfWh8kYRYMZfj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 443/817] x86/tdx: Introduce wrappers to read and write TD metadata
Date: Tue,  3 Dec 2024 15:40:15 +0100
Message-ID: <20241203144013.172307784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 327c45c5013fe..c74bb9e7d7a35 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -78,6 +78,32 @@ static inline void tdcall(u64 fn, struct tdx_module_args *args)
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
@@ -929,10 +955,6 @@ static void tdx_kexec_finish(void)
 
 void __init tdx_early_init(void)
 {
-	struct tdx_module_args args = {
-		.rdx = TDCS_NOTIFY_ENABLES,
-		.r9 = -1ULL,
-	};
 	u64 cc_mask;
 	u32 eax, sig[3];
 
@@ -951,7 +973,7 @@ void __init tdx_early_init(void)
 	cc_set_mask(cc_mask);
 
 	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
-	tdcall(TDG_VM_WR, &args);
+	tdg_vm_wr(TDCS_NOTIFY_ENABLES, 0, -1ULL);
 
 	/*
 	 * All bits above GPA width are reserved and kernel treats shared bit
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index fdfd41511b021..7e12cfa28bec9 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -16,6 +16,7 @@
 #define TDG_VP_VEINFO_GET		3
 #define TDG_MR_REPORT			4
 #define TDG_MEM_PAGE_ACCEPT		6
+#define TDG_VM_RD			7
 #define TDG_VM_WR			8
 
 /* TDCS fields. To be used by TDG.VM.WR and TDG.VM.RD module calls */
-- 
2.43.0



