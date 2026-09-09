Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522F256511F;
	Wed,  9 Sep 2026 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962551; cv=none; b=avJ81b20zFav7vvcsHmuZkqf2hmP/BZJ0/hnzsFkh0Rvj/i3IzgFU9FBjJ5wlDH2awHgsqhs4yJ96uPtMsMP7M5XC2kfanasn75ItyQGLYwIzP89JwBAIxaYvjiSoM5DdZzCwymbEnyqogagihA5ie9hogePMY0slnmNqS0/fgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962551; c=relaxed/simple;
	bh=SHQRVAb/HBHaN4wHAJH9YHH4ZL7WPgmPS7oQHVIOTTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDvs1df9fZthZAzJN+xlXonHAd2iSkbcEPFMmWBGvwX7brfcl0G3QVjsK3H53btBfrIkUb0asKsbr4QZfD/fU1QY4oQ00/NeJD/PNJWbutWsaQBP7iunMBY2E6nJIuYDahK1/dwAvU93IGVckHApwAWS8XEQzzarp9+Z194L3h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUlI51aW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUlI51aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77241F00A3A;
	Wed,  9 Sep 2026 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962550;
	bh=P21CIGGRsY56vxOkK9qNHOqdrpypsyjeYqLhuWCxrD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUlI51aWFBOX2sRiLjyo52HyDneGiWS+dUaUKi3gOcXnRDtgEjt7prEmEz1iGNhG2
	 XqqPk0l3yaP7Pczxd3f5MvnDDnWJa5OJWvSMe/xEPp/WuJz1eGkMMMy9XmImuLDvRZ
	 1ZgejRW3mI5hYH/NwiPMAp/zYR7Zw53PkCrP1KAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Zeng Chi <zengchi@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 328/556] LoongArch: KVM: Fix PC double advance in kernel MMIO read fast path
Date: Wed,  9 Sep 2026 15:40:08 +0200
Message-ID: <20260909134242.195923742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Chi <zengchi@kylinos.cn>

commit fd4021529faa931818186b6e83bd46f5de7517eb upstream.

In the in-kernel MMIO read fast path of kvm_emu_mmio_read(),
kvm_complete_mmio_read() already advances the guest PC via update_pc().
The explicit update_pc() call right after it advances the PC a second
time, so PC moves forward by 8 bytes instead of 4, and the instruction
following the MMIO read is silently skipped.

The user space MMIO read completion path in kvm_arch_vcpu_ioctl_run()
calls kvm_complete_mmio_read() only once, and the MMIO write fast path
advances the PC exactly once as well.

Here remove the redundant update_pc() so the kernel MMIO read fast path
advances the PC by a single instruction.

Cc: stable@vger.kernel.org
Fixes: 80edf90831a2 ("LoongArch: KVM: Add sign extension with kernel MMIO read emulation")
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/exit.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -481,7 +481,6 @@ int kvm_emu_mmio_read(struct kvm_vcpu *v
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (!ret) {
 			kvm_complete_mmio_read(vcpu, run);
-			update_pc(&vcpu->arch);
 			vcpu->mmio_needed = 0;
 			return EMULATE_DONE;
 		}


