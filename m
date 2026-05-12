Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5173EDE42;
	Tue, 12 May 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608699; cv=none; b=DAqLizCyaRV40CqhMMFPGtA2c07dqCqzP3n/TaBEqI+3L7nVp6wpIW8k1FrpJY3GxX5Z0m/ysuH1AOxUqvYBnKaeKlI7S7x+2fcpALaBKxW1c4nWiBavTl8pEaMut/zKknnb6T8AitArc1YMQk6Yiq2qqRxp6/yDfUn8/MiMnes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608699; c=relaxed/simple;
	bh=fu4ocS/b4alawIsdpqDyRk3H7r9IUTOcGuW0hE52P5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nN0SDhtFrxyyz+nsmqJWA44t2Jghop4lA0TdW6FsMaMDraDrM4m8P1IPMZwmr9yb3u0Q287nEPHjpHcowJEBTGOm6jFl4ASpym3BZyeaDr5FDfeC2bcRjHFLoTaAjB8DXQPk0aDRPHcWucWrO+/4wmpWYaOLCnIhujq7TBLCVKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QB/znXHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QB/znXHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3905EC2BCB0;
	Tue, 12 May 2026 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608698;
	bh=fu4ocS/b4alawIsdpqDyRk3H7r9IUTOcGuW0hE52P5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB/znXHkxRNvHiSLSpwQIk9o9n014y7JheBmutmMpiOeXzFx5UHDHD3ZIDtx59dQe
	 4f+bbdRskEnL/jK9NGPkhqlFHc7I8gaukK30ekVURrkGCZDxGXNk6z8ptMBD73cLky
	 FFDHjfDBMGNjEidquEUGMPWAcpX+AgkYwxazq7/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 181/270] KVM: x86: check for nEPT/nNPT in slow flush hypercalls
Date: Tue, 12 May 2026 19:39:42 +0200
Message-ID: <20260512173942.259550515@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -2039,7 +2039,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 	 * flush).  Translate the address here so the memory can be uniformly
 	 * read with kvm_read_guest().
 	 */
-	if (!hc->fast && is_guest_mode(vcpu)) {
+	if (!hc->fast && mmu_is_nested(vcpu)) {
 		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
 		if (unlikely(hc->ingpa == INVALID_GPA))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;


