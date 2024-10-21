Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166941E3DF0;
	Mon, 21 Oct 2024 10:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507763; cv=none; b=Bz6gtoVB9VPaYOPUToCgGNZPcS65XfsSFKk5pVTY6RhJhn7MIAGnh8AEOCIwrRaqIgkCdzzZTLkqwKZrQEh5oAKt9FYJ6FZC+3jeTPsxvWLkcEpum6/z+BdlqzmsFny2onifDemuXi9GrUmsRzAPsXZtpz/N2MjIh70qcInSx7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507763; c=relaxed/simple;
	bh=evC+SJpD+zFCFu9Ux7qB9NsiuT7o6ArcGQxGRduwiwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPWls1AOaPeUQmyMO9BEwooKUduY3R9sxVQmhMWU/kgxhHYbKL+Kw5WCuqtMG1q5belv8T4UixDg/5IyyTsIG1Tnfcu0CFfxpqWcLqzkXs2QeHXu0bHqXwjX3GJuM621EW106V9tH5saD0je/P/TkQQQFcrKfdT4U1x1FPa1aXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIEdppGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIEdppGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6B1C4CEC3;
	Mon, 21 Oct 2024 10:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507762;
	bh=evC+SJpD+zFCFu9Ux7qB9NsiuT7o6ArcGQxGRduwiwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIEdppGSICl/wBBKTTrw3sxjmu9eeQsW5xtrGJO1P5XpT/3AxJdSGY8yUy9uwj9kR
	 73YdlQ6eL8khBefBqFdsCHwW7kh1EAo5xo/HhIvTNUwkm2XKaLvlWCvgu/CllbmPcF
	 jG8RxfWtwo4jrUt3/qaKS7P5Yh9GRFxrdG81dXPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Sean Christopherson <seanjc@google.com>,
	Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Subject: [PATCH 5.10 11/52] KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
Date: Mon, 21 Oct 2024 12:25:32 +0200
Message-ID: <20241021102242.069895603@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Breno Leitao <leitao@debian.org>

commit 49f683b41f28918df3e51ddc0d928cb2e934ccdb upstream.

Use {READ,WRITE}_ONCE() to access kvm->last_boosted_vcpu to ensure the
loads and stores are atomic.  In the extremely unlikely scenario the
compiler tears the stores, it's theoretically possible for KVM to attempt
to get a vCPU using an out-of-bounds index, e.g. if the write is split
into multiple 8-bit stores, and is paired with a 32-bit load on a VM with
257 vCPUs:

  CPU0                              CPU1
  last_boosted_vcpu = 0xff;

                                    (last_boosted_vcpu = 0x100)
                                    last_boosted_vcpu[15:8] = 0x01;
  i = (last_boosted_vcpu = 0x1ff)
                                    last_boosted_vcpu[7:0] = 0x00;

  vcpu = kvm->vcpu_array[0x1ff];

As detected by KCSAN:

  BUG: KCSAN: data-race in kvm_vcpu_on_spin [kvm] / kvm_vcpu_on_spin [kvm]

  write to 0xffffc90025a92344 of 4 bytes by task 4340 on cpu 16:
  kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112) kvm
  handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
  vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:?
		 arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
  vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
  kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
  kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
  __se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
  __x64_sys_ioctl (fs/ioctl.c:890)
  x64_sys_call (arch/x86/entry/syscall_64.c:33)
  do_syscall_64 (arch/x86/entry/common.c:?)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

  read to 0xffffc90025a92344 of 4 bytes by task 4342 on cpu 4:
  kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4069) kvm
  handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
  vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:?
			arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
  vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
  kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
  kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
  __se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
  __x64_sys_ioctl (fs/ioctl.c:890)
  x64_sys_call (arch/x86/entry/syscall_64.c:33)
  do_syscall_64 (arch/x86/entry/common.c:?)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

  value changed: 0x00000012 -> 0x00000000

Fixes: 217ece6129f2 ("KVM: use yield_to instead of sleep in kvm_vcpu_on_spin")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20240510092353.2261824-1-leitao@debian.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3090,12 +3090,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int last_boosted_vcpu;
 	int yielded = 0;
 	int try = 3;
 	int pass;
 	int i;
 
+	last_boosted_vcpu = READ_ONCE(kvm->last_boosted_vcpu);
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
@@ -3126,7 +3127,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
 
 			yielded = kvm_vcpu_yield_to(vcpu);
 			if (yielded > 0) {
-				kvm->last_boosted_vcpu = i;
+				WRITE_ONCE(kvm->last_boosted_vcpu, i);
 				break;
 			} else if (yielded < 0) {
 				try--;


