Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211314;
	b=mbtBHxw5Y+jJsiBJNI112TlAK77JoG0SFIKJA9P7PdRfmfkcx3/yxITqvcEk860x2OP1
	 QilqtyESB7YMBwXb9P/jkBWRuMcFPxtB6+cvOlKRaHf8cjc/0h/IOWmfihjvrdGtzTFl1
	 ekr67/JSHfa56sunTq+BWPzyuOjb8yyDx1wVj3OF0nlGAMs7E6UgzNG8fDvMy0gUg8B+G
	 dfpeqpdtuJK0KjtEmo4s8nxa6EP+JbqLXvg3mIyr8MHRu+EHBgqAQYnEkjD+sRg8sbSfJ
	 Lb7PV5iDRnowtHkaiD03m5a8/QJMGKKQxJlzKnDtCypno9tWLyBxjcajQfxVhTnA7gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T+CJ6VwX229ZqNfe2cW2gU2qIJBlmG9yUnQ36Gmu9ek=;
	b=QBJRDwnLfQfO4YWKeX+no2pGxque34KX+Q9JmoeO40qi3j94uE29mruy7t0JwNMxSJ0O
	 pW4j8LEzJDYcOXCti/z0vHTWyWOlpZbc9TXlrU979Nh0WU0ja7JqDAxFTp2aopbtucZ/6
	 JHcrKWheHAbcFDNVpbcWXQrXGvHpX/y8n0thOldTvd39llDU6d1KfEMENtEg/gfdT3j65
	 U+8CzjUR8cARboVdmk636Zgj42NZjbtmvnLdrwbDjkbewnnhTuEADnsxA+qB6Ogmg385z
	 dDN5D5bRtX27EjCuvsly5joVufLPSNZINPqFp3c21fhAyTAgFq6nqm5b5w/fSY2BRSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NVXs+rBy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB52606A951;
	Wed, 28 Oct 2026 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NVXs+rBy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6501F01825;
	Wed, 28 Oct 2026 18:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211313;
	bh=T+CJ6VwX229ZqNfe2cW2gU2qIJBlmG9yUnQ36Gmu9ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVXs+rByapl9yIVEPyXFqpOxqTNds/ObKYQq5CEnQDMpvCBcEO+NsAUW3WAGoB9bC
	 BcRjb8y07iNebdSHtQrUe/x4jBvFC3qOdDbXrgHxj+BCCsV50imYMu9/dR/aIGZ9TJ
	 6fcAkgSX+Uaba0t7duzFLiqgr4hB18PnU5nhrKlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/571] KVM: SVM: Use the active VMCBs MSR bitmap when checking if MSR is intercepted
Date: Wed, 28 Oct 2026 17:58:02 +0100
Message-ID: <20261028170015.958259921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
[ sashal: Adapted SVM access to use to_svm(vcpu) with the existing kvm_vcpu parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 16d2b697dc631..f280155560a23 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -656,8 +656,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	u32 offset;
 	u32 *msrpm;
 
-	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
-				      to_svm(vcpu)->msrpm;
+	msrpm = __va(__sme_clr(to_svm(vcpu)->vmcb->control.msrpm_base_pa));
 
 	offset    = svm_msrpm_offset(msr);
 	bit_write = 2 * (msr & 0x0f) + 1;
-- 
2.53.0



