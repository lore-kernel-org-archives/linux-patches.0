Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9EB4CF49B;
	Sat, 17 Oct 2026 16:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256187; cv=none; b=qauCuAA9V3dtZdq6xhY+npDebR2oP97GDiWeTlWPr7X91Ow8zTVQj2Jc/mdZY4gur51/fv/iO9KQQLIdzRMijXvim6SNw8017Z1YBVlqEPa2E/lC7qF03vd8NarG1QjzEtkenSWLlm07fbR1E+Xrl7pBTVKY9AEFs+Oufqoiy70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256187; c=relaxed/simple;
	bh=l/Gmjms7Zb+yAZaQcnjBWSxRGG/9OI5H9pZhkrq1e1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI36Yfqy9GgpfHAsEqgfCBbeywu/p8/aKFelh1zCzYlQlmRwkhIxjZ43MKCXNpuPZtXFjbUkjrPARXiippq3k+2tiZCmxiUmVUJM0QmlaCnu6KADivh9mukGV6Bc6I9Lw68drJve2XrId3izMkcovhAdVeiJk0JAZULRLWLLuTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXthyOaR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXthyOaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65901F000C4;
	Sat, 17 Oct 2026 16:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256186;
	bh=y8mWKCjiww+kWlgdbS7WYFC1+Rkhs0pDIuo+dPAeEfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXthyOaRM7LFcugK0wDhwBi17I96Vvj///QIy5qTUrdcott/dlRPhtDWg/dE5yrPR
	 IR4ogw1llHgn8YKNljOT35jXckHujb9ajiXKTwLcG7U93nm4chPp1KnpSRNwEiaxGk
	 ZE9AwMccEd90sosxhw7T6O+MWB4vMUeiUR5+hwpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0152/1674] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr()
Date: Sat, 17 Oct 2026 17:40:24 +0200
Message-ID: <20261017160435.065249935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiakai Xu <jiakaipeanut@gmail.com>

[ Upstream commit 11366ead4f1412befea660777576c89a1bac0c1e ]

Add a null pointer check for imsic_state before dereferencing it in
kvm_riscv_aia_imsic_has_attr(). While the function checks that the
vcpu exists, it doesn't verify that the vcpu's imsic_state has been
initialized, leading to a null pointer dereference when accessed.

This issue was discovered during fuzzing of RISC-V KVM code. The
crash occurs when userspace calls KVM_HAS_DEVICE_ATTR ioctl on an
AIA IMSIC device before the IMSIC state has been fully initialized
for a vcpu.

The crash manifests as:
  Unable to handle kernel paging request at virtual address
  dfffffff00000001
  ...
  epc : kvm_riscv_aia_imsic_has_attr+0x464/0x50e
  arch/riscv/kvm/aia_imsic.c:998
  ...
  kvm_riscv_aia_imsic_has_attr+0x464/0x50e arch/riscv/kvm/aia_imsic.c:998
  aia_has_attr+0x128/0x2bc arch/riscv/kvm/aia_device.c:471
  kvm_device_ioctl_attr virt/kvm/kvm_main.c:4722 [inline]
  kvm_device_ioctl+0x296/0x374 virt/kvm/kvm_main.c:4739
  ...

The fix adds a check to return -ENODEV if imsic_state is NULL, which
is consistent with other error handling in the function and prevents
the null pointer dereference.

Fixes: 5463091a51cf ("RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260125143344.2515451-1-xujiakai2025@iscas.ac.cn
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/aia_imsic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 22782b009e370..9e8785e67b6db 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -945,8 +945,11 @@ int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type)
 	if (!vcpu)
 		return -ENODEV;
 
-	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 	imsic = vcpu->arch.aia_context.imsic_state;
+	if (!imsic)
+		return -ENODEV;
+
+	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 	return imsic_mrif_isel_check(imsic->nr_eix, isel);
 }
 
-- 
2.53.0



