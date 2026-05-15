Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831A8303CB0;
	Fri, 15 May 2026 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861291; cv=none; b=qsm1mL7Whooomr6eXOPpnngnU9a2lPz3N0TVU5k/ulwrJNVanGJKvODtIWXJ+AujVlVwdA+5Vkp/yLRKDKTBetkeqGPeZ8OgxiaDZ3uXfT+IduTEaSYG53WFn5a//MOjQXsAjj7WlSGg6qHf2JXIuHpy32Nr3LHenVlSQK5cjlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861291; c=relaxed/simple;
	bh=8bYbRjk/pqRXLl6vKjMJMXNAhCh8X+eGptjoe+d5TA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgQC7OZgn7Vu0Y+UwZySYpvY8bBFNfhPIZMIhRsQ8+3yVunOpXANrwhGMrcxTQEC5xOstiz1yqTC97HkAfPgIHDpIoQ/Gw1h0URbDii99E0PFf42RYwJKk2e18Wq4WefJgh2jGq02tk3KjCG2WctJZOmXerWKBrcJMPH0ZhQdLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhXtyrql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhXtyrql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AE9C2BCB0;
	Fri, 15 May 2026 16:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861291;
	bh=8bYbRjk/pqRXLl6vKjMJMXNAhCh8X+eGptjoe+d5TA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhXtyrqlL+y9Tb51FVbRgIoyNscCyrEukeNjXTOK4vUYAigG2tj58VC23DbgpJTkC
	 4oxK1si72tYEqKFPySeCAGMMwEcETCcTV5mgvZF54I1yHN/wmwX6TY0EkbtwW83D8t
	 4eyzGN2MMLsaK1oL0SbPduH+4gCRdaS9CCZoNiaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 272/474] KVM: x86: check for nEPT/nNPT in slow flush hypercalls
Date: Fri, 15 May 2026 17:46:21 +0200
Message-ID: <20260515154720.887253692@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -1987,7 +1987,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 	 * flush).  Translate the address here so the memory can be uniformly
 	 * read with kvm_read_guest().
 	 */
-	if (!hc->fast && is_guest_mode(vcpu)) {
+	if (!hc->fast && mmu_is_nested(vcpu)) {
 		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
 		if (unlikely(hc->ingpa == INVALID_GPA))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;


