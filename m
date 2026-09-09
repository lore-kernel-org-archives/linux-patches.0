Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A38A58FD13;
	Wed,  9 Sep 2026 14:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963974; cv=none; b=DeEBnDJM+F7K68PtHMymKtsg44qHdDLjYLzEeRXotz5lMqU5UE5vtIuOCuUvlJYv2at8Dh6K7Y1v+usnpPLX+CuCnUpSa8lHKH6nRYwwAT0x1XQMHY5x1MOBh2v9EQfYZO/K/wwd4ypcAbGOgWtiuWyZf1W4Pclz1CdE/rjD8hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963974; c=relaxed/simple;
	bh=HFlAvYT+A8c1qv3uhXZlxHzOxMYBA3KnCqscqBr1GGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4M8Bh58HsblkXGu90321aP096MNJXZzSdiDdwVR2/qIpeGOja1xdDYfLgx5fZnwN2/BboQEVZXYuQz4ErK2adFTao+mrwn/NV+Y6I7KeG8juRyVTwZ4LJ/TIaXbL0I9d7SgmFEb+1K2Ca2VSna4FcvGRvqUByEjI15sBRoXiso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1FUNuh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1FUNuh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30E81F00A3A;
	Wed,  9 Sep 2026 14:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963973;
	bh=LvjcxPx0k1P8zDG88iagbL0oBDiMNZcrHQv9BZYXuys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1FUNuh7CexSQBAGhuSjYF9PZT+B3kttoW3Nb68AnOR7ZzDiPFIwAruRuRstxXhFk
	 eodPeciFmoedRsd5bqT7jQfugLh4lZjW8PGUbjqln9FEvz+gN4eb2lbKJtQQ7d/VHE
	 ZV2hDngi6BksVUXo4v3HQ9jqkVdzdF0L1ZTUAKhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Zeng Chi <zengchi@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 262/583] LoongArch: KVM: Fix PC double advance in kernel MMIO read fast path
Date: Wed,  9 Sep 2026 15:39:07 +0200
Message-ID: <20260909134247.175571025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
 arch/loongarch/kvm/exit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 8572b63478bb..482ba17bcd3d 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -481,7 +481,6 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (!ret) {
 			kvm_complete_mmio_read(vcpu, run);
-			update_pc(&vcpu->arch);
 			vcpu->mmio_needed = 0;
 			return EMULATE_DONE;
 		}
-- 
2.55.0



