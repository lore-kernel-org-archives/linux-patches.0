Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF553D954E;
	Thu, 17 Sep 2026 18:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671446; cv=none; b=KRGlvB45b5DeFX8lSYU2qzAonlz4/LOspqKnC3fts7tK3gJGEX25jt6RHh9mnSrJfJzB83/748+HR8sYupwLwvr2C9DFHjCuKHpa6P6ATJNDZX+LlfETdpT3fotA8lhRRQhQzj/tDKkXEbpKjJkrfZFUet87vHp/cMQAMakCRpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671446; c=relaxed/simple;
	bh=yFBp5xIGJCNA67xHssz8k5IKYb3Ho1uNXJQkxaO0A/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW1N0TDmBm1FPeCJCMjxST6PVPOmAALvQBBN6K6FaS9xch1srQWfD8myt4nD1NUNOeOmmGNdTXi63FS+umS13LqKqYiDMZiuzV7Gldk3sKYX2Z6Kn51fOTH12cIPzYLawbjybo+C2zWzCHh5XG1tYs/dsZ0GvsQKBhIw8rFuTtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhPkS6HC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhPkS6HC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC95C1F000FF;
	Thu, 17 Sep 2026 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671444;
	bh=37JiDq/HxLQ5Qc6QwGwYKDdxykDYZEIVCkx9blY77R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhPkS6HCcR1nzGtM+zw+Y+oscfX+RxFYgkkCKE7WWkaJoeqNa8j5vqb0RQxkxktSJ
	 PFXdDNxbt0yVlARdOF1VdJCiWZrQMWCEjhhYvrODAVxXJiRhWWviGl+lrXDcaobo82
	 A0KUFaLYNgZ2s2W9tOL4th6wTBsc1shrsGfsbBa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0979/1102] KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure
Date: Thu, 17 Sep 2026 16:15:22 +0100
Message-ID: <20260917151605.274814495@linuxfoundation.org>
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

[ Upstream commit 4e96f010afb2815e33c9b15a695e0e0b4cb3cea6 ]

When processing an SNP AP Creation event, invalidate the "next" VMSA GPA
even if acquiring the page/pfn for the new VMSA fails.  In practice, the
next GPA will never be used regardless of whether or not its invalidated,
as the entire flow is guarded by snp_ap_waiting_for_reset, and said guard
and snp_vmsa_gpa are always written as a pair.  But that's really hard to
see in the code.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20250227012541.3234589-11-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 42a39ad5d592 ("KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3948,6 +3948,7 @@ void sev_snp_init_protected_guest_state(
 		return;
 
 	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
+	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
 
 	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!slot)
@@ -3978,8 +3979,6 @@ void sev_snp_init_protected_guest_state(
 	vcpu->arch.pv.pv_unhalted = false;
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
-	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
-
 	/*
 	 * gmem pages aren't currently migratable, but if this ever changes
 	 * then care should be taken to ensure svm->sev_es.vmsa is pinned


