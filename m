Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FF2401A0A;
	Thu, 30 Jul 2026 16:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428303; cv=none; b=Iv9T6p1otvsCAtZ9YAhmZZad2FmBZK/Us0s63cKALU+BQ8ak0EebULXCh9QIHsZStjrmqQd+qIiKfTcdr3p8lUQxe5Stj4BXGgd9V99FpQJ1Fekx5J0nLJ/4/MgQ3pKmrdc7zZGAaH92VTqvAQsS7VQqJ+dBfhZh85BjMcjRexQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428303; c=relaxed/simple;
	bh=Dz6DgM94WK03Rj9z19TXmmZqLigJ4qrIQZE9/NGIGG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhzflsLnmKsY99fOgaVOtm5883ZKBGyEAMfGafXoqO9LX4O/+z+5N49QWQJo+axxX0ZHqFJQ6nImnnrpI/JH4UuNVVgHsNRsHEfFsGW7eR1Pta7YVySnCcvr0WxQcQgkkEfIn/YSratijJlA2PrwuDEb44/pX9rLzrerSFWukEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qj34Ay6e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qj34Ay6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26821F000E9;
	Thu, 30 Jul 2026 16:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428302;
	bh=iKU4iEFwfI21oiaSdtsXnPdNR93yxThRRKL4fkpxv4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qj34Ay6eaj7ANYKja62+zig2koPSGj8LDVeDIBzVWYizKTxcxUln9cQr/ufU+Lilb
	 rly0DtMbbhP8FIYSHmk0IFpZV8Lve7IVidtZdLdwdYeqHAAPoxLjqWFVSozVlYKYDQ
	 m6ex3wF7RFC1Lk+U+dc4acpKMr/m4lElg2x3cYMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 475/484] KVM: Introduce vcpu->wants_to_run
Date: Thu, 30 Jul 2026 16:16:12 +0200
Message-ID: <20260730141433.811556470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -915,7 +915,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	vcpu_load(vcpu);
 
-	if (run->immediate_exit) {
+	if (!vcpu->wants_to_run) {
 		ret = -EINTR;
 		goto out;
 	}
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -436,7 +436,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		vcpu->mmio_needed = 0;
 	}
 
-	if (vcpu->run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		goto out;
 
 	lose_fpu(1);
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1858,7 +1858,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	kvm_sigset_activate(vcpu);
 
-	if (run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		r = -EINTR;
 	else
 		r = kvmppc_vcpu_run(vcpu);
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -704,7 +704,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		return ret;
 	}
 
-	if (run->immediate_exit) {
+	if (!vcpu->wants_to_run) {
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		return -EINTR;
 	}
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5048,7 +5048,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	if (vcpu->kvm->arch.pv.dumping)
 		return -EINVAL;
 
-	if (kvm_run->immediate_exit)
+	if (!vcpu->wants_to_run)
 		return -EINTR;
 
 	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_S390_VALID_FIELDS ||
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11224,7 +11224,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
-		if (kvm_run->immediate_exit) {
+		if (!vcpu->wants_to_run) {
 			r = -EINTR;
 			goto out;
 		}
@@ -11302,7 +11302,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		WARN_ON_ONCE(vcpu->mmio_needed);
 	}
 
-	if (kvm_run->immediate_exit) {
+	if (!vcpu->wants_to_run) {
 		r = -EINTR;
 		goto out;
 	}
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -378,6 +378,7 @@ struct kvm_vcpu {
 		bool dy_eligible;
 	} spin_loop;
 #endif
+	bool wants_to_run;
 	bool preempted;
 	bool ready;
 	struct kvm_vcpu_arch arch;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4160,7 +4160,10 @@ static long kvm_vcpu_ioctl(struct file *
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


