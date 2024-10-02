Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437FD1D0B84;
	Wed,  2 Oct 2024 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878696; cv=none; b=sT0pNR2Qlzj7h6gVwrT6KUqohhtHSGoZNPzEQTbNhDo/0rpAw2bSDgAl1QVa84SUI91g16tC5cOF3jVRMjjGK8VXNiJDR6jCO+YuAD/biJLHRM6bJxPzs0kUQdQ3NXoPf6iA/aJgiBV9igOXOLz2QC387pKB2dpOySzGBZ6rmro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878696; c=relaxed/simple;
	bh=f35ut4KeAz/cesxVksbcHK0FWGfq4SGeqZHXIFRzUzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T35j6q27nbWODd3g5Uf2wyMS7k59lLE9U0Z5L1VtZlDk1/sxUt8gMy5z4gG8xmE33mPW3bd7pz3NRVBxTNQ0EP1bFMKWwCRwdQregZ/WykqQhmzIjXEk7vv3/91R8pdPv0CQpotnSw83Ed6waN95GqwrMKNjQdKHcJ9s0eabab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyfVEk+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyfVEk+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FE5C4CEC2;
	Wed,  2 Oct 2024 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878696;
	bh=f35ut4KeAz/cesxVksbcHK0FWGfq4SGeqZHXIFRzUzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyfVEk+lWCKXk6sbr1mHDg8oHhBGmpYsmqVxyxkEjcLiQugb8kce1d3qlxUDXI58u
	 qhlOzmY3ULJlkniD2CHKp3Ax8TjGC5KrC3KAj0Y3tw5opzXwlJNxr2bIWtg2KB9Fui
	 xvKBin8ztHwCUsv5skL6yi1MXxsq6SrvDQ5wP+vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.10 500/634] Revert "LoongArch: KVM: Invalidate guest steal time address on vCPU reset"
Date: Wed,  2 Oct 2024 15:00:00 +0200
Message-ID: <20241002125830.833756701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

This reverts commit 05969a6944713f159e8f28be2388500174521818 which is
commit 4956e07f05e239b274d042618a250c9fa3e92629 upstream.

LoongArch's PV steal time support is add after 6.10, so 6.10.y doesn't
need this fix.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/kvm_vcpu.h |    1 +
 arch/loongarch/kvm/timer.c            |    7 +++++++
 arch/loongarch/kvm/vcpu.c             |    2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -76,6 +76,7 @@ static inline void kvm_restore_lasx(stru
 #endif
 
 void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
+void kvm_reset_timer(struct kvm_vcpu *vcpu);
 void kvm_save_timer(struct kvm_vcpu *vcpu);
 void kvm_restore_timer(struct kvm_vcpu *vcpu);
 
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -188,3 +188,10 @@ void kvm_save_timer(struct kvm_vcpu *vcp
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ESTAT);
 	preempt_enable();
 }
+
+void kvm_reset_timer(struct kvm_vcpu *vcpu)
+{
+	write_gcsr_timercfg(0);
+	kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TCFG, 0);
+	hrtimer_cancel(&vcpu->arch.swtimer);
+}
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -572,7 +572,7 @@ static int kvm_set_one_reg(struct kvm_vc
 				vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
 			break;
 		case KVM_REG_LOONGARCH_VCPU_RESET:
-			vcpu->arch.st.guest_addr = 0;
+			kvm_reset_timer(vcpu);
 			memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
 			memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
 			break;


