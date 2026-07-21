Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809BE472F71;
	Tue, 21 Jul 2026 19:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663473; cv=none; b=AK/IfNw+u/CAFWjfqYYnL19wiwZQXKv1J9sK/znFAt40dSqdJxavHZTsLflcOqOmcd3fTz5V1GrWtB+UTL50fgNfUe5jYwfsF2ECI5de5U3t3PZSTQzBv6nWpND8PSVDnKTRmJJDb0ZvN3pCUIj+kX1ECf7QZuqByHmlf3I7OJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663473; c=relaxed/simple;
	bh=8fk996TkM1IoIt9SD6nCz+/3BV+BOCq/Rw7v0S97ojc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYYUlzJci+ZTf7PMpEo8lMbf0QM8xxZOzgN1LwUcttOgWn/G+Rs/M1s+k7OKeZZpqvuMRkQNBcUjSezUWF12YF4w1kIWTSx1BC2p6fehdMQL4olX6TZUoINwKGDji83lqxeySmhHsoilBNykjoUFEMR3dzzZ+DTQPsj5ChMQGrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sqh03yv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sqh03yv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74D81F000E9;
	Tue, 21 Jul 2026 19:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663472;
	bh=55TWoWR4TXSu1oh8bxko1xaGz5Dyl8O+KRwEQe/Tuoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sqh03yv2y5nEmB5Ag3f/Y+SVXNs8ZCfod/aI+nwL5Eah5MJnfUfgrwjDMCSmpJ655
	 wIuq8zvCqCWQnkVfkupuFjTtwMO5r755Xt28HKz0yLXHQRWjWpgTLj+9LkPzKa9ZLj
	 ft3BQw+v+SJqTq62+6cMegWMqF8fD/setbE7py8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0829/1276] LoongArch: KVM: Fix FPU register width with user access API
Date: Tue, 21 Jul 2026 17:21:12 +0200
Message-ID: <20260721152504.612738610@linuxfoundation.org>
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

commit f4caaac76379daf4a617d9134b6087fb2636fb31 upstream.

At the beginning, only 64 bit FPU is supported. With FPU register get
interface, 64 bit FPU data is copied to user space, the same with FPU
register set API. However with LSX and LASX supported in later, there
should be FPU data copied with bigger width. So here fixes this issue,
copy the whole 256 bit FPU data from/to user space.

Cc: stable@vger.kernel.org
Fixes: db1ecca22edf ("LoongArch: KVM: Add LSX (128bit SIMD) support")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1234,7 +1234,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct k
 	fpu->fcc = vcpu->arch.fpu.fcc;
 	fpu->fcsr = vcpu->arch.fpu.fcsr;
 	for (i = 0; i < NUM_FPU_REGS; i++)
-		memcpy(&fpu->fpr[i], &vcpu->arch.fpu.fpr[i], FPU_REG_WIDTH / 64);
+		memcpy(&fpu->fpr[i], &vcpu->arch.fpu.fpr[i], sizeof(union fpureg));
 
 	return 0;
 }
@@ -1246,7 +1246,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 	vcpu->arch.fpu.fcc = fpu->fcc;
 	vcpu->arch.fpu.fcsr = fpu->fcsr;
 	for (i = 0; i < NUM_FPU_REGS; i++)
-		memcpy(&vcpu->arch.fpu.fpr[i], &fpu->fpr[i], FPU_REG_WIDTH / 64);
+		memcpy(&vcpu->arch.fpu.fpr[i], &fpu->fpr[i], sizeof(union fpureg));
 
 	return 0;
 }


