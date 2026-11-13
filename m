Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591449;
	b=0YRGFXj3QKYgbJ2EjBadIF4TVVqcc9WDGs1EbN7JIVNHU3MpzXDu1JWr+qxNKG/rph7O
	 EN8uX5qGw0AHRG1XonS/jnhygQ2ANOWcKRIupB33neQDq3SwkTOvdWcoE1dGSc739h6Lx
	 x5buK7p6SAG0zsAJdWv9Ca957TpaZEHHQt5jK0iHSIG0G/WUjedp1HXXN9ugGZOcqQM+r
	 Mo5kIkZ02JLrAdD0XP5PwpbZo2wtnKKj6He/DAOrJQ/BM+71QbIyEwa0LoL3keRkxKHcs
	 yZ8DvHUF/HDhWEj6KjQwC4yKwYBz9CEpE20ceIr5Z1Qf6dbgEIhg01LfqiVuMIRSQsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=256tfo0jETvT+W7FLe16e8tTQFP5RctRy7PKqiNzxmY=;
	b=aE24U5kI2U9vBHv1RLqOi6ShXCVERf/MhEoBzyWY7ZZPBKIDJ87sCQ3aV5NVQnRVWGd1
	 yuS9J0NmyYbSPXL21SR36ywACCj0HodTHvSst5tB8vjDP0D6Ea4NmsWn2eM3x2rapUtRG
	 RB+7hYrQYuB5HkxVJW0yLhO8yO/BeLwTdUv/LxRjOkeDqxit8Hz35Nlw5K0oycYx/g/P3
	 i2GKOQTYuswtlOHUYj8mzRtniEQKVe7Pewh0OIScYqVHjD5lINuKFzvYW6Dm6Ja+M0R6J
	 CpZpwz+MkTzZekLRLbLlkeAhOPtchYJfbXbzFdwrffkNSa5zD0TVBAfxsVjwHKTlEZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWF0VM+h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923CA607C352;
	Fri, 13 Nov 2026 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWF0VM+h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED3A1F000C4;
	Fri, 13 Nov 2026 17:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591449;
	bh=256tfo0jETvT+W7FLe16e8tTQFP5RctRy7PKqiNzxmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWF0VM+hzYa5QDxPw8muZZPiTpU84qOJt57dGJw0B8vzk0mKg9gFIHAeK881VXaJX
	 RXzJ+m0saEwRMgNDEoEkvTA3xBiFkrsmHyuxfFH4VeL38mRz96I1NTP1cwoJqJAG01
	 WVFI1IQwHoAKYRqL1nsoyE7HrVS1RTDFA2l29338=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 538/670] KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded
Date: Fri, 13 Nov 2026 10:51:42 -0500
Message-ID: <20261113153830.131654361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 22b6557ad05bf05c73246f62c19af3e04017270e ]

IN_GUEST_MODE is advertised too late, when state has already been moved
onto CPU registers and cannot be observed by another CPU anymore.

Move the IN_GUEST_MODE publication ahead of the state being loaded, and
immediately check for pending request. This ensures that there is no
window of opportunity for another CPU to observe OUTSIDE_GUEST_MODE and
yet for state to be loaded.

This also simplifies the "state rollback", which solely amounts to
synchronising the timer when no irqchip is present.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-4-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: Adapted PMU synchronization removal to an unconditional call while preserving kvm_arm_setup_debug() in the guest-entry loop. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 97d993f52b575..ec59faa70f97e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1189,30 +1189,33 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
-		kvm_vgic_flush_hwstate(vcpu);
-
-		kvm_pmu_update_vcpu_events(vcpu);
-
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
 		 * Documentation/virt/kvm/vcpu-requests.rst
+		 *
+		 * Requests to self must be posted before this point, or
+		 * won't be taken into account until the next exit. No state
+		 * loading other than what happens at vcpu_load() time can
+		 * be done before we have checked for pending requests.
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			isb(); /* Ensure work in x_flush_hwstate is committed */
-			kvm_pmu_sync_hwstate(vcpu);
 			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
-			kvm_vgic_sync_hwstate(vcpu);
 			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			continue;
 		}
 
+		/* From here onwards, we are commited to entering the guest */
+		kvm_vgic_flush_hwstate(vcpu);
+
+		kvm_pmu_update_vcpu_events(vcpu);
+
 		kvm_arm_setup_debug(vcpu);
 		kvm_arch_vcpu_ctxflush_fp(vcpu);
 
-- 
2.53.0



