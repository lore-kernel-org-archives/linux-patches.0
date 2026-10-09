Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7E34E2F2A;
	Fri,  9 Oct 2026 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557387; cv=none; b=HzGFy6eSFK/8Jgy6ege+m1NJ5rnhY+j36g7cCgRKR3MX8R9Ubjaz+Ta4DRcKwZe0Y94pH5Zr4OKLsPYcuMar+Z6Grfh42fgHPTF4sdvkCzVa5FpNmBWygO07bmSkYL8H9gboHUAK18rZ3GWJ/vACyYo9X37orHkVVj+ALVvWSEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557387; c=relaxed/simple;
	bh=Cf5OYRwhLsPFwNbr/FAdGMvRqrgT8cFbkAf3iRrooM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdWxt3FAs9SA4AUM0mB3J5YtihwPJvVCpyUC1vyKHefPuOR/ITrAdwt9cIEuKTHd7QooxcQqfC6uYOil+Zjd3OQyWmBsknXjxdlNPvZk9yfk6VZgu6gyqU3szyPe7K5mJzGNtkGWZGED413HfhwgQCILUsM5wOxtKMmiQGXaYhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grNS+XHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grNS+XHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF581F000FF;
	Fri,  9 Oct 2026 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557386;
	bh=uFNpjydrTjui8sXe+rhD7egVFS9S4OymQHne7c737x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grNS+XHwAaX5U8B5ahB4HxsQVs0+XGXARZK/OUM8LVwxPAOd5CSFIcqW5KQXCJR4h
	 l6cAEy6+OL/QBTksDMs/v8o+EJ34037dRfrdyAEtJ0BRAh/tuWz/ZAadRkt14Y2jMz
	 6PjqvhSk2wh8/PPgV3/JDKrYLcJWaGCa3fLmlYtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 392/403] KVM: SVM: Use the active VMCBs MSR bitmap when checking if MSR is intercepted
Date: Fri,  9 Oct 2026 16:12:33 +0200
Message-ID: <20261009141001.517394160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted svm->vmcb access to to_svm(vcpu)->vmcb to preserve the existing function signature. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -654,17 +654,7 @@ static void clr_dr_intercepts(struct vcp
 
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
-	/*
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	void *msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm :
-					    to_svm(vcpu)->msrpm;
+	void *msrpm = __va(__sme_clr(to_svm(vcpu)->vmcb->control.msrpm_base_pa));
 
 	return svm_test_msr_bitmap_write(msrpm, msr);
 }


