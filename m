Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946D0246BCD;
	Sat, 12 Sep 2026 10:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207754; cv=none; b=ZKH8P/0LtEfwoLkGTyx34DS1icU+WGzJY4AR9uzKdiZ+5FLiZK3rDHXnFbwmNc7JaKWKYI+EvpEt1GRoNy4w4e123LxjeVVtoisL+ullyMeMRqYxTYv+77DFY0AP58HCtCYKnpMNVvrtml8Nw9a7XN3xm4eTZ4YOSjaUpJSKc8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207754; c=relaxed/simple;
	bh=ytJNUR36TKkel/BjoSbx+Ax2CIOyVZzGLISQy8SdbMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWdmE1JpzeKrFaID4PsqEs6koZ3zP9mqn8Nihma08LKikz1bcVYuMzLY1fcVnKUVH05TIVKEAJdwB5KhyU7201VVuMYEQkFyU3XjK9J+YpUm/V1ZaV5RdYs5GsykkPtePeeV57EBZyjWO4XLMAvqYn8vkhRgXyQ2SBfiJuDVRo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOyi5tu6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOyi5tu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90891F000FF;
	Sat, 12 Sep 2026 10:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207752;
	bh=vWg0ops2TD1XJ7VFJRS6GutuEn6UfeLe4lwv0U95+P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOyi5tu6dqE+GfA1jAFQ5Pma3peDvZIu7ARbKmdJnfhNwu9O+QIjsUKuCqKwovyuz
	 OaBMwS0qqv+32tcrMBCVDr6YQZPtQIqWiqwz3H9wShgch03yU7x6zMdx+RoNymEp98
	 UW7So+f3QrvUiidztM6/dQ1BNh7d3xM8kyzlQlRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0460/1518] vfio/pci: clear vdev->msi_perm after freeing it on init failure
Date: Sat, 12 Sep 2026 08:43:49 +0200
Message-ID: <20260912065633.854826067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit dc77acfeb979dded39b247b60fef0399536bfa77 ]

vfio_msi_cap_len() lazily allocates the per-device MSI permission table:

	vdev->msi_perm = kmalloc_obj(struct perm_bits, GFP_KERNEL_ACCOUNT);
	if (!vdev->msi_perm)
		return -ENOMEM;

	ret = init_pci_cap_msi_perm(vdev->msi_perm, len, flags);
	if (ret) {
		kfree(vdev->msi_perm);
		return ret;		/* vdev->msi_perm left dangling */
	}

When init_pci_cap_msi_perm() -> alloc_perm_bits() fails with -ENOMEM, the
error path frees vdev->msi_perm but leaves the freed pointer stored in
it. vdev->msi_perm is not re-zeroed later because struct
vfio_pci_core_device is per-device and persists across open/close cycles,
and the vfio_config_init() error path returns without calling
vfio_config_free(). So the dangling pointer outlives the failed open.

That leads to two use-after-frees on the same device:

1. Reuse. The next vfio_config_init() sees the stale pointer at
   "if (vdev->msi_perm) return len;" and reuses the freed object. MSI
   config accesses in vfio_pci_config_rw_single() then dereference and
   call the freed perm->readfn / perm->writefn function pointers.

2. Double free. A later vfio_config_free() runs free_perm_bits() and
   kfree() on the already-freed object.

Fix it by NULLing vdev->msi_perm after the kfree(), matching the
NULL-after-free discipline already used in free_perm_bits() and
vfio_config_free().

  BUG: KASAN: slab-use-after-free in vfio_pci_config_rw_single (drivers/vfio/pci/vfio_pci_config.c:1961)
  Read of size 8 at addr ffff88800fcc88d0 by task exploit/143
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   vfio_pci_config_rw_single (drivers/vfio/pci/vfio_pci_config.c:1961)
   vfio_pci_config_rw (drivers/vfio/pci/vfio_pci_config.c:1986)
   vfio_pci_rw (drivers/vfio/pci/vfio_pci_core.c:1599)
   vfs_read (fs/read_write.c:572)
   __x64_sys_pread64 (fs/read_write.c:764)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   ...

Followed on device close by a double free of the same object:

  Oops: general protection fault, probably for non-canonical address
    0x1f63e0e8000008: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:kfree (mm/slub.c:6711)
  Call Trace:
   vfio_config_free (drivers/vfio/pci/vfio_pci_config.c:1861)
   vfio_pci_core_disable (drivers/vfio/pci/vfio_pci_core.c:685)
   vfio_pci_core_close_device (drivers/vfio/pci/vfio_pci_core.c:777)
   vfio_df_close (drivers/vfio/vfio_main.c:602)
   vfio_device_fops_release (drivers/vfio/vfio_main.c:648)
   __fput (fs/file_table.c:512)
   __x64_sys_close (fs/open.c:1496)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   ...
  Kernel panic - not syncing: Fatal exception

Fixes: 30ea32ab1951 ("vfio/pci: Fix potential memory leak in vfio_msi_cap_len")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/r/20260705014010.1297885-1-xmei5@asu.edu
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 8f02f236b5b4b..1050bd7fd7ce6 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1257,6 +1257,7 @@ static int vfio_msi_cap_len(struct vfio_pci_core_device *vdev, u8 pos)
 	ret = init_pci_cap_msi_perm(vdev->msi_perm, len, flags);
 	if (ret) {
 		kfree(vdev->msi_perm);
+		vdev->msi_perm = NULL;
 		return ret;
 	}
 
-- 
2.53.0



