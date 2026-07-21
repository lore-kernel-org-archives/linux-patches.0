Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DC246D2A4;
	Tue, 21 Jul 2026 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654024; cv=none; b=LPyY3tTqD4wV4VLDBlR3PYwAbyCCu83sgPmk643s8L4XJLR+hxhmBQSiYITgERDV4pe6gTc4FmqRJT4EBDx4PelHDTS8SUn3UjoghEeZ19zrU7IgNicLpYVlvvKMv6gmcgzcvac6naxvNnjaDI1U7cAxpNAXWE1Be8FeaViIA0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654024; c=relaxed/simple;
	bh=G/VDIHk+O9xWIXSIrqAJFNt/olbhKlTV/BZkDTu3ISg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhAHRaYKGk4dwGzExMVS0iWYJWJBjOcEEztbcfwX9FlPmEj5K2Q0X/UvV9dvkpXWA2petL4bv+o4oh0kVmXV5FU91ch37SKtlMJO7rrGN3LrcE/yqWh2H3tYm1d6S2AikXPZShangeBUHSC2dgc/f584KsRgCybx/6ywynbegqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJV/l+U+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJV/l+U+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E331F000E9;
	Tue, 21 Jul 2026 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654023;
	bh=fZioaNBWNl8EIiqZSk0mZMumvnRL3tYASeZCoTgmj8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJV/l+U+sfJOsX+PV1lj/7pQOZPKsTRGi0YUTTLpstdPoMZ1FPDjSu1vBeXurHxOm
	 m0xS4OjkpqHNLwM0URo6VvvfSnxjQuZylobLPhSZt4Y33AdOa30QvgUZn2aQ9PvAqf
	 FVRj8polyLS+0Ac4Lqt2Txkr66uJJCcSR/4xDfCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 1548/2077] LoongArch: KVM: Check irq validity in kvm_vcpu_ioctl_interrupt()
Date: Tue, 21 Jul 2026 17:20:21 +0200
Message-ID: <20260721152629.289114923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 09b318ab77b7a4fc9987fd98d1525fc55ddc2617 upstream.

Function kvm_vcpu_ioctl_interrupt() can be called from userspace, here
add irq validility cheking in kvm_vcpu_ioctl_interrupt().

Cc: stable@vger.kernel.org
Fixes: f45ad5b8aa93 ("LoongArch: KVM: Implement vcpu interrupt operations")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1487,6 +1487,10 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq)
 {
 	int intr = (int)irq->irq;
+	unsigned int vector = abs(intr);
+
+	if (vector >= EXCCODE_INT_NUM)
+		return -EINVAL;
 
 	if (intr > 0)
 		kvm_queue_irq(vcpu, intr);


