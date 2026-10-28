Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208974;
	b=I80PQp65qZEHZDzNRpBlQqlS8L3KzJG+JzjQle5keV0g6LbP4FeH0wCnnB1JBNzfEVJD
	 Ra4O/Doa1qVgDcLNdJYKNfbXZfNFjVGQJfe+FWJrIpXKvo71MROJ2TNDIZYW0lhfntRgy
	 FAFQ5gyLerwBaGB4FksSIgXMoAeAmfsWZ26S1AbelKTkQBuXmto9BC+pzWFhhylWtYMTS
	 zQPF1f5IMlL+kARw+ip9y9iIBaL+7rlXGiSCzYdPAjyoEaqoR3dBQwIH01cWu3V/irF/k
	 8ywphDibQdZ1/0T5u9YXcoXP0V85BlVwbDIcN+h5l8zCpqWaTeHpD/p9XdczYJLKhXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Th20P/h6YAcPXArUNOxD47l6G3ZL6XPG2Qvpvu7U+Og=;
	b=vwPRVCzersvVo94l4HeQMlIl8ZbdQd/RQ9ygaH0+xYCGDtSKEp5oE3GnGkpWjMuHj2cB
	 qFiYxwwSpJ+t627yPvKJ4Rgn7I7o8KdsYvbp0r6JXxcYE0ewJZ4ka6k0IRrorifDiZJE6
	 /FQplnW4FbqXT0YZPhdKhb6Cja0N4stCut9bL39u2XyjD7uZ2GEkaj0W7TtmXfqsnWdPI
	 yxcKXqnW4/Q95kIDuVFS/jHndZbeO/g0cMDIftl4CFNiuxezPrtx3PSlV/rG5IscRlLuJ
	 2wRraxs88gP4H7mvBQ2X2veRHDUnpLu7qbWoeXri2ZIXd7diKrwH/lzbt6oboApbkEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LtBafW8m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEA2606A31A;
	Wed, 28 Oct 2026 17:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LtBafW8m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFEE1F01825;
	Wed, 28 Oct 2026 17:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208974;
	bh=Th20P/h6YAcPXArUNOxD47l6G3ZL6XPG2Qvpvu7U+Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtBafW8m/7H2TsCcjGABw0J8QIvUMmjiGlJ4RFGRm6q/nUnEdl8BRr5TBzvWeglU3
	 ZdNwa+VjhzvZvaZJIC6HZq5uLcS+QQMOs15zwkbtn98ANfE/PNAQmuk2cAwmlvw8G6
	 BSAdEtp3DG4+dF55BwUWxo8IB4nxWD+RCJZhOIIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/516] KVM: SVM: Use the active VMCBs MSR bitmap when checking if MSR is intercepted
Date: Wed, 28 Oct 2026 17:57:40 +0100
Message-ID: <20261028170010.787384496@linuxfoundation.org>
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
[ sashal: adapted direct svm access to to_svm(vcpu) for the existing helper signature. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 97783bf50a3f3..41a4ee2aaa4c4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -616,8 +616,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	u32 offset;
 	u32 *msrpm;
 
-	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
-				      to_svm(vcpu)->msrpm;
+	msrpm = __va(__sme_clr(to_svm(vcpu)->vmcb->control.msrpm_base_pa));
 
 	offset    = svm_msrpm_offset(msr);
 	bit_write = 2 * (msr & 0x0f) + 1;
-- 
2.53.0



