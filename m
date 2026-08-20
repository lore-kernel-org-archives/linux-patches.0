Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC4147ACF5;
	Thu, 20 Aug 2026 16:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244479; cv=none; b=ctm0a6x0hPCUg5FN9X48sSG7YVGyRNXwld/rRhWq46vky9EwgLhZcprB+YgF7TYP5KXIykJcSoOWcMNzc/udTLjBDcqu/5bHcEGfdF7yGJai/0Qv0Se2Q+EmEvUhlgihma/K0iyLgTT+0tFXMFD0JYFq/0Jle9rkYRjyFPbEfKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244479; c=relaxed/simple;
	bh=68jCdGuLxjGa3eDZLzdk1pqAdtQtLNsm+MKrGYmeAas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pX4jSIO6HaLRN7t/n+Og+wqj9SjkRJ1hppeER19mJ4Z45DUVzmUe1a9F8Du3S55rRAwwp4HB/HRvWsxnbQDzDe+TgonCvZRca0l6TWEj08KmXs+EWehdQaob39h5GQtKnrNXGHd4u0ud8yj/Bx4eVpprGRF+V1CAmqJ85QycICI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvByHKAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvByHKAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0299D1F00A3D;
	Thu, 20 Aug 2026 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244478;
	bh=s6fG9Mc8fO+TOVWle1wkB4i84oAtoBAvEITErKssFpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvByHKAezBZM8W850wbNjjMOsgr2mUC9tLE2thbehZyimnM21ulm8oj0QN3vM9t4s
	 blGU0L8yyhkKN3TXEY16xCrr57FJDQ8SlwMhLwLo9+8E1BbgnezoTeFMpagC3F6Iso
	 yXw/8erUIKuhklZkfvCMzaN3C3N4RJ4GogiWmaNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/235] KVM: Introduce vcpu->wants_to_run
Date: Thu, 20 Aug 2026 16:56:20 +0200
Message-ID: <20260820145220.808791198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

[ Upstream commit a6816314af5749cd88944bfdceb270c627cdf348 ]

Introduce vcpu->wants_to_run to indicate when a vCPU is in its core run
loop, i.e. when the vCPU is running the KVM_RUN ioctl and immediate_exit
was not set.

Replace all references to vcpu->run->immediate_exit with
!vcpu->wants_to_run to avoid TOCTOU races with userspace. For example, a
malicious userspace could invoked KVM_RUN with immediate_exit=true and
then after KVM reads it to set wants_to_run=false, flip it to false.
This would result in the vCPU running in KVM_RUN with
wants_to_run=false. This wouldn't cause any real bugs today but is a
dangerous landmine.

Signed-off-by: David Matlack <dmatlack@google.com>
Link: https://lore.kernel.org/r/20240503181734.1467938-2-dmatlack@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: e800decd9c0a ("KVM: x86: Only reset TSC Deadline Timer in apic_timer_expired on KVM_RUN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c       |    2 +-
 arch/mips/kvm/mips.c       |    2 +-
 arch/powerpc/kvm/powerpc.c |    2 +-
 arch/s390/kvm/kvm-s390.c   |    2 +-
 arch/x86/kvm/x86.c         |    4 ++--
 include/linux/kvm_host.h   |    1 +
 virt/kvm/kvm_main.c        |    3 +++
 7 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -686,7 +686,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 			return ret;
 	}
 
-	if (run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		return -EINTR;
 
 	vcpu_load(vcpu);
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -464,7 +464,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		vcpu->mmio_needed = 0;
 	}
 
-	if (vcpu->run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		goto out;
 
 	lose_fpu(1);
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1832,7 +1832,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	kvm_sigset_activate(vcpu);
 
-	if (run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		r = -EINTR;
 	else
 		r = kvmppc_vcpu_run(vcpu);
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4373,7 +4373,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	struct kvm_run *kvm_run = vcpu->run;
 	int rc;
 
-	if (kvm_run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		return -EINTR;
 
 	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_S390_VALID_FIELDS ||
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9648,7 +9648,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	kvm_load_guest_fpu(vcpu);
 
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
-		if (kvm_run->immediate_exit) {
+		if (!vcpu->wants_to_run) {
 			r = -EINTR;
 			goto out;
 		}
@@ -9692,7 +9692,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	} else
 		WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed);
 
-	if (kvm_run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		r = -EINTR;
 	else
 		r = vcpu_run(vcpu);
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -318,6 +318,7 @@ struct kvm_vcpu {
 		bool dy_eligible;
 	} spin_loop;
 #endif
+	bool wants_to_run;
 	bool preempted;
 	bool ready;
 	struct kvm_vcpu_arch arch;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3366,7 +3366,10 @@ static long kvm_vcpu_ioctl(struct file *
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
+		vcpu->wants_to_run = !READ_ONCE(vcpu->run->immediate_exit);
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
+		vcpu->wants_to_run = false;
+
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
 		break;
 	}


