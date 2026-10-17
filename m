Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC423B7770;
	Sat, 17 Oct 2026 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257197; cv=none; b=lTxNFbgCyeOcbQLMTsIuiUso98slmqFky/kAoIgSULnYgUWUeIJaItM6s1eyzdVHAvhOMIntRiV90t8uaMKHqvQeB+x8I4dHaRjgc98pv/rEnBurHUQ4wuimEQikl5iqDKy3Yx+Igdh1dgf4Y/VPmzB/Ll6i9hkGxtRQ6+nWDJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257197; c=relaxed/simple;
	bh=jE2KEoppKqBOJUSS88fsxpgtsInSB55btTunxNog+Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpOlSgxUKfv1C704y0BofM1yUEZh00ELVvNAFp9NyisIQGjGrIzH8NkCoSpg5EH9+ACrNL5BOWMe1pSoAyKm7MrnI3JkMbS0rufkC+FwEcGG1OgtOIz13nIybGLruGUt6oCh1kfjKtkuVlOSHAFplFAJWTFqGNwX2jcu4YcCfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbVK3hJW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbVK3hJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308BB1F000C4;
	Sat, 17 Oct 2026 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257195;
	bh=+BSG3k3mxZ8K9vyx4/H9Rxk7E/SfWfrgHxuelQ+pScc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbVK3hJWial9tVIZNwXsEvNnbZxPQvDfdXmGbVlu4zf3Y6SUNRAjGxKFUlUA+ldT5
	 ULKqvG3VMt1IhRMIoY/gZZzLJeU3nZ+139A6QoVoBNtccW7q/sGfmKzaDKkyzkjb2M
	 VUcOLcKbzhsmKYslS9zjii89kkp9xKwel6xmyd6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0440/1674] KVM: SVM: Use the active VMCBs MSR bitmap when checking if MSR is intercepted
Date: Sat, 17 Oct 2026 17:45:12 +0200
Message-ID: <20261017160442.417681823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit 9e06bbb9ade7cdf28d4a3b5b14e5812881c8df85 ]

Use the MSR permission bitmap of the active VMCB instead of assuming that
KVM is always using vmcb02's bitmap when L2 is active, as KVM uses msrpm02
if and only if L1 wants to intercept MSR accesses, i.e. if and only if KVM
needs to merge msprm01 with msrpm12.

Don't bother tracking the virtual address of the bitmap that's being used,
as __va() is cheap on x86, and caching the virtual address would introduce
yet another source of potentially stale information.

Fixes: b2ac58f90540 ("KVM/SVM: Allow direct access to MSR_IA32_SPEC_CTRL")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260826195833.844526-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ sashal: Adapted direct svm access to to_svm(vcpu) for the existing kvm_vcpu interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 62c7e57530216..961ac6b55e4f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -825,17 +825,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	u32 offset;
 	u32 *msrpm;
 
-	/*
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
-				      to_svm(vcpu)->msrpm;
+	msrpm = __va(__sme_clr(to_svm(vcpu)->vmcb->control.msrpm_base_pa));
 
 	offset    = svm_msrpm_offset(msr);
 	bit_write = 2 * (msr & 0x0f) + 1;
-- 
2.53.0



