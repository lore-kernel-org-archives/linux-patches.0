Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4AB2D3A69;
	Sun,  7 Jun 2026 10:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828677; cv=none; b=mUr6IrluaTs2g2K0PoCWG0u5P9FqXq/EsVyoUqPkGoIabQtwcUWb/2JBAq2oMTf0bDkVM+j4ZIv0GLTJExF077ARNSBKdgoDFmbAEW8A/Laklie+G4j5f2YHfSERpKVf8D2tytjedITWOKVMcqcszgBbj8QlOrFwtmeT0L3WBpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828677; c=relaxed/simple;
	bh=lnR2Er16dLD48nWN8Z6JVHajE9ARMLwGRaTbtsiMIaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWn6ip0zbSpsD+/G2M7rN7VHAWpe3RXcuWQmQ9aJILKgXeNBczydtSwD5UDxctlDCvA9VDdlQpIRZ13ELOPewAMl9cpkxFdyUtUG8VVkuHc9vdjBbYEQBHRM4Bio5trJFU1uY44ZbKqk2EvPzqP9xZJyPO2dqtKNYdTxTXK4ydc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StmJvIAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StmJvIAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E021F00893;
	Sun,  7 Jun 2026 10:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828675;
	bh=9NlnAAUqb6auwE63TrPwCGLw4Lm1Ek7hQQ+ky9wAgas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StmJvIAmyi+A6peCS1yc54DrqCnyxpxXZ8zhSG7cXV7Brd3ueUpCflUYO+B78TLKs
	 lBAncj0dRIzL2s8mmbebeOQdKsFDbVsJbXS0d35Z0bmwCCyeaFoorG9zNTgkNWlWd5
	 ldr4El2n/XLlD5GFf0ixSkhF6AjqiQ0ZkixgpLAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 157/307] KVM: SEV: Compute the correct max length of the in-GHCB scratch area
Date: Sun,  7 Jun 2026 11:59:14 +0200
Message-ID: <20260607095733.489207116@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

commit 5867d7e202e09f037cefe77f7af4413c7c0fa088 upstream.

When setting the length of the GHCB scratch area, and the area is in the
GHCB shared buffer, set the effective length of the scratch area to the max
possible size given the start of the guest-provided pointer, and the end of
the shared buffer.

The code was "fine" when first introduced, as KVM doesn't consult the
length of the buffer when emulating MMIO, because the passed in @len always
specifies the *max* size required.  But for PSC requests, the incoming @len
is just the minimum length (to process the header), and KVM needs to know
the full size of the scratch area to avoid buffer overflows (spoiler alert).

Opportunistically rename @len => @min_len to better reflect its role.

Fixes: 9b54e248d264 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3502,7 +3502,7 @@ void pre_sev_run(struct vcpu_svm *svm, i
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
-static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 min_len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
@@ -3518,10 +3518,10 @@ static int setup_vmgexit_scratch(struct
 		goto e_scratch;
 	}
 
-	scratch_gpa_end = scratch_gpa_beg + len;
+	scratch_gpa_end = scratch_gpa_beg + min_len;
 	if (scratch_gpa_end < scratch_gpa_beg) {
 		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
-		       len, scratch_gpa_beg);
+		       min_len, scratch_gpa_beg);
 		goto e_scratch;
 	}
 
@@ -3545,6 +3545,8 @@ static int setup_vmgexit_scratch(struct
 
 		scratch_va = (void *)svm->sev_es.ghcb;
 		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
+
+		svm->sev_es.ghcb_sa_len = ghcb_scratch_end - scratch_gpa_beg;
 	} else {
 		/* GHCB v2 requires the scratch area to be within the GHCB. */
 		if (to_kvm_sev_info(svm->vcpu.kvm)->ghcb_version >= 2)
@@ -3554,16 +3556,16 @@ static int setup_vmgexit_scratch(struct
 		 * The guest memory must be read into a kernel buffer, so
 		 * limit the size
 		 */
-		if (len > GHCB_SCRATCH_AREA_LIMIT) {
+		if (min_len > GHCB_SCRATCH_AREA_LIMIT) {
 			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
-			       len, GHCB_SCRATCH_AREA_LIMIT);
+			       min_len, GHCB_SCRATCH_AREA_LIMIT);
 			goto e_scratch;
 		}
-		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
+		scratch_va = kvzalloc(min_len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
 			return -ENOMEM;
 
-		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
+		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, min_len)) {
 			/* Unable to copy scratch area from guest */
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
@@ -3579,11 +3581,10 @@ static int setup_vmgexit_scratch(struct
 		 */
 		svm->sev_es.ghcb_sa_sync = sync;
 		svm->sev_es.ghcb_sa_free = true;
+		svm->sev_es.ghcb_sa_len = min_len;
 	}
 
 	svm->sev_es.ghcb_sa = scratch_va;
-	svm->sev_es.ghcb_sa_len = len;
-
 	return 0;
 
 e_scratch:


