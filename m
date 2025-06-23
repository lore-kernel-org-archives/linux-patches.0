Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F375199FBA;
	Mon, 23 Jun 2025 22:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717294; cv=none; b=lTk8O7YFENvXUkzR9B0zGOM8R28uCcGEY5R/a+ziKOG8WOLESmeBvNVMMAKoLPCFPBgsvIrOLUp7PmEAZTCT730ey8y6+xxJBXVUetmcXEj2Lco+drFdJsX92lbkE9+FOeAmnuzNQU43qWbqV9v4wWGfQ3yscujTbm2yt+DPXmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717294; c=relaxed/simple;
	bh=vlTGuWSjRab+6LWgl27+YSqj1YZ0aBZNeejTxQtaQ70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlFlsNfOI5TXrcFEyT+uCEjY/ZXhp4zCw8F647gkeDI/O9PCsB1qZ3GMVXiXmKozqYDQ4G5I3T1IkOkmHOEwCLFFLIrpbPtvUitA7Ad19rXBV38ca3yzdRyDb2XIsmCmLxjuNYNTPI+/aJv4JfmECOhqSsn+n43Z7sGrYjVspgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDQtTCIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDQtTCIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24440C4CEEF;
	Mon, 23 Jun 2025 22:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717294;
	bh=vlTGuWSjRab+6LWgl27+YSqj1YZ0aBZNeejTxQtaQ70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDQtTCIiZy49f/iYRSRrl4hw+RsuPrVbk3BwSJgLY4lqz/IgLYyW6XsOYk9u3d0QV
	 7UoXKCNWjJ/2DYiuHLqDnxzqkpYQbYsGqk8XwfwnYm43vC8oKmXZ/H42WF5cnrnr2x
	 +rYFKrhhw8a06IauW7pIo/IRfvk5m28ooQujWX8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.12 317/414] x86/virt/tdx: Avoid indirect calls to TDX assembly functions
Date: Mon, 23 Jun 2025 15:07:34 +0200
Message-ID: <20250623130649.923695204@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -97,7 +97,7 @@ void tdx_init(void);
 
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
 


