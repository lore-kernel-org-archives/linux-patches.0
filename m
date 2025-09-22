Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E932F39DE;
	Mon, 22 Sep 2025 19:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570295; cv=none; b=UVrCAZ8Tyr0vAcMxKjcdQernR6hx8WpblY3XbkvoXQDlB8ZPpJGcdLFtSqCXKzHytc1KX7B03Ms9UjaZf+/IC0rmI8tysObcKTvuzdKu2HO4Zg77MvjoHDXsMSf3Wv+66FTFQ3Q0V4hBCpQQZ9scKw6S/l4ORIIGcl0zFqnXNbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570295; c=relaxed/simple;
	bh=2RrojkHOcdhrTHya8xb48yLHrFdn+0KXjtWR2fuZrno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cuxo8UoPMO1XwCr1NC0ovTDOUGV3I3XEBFpFvpTPZAajxZQ9ulHnwGSA5/oy5g4m1x+5MDm+r4qQALCzUCQigt2td+6+S0VFlxJG1VrIfyrqgSSYnvRlwQoLK3X3FCzJphPvUQUT17mDmakj/QLHPpmTzLoozl5Lg9L4o48Wwzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8dc5dg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8dc5dg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D076C4CEF0;
	Mon, 22 Sep 2025 19:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570294;
	bh=2RrojkHOcdhrTHya8xb48yLHrFdn+0KXjtWR2fuZrno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8dc5dg4VjDpub/wLUHCPDqxfurcfx2w8O+W2BURzF3UPVtOjM5rbQA2AI7PY3Gip
	 T5QbrDE7WOXntCS2uMFo58wpYweLj4OlijEBqnaBk4EXhwxRxrOU7bHBNfsEGFiv4b
	 i2V1watoMP49Er1syHkqZ65XCKVDSdyjDDgyU5fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.16 093/149] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active
Date: Mon, 22 Sep 2025 21:29:53 +0200
Message-ID: <20250922192415.231702417@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4204,8 +4204,7 @@ static inline void sync_lapic_to_cr8(str
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr8;
 
-	if (nested_svm_virtualize_tpr(vcpu) ||
-	    kvm_vcpu_apicv_active(vcpu))
+	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
 	cr8 = kvm_get_cr8(vcpu);


