Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036627;
	b=2H9tXfwjY7wIYxiCPDLlF723UsK6Q05aSTus1ecsPfPpQDMmztOQyTSiYpHqoYW7yXKz
	 6efl08bG/25tyoMIlynZSIuwC0A2PBQ+tS2SmP0HtOLxy9C1e/cB43yyHJkO4LXAiGGqI
	 zNlMf4Cj78oUfm9sjV6enWHr8DTub7/9aGS/6y9FePFJoz8Fgx6b+iNJV+/+lhuGrku9p
	 eLDafHc16WFp5DWPpBimaR+nK6Eje8u68QyewObW/CVoq1m2gqUGwNqnzNLU+CnbvSd02
	 +fNbkm0n1PrQxBcIXzsrwKqi8X0inFi3KjNMvB1k0P1s6LJHG8TZgMYoSbyPIKG0Kvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KHHcSwwIWhAKLMri+HJkPsoLkbHYWX7nMVeqCjQcyRM=;
	b=dyicCYBe0PefECLGeiP8UPIEgxS9Bq7XHhiLzxwNVS0abNxDMNEkub/ha+jGqpntrYgd
	 7o6IdhP2V+fwui53Xe2TH3KVOCkxX4NaZO4d1ug9V4GIY8Kn/Q661gzVIDb2u6Qr8gd1u
	 dXtuqUJ4j6FLWYns3fEKopBjO70alV5ZXexPZlf1qem6ZS3S44d2KFu3hkkh/8vIOjsJz
	 /N7o/xkLVsiXpp8nghiiWeiz3k9p8g+P4K/Ns3vjHp2syi2f/3tCTsXpIuJVMs6t5Yf0V
	 6jQLFb78l4AE2+Fu1Ss48gPF5+AVP9gWRlFKZ5CTU4g4wz5VkaNeEngLClLLASZgrbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFfboJj3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612D0606A320;
	Wed, 18 Nov 2026 21:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFfboJj3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3751F000C4;
	Wed, 18 Nov 2026 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036627;
	bh=KHHcSwwIWhAKLMri+HJkPsoLkbHYWX7nMVeqCjQcyRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFfboJj3l2XNMK0COHTbRYqWcPMfaBQxuNgQCIKLs7AqejLHgPkioHqa0KF3qHaiy
	 YKmU4zm+zePtraQksUQPKW5IGZMeNOIDc+Pw7i7nJmheIpOPJi9vYXjYmpy9TI3TGM
	 E1hpR62JCCPW9Jo2Qun6Zx5cC+f7QIlxKeF1bKk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1127/3318] KVM: arm64: Turn vcpu->arch.pause into a counter
Date: Wed, 18 Nov 2026 15:29:09 +0100
Message-ID: <20261118150353.847726546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df73e452d2cc0..fdd940fb6a2e4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -513,11 +513,10 @@ struct kvm_vcpu_arch {
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
index 7ff28efd4bd55..7b7afea4c5363 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -386,6 +386,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	atomic_set(&vcpu->arch.pause, 0);
 
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
@@ -547,6 +548,11 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
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
@@ -562,8 +568,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 		      (kvm_timer_should_notify_user(v) ||
 		       kvm_pmu_should_notify_user(v)));
 
-	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
+	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v)) && vcpu_can_run(v));
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -658,7 +663,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		vcpu->arch.pause = true;
+		atomic_inc(&vcpu->arch.pause);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
 }
 
@@ -668,8 +673,8 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		vcpu->arch.pause = false;
-		__kvm_vcpu_wake_up(vcpu);
+		if (atomic_dec_and_test(&vcpu->arch.pause))
+			__kvm_vcpu_wake_up(vcpu);
 	}
 }
 
@@ -677,11 +682,9 @@ static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
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



