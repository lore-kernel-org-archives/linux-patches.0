Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174E43B14C6;
	Thu,  2 Jul 2026 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010502; cv=none; b=Xxd/ctP4MGgr9krpLOJwVAXznFSMOW9pMaDHkcN7676T9j4xbGVoDKqivh3Sv2quhoXrldxroYamBeerO9GTp6vr02anay0WUH8VdOcyeLTpc6i97JQO1L+TmTVDz6xM+RiUyeH6w1OdI3W2a3lUZ4gldlNyZjuEYVF4R0WM0Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010502; c=relaxed/simple;
	bh=p+z8UWRItggaaYDbLAO5t+elcJGyS+l+aJEhgfqbm5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXEXheBey8oMLbSuHE2bNiAjqKJl2sVPdIO2TyQGA0rsqCNbf+g57CNd6rMBzeYt7jbf8Ru9QNrpuuhoju/QWkGmrJnNno0hWpIw663g+sNnmVRD3Xw9d8YzQRdBQiEkR2tlvuNJUDLtkM2TrAEj9Jp8vR4rbuJWky7DrQlCY5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FzVLSzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FzVLSzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334E81F0155B;
	Thu,  2 Jul 2026 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010495;
	bh=EI9oxi30RzmiKsj2fF54Jq38FMsowXbLwb+qBdsXERM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FzVLSzd4lGTeYZB2U5NNepZ9wsga23kc0Br15cweBM8W/zT4StU7XcBBUStlRhut
	 98q+9fqA1VAs3VllZiKQZLEpcGTEa8WPb89jOOVpBjo6ootPRphadlxJgJkz1DW4YV
	 n2ZCkXPClM4Ii3LRImlOqM1my4tXKMDTVE3/PVFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/204] KVM: SEV: Move sev_free_vcpu() down below sev_es_unmap_ghcb()
Date: Thu,  2 Jul 2026 18:19:48 +0200
Message-ID: <20260702155121.405455012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 08385c5e1814edee829ffe475d559ed730354335 ]

Relocate sev_free_vcpu() down in sev.c so that it's definition comes after
sev_es_unmap_ghcb().  This will allow sharing unmap functionality between
the two functions without needing a forward declaration (or weird placement
of the common code).

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-16-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20260529183549.1104619-16-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: Preserve use of sev_es_guest() as is_sev_es_guest() doesn't exist
       in 6.12, resolve superficial conflict due to pre_sev_run()
       prototype mismatch.]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 62 +++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 73e49317735173..7ddce0685293de 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3168,37 +3168,6 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	wbinvd_on_all_cpus();
 }
 
-void sev_free_vcpu(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm;
-
-	if (!sev_es_guest(vcpu->kvm))
-		return;
-
-	svm = to_svm(vcpu);
-
-	/*
-	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
-	 * a guest-owned page. Transition the page to hypervisor state before
-	 * releasing it back to the system.
-	 */
-	if (sev_snp_guest(vcpu->kvm)) {
-		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
-
-		if (kvm_rmp_make_shared(vcpu->kvm, pfn, PG_LEVEL_4K))
-			goto skip_vmsa_free;
-	}
-
-	if (vcpu->arch.guest_state_protected)
-		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
-
-	__free_page(virt_to_page(svm->sev_es.vmsa));
-
-skip_vmsa_free:
-	if (svm->sev_es.ghcb_sa_free)
-		kvfree(svm->sev_es.ghcb_sa);
-}
-
 static void dump_ghcb(struct vcpu_svm *svm)
 {
 	struct ghcb *ghcb = svm->sev_es.ghcb;
@@ -3475,6 +3444,37 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 	svm->sev_es.ghcb = NULL;
 }
 
+void sev_free_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm;
+
+	if (!sev_es_guest(vcpu->kvm))
+		return;
+
+	svm = to_svm(vcpu);
+
+	/*
+	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
+	 * a guest-owned page. Transition the page to hypervisor state before
+	 * releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		if (kvm_rmp_make_shared(vcpu->kvm, pfn, PG_LEVEL_4K))
+			goto skip_vmsa_free;
+	}
+
+	if (vcpu->arch.guest_state_protected)
+		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
+
+	__free_page(virt_to_page(svm->sev_es.vmsa));
+
+skip_vmsa_free:
+	if (svm->sev_es.ghcb_sa_free)
+		kvfree(svm->sev_es.ghcb_sa);
+}
+
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
-- 
2.53.0



