Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC131DDA0C;
	Tue,  8 Apr 2025 10:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109760; cv=none; b=GgyfJlQ2q44uGGV2Rkc5sF3g89Y+LTWbg684kbza2jY/fluLT8xeXHBhhS+af4LX00g5P9aO4r1l2WLpWtN0LaXguSXExZ9JK4TKcKM3ct1rVNNK/IMDohUja35zQx7akYWH232V0WkEh+oKqAChPtB1Pd3bn5oa43slgnkUaDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109760; c=relaxed/simple;
	bh=i6Y1/iwxyURZHdMIOiP4NvciPJAAIuDhMHvZUeLMQXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUFkBeGo4ZQnM3a+4kyT3yyqAIYvH7kvbXtM09sX+3wbBVF32Cqm+Ws/uIjua+t1Nd+M4bLQsUvvOj8PgSVmfhJs3IxjyjvLZz0Kd3HZHgrgEAM4HxTa8z4iVWMZhCCpX1MUuTXcU7G6nWBCVcNGvIPx6YaUBfupHpU5TFAJJ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRHF08P+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRHF08P+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA11C4CEEA;
	Tue,  8 Apr 2025 10:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109759;
	bh=i6Y1/iwxyURZHdMIOiP4NvciPJAAIuDhMHvZUeLMQXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRHF08P+03IMmvv481Q1bgw/hZE1nM3ZqGhz6xHuFwKLLZUwGMfAPwT5Q5Dsb6lo+
	 FESjh569nyztpmTK8pDQ88lzU+4iObdR1PyFSpydPz+fMJokJAfN1jHBdCa+4AZkW3
	 x2cFpVpvQIxuPHM10HbGDFzIBy9NQxIoaWZuZDtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongjie Zou <zoudongjie@huawei.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Abdelkareem Abdelsaamad <kareemem@amazon.com>
Subject: [PATCH 5.10 005/227] KVM: x86: Reject Hyper-Vs SEND_IPI hypercalls if local APIC isnt in-kernel
Date: Tue,  8 Apr 2025 12:46:23 +0200
Message-ID: <20250408104820.530848257@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit a8de7f100bb5989d9c3627d3a223ee1c863f3b69 upstream.

Advertise support for Hyper-V's SEND_IPI and SEND_IPI_EX hypercalls if and
only if the local API is emulated/virtualized by KVM, and explicitly reject
said hypercalls if the local APIC is emulated in userspace, i.e. don't rely
on userspace to opt-in to KVM_CAP_HYPERV_ENFORCE_CPUID.

Rejecting SEND_IPI and SEND_IPI_EX fixes a NULL-pointer dereference if
Hyper-V enlightenments are exposed to the guest without an in-kernel local
APIC:

  dump_stack+0xbe/0xfd
  __kasan_report.cold+0x34/0x84
  kasan_report+0x3a/0x50
  __apic_accept_irq+0x3a/0x5c0
  kvm_hv_send_ipi.isra.0+0x34e/0x820
  kvm_hv_hypercall+0x8d9/0x9d0
  kvm_emulate_hypercall+0x506/0x7e0
  __vmx_handle_exit+0x283/0xb60
  vmx_handle_exit+0x1d/0xd0
  vcpu_enter_guest+0x16b0/0x24c0
  vcpu_run+0xc0/0x550
  kvm_arch_vcpu_ioctl_run+0x170/0x6d0
  kvm_vcpu_ioctl+0x413/0xb20
  __se_sys_ioctl+0x111/0x160
  do_syscal1_64+0x30/0x40
  entry_SYSCALL_64_after_hwframe+0x67/0xd1

Note, checking the sending vCPU is sufficient, as the per-VM irqchip_mode
can't be modified after vCPUs are created, i.e. if one vCPU has an
in-kernel local APIC, then all vCPUs have an in-kernel local APIC.

Reported-by: Dongjie Zou <zoudongjie@huawei.com>
Fixes: 214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
Fixes: 2bc39970e932 ("x86/kvm/hyper-v: Introduce KVM_GET_SUPPORTED_HV_CPUID")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20250118003454.2619573-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ Conflict due to 72167a9d7da2 ("KVM: x86: hyper-v: Stop shadowing
  global 'current_vcpu' variable") not in the tree ]
Signed-off-by: Abdelkareem Abdelsaamad <kareemem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1618,6 +1618,9 @@ static u64 kvm_hv_send_ipi(struct kvm_vc
 	u32 vector;
 	bool all_cpus;
 
+	if (!lapic_in_kernel(current_vcpu))
+		return HV_STATUS_INVALID_HYPERCALL_INPUT;
+
 	if (!ex) {
 		if (!fast) {
 			if (unlikely(kvm_read_guest(kvm, ingpa, &send_ipi,
@@ -2060,7 +2063,8 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct k
 			ent->eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
 			ent->eax |= HV_X64_APIC_ACCESS_RECOMMENDED;
 			ent->eax |= HV_X64_RELAXED_TIMING_RECOMMENDED;
-			ent->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
+			if (!vcpu || lapic_in_kernel(vcpu))
+				ent->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
 			ent->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
 			if (evmcs_ver)
 				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;


