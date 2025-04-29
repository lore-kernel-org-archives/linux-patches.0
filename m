Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F7E22A81D;
	Tue, 29 Apr 2025 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947904; cv=none; b=ZYNWD5IHtQqGXNRFSGKAmEIXtHl23Ul+jixN1xlY2Ta2ozZF2kbGl+JNmcYYtnruSff02OebaHacMxTkuro+sd1IEmoolk74WNqqyytg8YP/yWSXJRKlGvtHxAtnL8aBvCOlfuotbKaw86GhSI3D8G4t7gOTDrQz0nsJNXUcKyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947904; c=relaxed/simple;
	bh=uiWWJZTe/7OrMnvUAZg4hyzxKHCtgLJ0vGs1sBAeikI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fknXOmAxdL6DXcG6OKkZ4dNbtqbDq95BC3zFz5DZg5bDRA9BgTpXO71LSReNyIek1DdTiqUhpkyAff0J5qbkh1OoZ8HHHlbI2RHYuTDG5canQHmzTWwH8tdrAsECnGoGpz0ML+WJODIX4jxrpsOYkx94OBClB+PLAdthlm/OF5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vI74c+Kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI74c+Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A0DC4CEE3;
	Tue, 29 Apr 2025 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947904;
	bh=uiWWJZTe/7OrMnvUAZg4hyzxKHCtgLJ0vGs1sBAeikI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI74c+KfQy/EZ0alrOp2o4qnyh3DWcH815hUn1/rmIM5kz5Uh9jJUsIo/vJq76XAM
	 h8SGpmzOW8i7tEhuB5Ij49dujCqwr1KY+nfO3gefc7aG8iTs9G6CV4GI2iU4KeN4on
	 bsvw9m195lsIugIpNQYIj2YFTDy1MNBfDgNSMABY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 110/280] LoongArch: KVM: Fully clear some CSRs when VM reboot
Date: Tue, 29 Apr 2025 18:40:51 +0200
Message-ID: <20250429161119.615337418@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


