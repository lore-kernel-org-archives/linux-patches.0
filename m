Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053731;
	b=f1lklKryKsmjYKh1fplomkaMp+f7S4gqJBLtboKwMQbDcQEycXuTJCJGcmJPiyq6T3mn
	 sB2y4iF6wUbP6E7NkneNeDreNfLRvIo4oUPwFaa5sJ4EYX5Ig/R0rleJCw7I+wzG1WoNp
	 xmhPrLIqkxAiPgAtNlqf3nEKpEQ9gigQwGQ4CqHwKw2/O/EK3m+pBSUXkTTvPFnwNElDi
	 HHRhj330+QO8QXZt1jzufGc7ZlABeunJ0nAfEWHDs8XYTh62Yy29NVdjHpQ27le7BG8O7
	 dF7KHCisRvj+m7G1pnxTzUex7m0p/TMrQFSZwOsaNyCe01DeehYSl7HDJvO82XaCycg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nRjSSxRRucVUZul3o8k38JQBniFtJOEt3D4AZlphrf0=;
	b=wFx0yapsvZ3K3/hSmBZ9GPOhEv3bTctslHgS4e+meMj6eN3/iNWH0XG8eAtrEvG9V2q2
	 Pn90uvD5A2aLoFwgRIWIG667ggMi76TZgYFribG2wVmCY0uEBhTYWprEeynwikPi6P29L
	 AYINJUU4IKaUs+AnjyceOe6CGlv2kzom2PIb8hZbkW/UAIPm0JbGmuwSiPMiNU/u2E5TF
	 o1sz4N7MtwRgOQa2wV6zc5bGGY2P83EGDaojKptaMCPrK611gx2I1M6V33PMFQmsAyrg6
	 tJSTT9mGKt/JpmAS6ajZN88Ztw2kS1RmxrrgF4bRa0qoz7qRW7Ad36kmzF/nu9NXD9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pw6GQQKb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF25606A325;
	Thu, 19 Nov 2026 02:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pw6GQQKb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4023F1F000C4;
	Thu, 19 Nov 2026 02:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053731;
	bh=nRjSSxRRucVUZul3o8k38JQBniFtJOEt3D4AZlphrf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pw6GQQKbRVQxVoyohLpH8CU2zkeoW+NFF7Xw3P98s9nXqYV8AWhi6Pd5f4kd8ljHz
	 UBT1jcNKZtfQNjCFko7201XkYIJPoaY8EqITiSnwkoMyckeD6B1ntdsHdfzMrdzdae
	 1fdGI7j4k0yYTVod89kJZYTG2QhnuoFJ8OviYiYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0982/2214] KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode without PAE enabled
Date: Wed, 18 Nov 2026 15:44:18 +0100
Message-ID: <20261118150051.529690424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6d37015772a31..ac139fa59b377 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -380,7 +380,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 #endif
 	walker->max_level = walker->level;
-	ASSERT(!(is_long_mode(vcpu) && !is_pae(vcpu)));
 
 	/*
 	 * FIXME: on Intel processors, loads of the PDPTE registers for PAE paging
@@ -390,6 +389,17 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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



