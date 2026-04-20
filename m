Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC3833DEFE;
	Mon, 20 Apr 2026 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699934; cv=none; b=JqwoSazKse/FNYLrsTSlyJoeFXXlqBglVFHr0Cl26jTtedQ8OwnkhsUIElY2LlNAZdtiJWVg7lUKODsWKtp4GUhMyQgNZe3WXC748pQ175m8teHnAanSy5zGGAjzqs6yiTaodDT+DqbHoEVVYsd1YlgrAVVJFwtk+EfRlWSI3+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699934; c=relaxed/simple;
	bh=s9aTqRXBR9Le3zLLWEd/cOk8pnWJCx0H/9ymnJ8P764=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjSJsGCTT2zV8N2M9XO9GtuC5gHXtx8+DRSeCWRoYeUhAQ8PMVAutSOsD54Tvy2jDq+RwjsVBPobkyvhTsrrABu7doX4aTh0SMmHTMgUiK+eeLu/6+Hj35d6b7Ytx5rHju2TWGQck4yI22kTcJMXErCfhT4SQBzZLqbsf3ev5MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfQmU44z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfQmU44z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52274C19425;
	Mon, 20 Apr 2026 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699934;
	bh=s9aTqRXBR9Le3zLLWEd/cOk8pnWJCx0H/9ymnJ8P764=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfQmU44zQFryjkLLNkLsuNBI9oiB4ZeMzgSfgau72CcYKIsPc8wJ9ZO6eP/7TwuS/
	 nRPqPHhgcrUj8n5UrPrRz5+234aAYN0eLrU2N4ThyW2Yz+nz2CFVx0ksX+4NbreMEw
	 2xeeGx6I4nmqhGF3MZuw3L3S4VCIs4jTmgWTW7Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 54/76] KVM: SEV: Lock all vCPUs when synchronzing VMSAs for SNP launch finish
Date: Mon, 20 Apr 2026 17:42:05 +0200
Message-ID: <20260420153912.788903857@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -882,6 +882,8 @@ static int sev_es_sync_vmsa(struct vcpu_
 	u8 *d;
 	int i;
 
+	lockdep_assert_held(&vcpu->mutex);
+
 	if (vcpu->arch.guest_state_protected)
 		return -EINVAL;
 
@@ -2456,6 +2458,10 @@ static int snp_launch_update_vmsa(struct
 	if (kvm_is_vcpu_creation_in_progress(kvm))
 		return -EBUSY;
 
+	ret = kvm_lock_all_vcpus(kvm);
+	if (ret)
+		return ret;
+
 	data.gctx_paddr = __psp_pa(sev->snp_context);
 	data.page_type = SNP_PAGE_TYPE_VMSA;
 
@@ -2465,12 +2471,12 @@ static int snp_launch_update_vmsa(struct
 
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
@@ -2479,7 +2485,7 @@ static int snp_launch_update_vmsa(struct
 		if (ret) {
 			snp_page_reclaim(kvm, pfn);
 
-			return ret;
+			goto out;
 		}
 
 		svm->vcpu.arch.guest_state_protected = true;
@@ -2493,7 +2499,9 @@ static int snp_launch_update_vmsa(struct
 		svm_enable_lbrv(vcpu);
 	}
 
-	return 0;
+out:
+	kvm_unlock_all_vcpus(kvm);
+	return ret;
 }
 
 static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)


