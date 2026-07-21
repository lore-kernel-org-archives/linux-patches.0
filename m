Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B2124A078;
	Tue, 21 Jul 2026 20:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665038; cv=none; b=NtjLk+j4/NjdR7LeIP6OZTx9QVO4vCaf7Cu1R+9gLm//toim+wWLVhvmH42u8UzvNhraGlD7R0L4JnBVR+TOhO4kUOrAEvNmm0SCMU+Sp3+kRg5nLAdfUrs+tQ9Bo+AxNN0IpDx/eBrG0BJcf0H2685hxtM1oBbjf0U8v3UyzB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665038; c=relaxed/simple;
	bh=2qtxZVet+BWJugQImmsVWFxQhI6ulOoJ00wq1m4PevM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxuE55XhUAn90GN5VuKByAOMIfAoFO2fB5V7r3awNAOFcEsGQnk1MSUYrfZsXPG9gbrvoJIH6kpRQa6ko1m/h2sSkRQjx1FbKnlvkKzGMYRBLoBeTzVByILnxAlFIV7o14U2xLplcz3lVPD74j4STdVq01+6bA4fwZE0eEUhkYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4GSXmOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4GSXmOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92BC1F000E9;
	Tue, 21 Jul 2026 20:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665037;
	bh=gsn89+56kfCYB5dNqCpd4Z8kbonZrUf9CBpRkzjqNUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4GSXmOer2h1xljqHooWbx9PhFKfmFGu6RC/MGmDs82Xsk2hpaNXFwkhn4ssbV76g
	 pmBT2QeqqMve9quhpGjnvS/mLajXi4HrtEFZtQ7r646UBt1/PJKUExKfr6bEEcrcIo
	 1/3knuZxCVZtimeQLNr4MFDdd96GUL3h0S7FjUqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0153/1266] crypto: amlogic - avoid double cleanup in meson_crypto_probe()
Date: Tue, 21 Jul 2026 17:09:50 +0200
Message-ID: <20260721152445.230506296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 6d827ade51a24e18d81afb9f32756d339520a14c upstream.

When meson_allocate_chanlist() fails after a partial allocation, it already
unwinds the allocated chanlist state through its local error path.
meson_crypto_probe() then jump to error_flow and calls
meson_free_chanlist() again, causing the same per-flow resources to be torn
down twice. In the reproduced failure path, the second teardown
re-entered crypto_engine_exit() on an already destroyed worker and KASAN
reported a slab-use-after-free in kthread_destroy_worker().

Prevent double-free by handling partial allocation failures locally within
meson_allocate_chanlist() and skipping the outer cleanup path.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available.

The bug was reproduced in a QEMU x86_64 guest booted with KASAN on v7.1,
using the reproducer under tools/testing/meson_crypto_probe. The reproducer
forces the second dma_alloc_attrs() call in the gxl-crypto probe path to
return NULL, making meson_allocate_chanlist() fail after partial
initialization. On the unpatched kernel this reliably triggered a
slab-use-after-free. With this fix applied, the same reproducer no longer
emits any KASAN report and the probe fails cleanly with -ENOMEM.

    ==================================================================
    BUG: KASAN: slab-use-after-free in kthread_destroy_worker+0xb2/0xd0
    Read of size 8 at addr ff1100010c057a68 by task insmod/265

    CPU: 1 UID: 0 PID: 265 Comm: insmod Tainted: G           O        7.1.0-rc2-00376-g810af9adc907-dirty #10 PREEMPT(lazy)
    Tainted: [O]=OOT_MODULE
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x68/0xa0
     print_report+0xcb/0x5e0
     ? __virt_addr_valid+0x21d/0x3f0
     ? kthread_destroy_worker+0xb2/0xd0
     ? kthread_destroy_worker+0xb2/0xd0
     kasan_report+0xca/0x100
     ? kthread_destroy_worker+0xb2/0xd0
     kthread_destroy_worker+0xb2/0xd0
     meson_crypto_probe+0x4d0/0xc10 [amlogic_gxl_crypto]
     platform_probe+0x99/0x140
     really_probe+0x1c6/0x6a0
     ? __pfx___device_attach_driver+0x10/0x10
     __driver_probe_device+0x248/0x310
     ? acpi_driver_match_device+0xb0/0x100
     driver_probe_device+0x48/0x210
     ? __pfx___device_attach_driver+0x10/0x10
     __device_attach_driver+0x160/0x320
     bus_for_each_drv+0x104/0x190
     ? __pfx_bus_for_each_drv+0x10/0x10
     ? _raw_spin_unlock_irqrestore+0x2c/0x50
     __device_attach+0x19d/0x3b0
     ? __pfx___device_attach+0x10/0x10
     ? do_raw_spin_unlock+0x53/0x220
     device_initial_probe+0x78/0xa0
     bus_probe_device+0x5b/0x130
     device_add+0xcfd/0x1430
     ? __pfx_device_add+0x10/0x10
     ? insert_resource+0x34/0x50
     ? lock_release+0xc9/0x290
     platform_device_add+0x24e/0x590
     ? __pfx_meson_crypto_probe_repro_init+0x10/0x10 [meson_crypto_probe_repro]
     meson_crypto_probe_repro_init+0x330/0xff0 [meson_crypto_probe_repro]
     do_one_initcall+0xc0/0x450
     ? __pfx_do_one_initcall+0x10/0x10
     ? _raw_spin_unlock_irqrestore+0x2c/0x50
     ? __create_object+0x59/0x80
     ? kasan_unpoison+0x27/0x60
     do_init_module+0x27b/0x7d0
     ? __pfx_do_init_module+0x10/0x10
     ? kasan_quarantine_put+0x84/0x1d0
     ? kfree+0x32c/0x510
     ? load_module+0x561e/0x5ff0
     load_module+0x54fe/0x5ff0
     ? __pfx_load_module+0x10/0x10
     ? security_file_permission+0x20/0x40
     ? kernel_read_file+0x23d/0x6e0
     ? mmap_region+0x235/0x4a0
     ? __pfx_kernel_read_file+0x10/0x10
     ? __file_has_perm+0x2c0/0x3e0
     init_module_from_file+0x158/0x180
     ? __pfx_init_module_from_file+0x10/0x10
     ? __lock_acquire+0x45a/0x1ba0
     ? idempotent_init_module+0x315/0x610
     ? lock_release+0xc9/0x290
     ? lockdep_init_map_type+0x4b/0x220
     ? do_raw_spin_unlock+0x53/0x220
     idempotent_init_module+0x330/0x610
     ? __pfx_idempotent_init_module+0x10/0x10
     ? __pfx_cred_has_capability.isra.0+0x10/0x10
     ? ksys_mmap_pgoff+0x385/0x520
     __x64_sys_finit_module+0xbe/0x120
     do_syscall_64+0x115/0x690
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    RIP: 0033:0x7f7d6d31690d
    Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f3 b4 0f 00 f7 d8 >
    RSP: 002b:00007fffc027ac68 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
    RAX: ffffffffffffffda RBX: 000055f7b81967c0 RCX: 00007f7d6d31690d
    RDX: 0000000000000000 RSI: 000055f79a0d6cd2 RDI: 0000000000000003
    RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000003 R11: 0000000000000246 R12: 000055f79a0d6cd2
    R13: 000055f7b8196790 R14: 000055f79a0d5888 R15: 000055f7b81968e0
     </TASK>

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -293,8 +293,8 @@ static int meson_crypto_probe(struct pla
 	return 0;
 error_alg:
 	meson_unregister_algs(mc);
-error_flow:
 	meson_free_chanlist(mc, MAXFLOW - 1);
+error_flow:
 	clk_disable_unprepare(mc->busclk);
 	return err;
 }


