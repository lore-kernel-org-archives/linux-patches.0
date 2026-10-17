Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672E917BED0;
	Sat, 17 Oct 2026 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253353; cv=none; b=F/W+I5RMaEyhB/IgWGvBZofZCVwXZTORtOEStB7Q5H0ZC8bRUvbE6tGvS0zOhVjEYF6vWjp51aJZgKV8ijQJvzgOpOZsZYRjSRZb0wxAlZMtZpRl/U198ihZeLfzDEqsQoEVn0U5lrCxepWHHBKvnTppEKUPyd5cngogIkuM250=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253353; c=relaxed/simple;
	bh=Afq7JRFujZgb9wqJzeNQ+p9WtRdzZZwnu8BZ9uwnfPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpFMR92mDJ2YwCfpxV4y8CR+U/x+rbKBl8I+GCg2xzg7HRN0Oj6BDxvQPzUAdKe6O4ounFGyfRbnLbgkc2u3DCE3RH8l7LHb+ILjU3pmR05NMRNITXEsL0uZ8mOPmH5BXyVViQqL+gTrzt8l390czODQ8rwHzZPbUywDTPSENBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU3tO18T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU3tO18T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A7C1F000C4;
	Sat, 17 Oct 2026 16:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253352;
	bh=oBJyuJ34+DRaHo09ch/GL+K8kE+s40easu8NqQjJ8Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UU3tO18T9eSvRxf2LlB/I4ASpXhDwvXXh4VQ/2b0nNgqZc/5tmQLGafl6NWWpWhRY
	 ZMyIwvROFn4DT8+F6kPIRb+8QAHg0t7V+Uk1djilH2HCz8uKCpCqwoZdRcoshx/B+y
	 bPfTpNrm3ad/SGEwtjtacACjQcgc62saboPohYFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/869] s390/kvm: Remove kvm_arch_fault_in_page()
Date: Sat, 17 Oct 2026 17:48:51 +0200
Message-ID: <20261017160039.342647898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit ca3c6dc3a9c520116deee7b74940835904e8ac07 ]

kvm_arch_fault_in_page() is a useless wrapper around gmap_fault(); just
use gmap_fault() directly instead.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20241022120601.167009-3-imbrenda@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 11709abccf93 ("s390/mm: Fix in_atomic() handling in do_secure_storage_access()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/intercept.c |  4 ++--
 arch/s390/kvm/kvm-s390.c  | 18 +-----------------
 arch/s390/kvm/kvm-s390.h  |  1 -
 3 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index f0be263b334ce..9c4304d484de7 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -367,7 +367,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg2, &srcaddr, GACC_FETCH, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = kvm_arch_fault_in_page(vcpu, srcaddr, 0);
+	rc = gmap_fault(vcpu->arch.gmap, srcaddr, 0);
 	if (rc != 0)
 		return rc;
 
@@ -376,7 +376,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg1, &dstaddr, GACC_STORE, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = kvm_arch_fault_in_page(vcpu, dstaddr, 1);
+	rc = gmap_fault(vcpu->arch.gmap, dstaddr, FAULT_FLAG_WRITE);
 	if (rc != 0)
 		return rc;
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0e3b8ee0ec264..61661e113873f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4582,22 +4582,6 @@ int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clo
 	return 1;
 }
 
-/**
- * kvm_arch_fault_in_page - fault-in guest page if necessary
- * @vcpu: The corresponding virtual cpu
- * @gpa: Guest physical address
- * @writable: Whether the page should be writable or not
- *
- * Make sure that a guest page has been faulted-in on the host.
- *
- * Return: Zero on success, negative error code otherwise.
- */
-long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable)
-{
-	return gmap_fault(vcpu->arch.gmap, gpa,
-			  writable ? FAULT_FLAG_WRITE : 0);
-}
-
 static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
 				      unsigned long token)
 {
@@ -4800,7 +4784,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 		if (kvm_arch_setup_async_pf(vcpu))
 			return 0;
 		vcpu->stat.pfault_sync++;
-		return kvm_arch_fault_in_page(vcpu, current->thread.gmap_addr, 1);
+		return gmap_fault(vcpu->arch.gmap, current->thread.gmap_addr, FAULT_FLAG_WRITE);
 	}
 	return vcpu_post_run_fault_in_sie(vcpu);
 }
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index e680c6bf0c9d9..0765ad1031c43 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -394,7 +394,6 @@ int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
 int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
-long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu);
-- 
2.53.0



