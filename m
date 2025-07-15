Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6371A24679C;
	Tue, 15 Jul 2025 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585567; cv=none; b=CGaJXjSeagTnqEe+IJgBPW5BIOfFi0o4MNdOJ2kO7Rf5f85V0l7vYo2TzQ/ycyRdgVj1A7Fjs7yvPyA+Jim8DfIwSC3ClkXnQ8ctXDDnEkJDNnqJdrNdp7gZSpj0rN3TcDNZYdMWjnl3dAUmTpZKthTQ60DHgvViFIG9AosBQm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585567; c=relaxed/simple;
	bh=lr5oc8gqTIVWTP3n/uoFn/4tYrIbNoAHM7012y6Rm/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO6pFycCy63dcCUALXztLafBs38853EU/bjl0aHAh4pWj+mu5qw9G5h/3YUK+OHYupepL4lKMPLg/qTVQqV0jMlv/ikRX8FbCB1Gym8Jwu2Ts6BGLc5LMPccmVl3veGIR7I4zs7TQtiT0HwanHasnF5tMuqDxDr6+Fb56TaK538=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpFSpVhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpFSpVhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBEFC4CEE3;
	Tue, 15 Jul 2025 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585567;
	bh=lr5oc8gqTIVWTP3n/uoFn/4tYrIbNoAHM7012y6Rm/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpFSpVhjndVGOMgHh2TJFqa10e+Ow2bJQjipgsa22cpZnFJSU9yswakb7uEp8ZmUI
	 UohQBE+WdvW3FhFdPJWg5uxoHE2sWAvLGPkAkrTXLxJtkKvjcBmv7Q2bkD43BSwES8
	 /7lEzl+qMC6oPErg0tUOrUt+36gTOCE8QsF6DU5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH 6.12 057/163] KVM: Allow CPU to reschedule while setting per-page memory attributes
Date: Tue, 15 Jul 2025 15:12:05 +0200
Message-ID: <20250715130811.038929381@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Liam Merwick <liam.merwick@oracle.com>

commit 47bb584237cc285e3a860b70c01f7bda9dcfb05b upstream.

When running an SEV-SNP guest with a sufficiently large amount of memory (1TB+),
the host can experience CPU soft lockups when running an operation in
kvm_vm_set_mem_attributes() to set memory attributes on the whole
range of guest memory.

watchdog: BUG: soft lockup - CPU#8 stuck for 26s! [qemu-kvm:6372]
CPU: 8 UID: 0 PID: 6372 Comm: qemu-kvm Kdump: loaded Not tainted 6.15.0-rc7.20250520.el9uek.rc1.x86_64 #1 PREEMPT(voluntary)
Hardware name: Oracle Corporation ORACLE SERVER E4-2c/Asm,MB Tray,2U,E4-2c, BIOS 78016600 11/13/2024
RIP: 0010:xas_create+0x78/0x1f0
Code: 00 00 00 41 80 fc 01 0f 84 82 00 00 00 ba 06 00 00 00 bd 06 00 00 00 49 8b 45 08 4d 8d 65 08 41 39 d6 73 20 83 ed 06 48 85 c0 <74> 67 48 89 c2 83 e2 03 48 83 fa 02 75 0c 48 3d 00 10 00 00 0f 87
RSP: 0018:ffffad890a34b940 EFLAGS: 00000286
RAX: ffff96f30b261daa RBX: ffffad890a34b9c8 RCX: 0000000000000000
RDX: 000000000000001e RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffad890a356868
R13: ffffad890a356860 R14: 0000000000000000 R15: ffffad890a356868
FS:  00007f5578a2a400(0000) GS:ffff97ed317e1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f015c70fb18 CR3: 00000001109fd006 CR4: 0000000000f70ef0
PKRU: 55555554
Call Trace:
 <TASK>
 xas_store+0x58/0x630
 __xa_store+0xa5/0x130
 xa_store+0x2c/0x50
 kvm_vm_set_mem_attributes+0x343/0x710 [kvm]
 kvm_vm_ioctl+0x796/0xab0 [kvm]
 __x64_sys_ioctl+0xa3/0xd0
 do_syscall_64+0x8c/0x7a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f5578d031bb
Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d 4c 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe0a742b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000004020aed2 RCX: 00007f5578d031bb
RDX: 00007ffe0a742c80 RSI: 000000004020aed2 RDI: 000000000000000b
RBP: 0000010000000000 R08: 0000010000000000 R09: 0000017680000000
R10: 0000000000000080 R11: 0000000000000246 R12: 00005575e5f95120
R13: 00007ffe0a742c80 R14: 0000000000000008 R15: 00005575e5f961e0

While looping through the range of memory setting the attributes,
call cond_resched() to give the scheduler a chance to run a higher
priority task on the runqueue if necessary and avoid staying in
kernel mode long enough to trigger the lockup.

Fixes: 5a475554db1e ("KVM: Introduce per-page memory attributes")
Cc: stable@vger.kernel.org # 6.12.x
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Link: https://lore.kernel.org/r/20250609091121.2497429-2-liam.merwick@oracle.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2557,6 +2557,8 @@ static int kvm_vm_set_mem_attributes(str
 		r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
 		if (r)
 			goto out_unlock;
+
+		cond_resched();
 	}
 
 	kvm_handle_gfn_range(kvm, &pre_set_range);
@@ -2565,6 +2567,7 @@ static int kvm_vm_set_mem_attributes(str
 		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
 				    GFP_KERNEL_ACCOUNT));
 		KVM_BUG_ON(r, kvm);
+		cond_resched();
 	}
 
 	kvm_handle_gfn_range(kvm, &post_set_range);


