Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E3313C90B;
	Tue, 25 Jun 2024 10:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309689; cv=none; b=sGq1RcPj5ICzahTYBoaoR9cRNu3zgSrlk13PAb3hx7qUIVDxcoUcgUTiy+HeLG5F7qHTv+2UFzmRxGZquK7hgbIit/JsivtyYShC/CNSs69cW/nI8JbspQc4PPyPsNMzW8o1f0S+T1wRkoY2XVJYJr3CQpNy8lhrmHYRmWIWlTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309689; c=relaxed/simple;
	bh=VhE8Vnqy+8hiiXaYtII6Rt3GK1ZumQJ96sDH6tG22Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T21TZ3jYQPa7yeDH91G9/6osFeyQNkkDL5b0WmzAJOhLoRmCqZTgFJLAT6xZB3rm+DpbGDp+rvPpENNv3u+lHtNQpebHwukUJzzE7oC2DB2mwgVKrVMkN3srnGoE59K6pMRcn/sBPEKsHPlMp+Zi7AA5j/bhcUuPJ/xAEc+kx2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlQVuBCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlQVuBCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AB2C32781;
	Tue, 25 Jun 2024 10:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309688;
	bh=VhE8Vnqy+8hiiXaYtII6Rt3GK1ZumQJ96sDH6tG22Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlQVuBCxoSlwvDPNbM81c++CYrlL5ktfeePZEJShqiY8y+/ipkol45BMTc51ofduH
	 aQaslSlZ7EWqpYmdLYkFtkTuXZneG5iQHfvWWQVmU4gfT2ODkk/76hEJudmU4MbFk0
	 J7nkNiVHyOwdhKK7/IY8eVW74JRo7urdxLws9Fkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 099/131] KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
Date: Tue, 25 Jun 2024 11:34:14 +0200
Message-ID: <20240625085529.702063242@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3742,12 +3742,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int last_boosted_vcpu;
 	unsigned long i;
 	int yielded = 0;
 	int try = 3;
 	int pass;
 
+	last_boosted_vcpu = READ_ONCE(kvm->last_boosted_vcpu);
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
@@ -3778,7 +3779,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
 
 			yielded = kvm_vcpu_yield_to(vcpu);
 			if (yielded > 0) {
-				kvm->last_boosted_vcpu = i;
+				WRITE_ONCE(kvm->last_boosted_vcpu, i);
 				break;
 			} else if (yielded < 0) {
 				try--;


