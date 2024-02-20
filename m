Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304F12DF9F;
	Tue, 20 Feb 2024 21:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465275; cv=none; b=HFeEXxE0EuZ9akdunt5qz/SGZSZVZGLkmhsVt4k2AAvn/eytb+wzsEIRWGaDcCJwpiAVX8gPzYK9Fppz+6prGz8zokreZVhgsbIfruqyDf1+nTq2ll9u2uoIN7DtBdXS7UnYAEvYF2cXrXWOJ/2rWFQVJgR59bQuA/cOldHKT5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465275; c=relaxed/simple;
	bh=a4kdoG0Waco/NrTZgVg13Ikox54AHSGJvy//EckxP1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNmfz5PcPMLZrzZnBpPadBi/8/rdMH9JlxxyUfJMqI3VVNfhZ9dvQHiXJjuX/oDuulZdvH+gF6NGACvKKGElmpDMpBUecXHqfw+u0jQN3la8LUlqcOGA+gdTft2x3Ru5LZjzjIgKVZYk/l4cbrikh59juadNiPfEwAkEjs5fiuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVq/XH7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVq/XH7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0BAC433C7;
	Tue, 20 Feb 2024 21:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465275;
	bh=a4kdoG0Waco/NrTZgVg13Ikox54AHSGJvy//EckxP1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVq/XH7Zg+xwFApYRgHTrRU17wqP7u+Jvs2ssf0Ps+ZArk7N92kTn0LOS/pbhvMPU
	 iWp58KWNiNiSEO8+2o6Gi2meqRUnRmRHCmGWw4mGXnjU2GxEIUok/VqPODCoz/LSL2
	 Mvl3l9hiOOEwdnE25YJcUrDyhz8vvX5JMRaevA4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.7 262/309] KVM: arm64: Fix circular locking dependency
Date: Tue, 20 Feb 2024 21:57:01 +0100
Message-ID: <20240220205641.352173277@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ene <sebastianene@google.com>

commit 10c02aad111df02088d1a81792a709f6a7eca6cc upstream.

The rule inside kvm enforces that the vcpu->mutex is taken *inside*
kvm->lock. The rule is violated by the pkvm_create_hyp_vm() which acquires
the kvm->lock while already holding the vcpu->mutex lock from
kvm_vcpu_ioctl(). Avoid the circular locking dependency altogether by
protecting the hyp vm handle with the config_lock, much like we already
do for other forms of VM-scoped data.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240124091027.1477174-2-sebastianene@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/pkvm.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -101,6 +101,17 @@ void __init kvm_hyp_reserve(void)
 		 hyp_mem_base);
 }
 
+static void __pkvm_destroy_hyp_vm(struct kvm *host_kvm)
+{
+	if (host_kvm->arch.pkvm.handle) {
+		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
+					  host_kvm->arch.pkvm.handle));
+	}
+
+	host_kvm->arch.pkvm.handle = 0;
+	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
+}
+
 /*
  * Allocates and donates memory for hypervisor VM structs at EL2.
  *
@@ -181,7 +192,7 @@ static int __pkvm_create_hyp_vm(struct k
 	return 0;
 
 destroy_vm:
-	pkvm_destroy_hyp_vm(host_kvm);
+	__pkvm_destroy_hyp_vm(host_kvm);
 	return ret;
 free_vm:
 	free_pages_exact(hyp_vm, hyp_vm_sz);
@@ -194,23 +205,19 @@ int pkvm_create_hyp_vm(struct kvm *host_
 {
 	int ret = 0;
 
-	mutex_lock(&host_kvm->lock);
+	mutex_lock(&host_kvm->arch.config_lock);
 	if (!host_kvm->arch.pkvm.handle)
 		ret = __pkvm_create_hyp_vm(host_kvm);
-	mutex_unlock(&host_kvm->lock);
+	mutex_unlock(&host_kvm->arch.config_lock);
 
 	return ret;
 }
 
 void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 {
-	if (host_kvm->arch.pkvm.handle) {
-		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
-					  host_kvm->arch.pkvm.handle));
-	}
-
-	host_kvm->arch.pkvm.handle = 0;
-	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
+	mutex_lock(&host_kvm->arch.config_lock);
+	__pkvm_destroy_hyp_vm(host_kvm);
+	mutex_unlock(&host_kvm->arch.config_lock);
 }
 
 int pkvm_init_host_vm(struct kvm *host_kvm)


