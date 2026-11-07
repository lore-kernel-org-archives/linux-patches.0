Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061379;
	b=q/C81d8Cfp48gGN5Sporhk7+42gDIGjph8l/qNrKVU6dcQPuPGE/qF+ERUynM3j/o64Z
	 rWSnIpq793ai+yEeS5IMGWgxwJmSABF7gwXH4RzOjUjJtmxnX8ULfaZ3kCNG7ge24lbPT
	 tLOevBHVjKFpwpHZ6056DnG+Z8QIQjjMw5fXYG7LXHrazE4w/JaA3MTf65lQELQZkDxA1
	 PmLfBISjjURJ7cVUqPDmPU553mNjqIMuj+EyBgXE5Gmty5AAzkKF6AVeeWcE+T5XH/43i
	 NLOP67Pq8F2Wtf24LEiiBJr1yFeoTlJNWeKqmN1tNSm2S8bqux6xD1iGS0Kq4cWXnPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HMOkF/ah7fNtmGVvY3UIcOvh/L3VBWSU9JzsBsmEFPI=;
	b=t5VHqoauIbqD9USUt04s7mimVFTdRjDdtxpizz9/tdmeriXkusmCoXMfK3/GDBwt8Yhw
	 +chrudFiKEnEXDPSsRMlbvjjqzNttfPS1siFKG738AMPK8LOeqaK8h+cqigpX5w/UQpLj
	 ayWCsg2SE71FH6l2ZpWSGgHrSpck/Tg9K3mlItKl66EOY/Aa+vcmtJbZY7+4DPVaLMdCB
	 W9MVJgC4lx+Gh3cw7s0ZFHuJCSteZ4aH/aGgqPYnu7J29V4/NHB7GTIRG8HG+Fv/SlaRx
	 E2vOA/7mbwcS0KpjeHoDR2NeMYkko1XmKn+f8/t+GM4H1FZa/ekt4SSicBrLxeiJxIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GCpPqo5y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EED6606A339;
	Sat,  7 Nov 2026 14:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GCpPqo5y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00B21F0089F;
	Sat,  7 Nov 2026 14:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061379;
	bh=HMOkF/ah7fNtmGVvY3UIcOvh/L3VBWSU9JzsBsmEFPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCpPqo5yKlsjX/YIegSeLj9G0jisNcxV6oLavt7LkVP2fekx/O92JXyPhOsxLpf4T
	 EXsNarYr6JKhUS828mQ4pk/bAd58757YCuzvoeXVXPwcn2KpdiwsNRaNdl7/C2nCtP
	 hTK7MnhoZrBw6Ygi09KjPxcQOqPKT5esRYn71Ohw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0453/1536] KVM: SEV: Mark vCPU RUNNABLE after AP_CREATE, even if VMSA is unusable
Date: Sat,  7 Nov 2026 08:41:09 -0500
Message-ID: <20261107135010.256051741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 98ade8c48c28c227fe2e80e545ff0c57cd4712a3 ]

Always mark the vCPU as RUNNABLE after responding to AP_CREATE, even if the
guest-specified VMSA is unusable, e.g. isn't backed by a memslot or doesn't
have a backing guest_memfd page.  If the VMSA is unusable, leaving the vCPU
in a non-running state will effectively hang the vCPU instead of reporting
an error to userspace.  This will also allow retrying the VMSA load in the
future, to fix a bug where KVM doesn't honor guest_memfd invalidation
events, e.g. if AP_CREATION races with PUNCH_HOLE.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Replaced the missing kvm_set_mp_state() helper with open-coded pv_unhalted/mp_state assignments, and the function is non-static in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e7f20e1b8d86f..2c6122bc90d76 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3988,10 +3988,6 @@ static void sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	svm->sev_es.snp_guest_vmsa_gpa = gpa;
 	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
-	/* Mark the vCPU as runnable */
-	vcpu->arch.pv.pv_unhalted = false;
-	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-
 	/*
 	 * gmem pages aren't currently migratable, but if this ever changes
 	 * then care should be taken to ensure svm->sev_es.vmsa is pinned
@@ -4026,6 +4022,17 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
 
 	sev_snp_reload_vmsa(vcpu, gpa);
+
+	/*
+	 * Mark the vCPU as runnable for CREATE requests, indicated by a valid
+	 * VMSA GPA, even if installing the VMSA failed, so that KVM_RUN will
+	 * fail instead of blocking indefinitely and hanging the vCPU, e.g. if
+	 * the backing guest_memfd page is unavailable.
+	 */
+	if (VALID_PAGE(gpa)) {
+		vcpu->arch.pv.pv_unhalted = false;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	}
 }
 
 static int sev_snp_ap_creation(struct vcpu_svm *svm)
-- 
2.53.0



