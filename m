Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046918;
	b=bg7xyUbt7D2YnBluxd/FUL9jVa9QU0PCtmKQbSiXFanh5lGmjRXDEz9Wq5khtwlPqOjw
	 sWt01gFn25oGvT+KN1CDfUnmKGp47S2tZYZ0hNF/Wwt6jJotnPpJcOvAY60IEHGT2PEaE
	 /VDFu6DmJludZpPVMAKF9Q4nNJfMvdjt9oRhwTIHP+9FlFVfDMA71DNUVBRX8hegFhRh8
	 ntc7vm7uVGpo9u3jpjuzdQOV7qYNc+2roxKqcctE6gzFY6KmkFMmsEACiPYtHDW9Zhpja
	 CU0WO397Hfu3gFFnoViK/89ayDAFbe7mVLtKvt9Gz2XXVVYGuWZyW23Jmr5JB5MXO2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7KA5Wf2xU4UzNuEKtx43bJ0Bq0b7gZ/D/fWqS7d94P8=;
	b=I+bAb5yxWOO+M/Mu7iNu1IHBn2I1nftdJ33TYZ3atYzr3NplwsBpWElHAHBGJgG2W6Dr
	 MMCcJp1PDqGDMDm2AGPAzFIBBoN7QhYtcAE0vfIN3gCsAkFkdI7zc7ZwgWPpLJfVlLDtX
	 ycSbdUv61xJnf9SGecKPEFAOmyUSYFUNP+h+B7dJMIzG3DE/dFUiXWHdcixw0iWKSeo6u
	 ZwOKR1H08yg48wKSo/mM0XAsQqp/KsqiTi/CMSGWC22/fbAfvhC/ZnHuiC39znLK2ri4R
	 CpxkhOan07i1T56ru7Mz9pk8FI8ZHOH1eYg2csWyo7Kv2ttoiw+6kDD8WGQCvqEM56A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqRj562W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5C5606A31C;
	Thu, 19 Nov 2026 00:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqRj562W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCEB1F000C4;
	Thu, 19 Nov 2026 00:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046918;
	bh=7KA5Wf2xU4UzNuEKtx43bJ0Bq0b7gZ/D/fWqS7d94P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqRj562WM0DiIi+OWp2CaQZ24AOuWhLsDNn3DjyMdfU6KruSC8VZ/uvQcwDyrxf0g
	 3v6CXklMwCZSIb6fasZRa2qRj5JEaIJXMaDJXF8+mHB+klvULM5BkYXIF5nqRWBb02
	 /nXbrzpDc7ko60s9C//gn90K0cLF9Y+tI9Uw24Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1452/2857] KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded
Date: Wed, 18 Nov 2026 15:41:26 +0100
Message-ID: <20261118150253.599641396@linuxfoundation.org>
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
[ sashal: adapted kvm_pmu_sync_hwstate() removal to code without the kvm_vcpu_has_pmu() guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b0b1324e84097..be99f1a88bd4c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -923,30 +923,33 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
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



