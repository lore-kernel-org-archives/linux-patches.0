Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054150;
	b=CbJ+9QfVSkKPTcWZb44sbMJM6Oi9SqfncXv5majFfDb185co9A4d06mVynHLUWoseWDk
	 p2Wl43e3vEOkNjXEa/Z5btZv2OAdrY0VHt+4vmHunVRBCWnsCh2/MMdmdu7nL5gi36dI8
	 iB7jOA4wYHFbRt3Aq01+LY4zzyH9OOXWuWkb5Z2617xpsvh1axBjpby1dsxr7jLfiTVWl
	 1V4ziZMjXrYKYCUuTMzXFkwJLxnPwOvDSgEriDopqFxLmhaqrMdBcLO1u0KNqkoOreY6u
	 ZGKBxgo27xHsQueqnXoq5MQO1lgNxWJU6qbgNiX/29R8DvnmXUW7Ta9lPjEi6kCBchA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rJNL+xU+yJWneQD3kvqDOryGDSYq8QY40ZE2MXJFf2g=;
	b=5ggyyGp5ZJdimTtHiagu8JKHKm1z+ElnxK7yvYFCh/7JOe3O5kJe9B8WxmHIjuQHTUY4
	 Q3LpGEALBVrgpF/V4DuuBQ3ZHxaqAvxdIzBcFKAx0guViCY5JROgjSSGAew1sYvdACRTe
	 XrZzF0wVAYuKKs8kGsXafQpX4ZjlhZmy+0bC07yTL4JSdnExKLx5EF6T9nm9T4gnAB7b7
	 tHSf+823RgWGJBSAAgIrNyMTw05gPCe8+KN6g3C1hdRd+UEaCyzGdhisCVQ+bpcRLul02
	 ATHhZdXcTM4m+U+Kxojxbd7687MBLGnTUlcZ7Sre/Dsu9rRtd3elXMm604N4cM6kktA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evek2udQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0CB606A337;
	Thu, 19 Nov 2026 02:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evek2udQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDA41F000C5;
	Thu, 19 Nov 2026 02:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054149;
	bh=rJNL+xU+yJWneQD3kvqDOryGDSYq8QY40ZE2MXJFf2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evek2udQkMGcs6OMcYT5el/wZJg8sGG8ItUsrX2UlMOx/m9eTyLIWMp/S02ZOdigH
	 wh/lbLSE9iY8Ogikne9GIsJ2X6HvqeUIfpW/efYeyqlhd5OpE3nKCX1KisOgJ7+5bZ
	 3CuL9xbAW+EO5daOGFPdCgPUVF/4EkaXDkiVTgis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1173/2214] KVM: arm64: Turn vcpu->arch.pause into a counter
Date: Wed, 18 Nov 2026 15:47:29 +0100
Message-ID: <20261118150058.908406376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Inlined vcpu_can_run() checks using power_off while retaining vcpu_req_sleep() and rcuwait_wake_up(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6d7b6b5d076d4..660d8ef766796 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -368,7 +368,7 @@ struct kvm_vcpu_arch {
 	bool power_off;
 
 	/* Don't run the guest (internal implementation need) */
-	bool pause;
+	atomic_t pause;
 
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a621dd31d9213..9e9674cc9bf36 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -336,6 +336,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	atomic_set(&vcpu->arch.pause, 0);
 
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
@@ -496,7 +497,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off && !v->arch.pause);
+		&& !v->arch.power_off && !atomic_read(&v->arch.pause));
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -636,7 +637,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		vcpu->arch.pause = true;
+		atomic_inc(&vcpu->arch.pause);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
 }
 
@@ -646,8 +647,8 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		vcpu->arch.pause = false;
-		rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
+		if (atomic_dec_and_test(&vcpu->arch.pause))
+			rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
 	}
 }
 
@@ -656,10 +657,10 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
 	rcuwait_wait_event(wait,
-			   (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
+			   !vcpu->arch.power_off && !atomic_read(&vcpu->arch.pause),
 			   TASK_INTERRUPTIBLE);
 
-	if (vcpu->arch.power_off || vcpu->arch.pause) {
+	if (vcpu->arch.power_off || atomic_read(&vcpu->arch.pause)) {
 		/* Awaken to handle a signal, request we sleep again later. */
 		kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	}
-- 
2.53.0



