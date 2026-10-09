Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258914E4C5E;
	Fri,  9 Oct 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557365; cv=none; b=KlowNSFgyc1D7To+9z/r+2KzVK26AraW+ofq8/4qkbbyz05QMP+FEfjrsn+fixrX+2I7TKb5dkEsJvbvOVQKKfHualtnN2fCpIO6tp+nxEKSnG1mT+xDGT/p8F/pVvxBGjDe03BR7C2ImA6LjZGiBbbiLf4j4NErh4b7AO7g5XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557365; c=relaxed/simple;
	bh=bWROYkNpsMuRsgZsxO2xtofub8BLHcAGFZ4QrYRNENM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGXcXj5Q7M0seyepDpcb+BUvTBiRB0himV+Vpie8ESo7VeS9jpoWJcEK9gubA6Uxyflyr0YeERMKCLbsPo2NQWfsFX4FOjN+K2adqhbHGO/C2yQR62VwuyE1hK5o2+pOQT13TlPutT16Ugl39Qt0YB6K2J/L/cDkxp+xwZYM9C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7ehR/KD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7ehR/KD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803AF1F000FF;
	Fri,  9 Oct 2026 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557364;
	bh=IY1IKI+erLZPSkBthF/EDxBB2okVA6XqNQ0NJ2xFp3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7ehR/KD7pybL0/N0FdpHu5yHn7vNWSBJo8d5wpxoCfSqn0OcpcraRfGyCMABCZ5+
	 h6nvUeEDWcEw1fwEJPC/JnMO+xGudHTrnXMS6GFT3G3gYZuGe4NoCIR87odvBWJ25u
	 xdkRZJLQnOwzMFeVW8UxJs+VLAN+hsIUoHzPZgBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Bot <sashiko-bot@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 312/428] KVM: SEV: Nullify "have run CPUs" mask pointer when freeing it
Date: Fri,  9 Oct 2026 16:10:49 +0200
Message-ID: <20261009140952.977551761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 8abbc76120a74bfba1851bd97528099d715e45c6 upstream.

Nullify have_run_cpus when freeing the mask, particularly in the error path
of __sev_guest_init(), so that KVM doesn't have to subtly use sev->active
to track whether or not the mask has been freed.  As pointed out by Sashiko,
blindly freeing the mask in sev_vm_destroy() results in a double-free if
the mask is freed if __sev_guest_init() fails.

Throw the logic in a helper as nullifying the pointer is frustratingly
difficult and weird due to have_run_cpus being a single-entry array when
CPUMASK_OFFSTACK=n.  Deliberately don't use CPUMASK_VAR_NULL, as it's not
directly assignable when the cpumask is on-stack, e.g. requires using a
local variable and a memcpy(), which is beyond ridiculous.  Furthermore,
while clearing the on-stack bitmask is an unnecessary and arguably unwanted
side effect, KVM absolutely relies on '0' being the "null" value given that
the struct is zero-allocated.

Opportunistically add an alloc() helper to pair with free(); there are just
enough call sites to make doing so worthwhile.

Fixes: 12c1f6e03f94 ("KVM: SEV: Free have_run_cpus during VM destruction even if VM is no longer SEV")
Cc: stable@vger.kernel.org
Reported-by: Sashiko Bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260923165349.CAAF01F000FF@smtp.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260928154644.2559454-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -488,6 +488,20 @@ static void snp_guest_req_cleanup(struct
 	sev->guest_resp_buf = NULL;
 }
 
+static int sev_alloc_have_run_cpus(struct kvm_sev_info *sev)
+{
+	if (!zalloc_cpumask_var(&sev->have_run_cpus, GFP_KERNEL_ACCOUNT))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void sev_free_have_run_cpus(struct kvm_sev_info *sev)
+{
+	free_cpumask_var(sev->have_run_cpus);
+	memset(&sev->have_run_cpus, 0, sizeof(sev->have_run_cpus));
+}
+
 static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 			    struct kvm_sev_init *data,
 			    unsigned long vm_type)
@@ -545,10 +559,9 @@ static int __sev_guest_init(struct kvm *
 	if (ret)
 		goto e_free_asid;
 
-	if (!zalloc_cpumask_var(&sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
-		ret = -ENOMEM;
+	ret = sev_alloc_have_run_cpus(sev);
+	if (ret)
 		goto e_free_asid;
-	}
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (snp_active) {
@@ -566,7 +579,7 @@ static int __sev_guest_init(struct kvm *
 	return 0;
 
 e_free:
-	free_cpumask_var(sev->have_run_cpus);
+	sev_free_have_run_cpus(sev);
 e_free_asid:
 	argp->error = init_args.error;
 	sev_asid_free(sev);
@@ -2198,10 +2211,9 @@ int sev_vm_move_enc_context_from(struct
 	 * does not, i.e. KVM could skip flushes if memory is reclaimed from
 	 * the old VM but not the new VM.
 	 */
-	if (!zalloc_cpumask_var(&dst_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
-		ret = -ENOMEM;
+	ret = sev_alloc_have_run_cpus(dst_sev);
+	if (ret)
 		goto out_source_vcpu;
-	}
 
 	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
@@ -2899,10 +2911,9 @@ int sev_vm_copy_enc_context_from(struct
 	}
 
 	mirror_sev = to_kvm_sev_info(kvm);
-	if (!zalloc_cpumask_var(&mirror_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
-		ret = -ENOMEM;
+	ret = sev_alloc_have_run_cpus(mirror_sev);
+	if (ret)
 		goto e_unlock;
-	}
 
 	/*
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
@@ -2995,7 +3006,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	 * Free the mask even if the VM is not *currently* an SEV VM, as it may
 	 * have been an SEV VM prior to intra-host migration.
 	 */
-	free_cpumask_var(sev->have_run_cpus);
+	sev_free_have_run_cpus(sev);
 
 	if (!sev_guest(kvm))
 		return;


