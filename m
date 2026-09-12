Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758E430F7E8;
	Sat, 12 Sep 2026 07:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199264; cv=none; b=r5dfzVeAdBiWeLZ2mLbw8YKsuDBgTvRtYmVVHHGiR+DjpNh4TIxpBbD7HLVNqCRmbMpefoYdKs9VJg8/WML+Mx3nVA8hio3AOPBgwTn1zfwP/4W9QgjF3q35mZ+HNOj7NVVKnfg2XweLCUA/TTU2ROlJ2J0hBS55+yt1FDCnwSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199264; c=relaxed/simple;
	bh=LNpNGnljRCuTfYFzIz7ZrpVvBKsY3Pb1kUc2lgjFULU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el36DHZXfu1VExBCSe8IF+PWBrr0GjjgR0qqIGk2a5QCI0z7KV4s99sik3/rbvpmVLg8mU1N750WdQtyeeRa5BFIs8pLIMnIGDlpGQ/MxahesOZji37j6XDFPJnGTi84BFCl7itHWva3Mtc4YpBt1OQPcTMw4GkD0Im+EZX4r5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9wnvooq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9wnvooq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA501F00893;
	Sat, 12 Sep 2026 07:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199263;
	bh=LJ/GKGwJUtU4dkflV5Y7ELLczxELBm4kNPh1c6Cce/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9wnvooq7IEoj6QMjU+adUGfhW5Rr/iX4nXQxJ0H6f4jEzM3IqpsRR61mpDARFE0R
	 bKq2xTnWXWZJAo4uSw5esRfASEy2v5K7ouODgJGei6uE9frx9UsToXWHXLOGJTM3eB
	 83AME0G8ve1ZlTguaoW6kdAM1Uf5zatZ/OnkG5EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0507/1815] vfio/pci: clear vdev->msi_perm after freeing it on init failure
Date: Sat, 12 Sep 2026 08:37:37 +0200
Message-ID: <20260912065700.792696633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a10ed733f0e3a..9914f3ac69aef 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1272,6 +1272,7 @@ static int vfio_msi_cap_len(struct vfio_pci_core_device *vdev, u8 pos)
 	ret = init_pci_cap_msi_perm(vdev->msi_perm, len, flags);
 	if (ret) {
 		kfree(vdev->msi_perm);
+		vdev->msi_perm = NULL;
 		return ret;
 	}
 
-- 
2.53.0



