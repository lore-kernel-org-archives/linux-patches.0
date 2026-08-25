Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099574749C1;
	Tue, 25 Aug 2026 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666257; cv=none; b=myyQa5xeyRr5muR6svX7x25YKRWIi2u7SVUhdyjp8THCRmJUUj5uBKH2BK0U4aDJKqm3ZRsVMVZymgRuptp5jl37tWbBz2jCmfQcQnnl3PhIVyDmuVGKmvGvWd0n40042XPpO5wNAjrfeW7LCPVBZLxusS7ZuxFhvjA0grzELI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666257; c=relaxed/simple;
	bh=y4P6QFOMQn3q2Ft03K8oAAFjGU6xNzMg+71o64S6u4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJfxzzTRNvPcvQSC4tLITINX1DqzkeEPRKr+QOZfowLEgVi+mkpVmvAVBy7rqqwWWCOnmEM/fyCAut+evsKbngpRKngWMTOFHFBZr+6gseYdAjMDUrw6aEoWbVb3jpdH31Mqc9XH66Yxw4785VfL7lCFUAH4qh5QlCEU0Yx5bJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMnrmoP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMnrmoP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9371F000E9;
	Tue, 25 Aug 2026 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666255;
	bh=o22bFbsZdGnCU8G96BW7kYMOHAZnQh5my6HA4LMxqvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMnrmoP6zKOORCyC/uSh0sNwqkjfXlbtXXg7xA9hGUan98L8TVM+ImM4uq3wQpmG6
	 i91gc0PWwWlA1OEQRRMo6h0EyPYr36+9xrZF86s/de+xoROVSZOCR83h9v407L08TN
	 s4lPIiKrlj5AY4GArASIJU1JHchmMCLS92PR3C2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>
Subject: [PATCH 5.15 58/76] KVM: x86: Check for invalid/obsolete root *after* making MMU pages available
Date: Tue, 25 Aug 2026 15:26:51 +0200
Message-ID: <20260825132543.852962232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2abd5287f08319fa35764566b15c6e22cb1068db ]

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
[backport note: upstream passes struct kvm_page_fault to is_page_fault_stale();
 here individual parameters are used, as is_page_fault_stale() was
 backported with that interface in the preceding commit]
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c         |    9 +++++----
 arch/x86/kvm/mmu/paging_tmpl.h |   10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4045,16 +4045,17 @@ static int direct_page_fault(struct kvm_
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
 		return r;
 
-	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, pfn, mmu_seq, hva))
-		goto out_unlock;
-
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 
+	if (is_page_fault_stale(vcpu, pfn, mmu_seq, hva)) {
+		r = RET_PF_RETRY;
+		goto out_unlock;
+	}
+
 	r = direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
 		       prefault, is_tdp);
 
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -923,16 +923,18 @@ static int FNAME(page_fault)(struct kvm_
 			walker.pte_access &= ~ACC_EXEC_MASK;
 	}
 
-	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, pfn, mmu_seq, hva))
-		goto out_unlock;
-
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
+
+	if (is_page_fault_stale(vcpu, pfn, mmu_seq, hva)) {
+		r = RET_PF_RETRY;
+		goto out_unlock;
+	}
+
 	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, pfn,
 			 map_writable, prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);


