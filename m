Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045550;
	b=2RNZkwtorNCxWpgBfyhFsx7t4auFowy+iemKCYtRjyCC6hGeXwkmXUPIq8DuZDxPGs1W
	 0Io6ndFDJRgfFIuwbijtOaseY7kq7g9nMJuhjJJIdFwgggJoOMC+p9TNjP7zd+ceg3av/
	 to5PtERWutNdX1xQUkHWR5WJlD8rT4FApgP0n/s1c+qJmhFOK2+kvgyT4BWJlewGwW48/
	 HeowluTGOVVgMlhhxk8OtlXV3IIMJTGntZuuTaYK5JFoWaWSvF8OkShSjNZiGi88Nyd0S
	 35bXSQ+TAXJr37rQ1ztxcSqiwcVN522pmBARHT/AhFWVUDacNviA6CaCxIyeIfqk1Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PMBUsfZb7l41/8XrGyQDHyLNHkSvNb3bXfCVFu/C9Bw=;
	b=K8OkOIevAgnwT2788erkjr4T58hcHMywayFtTnE+HrvK8HKiyCLIH8KcaLG0lHfUL2Os
	 +YVpSQdtpA7NNc179bCvaJbk0JALViFByedM3iw0XEjRSHOyWIxHaZ5HvsS4HPoceWrwo
	 FYnR4fhKuzHInGckpboT7srLl5aoWmvr0647u12hzyfh3Dcxz1DdbYDUJhT+PWXazGSJg
	 bSlOU6nL3NYCLi+KngcdbGnI/3PCzNPZU3MDuga3jsOOw34kU+9GYNUhhdfGDraqLrmk3
	 CRcvk58KHnl4P/8ES4Wsd8644Xu79JSI6PLJiE2V3rQh8dP/b28rKEsZbxp8zJc8C6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogAKbCEp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D24606A336;
	Wed, 18 Nov 2026 23:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogAKbCEp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E451F000C5;
	Wed, 18 Nov 2026 23:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045550;
	bh=PMBUsfZb7l41/8XrGyQDHyLNHkSvNb3bXfCVFu/C9Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogAKbCEpM7kRGpW6jd6cwu83FC7VH3/mXet071kq+2zKVJpkB1SfNC+tlHjn1f5CM
	 OjjTP7XwjliBpzf/ci19o2iZrvvw5QKYpeRc6YDAineiV5PCZy0IuQAOfjC0YYkhEr
	 ztYGxO5p54sRofLOjACPI5tw81dxAj0lHbN3ThPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0963/2857] KVM: arm64: Turn vcpu->arch.pause into a counter
Date: Wed, 18 Nov 2026 15:33:17 +0100
Message-ID: <20261118150236.280572488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit e64309198eda29415a95113def92aa40196cd422 ]

We have situations where we can call kvm_arm_halt_guest() without
holding config_lock, which means that halt and resume can overlap in
funny ways when called from separate contexts, and result in situations
where a vcpu is resumed while other parts of KVM assume it is halted.
Consequences are left to the imagination of the reader.

Fix this sorry situation by turning kvm_vcpu_arch::pause into an
atomic counter, which makes the races described above harmless.

Fixes: 3b92830ad41b2 ("KVM: arm/arm64: implement kvm_arm_[halt,resume]_guest")
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261015100539.1011760-5-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  7 +++----
 arch/arm64/kvm/arm.c              | 21 ++++++++++++---------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f57f02a52a84d..5c957d1aacbac 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -355,11 +355,10 @@ struct kvm_vcpu_arch {
 	/*
 	 * Don't run the guest (internal implementation need).
 	 *
-	 * Contrary to the flags above, this is set/cleared outside of
-	 * a vcpu context, and thus cannot be mixed with the flags
-	 * themselves (or the flag accesses need to be made atomic).
+	 * Contrary to the flags above, this is updated outside of
+	 * a vcpu context, and thus cannot be mixed with the flags.
 	 */
-	bool pause;
+	atomic_t pause;
 
 	/*
 	 * We maintain more than a single set of debug registers to support
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 35ba9b6696bc2..b0b1324e84097 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -365,6 +365,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	atomic_set(&vcpu->arch.pause, 0);
 
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
@@ -526,6 +527,11 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static bool vcpu_can_run(struct kvm_vcpu *vcpu)
+{
+	return !kvm_arm_vcpu_stopped(vcpu) && !atomic_read(&vcpu->arch.pause);
+}
+
 /**
  * kvm_arch_vcpu_runnable - determine if the vcpu can be scheduled
  * @v:		The VCPU pointer
@@ -541,8 +547,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 		      (kvm_timer_should_notify_user(v) ||
 		       kvm_pmu_should_notify_user(v)));
 
-	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
+	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v)) && vcpu_can_run(v));
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -631,7 +636,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		vcpu->arch.pause = true;
+		atomic_inc(&vcpu->arch.pause);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
 }
 
@@ -641,8 +646,8 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		vcpu->arch.pause = false;
-		__kvm_vcpu_wake_up(vcpu);
+		if (atomic_dec_and_test(&vcpu->arch.pause))
+			__kvm_vcpu_wake_up(vcpu);
 	}
 }
 
@@ -650,11 +655,9 @@ static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
-	rcuwait_wait_event(wait,
-			   (!kvm_arm_vcpu_stopped(vcpu)) && (!vcpu->arch.pause),
-			   TASK_INTERRUPTIBLE);
+	rcuwait_wait_event(wait, vcpu_can_run(vcpu), TASK_INTERRUPTIBLE);
 
-	if (kvm_arm_vcpu_stopped(vcpu) || vcpu->arch.pause) {
+	if (!vcpu_can_run(vcpu)) {
 		/* Awaken to handle a signal, request we sleep again later. */
 		kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	}
-- 
2.53.0



