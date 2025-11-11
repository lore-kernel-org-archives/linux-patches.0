Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376B53126B9;
	Tue, 11 Nov 2025 01:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824530; cv=none; b=ojZ2xTkqUsZMxCwC6Zii1QWLMcuFdCRMD+FVrzR95Wf/zp75gsKXGe2x3JAc0gKSFGH3lECMRPtvl4hr/qI02Qzl0q5Vrm9d7T+w0hXrcdpLWr6Gmp7Q/RvRY5BTtJyI+K+PBXaBWOonzk+s2iMApTrE651+Pf2Wm2IyyXz6S7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824530; c=relaxed/simple;
	bh=e5BLSzHbe62B2yHgAACsx8uJnU+FAu/kTXZxZQ+aRjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHPJQYajPJZAg2rPlNa6HX96X/kMKk0OfGe428iOjB+og0cDNSxUcWEH8tCjyxsK4ahn42RwTaerlozrdSrLHnsnzAliq9fupN6PrMtgPojYSomwsZjCKzBXNZMZNAACVNqHLKl+UPVdZwWkQrTWRYesq6YM17rU7WR/uURdK7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BblwUibC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BblwUibC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8E1C113D0;
	Tue, 11 Nov 2025 01:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824530;
	bh=e5BLSzHbe62B2yHgAACsx8uJnU+FAu/kTXZxZQ+aRjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BblwUibCn4bohIe/V6PhO7j0oM9TJRlcbXRe7Bnk8HZoXot3w9XlzAgSodVio10UV
	 vI7K7OoJu1Bi/N2IcI91ZAGGChCUgFYSwREpbOqSzV4HFOdum93o4pZHZDcCOnUH0Y
	 3Ki1nxlzvquaHfjn73L5MAytVDwKtOgvpzJ/TW5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Farrah Chen <farrah.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 518/849] x86/virt/tdx: Use precalculated TDVPR page physical address
Date: Tue, 11 Nov 2025 09:41:28 +0900
Message-ID: <20251111004548.948549149@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Huang <kai.huang@intel.com>

[ Upstream commit e414b1005891d74bb0c3d27684c58dfbfbd1754b ]

All of the x86 KVM guest types (VMX, SEV and TDX) do some special context
tracking when entering guests. This means that the actual guest entry
sequence must be noinstr.

Part of entering a TDX guest is passing a physical address to the TDX
module. Right now, that physical address is stored as a 'struct page'
and converted to a physical address at guest entry. That page=>phys
conversion can be complicated, can vary greatly based on kernel
config, and it is definitely _not_ a noinstr path today.

There have been a number of tinkering approaches to try and fix this
up, but they all fall down due to some part of the page=>phys
conversion infrastructure not being noinstr friendly.

Precalculate the page=>phys conversion and store it in the existing
'tdx_vp' structure.  Use the new field at every site that needs a
tdvpr physical address. Remove the now redundant tdx_tdvpr_pa().
Remove the __flatten remnant from the tinkering.

Note that only one user of the new field is actually noinstr. All
others can use page_to_phys(). But, they might as well save the effort
since there is a pre-calculated value sitting there for them.

[ dhansen: rewrite all the text ]

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      |  9 +++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 21 ++++++++-------------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a698668..5e043961fb1d7 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -146,6 +146,8 @@ struct tdx_td {
 struct tdx_vp {
 	/* TDVP root page */
 	struct page *tdvpr_page;
+	/* precalculated page_to_phys(tdvpr_page) for use in noinstr code */
+	phys_addr_t tdvpr_pa;
 
 	/* TD vCPU control structure: */
 	struct page **tdcx_pages;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d91d9d6bb26c1..987c0eb10545c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -861,6 +861,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	if (tdx->vp.tdvpr_page) {
 		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
 		tdx->vp.tdvpr_page = 0;
+		tdx->vp.tdvpr_pa = 0;
 	}
 
 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
@@ -2940,6 +2941,13 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
 
+	/*
+	 * page_to_phys() does not work in 'noinstr' code, like guest
+	 * entry via tdh_vp_enter(). Precalculate and store it instead
+	 * of doing it at runtime later.
+	 */
+	tdx->vp.tdvpr_pa = page_to_phys(tdx->vp.tdvpr_page);
+
 	tdx->vp.tdcx_pages = kcalloc(kvm_tdx->td.tdcx_nr_pages, sizeof(*tdx->vp.tdcx_pages),
 			       	     GFP_KERNEL);
 	if (!tdx->vp.tdcx_pages) {
@@ -3002,6 +3010,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	if (tdx->vp.tdvpr_page)
 		__free_page(tdx->vp.tdvpr_page);
 	tdx->vp.tdvpr_page = 0;
+	tdx->vp.tdvpr_pa = 0;
 
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf5..9767b5821f4d8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1502,11 +1502,6 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_phys(td->tdr_page);
 }
 
-static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
-{
-	return page_to_phys(td->tdvpr_page);
-}
-
 /*
  * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
  * a CLFLUSH of pages is required before handing them to the TDX module.
@@ -1518,9 +1513,9 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
-noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
+noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 {
-	args->rcx = tdx_tdvpr_pa(td);
+	args->rcx = td->tdvpr_pa;
 
 	return __seamcall_saved_ret(TDH_VP_ENTER, args);
 }
@@ -1581,7 +1576,7 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 {
 	struct tdx_module_args args = {
 		.rcx = page_to_phys(tdcx_page),
-		.rdx = tdx_tdvpr_pa(vp),
+		.rdx = vp->tdvpr_pa,
 	};
 
 	tdx_clflush_page(tdcx_page);
@@ -1650,7 +1645,7 @@ EXPORT_SYMBOL_GPL(tdh_mng_create);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = tdx_tdr_pa(td),
 	};
 
@@ -1706,7 +1701,7 @@ EXPORT_SYMBOL_GPL(tdh_mr_finalize);
 u64 tdh_vp_flush(struct tdx_vp *vp)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 	};
 
 	return seamcall(TDH_VP_FLUSH, &args);
@@ -1752,7 +1747,7 @@ EXPORT_SYMBOL_GPL(tdh_mng_init);
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = field,
 	};
 	u64 ret;
@@ -1769,7 +1764,7 @@ EXPORT_SYMBOL_GPL(tdh_vp_rd);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = field,
 		.r8 = data,
 		.r9 = mask,
@@ -1782,7 +1777,7 @@ EXPORT_SYMBOL_GPL(tdh_vp_wr);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = initial_rcx,
 		.r8 = x2apicid,
 	};
-- 
2.51.0



