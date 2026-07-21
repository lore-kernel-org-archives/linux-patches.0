Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75164315D53;
	Tue, 21 Jul 2026 18:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659174; cv=none; b=sW4n4D2GhyRiQRE/0dl352DALUcTnT13aKmfmjeZy1svbRb54zIWdAnyY/RNPjy+pjA3ds/lCHBs/erN75nyfZrj1mcqGPRIlaXccf2+TkKWfgMJeuXIQe6rfkGT3woX4ph8mWcfb1R8HyvQt7V2Ih+vUYOQl0xP6rB7PI55heg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659174; c=relaxed/simple;
	bh=f807LDdF9oymeGEZkKTMkj8AlHalgF7OYaHvsvDDBUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoaXIBcNtCqPsLASxEeq7NG92SzUbO00rLShcrOGpgyJ07sMfIfBlBla5q79IhJ7EGBc4zHh5qPAO9fKEBfV5vAL2JuFItGfmGX84oaQgr0luRWuUcKODf81f6tN4Tplzjq1f/QrlMePoLbc0jMfA9DLGsloiCHxlgBeuxKrlqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVqUGSxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVqUGSxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03411F000E9;
	Tue, 21 Jul 2026 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659173;
	bh=ToOCX9xC3vawQ4XM8rGEN8HEorfnboRTZaAGu2t08WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVqUGSxTuAGVeUXDImWSn8dzL4DwatC08LGxM8ZHbwiiHbbj7lvS4YruvwTG8MmHJ
	 84X//w80zS6a2YaNx5OW4j+8IshjxCCXJXftKeSPewUJBjsKSwJtE3UF5tpv5ABxP8
	 46YlTIFjvgXHZ0vu1UvBHlHgyxUenpQX6I0Fetg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1420/1611] KVM: TDX: Account all non-transient page allocations for per-TD structures
Date: Tue, 21 Jul 2026 17:25:36 +0200
Message-ID: <20260721152547.377050466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit a8b2924676ec42d76597f849baba31acc3ba1bfc ]

Account all non-transient allocations associated with a single TD (or its
vCPUs), as KVM's ABI is that allocations that are active for the lifetime
of a VM are accounted.  Leave temporary allocations, i.e. allocations that
are freed within a single function/ioctl, unaccounted, to again align with
KVM's existing behavior, e.g. see commit dd103407ca31 ("KVM: X86: Remove
unnecessary GFP_KERNEL_ACCOUNT for temporary variables").

Fixes: 8d032b683c29 ("KVM: TDX: create/destroy VM structure")
Fixes: a50f673f25e0 ("KVM: TDX: Do TDX specific vcpu initialization")
Cc: stable@vger.kernel.org
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Link: https://patch.msgid.link/20260129011517.3545883-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ Binbin: Resolved conflicts in __tdx_td_init() due to lacking commits
  eac90a5ba0aa and 69050f8d6d07, retain nr_configured_hkid increment and
  kcalloc() call. ]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/tdx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d9ffc16dfefe61..7534397defa295 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2474,7 +2474,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 	atomic_inc(&nr_configured_hkid);
 
-	tdr_page = alloc_page(GFP_KERNEL);
+	tdr_page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!tdr_page)
 		goto free_hkid;
 
@@ -2482,12 +2482,12 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	/* TDVPS = TDVPR(4K page) + TDCX(multiple 4K pages), -1 for TDVPR. */
 	kvm_tdx->td.tdcx_nr_pages = tdx_sysinfo->td_ctrl.tdvps_base_size / PAGE_SIZE - 1;
 	tdcs_pages = kcalloc(kvm_tdx->td.tdcs_nr_pages, sizeof(*kvm_tdx->td.tdcs_pages),
-			     GFP_KERNEL);
+			     GFP_KERNEL_ACCOUNT);
 	if (!tdcs_pages)
 		goto free_tdr;
 
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		tdcs_pages[i] = alloc_page(GFP_KERNEL);
+		tdcs_pages[i] = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!tdcs_pages[i])
 			goto free_tdcs;
 	}
@@ -2937,7 +2937,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	int ret, i;
 	u64 err;
 
-	page = alloc_page(GFP_KERNEL);
+	page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!page)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
@@ -2950,14 +2950,14 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	tdx->vp.tdvpr_pa = page_to_phys(tdx->vp.tdvpr_page);
 
 	tdx->vp.tdcx_pages = kcalloc(kvm_tdx->td.tdcx_nr_pages, sizeof(*tdx->vp.tdcx_pages),
-			       	     GFP_KERNEL);
+				     GFP_KERNEL_ACCOUNT);
 	if (!tdx->vp.tdcx_pages) {
 		ret = -ENOMEM;
 		goto free_tdvpr;
 	}
 
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		page = alloc_page(GFP_KERNEL);
+		page = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!page) {
 			ret = -ENOMEM;
 			goto free_tdcx;
-- 
2.53.0



