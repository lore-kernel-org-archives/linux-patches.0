Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BC4151CCC;
	Tue, 20 Feb 2024 21:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465129; cv=none; b=iSBinwd5h+UTmwq7v1kLq9cv6WZ6xMaW3LsUzCsL1e87S802nk20fpo9/fhzi/tjInMXAfgeiTndAhEWx66KdrGiAPLxs/1fZUhO1S+26q2dpnbnd4A+qMYEDQAkw9Nf6nvh1PUqeHQa08K9vFiPgZUNZrmVJIP9iektVMfVuac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465129; c=relaxed/simple;
	bh=tEsBKDhTZfci4smROxJDisB5GvkQjAifvfRcJvkWwec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hH+36KqZZnZJOJTbGinhzRoOEpBorJ+voch8ZuMpbZBLWX9NoWM8o9VSJ0rXeuSf+WQqjF7K2H+nDcDwoQ5ZkdCVYm105vB5iSatQY5WEASOP/2EP9Yc2L3CuaBiUh9f1gaZUfjWHXJG54VC45MIZWZDEsY+R4SXRLBvfAElyNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8TQ43xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8TQ43xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1658CC433C7;
	Tue, 20 Feb 2024 21:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465129;
	bh=tEsBKDhTZfci4smROxJDisB5GvkQjAifvfRcJvkWwec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8TQ43xfDzcTtLU/Pb5UrvyM6Gm+6Z5RCr6N+GiA84PySVtkxzeCvXM9RaHBe6pJV
	 F+YheVgR/CQFQh5qL929D2EoDPyliqFyc9HGHKCTaxRUWcRkthq11Sw6snI/X5BKbx
	 WKqtrQ/uMp+WwRqyuUwIP/TrJ6XccksDXDWehs74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Kim Phillips <kim.phillips@amd.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.7 245/309] crypto: ccp - Fix null pointer dereference in __sev_platform_shutdown_locked
Date: Tue, 20 Feb 2024 21:56:44 +0100
Message-ID: <20240220205640.821910160@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kim Phillips <kim.phillips@amd.com>

commit ccb88e9549e7cfd8bcd511c538f437e20026e983 upstream.

The SEV platform device can be shutdown with a null psp_master,
e.g., using DEBUG_TEST_DRIVER_REMOVE.  Found using KASAN:

[  137.148210] ccp 0000:23:00.1: enabling device (0000 -> 0002)
[  137.162647] ccp 0000:23:00.1: no command queues available
[  137.170598] ccp 0000:23:00.1: sev enabled
[  137.174645] ccp 0000:23:00.1: psp enabled
[  137.178890] general protection fault, probably for non-canonical address 0xdffffc000000001e: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN NOPTI
[  137.182693] KASAN: null-ptr-deref in range [0x00000000000000f0-0x00000000000000f7]
[  137.182693] CPU: 93 PID: 1 Comm: swapper/0 Not tainted 6.8.0-rc1+ #311
[  137.182693] RIP: 0010:__sev_platform_shutdown_locked+0x51/0x180
[  137.182693] Code: 08 80 3c 08 00 0f 85 0e 01 00 00 48 8b 1d 67 b6 01 08 48 b8 00 00 00 00 00 fc ff df 48 8d bb f0 00 00 00 48 89 f9 48 c1 e9 03 <80> 3c 01 00 0f 85 fe 00 00 00 48 8b 9b f0 00 00 00 48 85 db 74 2c
[  137.182693] RSP: 0018:ffffc900000cf9b0 EFLAGS: 00010216
[  137.182693] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 000000000000001e
[  137.182693] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000000000f0
[  137.182693] RBP: ffffc900000cf9c8 R08: 0000000000000000 R09: fffffbfff58f5a66
[  137.182693] R10: ffffc900000cf9c8 R11: ffffffffac7ad32f R12: ffff8881e5052c28
[  137.182693] R13: ffff8881e5052c28 R14: ffff8881758e43e8 R15: ffffffffac64abf8
[  137.182693] FS:  0000000000000000(0000) GS:ffff889de7000000(0000) knlGS:0000000000000000
[  137.182693] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  137.182693] CR2: 0000000000000000 CR3: 0000001cf7c7e000 CR4: 0000000000350ef0
[  137.182693] Call Trace:
[  137.182693]  <TASK>
[  137.182693]  ? show_regs+0x6c/0x80
[  137.182693]  ? __die_body+0x24/0x70
[  137.182693]  ? die_addr+0x4b/0x80
[  137.182693]  ? exc_general_protection+0x126/0x230
[  137.182693]  ? asm_exc_general_protection+0x2b/0x30
[  137.182693]  ? __sev_platform_shutdown_locked+0x51/0x180
[  137.182693]  sev_firmware_shutdown.isra.0+0x1e/0x80
[  137.182693]  sev_dev_destroy+0x49/0x100
[  137.182693]  psp_dev_destroy+0x47/0xb0
[  137.182693]  sp_destroy+0xbb/0x240
[  137.182693]  sp_pci_remove+0x45/0x60
[  137.182693]  pci_device_remove+0xaa/0x1d0
[  137.182693]  device_remove+0xc7/0x170
[  137.182693]  really_probe+0x374/0xbe0
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  __driver_probe_device+0x199/0x460
[  137.182693]  driver_probe_device+0x4e/0xd0
[  137.182693]  __driver_attach+0x191/0x3d0
[  137.182693]  ? __pfx___driver_attach+0x10/0x10
[  137.182693]  bus_for_each_dev+0x100/0x190
[  137.182693]  ? __pfx_bus_for_each_dev+0x10/0x10
[  137.182693]  ? __kasan_check_read+0x15/0x20
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  ? _raw_spin_unlock+0x27/0x50
[  137.182693]  driver_attach+0x41/0x60
[  137.182693]  bus_add_driver+0x2a8/0x580
[  137.182693]  driver_register+0x141/0x480
[  137.182693]  __pci_register_driver+0x1d6/0x2a0
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  ? esrt_sysfs_init+0x1cd/0x5d0
[  137.182693]  ? __pfx_sp_mod_init+0x10/0x10
[  137.182693]  sp_pci_init+0x22/0x30
[  137.182693]  sp_mod_init+0x14/0x30
[  137.182693]  ? __pfx_sp_mod_init+0x10/0x10
[  137.182693]  do_one_initcall+0xd1/0x470
[  137.182693]  ? __pfx_do_one_initcall+0x10/0x10
[  137.182693]  ? parameq+0x80/0xf0
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  ? __kmalloc+0x3b0/0x4e0
[  137.182693]  ? kernel_init_freeable+0x92d/0x1050
[  137.182693]  ? kasan_populate_vmalloc_pte+0x171/0x190
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  kernel_init_freeable+0xa64/0x1050
[  137.182693]  ? __pfx_kernel_init+0x10/0x10
[  137.182693]  kernel_init+0x24/0x160
[  137.182693]  ? __switch_to_asm+0x3e/0x70
[  137.182693]  ret_from_fork+0x40/0x80
[  137.182693]  ? __pfx_kernel_init+0x10/0x10
[  137.182693]  ret_from_fork_asm+0x1b/0x30
[  137.182693]  </TASK>
[  137.182693] Modules linked in:
[  137.538483] ---[ end trace 0000000000000000 ]---

Fixes: 1b05ece0c931 ("crypto: ccp - During shutdown, check SEV data pointer before using")
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Acked-by: John Allen <john.allen@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -534,10 +534,16 @@ EXPORT_SYMBOL_GPL(sev_platform_init);
 
 static int __sev_platform_shutdown_locked(int *error)
 {
-	struct sev_device *sev = psp_master->sev_data;
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
 	int ret;
 
-	if (!sev || sev->state == SEV_STATE_UNINIT)
+	if (!psp || !psp->sev_data)
+		return 0;
+
+	sev = psp->sev_data;
+
+	if (sev->state == SEV_STATE_UNINIT)
 		return 0;
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);


