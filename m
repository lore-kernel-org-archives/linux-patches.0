Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC4233689F;
	Tue, 21 Jul 2026 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654032; cv=none; b=i8psbUHMpAXk0hBUmbbe0A7mLslEkifKh2OS6qQLpp++Sjmb4F8BJAjR3RCDiXtpnftI/2mLCot7i5Dn5Ic9Cuha5YtXiut9j/TPO71/ICTwBD+SgZ50ik4cCX/iIzUDfWnI3imZyhO3KqMvrGT0DlVIe4hgoLK/Lazna9sNPSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654032; c=relaxed/simple;
	bh=KLdDGW2bc3AC09WJODE+aZ9Xlx/UxixJRWVUFdSqHa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1wFFBJjuH2UmiGWpAdbFrGWB4QKqqdfDEBSHbvrkteafq5wXrwxflFwFjCv9vaix8G8ssm2tx2NBj+6TKcdHQFwYpPHg9MF27cukevFr8tjQ3uYTuvVP/jQTNKDPysY14D49m2YPenz+Wo7Ry8BEPfJrWnwbrATGspnlIcXlAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLOQGKXr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLOQGKXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30F71F000E9;
	Tue, 21 Jul 2026 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654031;
	bh=Wrx/ui58sYhniQhwM7EWmu1gLitoCZvDOs0/LTJ3hbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLOQGKXr7cIgWGC5680ouRstf6UUVWvxTsdlrpgqT0bcI0JuqcuRLYTN4qWSNZ7F4
	 HgkgPxoz4bp5UwpBRnOfYV8cKrASamqLExdYyy7mffwspgYM73eLqLK0em5G98Qzap
	 wkzpM5hGYUCKJwlNVTJL3Iv2k7+SAhn5iaR8s5N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 1550/2077] LoongArch: KVM: Fix FPU register width with user access API
Date: Tue, 21 Jul 2026 17:20:23 +0200
Message-ID: <20260721152629.336205217@linuxfoundation.org>
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
@@ -1313,7 +1313,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct k
 	fpu->fcc = vcpu->arch.fpu.fcc;
 	fpu->fcsr = vcpu->arch.fpu.fcsr;
 	for (i = 0; i < NUM_FPU_REGS; i++)
-		memcpy(&fpu->fpr[i], &vcpu->arch.fpu.fpr[i], FPU_REG_WIDTH / 64);
+		memcpy(&fpu->fpr[i], &vcpu->arch.fpu.fpr[i], sizeof(union fpureg));
 
 	return 0;
 }
@@ -1325,7 +1325,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 	vcpu->arch.fpu.fcc = fpu->fcc;
 	vcpu->arch.fpu.fcsr = fpu->fcsr;
 	for (i = 0; i < NUM_FPU_REGS; i++)
-		memcpy(&vcpu->arch.fpu.fpr[i], &fpu->fpr[i], FPU_REG_WIDTH / 64);
+		memcpy(&vcpu->arch.fpu.fpr[i], &fpu->fpr[i], sizeof(union fpureg));
 
 	return 0;
 }


