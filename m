Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3E93EDE4F;
	Tue, 12 May 2026 17:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608067; cv=none; b=Y0rKyrw7L062Mppbn8fPIahRpyTPdE2q2hBFp7mFBx2h8o7mE7Lnbtlrx32/E1nbLUQOjDAjmQU5D7fBJtQHe8yHJMJY4EJxcdzpcGb+JuW9pztXhfEW0yEX2wg9f9Hn1sjMf9Pnt/aQ60EEFJoB5lBAFokAXokmRHNzOT837G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608067; c=relaxed/simple;
	bh=GLgvA5C8PXmJmqsN5424rjtZK8s2O0tEHWSzt0R4OSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw4QvB39FLti2EXr6GxJRp8e/usqPepHltmn+krWId2B5cp7AFRKQBNbx2gz5N3giUZ8RxBEKiWUCZCBMUjrE5HIL/7iCkL2iaxpQP+cb/vjJa4uq01V0r8EnCUQf2nbr1iPDQ0onyWovekkRzlEPNhg9HIVhuN5IM4rVNEYVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F01FfwXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F01FfwXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CEAC2BCB0;
	Tue, 12 May 2026 17:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608066;
	bh=GLgvA5C8PXmJmqsN5424rjtZK8s2O0tEHWSzt0R4OSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F01FfwXtJdrr9+qTMEXjZ3++OzVuv/l+vlmCPEQdIlMa+KvGrPK1JvpB4hibDmu3z
	 rH8CNUFGdzoVI0+iRWT3YtYEoESWYQ8WmX7LWd+0wGiAYQtW+aBsZ/Tu+dhtkaXTEq
	 te7Fsx4nmTqvSeoKrR3N6hs1ABysvI4WdFBwDPCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 141/206] KVM: x86: check for nEPT/nNPT in slow flush hypercalls
Date: Tue, 12 May 2026 19:39:53 +0200
Message-ID: <20260512173935.847148099@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
@@ -2038,7 +2038,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 	 * flush).  Translate the address here so the memory can be uniformly
 	 * read with kvm_read_guest().
 	 */
-	if (!hc->fast && is_guest_mode(vcpu)) {
+	if (!hc->fast && mmu_is_nested(vcpu)) {
 		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
 		if (unlikely(hc->ingpa == INVALID_GPA))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;


