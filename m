Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209404;
	b=SHiY47/ISYo8noQOYcDif8qkow4Pqk20eAT0aEVVz+XX0XXoyiZiUW0Js+Emf1bYidG8
	 UnNbkf5jLsL4aQTxIxWGIKTBKYkq8yrlQQO/olmgqU36YtxlYMJjYR9VR8vFYkCvmkhtd
	 Gg51PVdGSgwqcqTe0kTSEoTfVjtbDdEa9mFqvhC7EChmWLHGfffUoJkVmtoDXXQpZ0l7g
	 aCR6+zmPkdW1MFuKmV6iqemNL6UCmfZjneCTHQI1bxnq0zvbS6x9YdvRVY7GWYoVb0O9d
	 rl7fSFapxWFtEYN5G4oES+ww8XrYlDZfEOzYYyDAhSEHxWVb3gxPVlCkzdsfC0jTWSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+TynO62Rf11FoWhPn9KkD12HzzUTUzZXHkBQ+wLJD+o=;
	b=p62skrBficMbKwoFZ47oLKKraui5eQZtcVTz8HlUMk1e12m9UpOsWxf2fDwkw2xs1Dcn
	 29rL0WLcN8avqILt0O1u/FB5g8YUPyvR7FRduj24EdF4ZXsmiiR1dfRmFXDp6EOy5QK/L
	 A73pWbd7TJ4iect68tPjrH+7BOx8cAQBEEiKb96879A2WYh1a/sM7p+cPZ+uJ6TCMi82T
	 7gnnA1RyMgCnHhcRFS60GaQkT3/mYBpggazshzlhiKq19l3w7pwlqgx8j97+386f78pjc
	 fPp1YxDTOj+PFEcnaRcpkW/ztIjRJIgI11VKxM1G542kV/ASss05gvJ1s2DH5TeDvOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EMY5aDHD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE20606A31C;
	Wed, 28 Oct 2026 17:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EMY5aDHD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384AF1F01828;
	Wed, 28 Oct 2026 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209403;
	bh=+TynO62Rf11FoWhPn9KkD12HzzUTUzZXHkBQ+wLJD+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMY5aDHDs8aFOidQxFLJQ+xiVKU1Ri8cJiXsEXdMO1Bm+t3erXeC/oFoUTlZBTCX0
	 yi+aloawxxP6ipEfmYV+jAwGyPYZZ2tT67OD552lI6vklw6/JdvagP3r879SgjrJJk
	 5nSnSwIJIipsPq5aNUV6JS85foC/gazF7V4xtlRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinu Kim <kimjw04271234@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 422/516] KVM: x86: Use active memslots for the per-vCPU MMIO cache
Date: Wed, 28 Oct 2026 17:59:34 +0100
Message-ID: <20261028170013.484711942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -164,7 +164,7 @@ static inline bool is_noncanonical_addre
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 					gva_t gva, gfn_t gfn, unsigned access)
 {
-	u64 gen = kvm_memslots(vcpu->kvm)->generation;
+	u64 gen = kvm_vcpu_memslots(vcpu)->generation;
 
 	if (unlikely(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS))
 		return;
@@ -181,7 +181,7 @@ static inline void vcpu_cache_mmio_info(
 
 static inline bool vcpu_match_mmio_gen(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mmio_gen == kvm_memslots(vcpu->kvm)->generation;
+	return vcpu->arch.mmio_gen == kvm_vcpu_memslots(vcpu)->generation;
 }
 
 /*


