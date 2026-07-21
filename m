Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E95646A5FD;
	Tue, 21 Jul 2026 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658390; cv=none; b=ZdriCBuJMmS9GxHxSD2o8073QvA6DhgPpQUXnQko+qy2EEDdgShWZ0e3uYCBa6iGdtQQHXhe5I1SNz4IosJPKN0WfbLGFGXXDsG+BhxAGr7gw7H55wMPM4viZVe0+WTvQQqXuA+Ik3qs9xIL0DVkqR+tPy8tmheyaIqilC2PTVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658390; c=relaxed/simple;
	bh=mWZx17PKmqh9yn/2X85TRb7s2KBFgRdmY+JJugDXCUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYUAuAPC0HjyPNaFbArVu3u46d4/U+DiDuT3pbH1GJ/zsDagfz3UYtrl7HOPvNlpOcUiYiuzx1RNdgEBFRFziwB3ciNtykj4JYF5aSybFb8UwusHEJovBng3+ZbvEvMRibS0/gFlmuBDIVXpHtwX8+fJx2NzJj5E0RHycKTwwT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WM9gK8na; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WM9gK8na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9591F00A3D;
	Tue, 21 Jul 2026 18:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658388;
	bh=8wF5VgBx8EcH4nOoyJp47VqsHl60QITQDnwjKipoe2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WM9gK8na//8vMcdVhBmKGQIFJvK8JiMOwEPL/KJJn9OfpuDokHwyc0thwTq9xf8H+
	 nm7r6viZqdLEVaDNXPnd0gWCZg2WGT4UORDGxJEDLUNFozziksirEbKf0tZLsgsdea
	 WS5tkENz/aW5KAzAg5FAcQK3C3TvkQkRIXR2VRrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 1126/1611] LoongArch: KVM: Fix FPU register width with user access API
Date: Tue, 21 Jul 2026 17:20:42 +0200
Message-ID: <20260721152540.747157175@linuxfoundation.org>
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
@@ -1266,7 +1266,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct k
 	fpu->fcc = vcpu->arch.fpu.fcc;
 	fpu->fcsr = vcpu->arch.fpu.fcsr;
 	for (i = 0; i < NUM_FPU_REGS; i++)
-		memcpy(&fpu->fpr[i], &vcpu->arch.fpu.fpr[i], FPU_REG_WIDTH / 64);
+		memcpy(&fpu->fpr[i], &vcpu->arch.fpu.fpr[i], sizeof(union fpureg));
 
 	return 0;
 }
@@ -1278,7 +1278,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 	vcpu->arch.fpu.fcc = fpu->fcc;
 	vcpu->arch.fpu.fcsr = fpu->fcsr;
 	for (i = 0; i < NUM_FPU_REGS; i++)
-		memcpy(&vcpu->arch.fpu.fpr[i], &fpu->fpr[i], FPU_REG_WIDTH / 64);
+		memcpy(&vcpu->arch.fpu.fpr[i], &fpu->fpr[i], sizeof(union fpureg));
 
 	return 0;
 }


