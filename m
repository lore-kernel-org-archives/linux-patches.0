Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35751865ED;
	Fri, 27 Sep 2024 12:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440050; cv=none; b=s7ioyJ/EjjKHMqCUtqlN6cvfSZyRnqTuW5VZg8ru3hkbfVyQowOwY1RTLieZpHLL3Ay0HQsoBHJ8LsJSMUkJ2qyhx/JYBhmD51PbRwywSl1CKmxBmu+cM1pM3xJdxxBi5U08fw4ePd9FJhTM2ym8a6r1RsbLbX3DUVY+Ot5kDgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440050; c=relaxed/simple;
	bh=WXACQRx5mi7zB+vj97I90XYVzWeTcrpzn2si4wmQvMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCeIFrkVudYIoh1B1mnn2nZel3C80xhViBaUVgqYl2t3fUiMxiOqJa+cgIthl4BjLV5BrrVo3NDCaLm/WAFBoIqAZED/yP7cqTaKUqaEQfWUZgr8GnuKzb8JD/sd8Q4fekAeHlDIabhsjrViGchrn7a3fIFOu+Czonu93L9SNfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyBKF9If; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyBKF9If"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DB4C4CEC4;
	Fri, 27 Sep 2024 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440050;
	bh=WXACQRx5mi7zB+vj97I90XYVzWeTcrpzn2si4wmQvMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyBKF9If/QG542zNX3r+6Ts3ol6ps1T2VfrAZNF/DI0VP3DawwaNl/ZSqX9sCreBE
	 hYgizDSfRdEzougCLYyPfyOaRgrwZwyF+IZB6Lqgn3oMXfgd2qutDfAQWEJMsQiAVg
	 6tf7hPvIVLSr7jmZxbKUfioKHTH+dF+XYBH0CVAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 15/58] LoongArch: KVM: Invalidate guest steal time address on vCPU reset
Date: Fri, 27 Sep 2024 14:23:17 +0200
Message-ID: <20240927121719.436164314@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 4956e07f05e239b274d042618a250c9fa3e92629 ]

If ParaVirt steal time feature is enabled, there is a percpu gpa address
passed from guest vCPU and host modifies guest memory space with this gpa
address. When vCPU is reset normally, it will notify host and invalidate
gpa address.

However if VM is crashed and VMM reboots VM forcely, the vCPU reboot
notification callback will not be called in VM. Host needs invalidate
the gpa address, else host will modify guest memory during VM reboots.
Here it is invalidated from the vCPU KVM_REG_LOONGARCH_VCPU_RESET ioctl
interface.

Also funciton kvm_reset_timer() is removed at vCPU reset stage, since SW
emulated timer is only used in vCPU block state. When a vCPU is removed
from the block waiting queue, kvm_restore_timer() is called and SW timer
is cancelled. And the timer register is also cleared at VMM when a vCPU
is reset.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/kvm_vcpu.h | 1 -
 arch/loongarch/kvm/timer.c            | 7 -------
 arch/loongarch/kvm/vcpu.c             | 2 +-
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index 590a92cb54165..d741c3e9933a5 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -76,7 +76,6 @@ static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
 #endif
 
 void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
-void kvm_reset_timer(struct kvm_vcpu *vcpu);
 void kvm_save_timer(struct kvm_vcpu *vcpu);
 void kvm_restore_timer(struct kvm_vcpu *vcpu);
 
diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index bcc6b6d063d91..74a4b5c272d60 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -188,10 +188,3 @@ void kvm_save_timer(struct kvm_vcpu *vcpu)
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ESTAT);
 	preempt_enable();
 }
-
-void kvm_reset_timer(struct kvm_vcpu *vcpu)
-{
-	write_gcsr_timercfg(0);
-	kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TCFG, 0);
-	hrtimer_cancel(&vcpu->arch.swtimer);
-}
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 9e8030d451290..0b53f4d9fddf9 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -572,7 +572,7 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
 				vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
 			break;
 		case KVM_REG_LOONGARCH_VCPU_RESET:
-			kvm_reset_timer(vcpu);
+			vcpu->arch.st.guest_addr = 0;
 			memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
 			memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
 			break;
-- 
2.43.0



