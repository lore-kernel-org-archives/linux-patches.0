Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30F8355049;
	Fri, 15 May 2026 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860828; cv=none; b=Eu8b1xRE+z1AEpSBBLNMcGaOU5RgQxSj6juRMU0E+eB4KhPKCFFcMKwUWw0OH/WxuYG6xXHvTUkbtyHaat9FZGShV20MU30TL9HvIRUhWF4DjukBErqQmTGY8+82piCzFN7x7wsj/xZ8AqlRBnga8FExHn9pEADcwKwUXYRkesc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860828; c=relaxed/simple;
	bh=vCTNRskmXZF872NfkVS9LZ98SD381s3m076/BvtEKks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Byx1JYRyTd1p/meCY3EmRQZdqJWhoryy85J5HpVt1J7Kpk1JUiJsSdqFWq6E2tdjDip4SiIt1myf+ZIGZ+X95nACpQv9DYN6+O23kBFVgtPihmUGrF5kxB750/Ap1AZLNKV37esR809m2Ntpo5DycNfQsHZiQo0j+2bBGnkzL78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndCxt9B6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndCxt9B6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D4FC2BCB0;
	Fri, 15 May 2026 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860828;
	bh=vCTNRskmXZF872NfkVS9LZ98SD381s3m076/BvtEKks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndCxt9B68OtA21US6UOYgkznbjXI2fr0L5mZEG63J4ubizn0UjkDiWRNcVleU3lGv
	 rwU/7lfvKISPOODGlllneqvsU8h0p/+fuizfzKZJrcgjrfntBeN/RnSXJXmbC9eWZ0
	 btA1gRrT2GzCZWcfbKx5ijfXSZoRATQyzAlmj6GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 094/474] KVM: x86: Defer non-architectural deliver of exception payload to userspace read
Date: Fri, 15 May 2026 17:43:23 +0200
Message-ID: <20260515154717.073265590@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit d0ad1b05bbe6f8da159a4dfb6692b3b7ce30ccc8 upstream.

When attempting to play nice with userspace that hasn't enabled
KVM_CAP_EXCEPTION_PAYLOAD, defer KVM's non-architectural delivery of the
payload until userspace actually reads relevant vCPU state, and more
importantly, force delivery of the payload in *all* paths where userspace
saves relevant vCPU state, not just KVM_GET_VCPU_EVENTS.

Ignoring userspace save/restore for the moment, delivering the payload
before the exception is injected is wrong regardless of whether L1 or L2
is running.  To make matters even more confusing, the flaw *currently*
being papered over by the !is_guest_mode() check isn't even the same bug
that commit da998b46d244 ("kvm: x86: Defer setting of CR2 until #PF
delivery") was trying to avoid.

At the time of commit da998b46d244, KVM didn't correctly handle exception
intercepts, as KVM would wait until VM-Entry into L2 was imminent to check
if the queued exception should morph to a nested VM-Exit.  I.e. KVM would
deliver the payload to L2 and then synthesize a VM-Exit into L1.  But the
payload was only the most blatant issue, e.g. waiting to check exception
intercepts would also lead to KVM incorrectly escalating a
should-be-intercepted #PF into a #DF.

That underlying bug was eventually fixed by commit 7709aba8f716 ("KVM: x86:
Morph pending exceptions to pending VM-Exits at queue time"), but in the
interim, commit a06230b62b89 ("KVM: x86: Deliver exception payload on
KVM_GET_VCPU_EVENTS") came along and subtly added another dependency on
the !is_guest_mode() check.

While not recorded in the changelog, the motivation for deferring the
!exception_payload_enabled delivery was to fix a flaw where a synthesized
MTF (Monitor Trap Flag) VM-Exit would drop a pending #DB and clobber DR6.
On a VM-Exit, VMX CPUs save pending #DB information into the VMCS, which
is emulated by KVM in nested_vmx_update_pending_dbg() by grabbing the
payload from the queue/pending exception.  I.e. prematurely delivering the
payload would cause the pending #DB to not be recorded in the VMCS, and of
course, clobber L2's DR6 as seen by L1.

Jumping back to save+restore, the quirked behavior of forcing delivery of
the payload only works if userspace does KVM_GET_VCPU_EVENTS *before*
CR2 or DR6 is saved, i.e. before KVM_GET_SREGS{,2} and KVM_GET_DEBUGREGS.
E.g. if userspace does KVM_GET_SREGS before KVM_GET_VCPU_EVENTS, then the
CR2 saved by userspace won't contain the payload for the exception save by
KVM_GET_VCPU_EVENTS.

Deliberately deliver the payload in the store_regs() path, as it's the
least awful option even though userspace may not be doing save+restore.
Because if userspace _is_ doing save restore, it could elide KVM_GET_SREGS
knowing that SREGS were already saved when the vCPU exited.

Link: https://lore.kernel.org/all/20200207103608.110305-1-oupton@google.com
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: stable@vger.kernel.org
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Tested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260218005438.2619063-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   62 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 23 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -695,9 +695,6 @@ static void kvm_multiple_exception(struc
 		vcpu->arch.exception.error_code = error_code;
 		vcpu->arch.exception.has_payload = has_payload;
 		vcpu->arch.exception.payload = payload;
-		if (!is_guest_mode(vcpu))
-			kvm_deliver_exception_payload(vcpu,
-						      &vcpu->arch.exception);
 		return;
 	}
 
@@ -5147,18 +5144,8 @@ static int kvm_vcpu_ioctl_x86_set_mce(st
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
-					       struct kvm_vcpu_events *events)
+static struct kvm_queued_exception *kvm_get_exception_to_save(struct kvm_vcpu *vcpu)
 {
-	struct kvm_queued_exception *ex;
-
-	process_nmi(vcpu);
-
-#ifdef CONFIG_KVM_SMM
-	if (kvm_check_request(KVM_REQ_SMI, vcpu))
-		process_smi(vcpu);
-#endif
-
 	/*
 	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
 	 * the only time there can be two queued exceptions is if there's a
@@ -5169,21 +5156,46 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_
 	if (vcpu->arch.exception_vmexit.pending &&
 	    !vcpu->arch.exception.pending &&
 	    !vcpu->arch.exception.injected)
-		ex = &vcpu->arch.exception_vmexit;
-	else
-		ex = &vcpu->arch.exception;
+		return &vcpu->arch.exception_vmexit;
+
+	return &vcpu->arch.exception;
+}
+
+static void kvm_handle_exception_payload_quirk(struct kvm_vcpu *vcpu)
+{
+	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
 
 	/*
-	 * In guest mode, payload delivery should be deferred if the exception
-	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
-	 * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
-	 * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
-	 * propagate the payload and so it cannot be safely deferred.  Deliver
-	 * the payload if the capability hasn't been requested.
+	 * If KVM_CAP_EXCEPTION_PAYLOAD is disabled, then (prematurely) deliver
+	 * the pending exception payload when userspace saves *any* vCPU state
+	 * that interacts with exception payloads to avoid breaking userspace.
+	 *
+	 * Architecturally, KVM must not deliver an exception payload until the
+	 * exception is actually injected, e.g. to avoid losing pending #DB
+	 * information (which VMX tracks in the VMCS), and to avoid clobbering
+	 * state if the exception is never injected for whatever reason.  But
+	 * if KVM_CAP_EXCEPTION_PAYLOAD isn't enabled, then userspace may or
+	 * may not propagate the payload across save+restore, and so KVM can't
+	 * safely defer delivery of the payload.
 	 */
 	if (!vcpu->kvm->arch.exception_payload_enabled &&
 	    ex->pending && ex->has_payload)
 		kvm_deliver_exception_payload(vcpu, ex);
+}
+
+static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
+					       struct kvm_vcpu_events *events)
+{
+	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
+
+	process_nmi(vcpu);
+
+#ifdef CONFIG_KVM_SMM
+	if (kvm_check_request(KVM_REQ_SMI, vcpu))
+		process_smi(vcpu);
+#endif
+
+	kvm_handle_exception_payload_quirk(vcpu);
 
 	memset(events, 0, sizeof(*events));
 
@@ -5364,6 +5376,8 @@ static void kvm_vcpu_ioctl_x86_get_debug
 {
 	unsigned long val;
 
+	kvm_handle_exception_payload_quirk(vcpu);
+
 	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
 	kvm_get_dr(vcpu, 6, &val);
@@ -11396,6 +11410,8 @@ static void __get_sregs_common(struct kv
 	if (vcpu->arch.guest_state_protected)
 		goto skip_protected_regs;
 
+	kvm_handle_exception_payload_quirk(vcpu);
+
 	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);


