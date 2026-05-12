Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC3A36AB5B;
	Tue, 12 May 2026 18:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609679; cv=none; b=uRDMvTdk6czhLKJRgFrlVleZCdikj1hnIByl9A+E3QkujQTA3U8O/0q5KVyKo6qb13hf9jjpCmOxhQJbJj5jL/3QDMScVBkMIUg9t5Jt2Y7JdQPtL0vig5EEPuXJQqOhL6qANbAVgkn+HAS2C6mj4XKKoDtQZ0xlQ6a+DxwZHFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609679; c=relaxed/simple;
	bh=7zckdiLWjHUu1nssuID2lPnH+DH6p8AOYObcEpa2dck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFfd4iuRvbhGQTL9BuyybosjL8z3vcFBnVbKP0ExZWZXQoGsRSVvsWeu8TCcHr0Fywz9PEvdZzE3N0t2u12QOzdoVpi1vdgWwDGcmFvEwVcKXidkDnHeKJpzdu/+rATE4X8DO5V8W7tfT8ILjZrucn8cw8tgwXMfE5eKkgkA0t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsC6aulH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsC6aulH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2231DC2BCB0;
	Tue, 12 May 2026 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609679;
	bh=7zckdiLWjHUu1nssuID2lPnH+DH6p8AOYObcEpa2dck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsC6aulHOkmoPk9ULpvqbE+ug9avY6odGzz+jxlYuTYTs5sVzvRHEx4zkq6HmpF+8
	 9Sc9RbMneLl1Xeg4UkyQ7DgnIhGEkdDOIF76vk7tGqOYHjcQaHFTxVV+2/BnEJOBLp
	 09TJtry1rwLn0XJbA5eY1q5pu0Hn2Gu3A8d/ysvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 287/307] LoongArch: KVM: Fix HW timer interrupt lost when inject interrupt by software
Date: Tue, 12 May 2026 19:41:22 +0200
Message-ID: <20260512173946.182057328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 2433f3f5724b3af569d9fb411ba728629524738b upstream.

With passthrough HW timer, timer interrupt is injected by HW. When
inject emulated CPU interrupt by software such SIP0/SIP1/IPI, HW timer
interrupt may be lost.

Here check whether there is timer tick value inversion before and after
injecting emulated CPU interrupt by software, timer enabling by reading
timer cfg register is skipped. If the timer tick value is detected with
changing, then timer should be enabled. And inject a timer interrupt by
software if there is.

Cc: <stable@vger.kernel.org>
Fixes: f45ad5b8aa93 ("LoongArch: KVM: Implement vcpu interrupt operations").
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/interrupt.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/loongarch/kvm/interrupt.c
+++ b/arch/loongarch/kvm/interrupt.c
@@ -27,6 +27,7 @@ static unsigned int priority_to_irq[EXCC
 static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 {
 	unsigned int irq = 0;
+	unsigned long old, new;
 
 	clear_bit(priority, &vcpu->arch.irq_pending);
 	if (priority < EXCCODE_INT_NUM)
@@ -42,7 +43,13 @@ static int kvm_irq_deliver(struct kvm_vc
 	case INT_IPI:
 	case INT_SWI0:
 	case INT_SWI1:
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_TVAL);
 		set_gcsr_estat(irq);
+		new = kvm_read_hw_gcsr(LOONGARCH_CSR_TVAL);
+
+		/* Inject TI if TVAL inverted */
+		if (new > old)
+			set_gcsr_estat(CPU_TIMER);
 		break;
 
 	case INT_HWI0 ... INT_HWI7:
@@ -59,6 +66,7 @@ static int kvm_irq_deliver(struct kvm_vc
 static int kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
 {
 	unsigned int irq = 0;
+	unsigned long old, new;
 
 	clear_bit(priority, &vcpu->arch.irq_clear);
 	if (priority < EXCCODE_INT_NUM)
@@ -74,7 +82,13 @@ static int kvm_irq_clear(struct kvm_vcpu
 	case INT_IPI:
 	case INT_SWI0:
 	case INT_SWI1:
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_TVAL);
 		clear_gcsr_estat(irq);
+		new = kvm_read_hw_gcsr(LOONGARCH_CSR_TVAL);
+
+		/* Inject TI if TVAL inverted */
+		if (new > old)
+			set_gcsr_estat(CPU_TIMER);
 		break;
 
 	case INT_HWI0 ... INT_HWI7:


