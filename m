Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046679;
	b=FPSNrRWs1QqUZovnx450ieJ6hCoUIc8nOlvNpARITH0v7oChiMKQb9Zgu7rNEvYR+FmL
	 oMU1m3RaF+5SD4aONQocFQ/4v33RtkWawJwviPup0gt1gyLA2mROM0fMaXhUys84dDWep
	 B8evAFXw0ArvbSJwR3kjD7e/SMJLQUTiHuxErwRrzFCho1BwZrQ5BAHD7zOdAaHVmu17i
	 3sdRpLFcsjvEYsG3zY7EWVeo3iOeTKANkIgYOVt1xIRCKOZxW1iacm2Qj4fW+NDDe61NH
	 1vhE4E/6AkZZLq4NO6dFbxxv6A6m4h0PDQhc1iUgmvwt14tT7W/IhEtTSsoiZwAPgFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iyo8B8hcbTYNUCCmeOOjyLczMe4rcKnwRjr6VBjD1Ac=;
	b=GcQIpSGswBnWq9Rakjtn/EOF0teLR+jOg2KdwaqTkAtV3Q31TTplWPURgHI+s3D8xZfo
	 WEys3ftyapE9iU8iqYss23B4Jbdb8QyrdKuxG7kos54wlHssw/MvGTPJM8FEgAe3xO4xu
	 p8jUJVxhDc/h7+cyRe7NACvJLPsjo20okCM4Dll7eA77CfMqujOJLqkOIP2/T9aguDeKQ
	 iXuwV3FJKHDf4dMoOn96VlUjdNS/9PqbP13iHEJwcRn4jj3fan/QOIvLYO8Y2H/yee+eU
	 DvLPBxHaGoOTvGt5gdtRpMwiGOCGh+PvEDvEtGE1Z/qxhnNvdnCDE2W4HSWNcYMErpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEIe0Uj9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BC3606A31C;
	Thu, 19 Nov 2026 00:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEIe0Uj9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCBC1F000C4;
	Thu, 19 Nov 2026 00:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046678;
	bh=iyo8B8hcbTYNUCCmeOOjyLczMe4rcKnwRjr6VBjD1Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEIe0Uj9aL4FVEOnscN6ytyJTRnoPytITAk4r6g/TDFcMDlo6gHAJ/jsA+d25eoV8
	 HT33NvxP1FKgwq5f5+6Zfd7x92ie15sYPBZLX2SIGAMsSl0HOMZf96z3fxBASHXwxV
	 jH2ALM7+uMormuM47nWvfVNsdNUFmUChtGnZoHkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1366/2857] KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode without PAE enabled
Date: Wed, 18 Nov 2026 15:40:00 +0100
Message-ID: <20261118150250.582089362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 72e2fb24a0b0528bcc16a8f6ad2cf336ac361525 ]

Promote the ASSERT(), which is quite dead code in KVM, into a KVM_BUG_ON()
for KVM's sanity check that CR4.PAE=1 if the vCPU is in long mode when
performing a walk of guest page tables.  The sanity is quite cheap since
neither EFER nor CR4.PAE requires a VMREAD, especially relative to the
cost of walking the guest page tables.

More importantly, the sanity check would have prevented the true badness
fixed by commit 112e66017bff ("KVM: nVMX: add missing consistency checks
for CR0 and CR4").  The missed consistency check resulted in some versions
of KVM corrupting the on-stack guest_walker structure due to KVM thinking
there are 4/5 levels of page tables, but wiring up the MMU hooks to point
at the paging32 implementation, which only allocates space for two levels
of page tables in "struct guest_walker32".

Queue a page fault for injection if the assertion fails, as both callers,
FNAME(gva_to_gpa) and FNAME(walk_addr_generic), assume that walker.fault
contains sane info on a walk failure.  E.g. not populating the fault info
could result in KVM consuming and/or exposing uninitialized stack data
before the vCPU is kicked out to userspace, which doesn't happen until
KVM checks for KVM_REQ_VM_DEAD on the next enter.

Move the check below the initialization of "pte_access" so that the
aforementioned to-be-injected page fault doesn't consume uninitialized
stack data.  The information _shouldn't_ reach the guest or userspace,
but there's zero downside to being paranoid in this case.

Link: https://lore.kernel.org/r/20230729004722.1056172-9-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 115f9405a2ed ("KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 952f7e9b64fad..42d459370f781 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -345,7 +345,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 #endif
 	walker->max_level = walker->level;
-	ASSERT(!(is_long_mode(vcpu) && !is_pae(vcpu)));
 
 	/*
 	 * FIXME: on Intel processors, loads of the PDPTE registers for PAE paging
@@ -355,6 +354,17 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	nested_access = (have_ad ? PFERR_WRITE_MASK : 0) | PFERR_USER_MASK;
 
 	pte_access = ~0;
+
+	/*
+	 * Queue a page fault for injection if this assertion fails, as callers
+	 * assume that walker.fault contains sane info on a walk failure.  I.e.
+	 * avoid making the situation worse by inducing even worse badness
+	 * between when the assertion fails and when KVM kicks the vCPU out to
+	 * userspace (because the VM is bugged).
+	 */
+	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm))
+		goto error;
+
 	++walker->level;
 
 	do {
-- 
2.53.0



