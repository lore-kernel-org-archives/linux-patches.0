Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F065D30216D;
	Sat, 17 Oct 2026 16:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253840; cv=none; b=Gg5fcIreU+9FdETrfbGT1fwsOZB8GW1PSQyrw0SS0yeE7WMiSQ0JNwhU/Txa0k4P/lfGaunidhsDc9KVOXwvWQ3s8XaQ8c+FybrK6jiPxc5DQOF+htYnT94gYrdGppQ3rRXlTFmVgT2X78BAMW/eFy3wiSWQU4GWsmgCbZAH84A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253840; c=relaxed/simple;
	bh=LLSoSSewzZwGEv7pzPjEojdnLVAW8sqb+GHNl3FAyHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgHVkLwJL9VseUdZCGfBaL3RNIdibmSNN8QbvwyQT1we6AUolL5XCWUg7giK+peboUdwa4/AjCC+HKGjbBqc+85i2Bz2GFcbdNugyAM4ZiSO5GEN4Qiv7rW1oJiU1yAsoRrQS5YEZfyEuv8ROQmRniY5B1Cz1YQCfAoSFBBTM3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJe5VzrH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJe5VzrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CBC1F000C4;
	Sat, 17 Oct 2026 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253838;
	bh=GCzNAkqW9oDFMfxqeMJB3UWox6w1QVdc8+RUc7UXAPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJe5VzrHI1DezYFjXiYrDPKPLE/StreeI+qxPl+afWO0WnPAW46NgYD5IovzkBnD5
	 z9nAI1wuXf/FDmkscfRaE/XFSjkYPEdH5qTMRzNH9x6mp3ScIsrrxVvMM/haN83mW7
	 6hnPSnFgmZnh14NiqPjyPjh/k/qSpfsIVKXaFRTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/869] KVM: SEV: Protect *all* of sev_mem_enc_register_region() with kvm->lock
Date: Sat, 17 Oct 2026 17:50:41 +0200
Message-ID: <20261017160042.187319506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit b6408b6cec5df76a165575777800ef2aba12b109 ]

Take and hold kvm->lock for before checking sev_guest() in
sev_mem_enc_register_region(), as sev_guest() isn't stable unless kvm->lock
is held (or KVM can guarantee KVM_SEV_INIT{2} has completed and can't
rollack state).  If KVM_SEV_INIT{2} fails, KVM can end up trying to add to
a not-yet-initialized sev->regions_list, e.g. triggering a #GP

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  CPU: 110 UID: 0 PID: 72717 Comm: syz.15.11462 Tainted: G     U  W  O        6.16.0-smp-DEV #1 NONE
  Tainted: [U]=USER, [W]=WARN, [O]=OOT_MODULE
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 12.52.0-0 10/28/2024
  RIP: 0010:sev_mem_enc_register_region+0x3f0/0x4f0 ../include/linux/list.h:83
  Code: <41> 80 3c 04 00 74 08 4c 89 ff e8 f1 c7 a2 00 49 39 ed 0f 84 c6 00
  RSP: 0018:ffff88838647fbb8 EFLAGS: 00010256
  RAX: dffffc0000000000 RBX: 1ffff92015cf1e0b RCX: dffffc0000000000
  RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff888367870000
  RBP: ffffc900ae78f050 R08: ffffea000d9e0007 R09: 1ffffd4001b3c000
  R10: dffffc0000000000 R11: fffff94001b3c001 R12: 0000000000000000
  R13: ffff8982ab0bde00 R14: ffffc900ae78f058 R15: 0000000000000000
  FS:  00007f34e9dc66c0(0000) GS:ffff89ee64d33000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fe180adef98 CR3: 000000047210e000 CR4: 0000000000350ef0
  Call Trace:
   <TASK>
   kvm_arch_vm_ioctl+0xa72/0x1240 ../arch/x86/kvm/x86.c:7371
   kvm_vm_ioctl+0x649/0x990 ../virt/kvm/kvm_main.c:5363
   __se_sys_ioctl+0x101/0x170 ../fs/ioctl.c:51
   do_syscall_x64 ../arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x6f/0x1f0 ../arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f34e9f7e9a9
  Code: <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f34e9dc6038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007f34ea1a6080 RCX: 00007f34e9f7e9a9
  RDX: 0000200000000280 RSI: 000000008010aebb RDI: 0000000000000007
  RBP: 00007f34ea000d69 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  R13: 0000000000000000 R14: 00007f34ea1a6080 R15: 00007ffce77197a8
   </TASK>

with a syzlang reproducer that looks like:

  syz_kvm_add_vcpu$x86(0x0, &(0x7f0000000040)={0x0, &(0x7f0000000180)=ANY=[], 0x70}) (async)
  syz_kvm_add_vcpu$x86(0x0, &(0x7f0000000080)={0x0, &(0x7f0000000180)=ANY=[@ANYBLOB="..."], 0x4f}) (async)
  r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000200), 0x0, 0x0)
  r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
  r2 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000240), 0x0, 0x0)
  r3 = ioctl$KVM_CREATE_VM(r2, 0xae01, 0x0)
  ioctl$KVM_SET_CLOCK(r3, 0xc008aeba, &(0x7f0000000040)={0x1, 0x8, 0x0, 0x5625e9b0}) (async)
  ioctl$KVM_SET_PIT2(r3, 0x8010aebb, &(0x7f0000000280)={[...], 0x5}) (async)
  ioctl$KVM_SET_PIT2(r1, 0x4070aea0, 0x0) (async)
  r4 = ioctl$KVM_CREATE_VM(0xffffffffffffffff, 0xae01, 0x0)
  openat$kvm(0xffffffffffffff9c, 0x0, 0x0, 0x0) (async)
  ioctl$KVM_SET_USER_MEMORY_REGION(r4, 0x4020ae46, &(0x7f0000000400)={0x0, 0x0, 0x0, 0x2000, &(0x7f0000001000/0x2000)=nil}) (async)
  r5 = ioctl$KVM_CREATE_VCPU(r4, 0xae41, 0x2)
  close(r0) (async)
  openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x8000, 0x0) (async)
  ioctl$KVM_SET_GUEST_DEBUG(r5, 0x4048ae9b, &(0x7f0000000300)={0x4376ea830d46549b, 0x0, [0x46, 0x0, 0x0, 0x0, 0x0, 0x1000]}) (async)
  ioctl$KVM_RUN(r5, 0xae80, 0x0)

Opportunistically use guard() to avoid having to define a new error label
and goto usage.

Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
Cc: stable@vger.kernel.org
Reported-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Link: https://patch.msgid.link/20260310234829.2608037-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 775704fb704ca..1a766b3d95f23 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2703,6 +2703,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 	struct enc_region *region;
 	int ret = 0;
 
+	guard(mutex)(&kvm->lock);
+
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
@@ -2717,12 +2719,10 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 	if (!region)
 		return -ENOMEM;
 
-	mutex_lock(&kvm->lock);
 	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
 				       FOLL_WRITE | FOLL_LONGTERM);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
-		mutex_unlock(&kvm->lock);
 		goto e_free;
 	}
 
@@ -2740,8 +2740,6 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 	region->size = range->size;
 
 	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
-
 	return ret;
 
 e_free:
-- 
2.53.0



