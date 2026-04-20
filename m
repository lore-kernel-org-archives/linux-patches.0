Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E1B34404B;
	Mon, 20 Apr 2026 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701062; cv=none; b=dF0N1vTahKhyhBtJdkALda0dfOpdRs/ZhUuQcmTNVbrjpktGg2kssNuhncN9pCE55v9UQB5LS4XzjhNXadaFCy5Tv2y9X1wdpG8EnAUNYbI0mT1DidxlIyTIc/wy89QLGIUHpOBNtQIw6TW/Me+W7Rqy95NXqWViwMpl2HVuxe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701062; c=relaxed/simple;
	bh=acyu2+MNpRmpeUXMPPRyDTHj7AOHA8HaaZnRIr6WojY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eB49cuAxXAjdzB/t0JaChsN/kwhrczUaqA2ogzzN7aHLWA95PZ7vETpJvzFBPh8EF+qIIoJFqRBlBpRIb+6TCP2SV/7B7wx+hzLcSoecBOoj2zC4Kn8EV8Q5euSCBOVU9pj3WhXeKLp6zsBW05r9/pGoUuODa334mBr4o7U8dfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3VHAEKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3VHAEKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D4BC19425;
	Mon, 20 Apr 2026 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701061;
	bh=acyu2+MNpRmpeUXMPPRyDTHj7AOHA8HaaZnRIr6WojY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3VHAEKj4gwMI/TxFkeU8OE/wbTawXl3qZHIb+zZUHGlAWqqZgS4aClCQu4p8x8fo
	 3eiS27wFrLvPiHCAZlbLMym9Q/x+iBT9tz93g+mDiHg5PTnSVh22gkr2gXTNeFx2IX
	 0M8fJrSL4degIcqqVVzpbs6MI91ej3VKXRGBCrNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Beekman <jethro@fortanix.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 166/198] KVM: SEV: Reject attempts to sync VMSA of an already-launched/encrypted vCPU
Date: Mon, 20 Apr 2026 17:42:25 +0200
Message-ID: <20260420153941.588626569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 9b9f7962e3e879d12da2bf47e02a24ec51690e3d upstream.

Reject synchronizing vCPU state to its associated VMSA if the vCPU has
already been launched, i.e. if the VMSA has already been encrypted.  On a
host with SNP enabled, accessing guest-private memory generates an RMP #PF
and panics the host.

  BUG: unable to handle page fault for address: ff1276cbfdf36000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x80000003) - RMP violation
  PGD 5a31801067 P4D 5a31802067 PUD 40ccfb5063 PMD 40e5954063 PTE 80000040fdf36163
  SEV-SNP: PFN 0x40fdf36, RMP entry: [0x6010fffffffff001 - 0x000000000000001f]
  Oops: Oops: 0003 [#1] SMP NOPTI
  CPU: 33 UID: 0 PID: 996180 Comm: qemu-system-x86 Tainted: G           OE
  Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
  Hardware name: Dell Inc. PowerEdge R7625/0H1TJT, BIOS 1.5.8 07/21/2023
  RIP: 0010:sev_es_sync_vmsa+0x54/0x4c0 [kvm_amd]
  Call Trace:
   <TASK>
   snp_launch_update_vmsa+0x19d/0x290 [kvm_amd]
   snp_launch_finish+0xb6/0x380 [kvm_amd]
   sev_mem_enc_ioctl+0x14e/0x720 [kvm_amd]
   kvm_arch_vm_ioctl+0x837/0xcf0 [kvm]
   kvm_vm_ioctl+0x3fd/0xcc0 [kvm]
   __x64_sys_ioctl+0xa3/0x100
   x64_sys_call+0xfe0/0x2350
   do_syscall_64+0x81/0x10f0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7ffff673287d
   </TASK>

Note, the KVM flaw has been present since commit ad73109ae7ec ("KVM: SVM:
Provide support to launch and run an SEV-ES guest"), but has only been
actively dangerous for the host since SNP support was added.  With SEV-ES,
KVM would "just" clobber guest state, which is totally fine from a host
kernel perspective since userspace can clobber guest state any time before
sev_launch_update_vmsa().

Fixes: ad27ce155566 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command")
Reported-by: Jethro Beekman <jethro@fortanix.com>
Closes: https://lore.kernel.org/all/d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260310234829.2608037-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -871,6 +871,9 @@ static int sev_es_sync_vmsa(struct vcpu_
 	u8 *d;
 	int i;
 
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	/* Check some debug related fields before encrypting the VMSA */
 	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
 		return -EINVAL;


