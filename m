Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063418;
	b=II1CDuxmQeZ3m12QSeUfPxK5z9BpjqgPsf1BrXdjMEwm03W722wyeRhFmxhCXjF1FNGO
	 E4eg/r224t2iA71Qnv9d2061U3BbQz1a0ZCBeHVr8xkKrvfbr7LKD7iQpcReMZc8rACAS
	 dpIi/+bksD1dctn2I/UPFOnNGl59RaFK30/uO6g18mrrdWUjPjUfML1fNswi+xQMoLCMd
	 EqGHZomKNlJIkjO/4Gzm6Jep7UCXVut/Mum0nVro9hA7UB1vKVGA+aD18YkE4DQZ71Z1r
	 XtokuP+lGX9WfGhErpPfP6VFCksO3sVVYBnB0PTEa5xJ2mx7GVJ76QXICOYvwmQBWZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tDNzeqrVJnGzY+b/28VgD8byfpuAVo9oygc9wQQmYs4=;
	b=Xu6SUFgtmd+Rjnd7e3tvIGXS+D/ba/8Ko5uFdn+XVUpwzxokv6q2Jzko1zHpdeib7Z77
	 P4zZbiDoWrFfRp6yG9CStaacqLcnVKlxrx1McFciROs0VgfWkSyFSTCWSBCdymJJ2hzN0
	 erY+1y7Uebxe3AJEOttF6Ct8xK5Xwm+EUTOGZHE0QFTKhqEAmt2veUT0i1FZ553UIhMyU
	 yrig+dcXgazi0bzgb/hvDGF2ddJ22r5DUHRTPLKLl3qbePFJqFJKDvtY+5qe9IeQYJkCd
	 JotMN3niKn15zGEk+yASwPmr/ljcYxRcjLXJyvN+wGc124oHU9a83Ggjd7w5s/K+/yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rh211vJ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8F9608360B;
	Sat,  7 Nov 2026 14:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rh211vJ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC271F0089F;
	Sat,  7 Nov 2026 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063417;
	bh=tDNzeqrVJnGzY+b/28VgD8byfpuAVo9oygc9wQQmYs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rh211vJ540R5moTZFOeRrrZV9Ajtp8ETNt6iE9HN78ZueChKxRFAPCMQeJL67Nt3O
	 SptNCbuLoRN7lDIqe7VAquIlPiiKU+M4c1xUy/7fmNGJ1WYg45y6CZRImwi1DbGe9R
	 T0WmO12rSmVqxtwoJQzqbWXL44FPN8knBL4m33L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 585/869] KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved
Date: Sat,  7 Nov 2026 08:54:27 -0500
Message-ID: <20261107134912.987188312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 1d4ce2901f1e25b06d447c0b02d105d6dd3550d8 ]

OUTSIDE_GUEST_MODE indicates to the rest of KVM that the vcpu has
exited. So far, this is set as soon as we return from the notional
hypervisor (which with VHE is just a function call away).

However, code that uses OUTSIDE_GUEST_MODE as a synchronisation point
relies on the vcpu state to have been written back to the in-memory
structures. Clearly, this is not what is happening.

Move the publication of OUTSIDE_GUEST_MODE to the point where the state
is actually written, and give this write release semantics to ensure the
correct ordering.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-3-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b52c162cb380e..ab01b6c961132 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1242,13 +1242,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			if (kvm_vcpu_has_pmu(vcpu))
 				kvm_pmu_sync_hwstate(vcpu);
 			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			continue;
@@ -1264,7 +1264,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 		/*
 		 * Back from guest
@@ -1298,6 +1297,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
+		/*
+		 * The state that was pushed into the CPU on entering
+		 * the guest has been synchronised back, let's
+		 * advertise we're outside of the guest.
+		 */
+		smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
+
 		/*
 		 * We must ensure that any pending interrupts are taken before
 		 * we exit guest timing so that timer ticks are accounted as
-- 
2.53.0



