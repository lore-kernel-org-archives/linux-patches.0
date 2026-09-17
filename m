Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7993249D58C;
	Thu, 17 Sep 2026 18:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671440; cv=none; b=lXSeFKch0uPS71G+El8a1baP8Tl4QIm+f9cilq4QV1xuSzLkhtejiERq36LiYhjR+0YwXz9J28b1JsNsQfQ5w1W4XOKH6Cj/3iSUVr0HghdzS1sArLE9url0hJ1ZSrIRrqZEB9JjGn7uRBvVTXVVZSSaSYdDRNuqWmBjcmG+2DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671440; c=relaxed/simple;
	bh=3H7YLNGq3sZ0aVq8G/QMUfrgkTy8TQ3hqe/y7QwGqWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1rkOBfOkY+mkOXrb/fVqSfLUiCaqIhaey4ZBw38czcIoOhOuwCI7JwmtY1isOY7HmrQ9IwysgMpFx0ftP7kIVLuY/eCEU++qxd2kcgKaZV9HeX4spOpbkNlLSqNT+3azHjOGYi1ItVXiG7AAtNQ09rL40lDRokplmI2aq52zNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=celHT7oO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="celHT7oO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA951F000FF;
	Thu, 17 Sep 2026 18:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671438;
	bh=L3aGQxmd8dA7jYRNEheWY7ArMypDF9YqvHdjjtKjkuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=celHT7oOh+TSLWUDL67aM2VMEUd3yNLg5pFNdIevxf8V0xplJ2kKEdl2AA42twfi1
	 z26WMfnidrnTEhQCZh3LxdeuyRNvRN3OSc/t3/93e1vajqL2ClKrt9ShEg/wcLRGFQ
	 S8OI4lTcJ6KbR5WvOVGudQvCGvslutnVStOFh+oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0977/1102] KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
Date: Thu, 17 Sep 2026 16:15:20 +0100
Message-ID: <20260917151605.224134515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit e268beee4a25ce58807a96253e95e96c2e3a5c1a ]

Mark the VMCB dirty, i.e. zero control.clean, prior to handling the new
VMSA.  Nothing in the VALID_PAGE() case touches control.clean, and
isolating the VALID_PAGE() code will allow simplifying the overall logic.

Note, the VMCB probably doesn't need to be marked dirty when the VMSA is
invalid, as KVM will disallow running the vCPU in such a state.  But it
also doesn't hurt anything.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20250227012541.3234589-9-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 42a39ad5d592 ("KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3924,6 +3924,12 @@ static int __sev_snp_update_protected_gu
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 
+	/*
+	 * When replacing the VMSA during SEV-SNP AP creation,
+	 * mark the VMCB dirty so that full state is always reloaded.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
 	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
 		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
 		struct kvm_memory_slot *slot;
@@ -3969,12 +3975,6 @@ static int __sev_snp_update_protected_gu
 		kvm_release_pfn_clean(pfn);
 	}
 
-	/*
-	 * When replacing the VMSA during SEV-SNP AP creation,
-	 * mark the VMCB dirty so that full state is always reloaded.
-	 */
-	vmcb_mark_all_dirty(svm->vmcb);
-
 	return 0;
 }
 


