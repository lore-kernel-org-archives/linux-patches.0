Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3600730BB80;
	Tue, 12 May 2026 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608861; cv=none; b=VIFlxWEoDBdxPUR1Y9rhtgym+VSsUwDZJUiqtN2J0l3ea0cdJUuCVM+l2QjyB+P9OrbbhSIJsUjJ/G4Gbb+cYIsMXooAWPPc37XmMbQgXY/rW8qOYC/gs95mizEBdqNTP83bVJw0TEiG51sxkiu9ulcKv3xchG0wCApW4AZfUc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608861; c=relaxed/simple;
	bh=sL92adRtFWvCYn6uRoHm842rowjSTpAPGU/9v2YJed0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMLEG6KGdzSvSc1v+1PRJFDCkjC8azK9hpKLJtwtu2ThEjakTPANrKewwJdK/ZWOnc5rMAKMk99vAyoLMGsq5c/TK/vr4mkSvCaXMbeAsKJNPTTQ6FmRQmPUiFXKxziBwXnhYE8J2/zhNmQm4ZqOI3ztzE6dv60PcFtQIKGvoz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7KJpbLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7KJpbLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00C2C2BCB0;
	Tue, 12 May 2026 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608861;
	bh=sL92adRtFWvCYn6uRoHm842rowjSTpAPGU/9v2YJed0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7KJpbLVO2JV48WsX9IGDvqy7BcQ0mhPVz3N71L1nHx5R/yLJToy1TB/aasAbgPs/
	 sseiAbs4j6QllKwYmeftV/PkR68rkvCvaaZUizetuTTBmqxX4NcrLICKP7hihfgM1Y
	 RgkcWlUJcR4OYiapdke364Kw1yqXm5VFqLSZ5yzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 242/270] LoongArch: KVM: Fix HW timer interrupt lost when inject interrupt by software
Date: Tue, 12 May 2026 19:40:43 +0200
Message-ID: <20260512173943.534563977@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -26,6 +26,7 @@ static unsigned int priority_to_irq[EXCC
 static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 {
 	unsigned int irq = 0;
+	unsigned long old, new;
 
 	clear_bit(priority, &vcpu->arch.irq_pending);
 	if (priority < EXCCODE_INT_NUM)
@@ -36,7 +37,13 @@ static int kvm_irq_deliver(struct kvm_vc
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
@@ -53,6 +60,7 @@ static int kvm_irq_deliver(struct kvm_vc
 static int kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
 {
 	unsigned int irq = 0;
+	unsigned long old, new;
 
 	clear_bit(priority, &vcpu->arch.irq_clear);
 	if (priority < EXCCODE_INT_NUM)
@@ -63,7 +71,13 @@ static int kvm_irq_clear(struct kvm_vcpu
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


