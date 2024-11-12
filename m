Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F1F20EA2D;
	Tue, 12 Nov 2024 10:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407499; cv=none; b=u9coI96z1wz3uBCeRS27K9+5rXbDxgIgDEZvBSjGAVmceUlKTyYk2O4aF9ljoCpjARz1dV3HZ7b4xvFz5oPCXbRD98kYAtOr/AVJjOcA1GXPKLEH5uN7alP1aPnT2KFq4hDoJ4dtoS3PBO6G1ZYcF4GUU7psMFnxlIaZ9HgQ7iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407499; c=relaxed/simple;
	bh=o8LS8WUzU7ipojHghka4G+2HcdewGboenJUP+EYdiM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP4c9HI29KjH+a5J5fz3w00jEWxZpcfGlnQWVirzerLW6sVe7gClxkTCSkACN0sASaUF+LAWbs7Wj40QhFs8WX3Bo4ursFbkkrimHXY2RAiX2kphriVSKy0YewYLI481lsHAbKW9FH0pX4jA39Kn7WjtFHMe3vhl06cyTh6eh+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SVEqMrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SVEqMrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5323FC4CECD;
	Tue, 12 Nov 2024 10:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407498;
	bh=o8LS8WUzU7ipojHghka4G+2HcdewGboenJUP+EYdiM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SVEqMrChXpTnE7g6qGfW2uI+Zbocp/oDwzIjKQgplbr9Q6bP/9gkvRWU1fXUXqrO
	 RTTwxxmItC7dhEAKEpncLe0lshWLcm+rPLeu2zU4MBpoFEBgVaSijxVTXs9mz8Z0VU
	 laSqfHSyuYfLLvuxDfch02fYgrq+QJrglCTKNjpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 76/98] bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq
Date: Tue, 12 Nov 2024 11:21:31 +0100
Message-ID: <20241112101847.151065431@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

commit 78cfd17142ef70599d6409cbd709d94b3da58659 upstream.

Undefined behavior is triggered when bnxt_qplib_alloc_init_hwq is called
with hwq_attr->aux_depth != 0 and hwq_attr->aux_stride == 0.
In that case, "roundup_pow_of_two(hwq_attr->aux_stride)" gets called.
roundup_pow_of_two is documented as undefined for 0.

Fix it in the one caller that had this combination.

The undefined behavior was detected by UBSAN:
  UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
  shift exponent 64 is too large for 64-bit type 'long unsigned int'
  CPU: 24 PID: 1075 Comm: (udev-worker) Not tainted 6.9.0-rc6+ #4
  Hardware name: Abacus electric, s.r.o. - servis@abacus.cz Super Server/H12SSW-iN, BIOS 2.7 10/25/2023
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   ubsan_epilogue+0x5/0x30
   __ubsan_handle_shift_out_of_bounds.cold+0x61/0xec
   __roundup_pow_of_two+0x25/0x35 [bnxt_re]
   bnxt_qplib_alloc_init_hwq+0xa1/0x470 [bnxt_re]
   bnxt_qplib_create_qp+0x19e/0x840 [bnxt_re]
   bnxt_re_create_qp+0x9b1/0xcd0 [bnxt_re]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __kmalloc+0x1b6/0x4f0
   ? create_qp.part.0+0x128/0x1c0 [ib_core]
   ? __pfx_bnxt_re_create_qp+0x10/0x10 [bnxt_re]
   create_qp.part.0+0x128/0x1c0 [ib_core]
   ib_create_qp_kernel+0x50/0xd0 [ib_core]
   create_mad_qp+0x8e/0xe0 [ib_core]
   ? __pfx_qp_event_handler+0x10/0x10 [ib_core]
   ib_mad_init_device+0x2be/0x680 [ib_core]
   add_client_context+0x10d/0x1a0 [ib_core]
   enable_device_and_get+0xe0/0x1d0 [ib_core]
   ib_register_device+0x53c/0x630 [ib_core]
   ? srso_alias_return_thunk+0x5/0xfbef5
   bnxt_re_probe+0xbd8/0xe50 [bnxt_re]
   ? __pfx_bnxt_re_probe+0x10/0x10 [bnxt_re]
   auxiliary_bus_probe+0x49/0x80
   ? driver_sysfs_add+0x57/0xc0
   really_probe+0xde/0x340
   ? pm_runtime_barrier+0x54/0x90
   ? __pfx___driver_attach+0x10/0x10
   __driver_probe_device+0x78/0x110
   driver_probe_device+0x1f/0xa0
   __driver_attach+0xba/0x1c0
   bus_for_each_dev+0x8f/0xe0
   bus_add_driver+0x146/0x220
   driver_register+0x72/0xd0
   __auxiliary_driver_register+0x6e/0xd0
   ? __pfx_bnxt_re_mod_init+0x10/0x10 [bnxt_re]
   bnxt_re_mod_init+0x3e/0xff0 [bnxt_re]
   ? __pfx_bnxt_re_mod_init+0x10/0x10 [bnxt_re]
   do_one_initcall+0x5b/0x310
   do_init_module+0x90/0x250
   init_module_from_file+0x86/0xc0
   idempotent_init_module+0x121/0x2b0
   __x64_sys_finit_module+0x5e/0xb0
   do_syscall_64+0x82/0x160
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? syscall_exit_to_user_mode_prepare+0x149/0x170
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? syscall_exit_to_user_mode+0x75/0x230
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? do_syscall_64+0x8e/0x160
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __count_memcg_events+0x69/0x100
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? count_memcg_events.constprop.0+0x1a/0x30
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? handle_mm_fault+0x1f0/0x300
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? do_user_addr_fault+0x34e/0x640
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f4e5132821d
  Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e3 db 0c 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffca9c906a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
  RAX: ffffffffffffffda RBX: 0000563ec8a8f130 RCX: 00007f4e5132821d
  RDX: 0000000000000000 RSI: 00007f4e518fa07d RDI: 000000000000003b
  RBP: 00007ffca9c90760 R08: 00007f4e513f6b20 R09: 00007ffca9c906f0
  R10: 0000563ec8a8faa0 R11: 0000000000000246 R12: 00007f4e518fa07d
  R13: 0000000000020000 R14: 0000563ec8409e90 R15: 0000563ec8a8fa60
   </TASK>
  ---[ end trace ]---

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Link: https://lore.kernel.org/r/20240507103929.30003-1-mschmidt@redhat.com
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1014,7 +1014,8 @@ int bnxt_qplib_create_qp(struct bnxt_qpl
 	hwq_attr.stride = sizeof(struct sq_sge);
 	hwq_attr.depth = bnxt_qplib_get_depth(sq);
 	hwq_attr.aux_stride = psn_sz;
-	hwq_attr.aux_depth = bnxt_qplib_set_sq_size(sq, qp->wqe_mode);
+	hwq_attr.aux_depth = psn_sz ? bnxt_qplib_set_sq_size(sq, qp->wqe_mode)
+				    : 0;
 	hwq_attr.type = HWQ_TYPE_QUEUE;
 	rc = bnxt_qplib_alloc_init_hwq(&sq->hwq, &hwq_attr);
 	if (rc)


