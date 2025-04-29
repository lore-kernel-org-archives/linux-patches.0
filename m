Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1BC7E110;
	Tue, 29 Apr 2025 17:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946032; cv=none; b=OVA9Sg8CqHo3LTIvb6Qp1MeDTmgYpfl6S99G1C8/+X+R9fmw6cjBQiJvc4asGjz74UyA9R5l5nw0sqCbaa30dl6bpyqG7+A1eZ4wxisVIRDdqDzLqlvwlZVL2w46Iy95NhVYfNusr5y9usIYSTRgrz1Iqs5IBw3eOhxhQe3UCpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946032; c=relaxed/simple;
	bh=jelVxnANYkxCEDv6vkz2J1Xvrz2/NRFCorCwoLAiFxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVJJuBNVeVcgonZOCba00TlLvxzFZPEnoo4mr20I5w1G3oTPKBKBkADvxthJvgSMzwE6DlRxa/pHzgY7oy8P6XOyb0tRK99qOEd/cVFpFnuGNJcKMiPzKmC3MIvvVuwaXW7uycITuDxEE3L7fWWu2E8EnN+xOtb/219seYXZatI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPtlUj46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPtlUj46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1836C4CEE3;
	Tue, 29 Apr 2025 17:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946032;
	bh=jelVxnANYkxCEDv6vkz2J1Xvrz2/NRFCorCwoLAiFxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPtlUj46GLysOSp3x09Ai+m7SyZyXmP5e40WzEMc+OlHxbOFeg3xa23jv8n4wryCj
	 ekuLfi54dynNy1B+9TlNeKsB2sKW2roAgrmoZyhTFyb6/742bkC4Gb+VBx2XnAqIbh
	 +Mcy7WokMYX7sjMhxQ7nnCVSRh8aKKrZPaSMyiDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 132/311] LoongArch: KVM: Fully clear some CSRs when VM reboot
Date: Tue, 29 Apr 2025 18:39:29 +0200
Message-ID: <20250429161126.449263519@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 9ea86232a5520d9d21832d06031ea80f055a6ff8 upstream.

Some registers such as LOONGARCH_CSR_ESTAT and LOONGARCH_CSR_GINTC are
partly cleared with function _kvm_setcsr(). This comes from the hardware
specification, some bits are read only in VM mode, and however they can
be written in host mode. So they are partly cleared in VM mode, and can
be fully cleared in host mode.

These read only bits show pending interrupt or exception status. When VM
reset, the read-only bits should be cleared, otherwise vCPU will receive
unknown interrupts in boot stage.

Here registers LOONGARCH_CSR_ESTAT/LOONGARCH_CSR_GINTC are fully cleared
in ioctl KVM_REG_LOONGARCH_VCPU_RESET vCPU reset path.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -874,6 +874,13 @@ static int kvm_set_one_reg(struct kvm_vc
 			vcpu->arch.st.guest_addr = 0;
 			memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
 			memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
+
+			/*
+			 * When vCPU reset, clear the ESTAT and GINTC registers
+			 * Other CSR registers are cleared with function _kvm_setcsr().
+			 */
+			kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_GINTC, 0);
+			kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_ESTAT, 0);
 			break;
 		default:
 			ret = -EINVAL;


