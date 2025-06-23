Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC365222576;
	Mon, 23 Jun 2025 21:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715720; cv=none; b=AU2bm1yLBNx7amSxSft0PFJe4Qx50bd41nZVqFQn7C2RCIKmkttKBqTW+0lAALP6W5L8/mxUuNPVi77iQGs8/qyZRpta5ZqFjUfJOu2vCM6ZSK8sb7S6+So5fFg7raEiHa7w/ogZ9uCWysKZMBKZJfrWySZO0FTcNye2V82V3PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715720; c=relaxed/simple;
	bh=kexV3X6pYpyq4KcIHXnBiWEwykoBYLvgUBO8Zpgoq2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLb1sTjJqJNSh3btMfRZULJUWT0zXtTecrx+DCDZogWFFjTtlsOd38hn5mS6Dh/3izBHjgubJRhtZDsYYrE81xq/EkfesiDQJwwvC9be/whXDmPKVWJwKOchDVhDFb2d5J4BL8tgVIbdYUrC0uzJdbVyGq+gYgB6/5SV7Utnp3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9pKhNXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9pKhNXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CE8C4CEEA;
	Mon, 23 Jun 2025 21:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715719;
	bh=kexV3X6pYpyq4KcIHXnBiWEwykoBYLvgUBO8Zpgoq2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9pKhNXXIHV/z8SsLZ/KZsy9dOGeOFlcsk84oQ78bj5NmnA5ZCqoG+nsgCP4uJnS7
	 uGLP0HUtzrIHwCBe0pHVS0uEFl2lQkI5fJkmwOxBcC0gS9vMXwxZZZkgmvi6+Pryb+
	 o3sClibE0b1zyRpAXe8nfy6IJzCGQ7tC3y4xxKxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.15 476/592] x86/virt/tdx: Avoid indirect calls to TDX assembly functions
Date: Mon, 23 Jun 2025 15:07:14 +0200
Message-ID: <20250623130711.755612039@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Huang <kai.huang@intel.com>

commit 0b3bc018e86afdc0cbfef61328c63d5c08f8b370 upstream.

Two 'static inline' TDX helper functions (sc_retry() and
sc_retry_prerr()) take function pointer arguments which refer to
assembly functions.  Normally, the compiler inlines the TDX helper,
realizes that the function pointer targets are completely static --
thus can be resolved at compile time -- and generates direct call
instructions.

But, other times (like when CONFIG_CC_OPTIMIZE_FOR_SIZE=y), the
compiler declines to inline the helpers and will instead generate
indirect call instructions.

Indirect calls to assembly functions require special annotation (for
various Control Flow Integrity mechanisms).  But TDX assembly
functions lack the special annotations and can only be called
directly.

Annotate both the helpers as '__always_inline' to prod the compiler
into maintaining the direct calls. There is no guarantee here, but
Peter has volunteered to report the compiler bug if this assumption
ever breaks[1].

Fixes: 1e66a7e27539 ("x86/virt/tdx: Handle SEAMCALL no entropy error in common code")
Fixes: df01f5ae07dd ("x86/virt/tdx: Add SEAMCALL error printing for module initialization")
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/20250605145914.GW39944@noisy.programming.kicks-ass.net/ [1]
Link: https://lore.kernel.org/all/20250606130737.30713-1-kai.huang%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/tdx.h  |    2 +-
 arch/x86/virt/vmx/tdx/tdx.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -100,7 +100,7 @@ void tdx_init(void);
 
 typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
 
-static inline u64 sc_retry(sc_func_t func, u64 fn,
+static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 			   struct tdx_module_args *args)
 {
 	int retry = RDRAND_RETRY_LOOPS;
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -69,8 +69,9 @@ static inline void seamcall_err_ret(u64
 			args->r9, args->r10, args->r11);
 }
 
-static inline int sc_retry_prerr(sc_func_t func, sc_err_func_t err_func,
-				 u64 fn, struct tdx_module_args *args)
+static __always_inline int sc_retry_prerr(sc_func_t func,
+					  sc_err_func_t err_func,
+					  u64 fn, struct tdx_module_args *args)
 {
 	u64 sret = sc_retry(func, fn, args);
 


