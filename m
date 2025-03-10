Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ADE230D0F;
	Mon, 10 Mar 2025 17:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627387; cv=none; b=OHOtiGAV26pbmcl/BO+oIFzN3JgmrUAAkn0fPNdB78vWYeH7ZyXV/AAKuA24fuKjvb7MoK9OA7PQiwA7y1gg0wEUtJjDgUjfx787S9sLJY12au39NVUuILS6RTjC2vq53QN3BbowdIOus8AM65lseSzN+zuaqtnqIAN33xON4fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627387; c=relaxed/simple;
	bh=dV7IMrglaS2mWMRPqwxl9HsQZOnc4vKZjT0AcBI/Uuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsRVaOCXRMQYLli2EcgMN7Ysej5Thhd2oLWxBfa8/uuHto3WHzAVuBXdJb8C4Rv9AQJ8E1rczW6xxzdl4omZ65gyLiZKtdYQtHQCqG5PnMH3MI1Iqpn6w9NKdZkXTWTp5UNvjJFdPB3Q7c2UTiJPJGAYgX1/z2696PNXtv1CSeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5CJqzk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5CJqzk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E52CC4CEE5;
	Mon, 10 Mar 2025 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627387;
	bh=dV7IMrglaS2mWMRPqwxl9HsQZOnc4vKZjT0AcBI/Uuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5CJqzk2w8wC22SWUqxaRRXztupZPMrfkO7bBXpEdjEnF57/vEeXdgcpsqduqRPca
	 8los+fmqvR59J6a5URUo1JI9LFMUt/oL3CvUL/5pxBr+tpDMLB/6NyYJteh2KMxOMP
	 eJuSSMTEZ+3F4BJjBbYo7igmnDLYsCXNIUeOpaho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 081/269] LoongArch: KVM: Fix GPA size issue about VM
Date: Mon, 10 Mar 2025 18:03:54 +0100
Message-ID: <20250310170500.952700456@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

commit 6bdbb73dc8d99fbb77f5db79dbb6f108708090b4 upstream.

Physical address space is 48 bit on Loongson-3A5000 physical machine,
however it is 47 bit for VM on Loongson-3A5000 system. Size of physical
address space of VM is the same with the size of virtual user space (a
half) of physical machine.

Variable cpu_vabits represents user address space, kernel address space
is not included (user space and kernel space are both a half of total).
Here cpu_vabits, rather than cpu_vabits - 1, is to represent the size of
guest physical address space.

Also there is strict checking about page fault GPA address, inject error
if it is larger than maximum GPA address of VM.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/exit.c |    6 ++++++
 arch/loongarch/kvm/vm.c   |    6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -624,6 +624,12 @@ static int kvm_handle_rdwr_fault(struct
 	struct kvm_run *run = vcpu->run;
 	unsigned long badv = vcpu->arch.badv;
 
+	/* Inject ADE exception if exceed max GPA size */
+	if (unlikely(badv >= vcpu->kvm->arch.gpa_size)) {
+		kvm_queue_exception(vcpu, EXCCODE_ADE, EXSUBCODE_ADEM);
+		return RESUME_GUEST;
+	}
+
 	ret = kvm_handle_mm_fault(vcpu, badv, write);
 	if (ret) {
 		/* Treat as MMIO */
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -46,7 +46,11 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	if (kvm_pvtime_supported())
 		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
 
-	kvm->arch.gpa_size = BIT(cpu_vabits - 1);
+	/*
+	 * cpu_vabits means user address space only (a half of total).
+	 * GPA size of VM is the same with the size of user address space.
+	 */
+	kvm->arch.gpa_size = BIT(cpu_vabits);
 	kvm->arch.root_level = CONFIG_PGTABLE_LEVELS - 1;
 	kvm->arch.invalid_ptes[0] = 0;
 	kvm->arch.invalid_ptes[1] = (unsigned long)invalid_pte_table;


