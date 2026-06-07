Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709441FE47B;
	Sun,  7 Jun 2026 10:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828304; cv=none; b=Pk5nfQFXxMug8UN7ETwDzJBuxdxXYw+mu+fK9mzHzUnNDLCWZSr23dFmbAvEorNmaokjJeHVFtazUJbdKw+QPqjlOsBhCpb+UpQ5AyzK7A01GqOOarvjTemItlm1ioXaGaobMX48zjPffG2T67PzQuzfG6Do81v5jELGfBisMYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828304; c=relaxed/simple;
	bh=jOwoi0R01enQSGjADRyCGon2XDtgEpV3VZGRIpACMjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzXUvPyhsASXT/HdxKdXBzk5jtUvf80dVENYwg+APDHfpYNHzWrUtTeeThJq9lLMO1aZzx/2GbTIa2nrPhxc2Jt55KZCOYVGorf0+LHIVLHotAypneg9HP6CRqLy/FXVpx92FuBmKFGHkpuFtRA6btRUaUDj3mHg7oqUn42DIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUATxnJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUATxnJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9341F00893;
	Sun,  7 Jun 2026 10:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828303;
	bh=IE4FZ0LVpUQS+ksGW+rq3c8KbjO1r9FAB/nKhlk9GaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUATxnJwt8xiKc2bzaT7XgK08MRBQIsIJIBdhlIaJgYUSrBLgI7q2A67ypQwOs6co
	 WrttJ4h4JepfiJ4SKVHm/eyB3upIjLQfwKjU2TAH/76Eg6uTXzZwlhoCDtqeK4PU3W
	 CpAdsZwdLLJuQUTvRAzeUhvEOKxS7fedq9TfTEhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 148/315] KVM: SEV: Compute the correct max length of the in-GHCB scratch area
Date: Sun,  7 Jun 2026 11:58:55 +0200
Message-ID: <20260607095733.043452488@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -3610,7 +3610,7 @@ int pre_sev_run(struct vcpu_svm *svm, in
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
-static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 min_len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
@@ -3626,10 +3626,10 @@ static int setup_vmgexit_scratch(struct
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
 
@@ -3653,6 +3653,8 @@ static int setup_vmgexit_scratch(struct
 
 		scratch_va = (void *)svm->sev_es.ghcb;
 		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
+
+		svm->sev_es.ghcb_sa_len = ghcb_scratch_end - scratch_gpa_beg;
 	} else {
 		/* GHCB v2 requires the scratch area to be within the GHCB. */
 		if (to_kvm_sev_info(svm->vcpu.kvm)->ghcb_version >= 2)
@@ -3662,16 +3664,16 @@ static int setup_vmgexit_scratch(struct
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
 
@@ -3687,11 +3689,10 @@ static int setup_vmgexit_scratch(struct
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


