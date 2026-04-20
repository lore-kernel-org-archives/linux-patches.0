Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6A933F8DC;
	Mon, 20 Apr 2026 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701069; cv=none; b=LPZgQGqsQLLeNFVuTwN/W5m2eAJVUeuuEYGLMEhp3NP4c1ZimE6ZTGc4ShVNDqF41Ivy3bki/w1as9mPmR6SZPFfhAiBtOs8Crh9OZ9tfBPVoaWwfLNFQlSrAkU13ayT9Foyj882dbj6Z27+SuhYi/61v5O4GW20G4aWN5cbIWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701069; c=relaxed/simple;
	bh=lTB3J1MGtp7wjefclh2cgeN+uBDwCyBQO/kgj90neYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oyz86RVvHiRKa82iZVZg7XfeuXIDyPd4XoiofAnYLOIkpEhoyeQKgoYPxwV6RZWiOSEriWdCDExW+xWIXAipoAAWTT9qJ4GYsbxf/oCXGaaJiPjxi8Iy7mLNHMfH+Y8TCfYhjE47/HU401d8SrMduCP6/y4AmPDm2EuRxPg56QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfQLUr8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfQLUr8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4002BC19425;
	Mon, 20 Apr 2026 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701069;
	bh=lTB3J1MGtp7wjefclh2cgeN+uBDwCyBQO/kgj90neYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfQLUr8YPLrv1fbwJPEFcpzogw+zuOJ5rnwhOUq/2PN2jnUQpNF86/KY6NHJF6bjF
	 jYflQqVw2pORhRFee8kregrmvhK+ZEITEjxd/X/zSi3oL76R0qRNBgivbb5fw//TDv
	 FO0+GfEizJiIYDfkf8HcOw9MpoCJe/dMpZ5CfMwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 169/198] KVM: SEV: Lock all vCPUs when synchronzing VMSAs for SNP launch finish
Date: Mon, 20 Apr 2026 17:42:28 +0200
Message-ID: <20260420153941.695647303@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

commit cb923ee6a80f4e604e6242a4702b59251e61a380 upstream.

Lock all vCPUs when synchronizing and encrypting VMSAs for SNP guests, as
allowing userspace to manipulate and/or run a vCPU while its state is being
synchronized would at best corrupt vCPU state, and at worst crash the host
kernel.

Opportunistically assert that vcpu->mutex is held when synchronizing its
VMSA (the SEV-ES path already locks vCPUs).

Fixes: ad27ce155566 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260310234829.2608037-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -871,6 +871,8 @@ static int sev_es_sync_vmsa(struct vcpu_
 	u8 *d;
 	int i;
 
+	lockdep_assert_held(&vcpu->mutex);
+
 	if (vcpu->arch.guest_state_protected)
 		return -EINVAL;
 
@@ -2452,6 +2454,10 @@ static int snp_launch_update_vmsa(struct
 	if (kvm_is_vcpu_creation_in_progress(kvm))
 		return -EBUSY;
 
+	ret = kvm_lock_all_vcpus(kvm);
+	if (ret)
+		return ret;
+
 	data.gctx_paddr = __psp_pa(sev->snp_context);
 	data.page_type = SNP_PAGE_TYPE_VMSA;
 
@@ -2461,12 +2467,12 @@ static int snp_launch_update_vmsa(struct
 
 		ret = sev_es_sync_vmsa(svm);
 		if (ret)
-			return ret;
+			goto out;
 
 		/* Transition the VMSA page to a firmware state. */
 		ret = rmp_make_private(pfn, INITIAL_VMSA_GPA, PG_LEVEL_4K, sev->asid, true);
 		if (ret)
-			return ret;
+			goto out;
 
 		/* Issue the SNP command to encrypt the VMSA */
 		data.address = __sme_pa(svm->sev_es.vmsa);
@@ -2475,7 +2481,7 @@ static int snp_launch_update_vmsa(struct
 		if (ret) {
 			snp_page_reclaim(kvm, pfn);
 
-			return ret;
+			goto out;
 		}
 
 		svm->vcpu.arch.guest_state_protected = true;
@@ -2489,7 +2495,9 @@ static int snp_launch_update_vmsa(struct
 		svm_enable_lbrv(vcpu);
 	}
 
-	return 0;
+out:
+	kvm_unlock_all_vcpus(kvm);
+	return ret;
 }
 
 static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)


