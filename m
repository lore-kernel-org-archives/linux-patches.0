Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521693B52EE;
	Thu, 30 Jul 2026 15:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427065; cv=none; b=HvlSzvslCtSn017rndjWFlHgva6Z47V1ZnOImrJV0eP8X9Jdp+KQYE5BBaPyBjmzX3D3sm8ZVSywpaXSkSStII1MtMm5bzWxMGuIKHEva2dMrYa8g+ozlipARAVoEASX2TuZ3RM3Fw0oAg/uU3nUV6enxZtR2q/briF182oy0dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427065; c=relaxed/simple;
	bh=Us+Ta+NSl+LPBtyzry9PM6+lkI0X3Y4lUZVqZhW4G1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6auj/KwDMhK6dwUFUB9gbF7b62AVWrw0nYrY6+L6JSRoDquEFypVtllk4i5OfEgBTevU/2R32uGOeXOvpG7lEdGdP+LqvNc9kWdO7RtS/9i1q0vP9sWG4Gf1Vz1RNe1/3kl/BlNGqjB+dj5tcwDHOxXxxj6r7JZx1Lz7gHtspc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgJNhMK0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgJNhMK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA9B1F000E9;
	Thu, 30 Jul 2026 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427064;
	bh=Jb2FXDD45C7dFeXLufDFwWPpex9+51D3eGf409YF+mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgJNhMK0Gd33zT1V+oI0VTqLdNsUAJY8rRjBZy2VgyUeT8G+84wBzfY7rjH8UnfKE
	 og0iYuRag1nUkKY/UsVx2TNmTGq0raeMk/PnN9Ymnpacx7MXLXz5S83/nxLxxOi4Dv
	 xDdR5eqLPpN8tvgXcZoiHCXiHp2+1qcT2gFhKPKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 010/484] KVM: x86: Check for invalid/obsolete root *after* making MMU pages available
Date: Thu, 30 Jul 2026 16:08:27 +0200
Message-ID: <20260730141423.630830561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 2abd5287f08319fa35764566b15c6e22cb1068db upstream.

Check for a "stale" page fault, i.e. for an invalid and/or obsolete root,
after making MMU pages available for the shadow MMU.  If reclaiming shadow
pages zaps an in-use root, i.e. marks it invalid, then KVM will attempt to
map memory into an invalid root.  On its own, populating an invalid root is
"fine", but because child shadow pages inherit their parent's role, any
children created during the map/fetch will be created as invalid pages,
thus violating KVM's invariant that invalid pages are never on the list of
active MMU pages.

Note, the underlying flaw has existed since KVM first started tracking
invalid roots in 2008 (commit 2e53d63acba7, "KVM: MMU: ignore zapped root
pagetables"), but the true badness only came along in 2020 (Linux 5.9)
with the invariant that invalid shadow pages can't be on the list of
active pages.

Note #2, inheriting role.invalid when creating child shadow pages is also
far from ideal; that flaw will be addressed separately.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Fixes: f95eec9bed76 ("KVM: x86/mmu: Don't put invalid SPs back on the list of active pages")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c         |    9 +++++----
 arch/x86/kvm/mmu/paging_tmpl.h |   10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4384,16 +4384,17 @@ static int direct_page_fault(struct kvm_
 
 	orig_pfn = fault->pfn;
 
-	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
-
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 
+	if (is_page_fault_stale(vcpu, fault)) {
+		r = RET_PF_RETRY;
+		goto out_unlock;
+	}
+
 	r = direct_map(vcpu, fault);
 
 out_unlock:
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -838,15 +838,17 @@ static int FNAME(page_fault)(struct kvm_
 
 	orig_pfn = fault->pfn;
 
-	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
-
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
+
+	if (is_page_fault_stale(vcpu, fault)) {
+		r = RET_PF_RETRY;
+		goto out_unlock;
+	}
+
 	r = FNAME(fetch)(vcpu, fault, &walker);
 
 out_unlock:


