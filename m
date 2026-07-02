Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092A924E4C3;
	Thu,  2 Jul 2026 16:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011387; cv=none; b=rDQdwNdOHcCh/8bfqgD0JyD/DdfVJamfJ0X2AbmD7Nr9JdBZ7SkP6Ex1LkDZe+pdhKjMNcrFtjYUaIDy7v4OrtAZNMTkWGm4nZUTtu/AYnmhxXapt8hssSZJoWug13ILVFalTUHIylqpy4b7e6MoWEaHc2eL1xFkq4V33jStGF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011387; c=relaxed/simple;
	bh=nFbz1Zk1SuvsDB0YN0gEEQopt6UqI9FShTdggXvRNsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA/60e4ebLj4JFQbcpNddVSaxv+c+C5cyBAO/3lxlB7tFQYN6tozb0YA0ambHejR6vqzSwi+gYrlvGyNI8/nMsltiguzRdz4GAdCptAQal38p2moyRr5WBF0FpEEEJ5LktYAVyZs8QXysZ+7fEd7UTZgJIq3smDXlAhEpR9Mr+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybT8lVbg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybT8lVbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F04B1F000E9;
	Thu,  2 Jul 2026 16:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011385;
	bh=B9N0TNRhHNUksRL68sNmFOHfVshyybi5JCHjz/syMAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybT8lVbg48z8Uw2pCsigb7Bgl7fZWMdbrAcSzzERGWoCx5to4H9ZNh+025tkHxQ5b
	 xFfb5WEm5XI2KbdpY8j9LPOwRltgYREPZW9jpt2u9bnZfO7LrlTRa+u4fAfMMoWcQM
	 0MiW8blsvrL9sSZjJholSQag9pm22yuUGGptKv6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 087/108] KVM: x86: hyper-v: Bound the bank index when querying sparse banks
Date: Thu,  2 Jul 2026 18:21:24 +0200
Message-ID: <20260702155113.914243002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 4721f8160f17554b003e8928bb61e6c9b2fe92a3 upstream.

When checking if a VP ID is included in a sparse bank set, explicitly check
that the ID can actually be contained in a sparse bank (the TLFS allows for
a maximum of 64 banks of 64 vCPUs each).  When handling a paravirtual TLB
flush for L2, the VP ID is copied verbatim from the enlightened VMCS,
without any bounds check, i.e. isn't guaranteed to be under the limit of
4096.

Failure to check the bounds of the VP ID leads to an out-of-bounds read
when testing the sparse bank, and super strictly speaking could lead to KVM
performing an unnecessary TLB flush for an L2 vCPU.

  ==================================================================
  BUG: KASAN: use-after-free in hv_is_vp_in_sparse_set+0x85/0x100 [kvm]
  Read of size 8 at addr ffff88811ba5f598 by task hyperv_evmcs/2802

  CPU: 12 UID: 1000 PID: 2802 Comm: hyperv_evmcs Not tainted 7.1.0-rc2 #7 PREEMPT
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x51/0x60
   print_report+0xcb/0x5d0
   kasan_report+0xb4/0xe0
   kasan_check_range+0x35/0x1b0
   hv_is_vp_in_sparse_set+0x85/0x100 [kvm]
   kvm_hv_flush_tlb+0xe9e/0x16c0 [kvm]
   kvm_hv_hypercall+0xe6b/0x1e60 [kvm]
   vmx_handle_exit+0x485/0x1b60 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0x22e3/0x5070 [kvm]
   kvm_vcpu_ioctl+0x5d0/0x10c0 [kvm]
   __x64_sys_ioctl+0x129/0x1a0
   do_syscall_64+0xb9/0xcf0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f0e62d1a9bf
   </TASK>

  The buggy address belongs to the physical page:
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffffffffffffffff pfn:0x11ba5f
  flags: 0x4000000000000000(zone=1)
  raw: 4000000000000000 0000000000000000 00000000ffffffff 0000000000000000
  raw: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffff88811ba5f480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
   ffff88811ba5f500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  >ffff88811ba5f580: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                              ^
   ffff88811ba5f600: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
   ffff88811ba5f680: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ==================================================================
  Disabling lock debugging due to kernel taint

Opportunistically add a compile time assertion to ensure the maximum number
of sparse banks exactly matches the number of possible bits in the passed
in mask.

Cc: stable@vger.kernel.org
Fixes: c58a318f6090 ("KVM: x86: hyper-v: L2 TLB flush")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://patch.msgid.link/aiQyZIJtO-2Aj_xN@v4bel
[sean: add KASAN splat, drop comment, add assert, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1839,6 +1839,11 @@ static bool hv_is_vp_in_sparse_set(u32 v
 	int valid_bit_nr = vp_id / HV_VCPUS_PER_SPARSE_BANK;
 	unsigned long sbank;
 
+	BUILD_BUG_ON(BITS_PER_TYPE(valid_bank_mask) != HV_MAX_SPARSE_VCPU_BANKS);
+
+	if (valid_bit_nr >= HV_MAX_SPARSE_VCPU_BANKS)
+		return false;
+
 	if (!test_bit(valid_bit_nr, (unsigned long *)&valid_bank_mask))
 		return false;
 


