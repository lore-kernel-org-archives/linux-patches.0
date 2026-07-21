Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86893909A9;
	Tue, 21 Jul 2026 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658384; cv=none; b=DPfS7p7OD0FXlhYTfDC9DfDT8Yn/dm4PnibQhw2676GOdCtoOxiVknIFGawqUoTmsxR9TFHbmRook39DK4yQ8pGJsJxgZ6CAhDSWhgsVGwKbOB5hdBrvnnYgElQAbxjRf0xowfND2KvnTNhGBTwXCwSDzDKEx7eoJBDIPlyr/os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658384; c=relaxed/simple;
	bh=NZkBp3cGPkNalr5jQJO39YhtTSx3zOykRmzA+M5HGsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEG795X1tu4INAQdSwR7r4Y4LO6I9Lmm69bwvyLL8ngCZK5XWTuYBfyc5v1uJErCGk3x1rSXrmRpczH5Pm6sjnIh/sfFdcOR5PBDbtzs18NBtZ9rBJWoPuYZpfFgT1DigSdZn/3nKFl1ocExzxvvEW3tUdsJrY+fpjCkNzrLuNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3kP2nCp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3kP2nCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A21A1F000E9;
	Tue, 21 Jul 2026 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658383;
	bh=KLyH3d5EeNDzRRfHOAHWDYAmTVGtjGGPqIpYaIArp34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3kP2nCpGciWLqqN1q+wlmJYgaLP9RCzHlLCIRiek3/Tl7+3Vk9YLpgpbmQAzpbgq
	 a2XyJj/Aa1/Sy4yi9oYCO6RdDRpwB0egSMT4FM7CiDhU3vqSpf7yivj1aJ+fCh+ReR
	 5yox8zIwmg50QOcBxFGMGJE07keoHHNnJEROsscM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 1124/1611] LoongArch: KVM: Check irq validity in kvm_vcpu_ioctl_interrupt()
Date: Tue, 21 Jul 2026 17:20:40 +0200
Message-ID: <20260721152540.700772139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1461,6 +1461,10 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq)
 {
 	int intr = (int)irq->irq;
+	unsigned int vector = abs(intr);
+
+	if (vector >= EXCCODE_INT_NUM)
+		return -EINVAL;
 
 	if (intr > 0)
 		kvm_queue_irq(vcpu, intr);


