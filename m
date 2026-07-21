Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D9A472F69;
	Tue, 21 Jul 2026 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663455; cv=none; b=DNgYdY76EXJazxrQKm0+EffOkFJL1NDq7lj9m/oZGcsLQXL4Bnpo6nbmZYnCHaP9WbiMHz0KQhYqDYmroESNFjU7Mpyn6/sgjnmKcuClZh4XXXfrjEGMjrPGfQX/VFUazUX6uh6XASrxR84/GQDxkW5OOcFJGArDPsvQClefN3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663455; c=relaxed/simple;
	bh=3jhoxhGj5tnlB2CDIWDXiJN1+LDz3u/EvlBqEuEgC9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgtBPE6pC4LVGuk8FT56pBgG+yQB4BIWQqGJOlKmosGoY75tOrIDyCx5d5la2QuXX/ERjjIjVRzU6OnZwTMyWegWumAsOo5/fgJV3jiOV9vljHAUuUMJNKjpbN3gfjmvGaCS5noLgDMyyDC2+wyncqDoXr4/wyJcWva8FWgfY7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aW9xrme0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aW9xrme0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C921F00A3A;
	Tue, 21 Jul 2026 19:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663453;
	bh=MJN2nO6KWALc/xHjWAY2DNSUmPeJ+Wz6IF84cOItQx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aW9xrme0CAIGOobBaByLkFLlCMQ4xUKI85HrOVN2KvPsUmpXiPahypGpwoTQKOBp1
	 wXNWOQm1uoxI0jzryBmWJ32Z9B81pCa7pT6avtYZubWzHUmlQuJKZNZSedTpLWEM4j
	 tRTtEYGRerDBec/WVCf6sIYg6Cy+V8qV/MqGkJcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0827/1276] LoongArch: KVM: Check irq validity in kvm_vcpu_ioctl_interrupt()
Date: Tue, 21 Jul 2026 17:21:10 +0200
Message-ID: <20260721152504.569170088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -1429,6 +1429,10 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq)
 {
 	int intr = (int)irq->irq;
+	unsigned int vector = abs(intr);
+
+	if (vector >= EXCCODE_INT_NUM)
+		return -EINVAL;
 
 	if (intr > 0)
 		kvm_queue_irq(vcpu, intr);


