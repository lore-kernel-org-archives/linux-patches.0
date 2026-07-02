Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF523B6361;
	Thu,  2 Jul 2026 16:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010505; cv=none; b=MT1xk+sqbrOEDLHMrG6rWULDzC4JveZoqqDl3jArV7QKc6TBerb4ff4Cb3yD4eWhDLsC7Sq5qU02e1dgsacuGvK0MnewLvvXJ6v6Y4sOLkM/t0Lz6aosMkv49kqcDnJO275K3aoJQuzDC59T1ok5hsS1se++KBEdNwkEL/DYGyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010505; c=relaxed/simple;
	bh=8/JZ5fSJbIeLJ7tVQJHqvI6BEL80TGjhVrclY6nq49g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fml5FPksXo/jXiEXqcCuZELHsYaiP1fzFGWQHBKSjh2+8BLFVOaYETMD2RZRGfDa3z42xQR2UpdfN2pKdzX6vIE0sziqNyfF/Yu9nxM0nz76/Nd7RsJm2yDnTyNLaQL/JHpEwKG3ub7J4bTiOlPFGWrbJ88KcOhWTddX4m/XHFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUQgc3Pp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUQgc3Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0AF1F01559;
	Thu,  2 Jul 2026 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010498;
	bh=PHPRxw0zGSlPm1gBu5TfLljco9ZaKxb9Z6H0AnveK50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUQgc3PpEzum9daDjjZ8F2iP+CoOE60jF11rVF7FTLlAvleg5kNfUqJ+66O1Q+tdC
	 CEbA+R3bd+iIzd2t2pUvAq8mQuE6ZCTSgOiyZCsHZnKX5B3amcT/62NpkeOHRZHFXm
	 rplCXjrxH5yE3ukZGZrN6ep59o/gSSPn4TcGAeDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/204] KVM: SEV: Unmap and unpin the GHCB as needed on vCPU free
Date: Thu,  2 Jul 2026 18:19:49 +0200
Message-ID: <20260702155121.426435064@linuxfoundation.org>
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

[ Upstream commit db38bcb3311053954f62b865cd2d86e164b04351 ]

Unmap and unpin the GHCB as needed when freeing a vCPU.  If the VM is
destroyed after mapping+pinning the GHCB on #VMGEXIT, without re-running
the vCPU, KVM will effectively leak the GHCB and any mappings created for
the GHCB.

Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Cc: stable@vger.kernel.org
Tested-by: Michael Roth <michael.roth@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-18-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20260529183549.1104619-18-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: Preserve @dirty=true param to kvm_vcpu_unmap()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7ddce0685293de..6032d7e69a20e7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3412,6 +3412,20 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	return 1;
 }
 
+static void __sev_es_unmap_ghcb(struct vcpu_svm *svm)
+{
+	if (svm->sev_es.ghcb_sa_free) {
+		kvfree(svm->sev_es.ghcb_sa);
+		svm->sev_es.ghcb_sa = NULL;
+		svm->sev_es.ghcb_sa_free = false;
+	}
+
+	if (svm->sev_es.ghcb) {
+		kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map, true);
+		svm->sev_es.ghcb = NULL;
+	}
+}
+
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
 	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
@@ -3430,18 +3444,11 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 		svm->sev_es.ghcb_sa_sync = false;
 	}
 
-	if (svm->sev_es.ghcb_sa_free) {
-		kvfree(svm->sev_es.ghcb_sa);
-		svm->sev_es.ghcb_sa = NULL;
-		svm->sev_es.ghcb_sa_free = false;
-	}
-
 	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->sev_es.ghcb);
 
 	sev_es_sync_to_ghcb(svm);
 
-	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map, true);
-	svm->sev_es.ghcb = NULL;
+	__sev_es_unmap_ghcb(svm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -3471,8 +3478,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->sev_es.vmsa));
 
 skip_vmsa_free:
-	if (svm->sev_es.ghcb_sa_free)
-		kvfree(svm->sev_es.ghcb_sa);
+	__sev_es_unmap_ghcb(svm);
 }
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
-- 
2.53.0



