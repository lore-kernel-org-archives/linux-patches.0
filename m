Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874D614A0BC;
	Tue, 25 Jun 2024 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309239; cv=none; b=m7pCxh4/RnYdb20Ybh+wkW/F+4qqTCJ1qvtCBhnXCgfBfAUOtiB6BKLhS8ErTjkljyoIblS63MZms8XeMvoIpFGiesgkYKQNxmfyrhS60IxOQxNPuykKzaf57iiSUshfut3u/pAEQdLpWBo6KK2Kzkz1tFMrh2w/OfB4tx7ehPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309239; c=relaxed/simple;
	bh=M0kg1O3DS11R3D8kmWw9rIUA+nhKECX3DhpZSUnes2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyb+Kq4xG3gKgb8GG9kalEB7c0irkU4Gq9r/esN22ZNiLOfylAkJMd7ERT+mUWdUSRY4ejJ2QVmf+3/uqLwapKIaF9NtiuaAMgDUeuqCIuLiVVorupOdbn2YcjRZ9lFwNZM9mALY9z9G83mrWwnbgrq9Dc0Y/9aJU8viqYaI7gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z30yo2py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z30yo2py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8306C32781;
	Tue, 25 Jun 2024 09:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309239;
	bh=M0kg1O3DS11R3D8kmWw9rIUA+nhKECX3DhpZSUnes2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z30yo2py6sjnF49s+uIHet6YfX0lsZbUEMsyMYkiUznvOgNX8HlSNqeCJwWQTgu5j
	 fOAMYxuNKAlUPmqoQm7z1GnbclXlN3L55g72dBfwR3Tp6sXM5zvSeHFypbbYBf0+5a
	 E4PJDHOrWv53TVDXfuIDnu7CPrGtO3aLNYcXqtxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 142/192] KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
Date: Tue, 25 Jun 2024 11:33:34 +0200
Message-ID: <20240625085542.609785922@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3772,12 +3772,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
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
@@ -3808,7 +3809,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
 
 			yielded = kvm_vcpu_yield_to(vcpu);
 			if (yielded > 0) {
-				kvm->last_boosted_vcpu = i;
+				WRITE_ONCE(kvm->last_boosted_vcpu, i);
 				break;
 			} else if (yielded < 0) {
 				try--;


