Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CFD47DF86;
	Thu, 20 Aug 2026 17:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248299; cv=none; b=qay83iMu1e77Gm+sIwLYYCrNFh7HyO5XXdzU8eGomvTcTNtViuxPlt/vKg0ZIhfX4J+t4rQ1v07F7wLGqPj/1IE5BO9KYZe81cjKEosXPFltT2ZRUHLTCpwvx0m5FUjFtWtK2IdCCk+HopV5QrbKPYbULMxeQJTfTOc3h/MUYc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248299; c=relaxed/simple;
	bh=azodNdT8J7Ie584aFwQMmQBUdPfRSB8Rydp0IpQZ7yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAYKykFMBa491/Gby4wtMMvVFHNOje/JwK4/QOceHNkKqz0yBswhfCxmA65pzrfHbpAnUqE79gXDEBpF2IpR/DlTalDkOYpH76Gubhvg8PXWW88GYglP9SjOcYfILlPeiHpFFd3zSEuNkvu6TkPMTMsGFSGT9Qnmv6Rn+4x/pkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpQJyjAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpQJyjAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA511F000E9;
	Thu, 20 Aug 2026 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248298;
	bh=6ROs0L44qgIKLGcN4bkIdEjaeFYTqkknLijDg3wmUXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpQJyjAujEdMbY7MxWP9TG+cjfm7Bt8mcx4Szs2Azu7b5TKWoW6xB6HcePAynfrdE
	 cMEmoKcZgfuhREYIPz6hqf4L0vQZNvKopEkov/f6a26QsgG4A6FhVfu8oJ2Ez2+2hF
	 NAca9XoJkItgpvox8xXBen4pojlD2yWaa2T1nErY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/303] KVM: Introduce vcpu->wants_to_run
Date: Thu, 20 Aug 2026 16:55:14 +0200
Message-ID: <20260820145258.653616454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/riscv/kvm/vcpu.c      |    2 +-
 arch/s390/kvm/kvm-s390.c   |    2 +-
 arch/x86/kvm/x86.c         |    4 ++--
 include/linux/kvm_host.h   |    1 +
 virt/kvm/kvm_main.c        |    3 +++
 8 files changed, 11 insertions(+), 7 deletions(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -891,7 +891,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	vcpu_load(vcpu);
 
-	if (run->immediate_exit) {
+	if (!vcpu->wants_to_run) {
 		ret = -EINTR;
 		goto out;
 	}
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -446,7 +446,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		vcpu->mmio_needed = 0;
 	}
 
-	if (vcpu->run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		goto out;
 
 	lose_fpu(1);
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1866,7 +1866,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	kvm_sigset_activate(vcpu);
 
-	if (run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		r = -EINTR;
 	else
 		r = kvmppc_vcpu_run(vcpu);
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -1005,7 +1005,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		return ret;
 	}
 
-	if (run->immediate_exit) {
+	if (!vcpu->wants_to_run) {
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		return -EINTR;
 	}
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4881,7 +4881,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	if (vcpu->kvm->arch.pv.dumping)
 		return -EINVAL;
 
-	if (kvm_run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		return -EINTR;
 
 	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_S390_VALID_FIELDS ||
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11264,7 +11264,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
-		if (kvm_run->immediate_exit) {
+		if (!vcpu->wants_to_run) {
 			r = -EINTR;
 			goto out;
 		}
@@ -11337,7 +11337,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		WARN_ON_ONCE(vcpu->mmio_needed);
 	}
 
-	if (kvm_run->immediate_exit) {
+	if (!vcpu->wants_to_run) {
 		r = -EINTR;
 		goto out;
 	}
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -365,6 +365,7 @@ struct kvm_vcpu {
 		bool dy_eligible;
 	} spin_loop;
 #endif
+	bool wants_to_run;
 	bool preempted;
 	bool ready;
 	struct kvm_vcpu_arch arch;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4119,7 +4119,10 @@ static long kvm_vcpu_ioctl(struct file *
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


