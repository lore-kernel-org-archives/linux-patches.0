Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AAF31717E;
	Thu, 16 Jul 2026 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210157; cv=none; b=LSWdjtAfWHpkzdEb70zQhzM+yIk8NhwPegjSqw/YGyb4mK6QI04jx0vUxwSI9Ic8QdYbWNLvZPex2cuLQztvZBv065cBNdsj31KDGSWyuC/xLfhu2JLQb8sGZ5biX2d0LPTCA0+T4vUXbEvJZJOW8nUZhjvUqfdCnHVt0vXIc5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210157; c=relaxed/simple;
	bh=YbpGH5Sa/fwM4N/GxOT3koiqD5wNOxPUjtDAaFaGwQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGahkjassVJMYtqLofbZRm7qTruFKYzgntK/BwNR1IenK9gWPab2J1CNmQoMHrcTAuGB+2AoNRZLqQ9fataTHgoZH8X/4rBzdjYpCdEvXoaYu/ffOW6diYg/u5J0HaX15Pl6hkWuu/hU39u/BVyRvyBGiHfoOufzOAkzR1nti3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTQUXrrO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTQUXrrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE281F000E9;
	Thu, 16 Jul 2026 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210156;
	bh=T0R91PFh6yOfy4obe55AawY0lTKqHGPHRi7QcdnCaZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTQUXrrOPAVLXldYVyzYinQ2CmReVTftGhURaRkUfxpadSA4Z1WcMLf77Rx23vwDU
	 +eyJynHtqR9ZX+Xvv9AEsB0SImr66uOxcVh3L4PQ97ieZtzZVl7BsS1S1QtCXx7zEl
	 m+PO287E0hKirZOMZuKUHdmPzZGvzl0AXHI5G49c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 460/518] KVM: TDX: Account all non-transient page allocations for per-TD structures
Date: Thu, 16 Jul 2026 15:32:08 +0200
Message-ID: <20260716133057.910544946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit a8b2924676ec42d76597f849baba31acc3ba1bfc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2387,20 +2387,20 @@ static int __tdx_td_init(struct kvm *kvm
 
 	ret = -ENOMEM;
 
-	tdr_page = alloc_page(GFP_KERNEL);
+	tdr_page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!tdr_page)
 		goto free_hkid;
 
 	kvm_tdx->td.tdcs_nr_pages = tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
 	/* TDVPS = TDVPR(4K page) + TDCX(multiple 4K pages), -1 for TDVPR. */
 	kvm_tdx->td.tdcx_nr_pages = tdx_sysinfo->td_ctrl.tdvps_base_size / PAGE_SIZE - 1;
-	tdcs_pages = kzalloc_objs(*kvm_tdx->td.tdcs_pages,
-				  kvm_tdx->td.tdcs_nr_pages);
+	tdcs_pages = kzalloc_objs(*kvm_tdx->td.tdcs_pages, kvm_tdx->td.tdcs_nr_pages,
+				  GFP_KERNEL_ACCOUNT);
 	if (!tdcs_pages)
 		goto free_tdr;
 
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		tdcs_pages[i] = alloc_page(GFP_KERNEL);
+		tdcs_pages[i] = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!tdcs_pages[i])
 			goto free_tdcs;
 	}
@@ -2875,7 +2875,7 @@ static int tdx_td_vcpu_init(struct kvm_v
 	int ret, i;
 	u64 err;
 
-	page = alloc_page(GFP_KERNEL);
+	page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!page)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
@@ -2888,14 +2888,14 @@ static int tdx_td_vcpu_init(struct kvm_v
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


