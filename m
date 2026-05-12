Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64F23EDE68;
	Tue, 12 May 2026 18:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609486; cv=none; b=fn7DzbRrUZGHfPzgPG0WFADfbL98E1lSHSbTDeLHERBuE074LVL/pp5Fo/XSbCUYsdtgYCqliTS3/+eoZ9IFCrqJTNA0VzKWUUJUnugBmzoERQJyrdNirDdw0++vKNLzaUix7t2gDvRoO38gOKC3vT33quHi0JHTwrc3/1ENqU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609486; c=relaxed/simple;
	bh=BH7nrwUaz73ygRv8Xs49j0NuzQRP8PXT+o6B3YWkaDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Euj4NuTb1OX6Puo+vCZ4cDnI0cn43ywB1EI3QAspLPTAUC+xIR2kW6FgnwqCywQMhHm772+tFQ+q6IE7VSVwi+hN30gZVl70lb3+SUEwA1DPqGrQAgPbS6ndi+O2AxKDTmVzLCjkxtgOQQwvJ3E1F99bIclpQGM6IrV0ybenpDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ns8yaYq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ns8yaYq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCB6C2BCB0;
	Tue, 12 May 2026 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609486;
	bh=BH7nrwUaz73ygRv8Xs49j0NuzQRP8PXT+o6B3YWkaDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ns8yaYq12VHJNYqlo7PzChHZZBQ7TYZD7KSOJRm6Six3C4x3IloYLBxcxcey+5r1x
	 Z7oyGZYzxZ77Wz+2JbPInlesO4BoguLqbmiLJ1IeQtEM/E0rKov7eVjsUW6NzuSDIr
	 Bo3W4fmSZ72bbNhlsh77t3U5oVQwapZ5JJezfT/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.0 215/307] KVM: x86: check for nEPT/nNPT in slow flush hypercalls
Date: Tue, 12 May 2026 19:40:10 +0200
Message-ID: <20260512173944.653279402@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 464af6fc2b1dcc74005b7f58ee3812b17777efee upstream.

Checking is_guest_mode(vcpu) is incorrect, because translate_nested_gpa()
is only valid if an L2 guest is running *with nested EPT/NPT enabled*.
Instead use the same condition as translate_nested_gpa() itself.

Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Fixes: aee738236dca ("KVM: x86: Prepare kvm_hv_flush_tlb() to handle L2's GPAs", 2022-11-18)
Link: https://patch.msgid.link/20260503200905.106077-1-pbonzini@redhat.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2040,7 +2040,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 	 * flush).  Translate the address here so the memory can be uniformly
 	 * read with kvm_read_guest().
 	 */
-	if (!hc->fast && is_guest_mode(vcpu)) {
+	if (!hc->fast && mmu_is_nested(vcpu)) {
 		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
 		if (unlikely(hc->ingpa == INVALID_GPA))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;


