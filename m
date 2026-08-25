Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E30C470117;
	Tue, 25 Aug 2026 13:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666245; cv=none; b=T1UNkEFwZpkb9vsqp7O9NAz1x64WzGCJAVpN735QrcqHbtOwU4TtRZ5f9a1J5aIYYiLFCWgVxGKOhqLDd6awpR4cEcnsNXFNMXshoVBANpyyIh0uNbx8KyjKIHq9No8Zra7qDyl85P1VPr2aD6DWYtX5NnPW/5/2wmoUdQQCW2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666245; c=relaxed/simple;
	bh=D5l/eAX4cbEVxe7fLaEZvjbJh1Oeu5NjwHt3z5KtCJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvtWOTn6k2O8OHo0NgL4QDRH/9fPirn3FoemgGEdb9EBWr8QjJj1EzTvRC+NUCORnup92XbOLj7MGqPUmqRz9MZfyMR6ofgCjQmozLYDouQxxiYjLQioR75ATvItS5XPKQxfoM4VeKC9KeM16k7VGdJFjGdILK4tG49oLd1iiS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FD3Fhl99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FD3Fhl99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E061F000E9;
	Tue, 25 Aug 2026 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666244;
	bh=Zx898+DPV+PMuGAR2yrWbdY1D1nQkXtwtoGn1kMoT+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD3Fhl9921iwRJP8mJOWz2ho+ugTS30m8swb1w3Z6AvngC5cmh69cA/s2DIiXtWWZ
	 ep6VdRQOnaxN67lBLZGyecTs7lbaurXo3wEzI+Kly0DehO9TUYFLdPkC0huAH/eqmk
	 DlNxabskUdXs521C/chUPUa4BYN4eED25t4Fi/ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Kenta Akagi <k@mgml.me>
Subject: [PATCH 5.15 54/76] KVM: x86/mmu: Document the "rules" for using host_pfn_mapping_level()
Date: Tue, 25 Aug 2026 15:26:47 +0200
Message-ID: <20260825132543.695510799@linuxfoundation.org>
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

[ Upstream commit 65e3b446bcceaac7448cb25a2a5bf4adbcf25fe6 ]

Add a comment to document how host_pfn_mapping_level() can be used safely,
as the line between safe and dangerous is quite thin.  E.g. if KVM were
to ever support in-place promotion to create huge pages, consuming the
level is safe if the caller holds mmu_lock and checks that there's an
existing _leaf_ SPTE, but unsafe if the caller only checks that there's a
non-leaf SPTE.

Opportunistically tweak the existing comments to explicitly document why
KVM needs to use READ_ONCE().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220715232107.3775620-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2abd5287f083 ("KVM: x86: Check for invalid/obsolete root *after* making MMU pages available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2873,6 +2873,31 @@ static void direct_pte_prefetch(struct k
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
+/*
+ * Lookup the mapping level for @gfn in the current mm.
+ *
+ * WARNING!  Use of host_pfn_mapping_level() requires the caller and the end
+ * consumer to be tied into KVM's handlers for MMU notifier events!
+ *
+ * There are several ways to safely use this helper:
+ *
+ * - Check mmu_notifier_retry_hva() after grabbing the mapping level, before
+ *   consuming it.  In this case, mmu_lock doesn't need to be held during the
+ *   lookup, but it does need to be held while checking the MMU notifier.
+ *
+ * - Hold mmu_lock AND ensure there is no in-progress MMU notifier invalidation
+ *   event for the hva.  This can be done by explicit checking the MMU notifier
+ *   or by ensuring that KVM already has a valid mapping that covers the hva.
+ *
+ * - Do not use the result to install new mappings, e.g. use the host mapping
+ *   level only to decide whether or not to zap an entry.  In this case, it's
+ *   not required to hold mmu_lock (though it's highly likely the caller will
+ *   want to hold mmu_lock anyways, e.g. to modify SPTEs).
+ *
+ * Note!  The lookup can still race with modifications to host page tables, but
+ * the above "rules" ensure KVM will not _consume_ the result of the walk if a
+ * race with the primary MMU occurs.
+ */
 static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				  const struct kvm_memory_slot *slot)
 {


