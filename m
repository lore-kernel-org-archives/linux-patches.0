Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188DD424D4A;
	Thu, 16 Jul 2026 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211439; cv=none; b=DQLOePSFAHanP4wMuNRPGD26YI2FWp6NRwBB4NYFvDgNKooDdAt+DpknuOIhjGvK5oJAr3TKCq7C75AGOdfCGm9HxBJqpUWAfJVyTLngpQ5FmWpc8VXXE6FiQSiPeEP3nD4WQM6wwISwQ9k7ifCcWX1Nd30CU+kD9NjGHUHET1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211439; c=relaxed/simple;
	bh=kOCGLIP636GvK2XZQY1St0v6xRwZVEn4uJ7HV75ee6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Drshi3MgVw3EytKLljSl1ade+dkyh0b+cZND2xtvFUb7FIFzOrEpHxB6FZsPdWNmc5GzJnFy5TvEYJt3F3TCBnpqi5uzOA/jMnlQNprOQ3Zkr0Jd+Gma5yQu3fDSnYNXiracZHSWoIdeGPEseR2mjg55IVevVMwz/PmzdghWcXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FB+g+56k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FB+g+56k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EB31F000E9;
	Thu, 16 Jul 2026 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211438;
	bh=y0dKhK9y4qr3+M21Cu7EnZrAmCop9Sr2HR4k4B5qfBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FB+g+56kXSajpTTNmjyK+M4cXjcKOjwMKD05sms3dlOEL2Ci7+laESC7xo78JS2sl
	 arSDsIhydcX2xf0rB5GxAlDvVXdgVbRxGl+PsOwgEwkJZhGg+07jDYpzVzuND++Kcz
	 T7y0Q1x3+mVWez/P8aEKMzMopULNi3VuA/8m/EaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 429/480] KVM: arm64: Dont leak PFN when kvm_translate_vncr() races MMU notifier
Date: Thu, 16 Jul 2026 15:32:56 +0200
Message-ID: <20260716133054.095648779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Oliver Upton <oupton@kernel.org>

commit 9f76b039a72d7e06374aa96862f0232ed53f7787 upstream.

In the case that kvm_translate_vncr() races with an MMU notifier the
early return does not release a reference on the faulted in PFN. Add
the necessary call to kvm_release_faultin_page() for the unused PFN.

Cc: stable@vger.kernel.org
Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
Reported-by: Sashiko (local):gemini-3.1-pro
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260602235450.103057-2-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1238,8 +1238,10 @@ static int kvm_translate_vncr(struct kvm
 	}
 
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
-		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
+		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq)) {
+			kvm_release_faultin_page(vcpu->kvm, page, true, false);
 			return -EAGAIN;
+		}
 
 		vt->gva = va;
 		vt->hpa = pfn << PAGE_SHIFT;


