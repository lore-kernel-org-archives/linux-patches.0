Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF458836;
	Tue,  8 Apr 2025 13:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117219; cv=none; b=Gldmf/4hLXT2boYm/oeTfnVHMACrC+Sgf36UQ6zqvnwT44f9TdSzvdIhbyQUoDK1Xf9AZcyY58syL5SbFzSxxYHlPMHl3gT6kF/ERy/rjdu/ti+KJvYyjq7pFYlSqDFiLybysriSaP9M4t9CeVPuSgmWLv+QgJyIJb6d0wuAv30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117219; c=relaxed/simple;
	bh=F4BKSeKIBsnvgYGLfy0hhe5Jbl1GtJ/alwGfuNCpY5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrXG57FuRpYH7FWxsU+b31QCfUyz6OzsNLhUMQI0NFPaTJCjBWW74ASH9kdkX3/tks2iumArFstev03IdnnTRQrzt7ALAam/W6ZpU2QN+p4ZymhdeT18j0z40pvJIn0AqY16QlZMkfyGbd9seC7WtK6HykD19t3lQ7qFbXke2MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k46F1wY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k46F1wY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4672C4CEE5;
	Tue,  8 Apr 2025 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117219;
	bh=F4BKSeKIBsnvgYGLfy0hhe5Jbl1GtJ/alwGfuNCpY5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k46F1wY6YJi9qRA45SMU3g+Y/fb7rXO7guH1FOK1X/jeLv0Tp7J+Nwcz7kjSc4jqz
	 CXix8heXOdmMufiMjS2ZbGgLuNlq8nBKeHeolUasamOkx+ZxKuaa/VR+Vdj/NxupTx
	 /WL0u7HO2MY36JEB3jQKvcL6qycQYbKrSo2tMxuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 393/423] KVM: SVM: Dont change target vCPU state on AP Creation VMGEXIT error
Date: Tue,  8 Apr 2025 12:51:59 +0200
Message-ID: <20250408104855.048721055@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
@@ -3957,16 +3957,12 @@ static int sev_snp_ap_creation(struct vc
 
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
@@ -4012,20 +4008,23 @@ static int sev_snp_ap_creation(struct vc
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


