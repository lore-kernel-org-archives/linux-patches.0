Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216845;
	b=K0Ui94llHIxvtdx7IH0xqu3rDglS5/DGSQTN9yutNwaFTLV5dNgfsGE1T6BMugZ0IxyY
	 sWlYjwP/2X650SEmc3MmwdUTc/DLaaDAYbHpVgUPV1dG4JUVXsDyRCU/3TlDwa5LPH3AM
	 k4GDcIHXfuVMcF7x+/CmVWOoEJ1IqadyAZGaMg3eQhXIvNVUhwl2jH05I0VyQ7uBEGgN+
	 mH/8lGiedJpTtB6oS3bLFtE7MB2kaQGrfY9l1NgJP/Uqd+OBGUzFgrX9/UH8buxD/9W6q
	 jYZd3EystxmlfL5xDyUjGJLHX3x1XnlkMosDvUeky7lhXILlWTd+aagkpHxz/e8CSSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oO84gWEG6Vh4IWRDcRzQHKHNs4SbJ/urnyTvGth2ySY=;
	b=45CGCppVcurczSXIUaX3O7Okp8x3w+9Oa0ABffUh7/h5Adhmg+bLweUag0+zZ0y3TAEY
	 gwwNjSIfRMkF5UkMzEbTbyF7t8U/adxOJV1sxXRD5BR3qoGh026b1h9ABpCP7Cg3hEIbO
	 /XKDRXyeir81FWnRVuBPam6GATILl+jlR/ZLGFgOA23i2Fwvp9LlYMQthA5w4GQSBjrTe
	 zdK7Ej76cYf6mpMsIIchIXGcFQRCVTGz3fRWZcKIKrWM9XpZSUDVSD6qFB7s1Nhm7tiam
	 IazMXOBeVaibcEid1+sAkl7uND8VAq6iCWNojCAxFTz3c4f32FOC5mxlqxDitynyxPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJvU9lbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D74606A31C;
	Wed, 28 Oct 2026 19:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJvU9lbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62EE1F01825;
	Wed, 28 Oct 2026 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216845;
	bh=oO84gWEG6Vh4IWRDcRzQHKHNs4SbJ/urnyTvGth2ySY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJvU9lbZgD3QJT2mg15/t5UShJYWT8jpNbi6QbVbvrYxPUEX9HdyC19P5ayfbGju1
	 /wEB1D8xx3fKfHK3gr9rqFJituKAweX2A47VFIqlRI+Cp721o/LpcJ/QrmsPChbXlc
	 XPputq4cBgk9xXCbLwMzfbC+dcjHIHpYDj2P2alk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinu Kim <kimjw04271234@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 1700/1887] KVM: x86: Use active memslots for the per-vCPU MMIO cache
Date: Wed, 28 Oct 2026 18:03:16 +0100
Message-ID: <20261028170538.139622058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jinu Kim <kimjw04271234@gmail.com>

commit b3e6212dea2e4328a841ceb37f377583176dc735 upstream.

KVM tags the per-vCPU MMIO cache with a memslot generation so that a
memslot update invalidates cached MMIO information.  Both the fill and
validation paths use kvm_memslots(), which unconditionally selects address
space 0, even when the vCPU is running in SMM and using address space 1.

Commit 56f17dd3fbc4 ("kvm: x86: fix stale mmio cache bug") added the
memslot generation to the cache key so that a memslot update could not
leave a stale entry valid.  When commit 699023e23965 ("KVM: x86: add SMM
to the MMU role, support SMRAM address space") added the SMM address space,
these helpers were not converted to use the active memslots.

Consequently, an update to the SMM memslots can leave an entry from the old
SMM address space apparently valid after the vCPU returns to the normal
address space.  A guest can then cause an access to valid RAM at the same
GFN to be returned to userspace as KVM_EXIT_MMIO.

Completing that exit through the VMM's RAM address space writes the backing
page without going through KVM's write-tracking path.  If the page backs a
nested EPT table, KVM can continue using shadow translations derived from
the old contents.  The WARN_ON_ONCE() in kvm_mmu_write_protect_fault()
catches this invalid cache and memslot combination.

Use the vCPU's active memslots when caching and validating the entry.
Memslot generations are unique across address spaces, so the generation
also distinguishes the normal and SMM views.  This matches the MMIO SPTE
cache, which already uses kvm_vcpu_memslots().

On an unpatched current-mainline kernel, a regression test that fills the
cache in SMM and updates only the SMM memslots fails the intended RAM write
and triggers the kvm_mmu_write_protect_fault() warning.  With this change,
the same test completes the RAM write without a warning.  The x86/smm_test,
set_memory_region_test, and memslot_modification_stress_test selftests also
pass.

Fixes: 699023e23965 ("KVM: x86: add SMM to the MMU role, support SMRAM address space")
Cc: stable@vger.kernel.org
Signed-off-by: Jinu Kim <kimjw04271234@gmail.com>
Link: https://patch.msgid.link/20260807112818.958190-1-kimjw04271234@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -205,7 +205,7 @@ static inline bool is_noncanonical_addre
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 					gva_t gva, gfn_t gfn, unsigned access)
 {
-	u64 gen = kvm_memslots(vcpu->kvm)->generation;
+	u64 gen = kvm_vcpu_memslots(vcpu)->generation;
 
 	if (unlikely(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS))
 		return;
@@ -222,7 +222,7 @@ static inline void vcpu_cache_mmio_info(
 
 static inline bool vcpu_match_mmio_gen(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mmio_gen == kvm_memslots(vcpu->kvm)->generation;
+	return vcpu->arch.mmio_gen == kvm_vcpu_memslots(vcpu)->generation;
 }
 
 /*


