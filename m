Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813B02F0C52;
	Mon, 22 Sep 2025 19:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569936; cv=none; b=ppHDldecxrzVsRcKf26FSGgrSrYzHgmkkfr+ik4aGIkIDUzePTFesrG1wd8JRdFQia64+dAcGKaQKwu7MtE7iUq5HCkmqY547O7StJTRic/p0HyDJt8+A8gC2jwE7rodNHyQRxaF/b+rQJiiTSdriW1HJ8/53JOmc4DcIOiUhZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569936; c=relaxed/simple;
	bh=JbAR2i1tLG0qgor1eEXXWmayOC8Zpkg+6vTop9Rd2Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6GsXVhaF3phAowdrT9Du80eVEVO6bDuTb1ls/x6bZpMFiFbh4qjCvwlZh8lntOuDmvPa6B0u5mrkMgnjEkEUX3rA+URSNJ/mf31fp4c7x81xexgaTdy6K0qVtqJih8wBaruLMwqvxNpAFXSZk4YCKimOgf4D7AHd8rR+MnCla0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOAJXilY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOAJXilY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B87DC4CEF0;
	Mon, 22 Sep 2025 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569936;
	bh=JbAR2i1tLG0qgor1eEXXWmayOC8Zpkg+6vTop9Rd2Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOAJXilY97VLf6Kb2RnJbGP0xdVDhxrGeRaY+OmSEk5yXAovWnmVdYOpieDlSjp9H
	 0u0ZX2tiXxAFf3QEkbUeR1r2q8auvX5Xd9EkG1LDSUvSuXG2kKETR+QRy6H+2Vg0As
	 8//WDjCKahoIfTHNMraHMdyQFaPZSn18P5b5vOTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 058/105] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active
Date: Mon, 22 Sep 2025 21:29:41 +0200
Message-ID: <20250922192410.436237046@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

commit d02e48830e3fce9701265f6c5a58d9bdaf906a76 upstream.

Commit 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
inhibited pre-VMRUN sync of TPR from LAPIC into VMCB::V_TPR in
sync_lapic_to_cr8() when AVIC is active.

AVIC does automatically sync between these two fields, however it does
so only on explicit guest writes to one of these fields, not on a bare
VMRUN.

This meant that when AVIC is enabled host changes to TPR in the LAPIC
state might not get automatically copied into the V_TPR field of VMCB.

This is especially true when it is the userspace setting LAPIC state via
KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
VMCB.

Practice shows that it is the V_TPR that is actually used by the AVIC to
decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
so any leftover value in V_TPR will cause serious interrupt delivery issues
in the guest when AVIC is enabled.

Fix this issue by doing pre-VMRUN TPR sync from LAPIC into VMCB::V_TPR
even when AVIC is enabled.

Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://lore.kernel.org/r/c231be64280b1461e854e1ce3595d70cde3a2e9d.1756139678.git.maciej.szmigiero@oracle.com
[sean: tag for stable@]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4044,8 +4044,7 @@ static inline void sync_lapic_to_cr8(str
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr8;
 
-	if (nested_svm_virtualize_tpr(vcpu) ||
-	    kvm_vcpu_apicv_active(vcpu))
+	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
 	cr8 = kvm_get_cr8(vcpu);


