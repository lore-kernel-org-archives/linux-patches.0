Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09363E5A1C;
	Tue, 12 May 2026 17:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608150; cv=none; b=rd/7lfooE17ZsLUVBtoLF4jXo+YlVmibBaMWjQJemaagkCnvlakmXQSEXWWb34xJkRtfFAvmxytTFQ/HeAPNLP7afyqQTWK2XSbbnksLDSV2DvcbTdny86EkmpuS1tQ9QWy8B5PlGsO3ST51ACJ3uxw7Oe1Ef9yKExN0WArJmq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608150; c=relaxed/simple;
	bh=QMu6uAw59xK3TdaRgbqHFffwa1nsD2C5KXHCJAKQrDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAsO7kT+rFRMcrybIjKJTmgzR5A/FdsluwvSxp315i6rip4eXi4yNuducOBjpfbLQQ/PPXjqVyGki3jnpRx5XUoLqnuMd+D+wzKrMUQy+EIJgH2F/2hQ4L1j0UHM/xskExde7DUo5p5ip+waf+XQE05O/uaDAKN2T7B9aJ/vH9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcAJPBua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcAJPBua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DAFC2BCB0;
	Tue, 12 May 2026 17:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608149;
	bh=QMu6uAw59xK3TdaRgbqHFffwa1nsD2C5KXHCJAKQrDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcAJPBuaPiiKav28+4sNl0fnl7h1ca3jvbrTf4Olhdw1FDB6QzuHn4cLZVZxPeJEU
	 PvWW+Irc1Oj/EnMo+6AvWuNzBU7oZ2BujyIv1Ccsu728rNYht2vDp6J+PCcM2tiqT8
	 yyPEum4KUTGWrPFbkqI1xLAoZr3+xWUPdQh/iMW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 174/206] LoongArch: KVM: Fix HW timer interrupt lost when inject interrupt by software
Date: Tue, 12 May 2026 19:40:26 +0200
Message-ID: <20260512173936.545531255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


