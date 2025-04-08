Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138052192F2;
	Tue,  8 Apr 2025 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112158; cv=none; b=Ivn8ImjSMNgLOcTCqXQnv2W6bzOesphqqEoZtLS/RbtK/8OyOzGgFvDybDcI6UVJc0h3iVUDbILFGnBZ+FGXn7wWP9I1Wxn4ssVj+q1zeoQ0SsWzpxcoPOEAeiqu8cp9AIvjZg0xjx9UCKMODilcUBIwRjq/+MTHNOtOE6oPKTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112158; c=relaxed/simple;
	bh=a736okLsGGKa1D7Stk4qa0Ohyr1C5L77bANUWQdqKzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb/EVfWwQiNyqc1wkzg4F+CIOT3YvxNW7/VTWPaw88B6x/rVJIqjhZNlyGEQ3QFB7Q40lvYP8PdPQ7mQIqAW8F0ENn0JoK31vP9oYJAoKSsQFSYp6SJGI7Mwd7MEaXRYnAV+nbWUv2uGLwEX+g4ABG/YdoRmEN8MT9CwWQGhkvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLI7ZqhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLI7ZqhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985D6C4CEE7;
	Tue,  8 Apr 2025 11:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112157;
	bh=a736okLsGGKa1D7Stk4qa0Ohyr1C5L77bANUWQdqKzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLI7ZqhPMzzMM/hczXIQzMRgsGCrc0CzI/2Qu92UVfNBs3MdhsJxmq0hBQLZPxxj7
	 OFnXm9VVtmwA6jVsWQQSSO0haRaNUyxQagJpxmgaDyezuX2dpYo3ajLYfZKKwWll+U
	 0S2DXxo2IRnw0GhgOT0stF1imlzxHeszqky4MjHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.14 697/731] KVM: SVM: Dont change target vCPU state on AP Creation VMGEXIT error
Date: Tue,  8 Apr 2025 12:49:54 +0200
Message-ID: <20250408104930.481253465@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit d26638bfcdfc5c8c4e085dc3f5976a0443abab3c upstream.

If KVM rejects an AP Creation event, leave the target vCPU state as-is.
Nothing in the GHCB suggests the hypervisor is *allowed* to muck with vCPU
state on failure, let alone required to do so.  Furthermore, kicking only
in the !ON_INIT case leads to divergent behavior, and even the "kick" case
is non-deterministic.

E.g. if an ON_INIT request fails, the guest can successfully retry if the
fixed AP Creation request is made prior to sending INIT.  And if a !ON_INIT
fails, the guest can successfully retry if the fixed AP Creation request is
handled before the target vCPU processes KVM's
KVM_REQ_UPDATE_PROTECTED_GUEST_STATE.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Link: https://lore.kernel.org/r/20250227012541.3234589-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3969,16 +3969,12 @@ static int sev_snp_ap_creation(struct vc
 
 	/*
 	 * The target vCPU is valid, so the vCPU will be kicked unless the
-	 * request is for CREATE_ON_INIT. For any errors at this stage, the
-	 * kick will place the vCPU in an non-runnable state.
+	 * request is for CREATE_ON_INIT.
 	 */
 	kick = true;
 
 	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
 
-	target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
-	target_svm->sev_es.snp_ap_waiting_for_reset = true;
-
 	/* Interrupt injection mode shouldn't change for AP creation */
 	if (request < SVM_VMGEXIT_AP_DESTROY) {
 		u64 sev_features;
@@ -4024,20 +4020,23 @@ static int sev_snp_ap_creation(struct vc
 		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
 		break;
 	case SVM_VMGEXIT_AP_DESTROY:
+		target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
 		break;
 	default:
 		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
 			    request);
 		ret = -EINVAL;
-		break;
+		goto out;
 	}
 
-out:
+	target_svm->sev_es.snp_ap_waiting_for_reset = true;
+
 	if (kick) {
 		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
 		kvm_vcpu_kick(target_vcpu);
 	}
 
+out:
 	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
 
 	return ret;


