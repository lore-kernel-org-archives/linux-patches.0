Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762F2371458;
	Sat, 28 Feb 2026 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301462; cv=none; b=HZllRg+bxXaAs3OOuRra+cH8r6V5PoDAyUOaOKd6s4NOxJ2IzcBhbbluOt9B3AM8MP3AixgP18pqQDtY5S7i2NmgSJe6Sqckl8n1po6ZYP8my+GQwEcqtS0k2HhSTrLEy8YOnVeeqMVn+UvdzK28EcPC738w0Mb0cEeNjVnHW48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301462; c=relaxed/simple;
	bh=OSU9CjhCRx29PFz+wonWDbpuIeTWLM7vXalKx0F/ty4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufvBTCS0HQIN3GONcm3Fo+BOJiAewNhHq5uiv6c6fNtq3ZeAN18UbLMMhRMM5uWJomEe+z4cfECXd2yq4CD5jRuFEmESqCnVUV3ymdF7dzXhmwdbRZ7MfZQKTeJBRnwtANlflxVTHSIf8M7qDYUR5dSJuiItgbqjHb6easV7qIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7cSOReC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7cSOReC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F77C2BC87;
	Sat, 28 Feb 2026 17:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301462;
	bh=OSU9CjhCRx29PFz+wonWDbpuIeTWLM7vXalKx0F/ty4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7cSOReCs719YDfc7H0aKoRqW3xSPNwE1LQ8W36Re1ugs3OIVik3rvkpLTv9w+UKo
	 nS6CYEKkHSmJ06dnnbXSiZketVFYR79t8XMzf3CXdYZJvBhANhwZ7SWnI2uXXu4SF5
	 yOWid/FIXrMXC8z34C643vRkJAK9Ko34Sknwl5nDR6KbWgijyvCtElx8vTIMTJ39aA
	 UWHeW998rWe1R2Qi+jkMsOZ4NuW/9XYTkKSqE6ooG6fJ5Ckec77wym0xRrBqkirOqo
	 i37BGvtPBOw/0OA4GV5mVI8mo3NQpUB03+zapdE2I0rt//90cmiIobLKZM4x4pM+jR
	 TdAX3yqMSERTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 647/752] Revert "PCI/IOV: Add PCI rescan-remove locking when enabling/disabling SR-IOV"
Date: Sat, 28 Feb 2026 12:45:58 -0500
Message-ID: <20260228174750.1542406-647-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 2fa119c0e5e528453ebae9e70740e8d2d8c0ed5a ]

This reverts commit 05703271c3cd ("PCI/IOV: Add PCI rescan-remove locking
when enabling/disabling SR-IOV"), which causes a deadlock by recursively
taking pci_rescan_remove_lock when sriov_del_vfs() is called as part of
pci_stop_and_remove_bus_device(). For example with the following sequence
of commands:

  $ echo <NUM> > /sys/bus/pci/devices/<pf>/sriov_numvfs
  $ echo 1 > /sys/bus/pci/devices/<pf>/remove

A trimmed trace of the deadlock on a mlx5 device is as below:

  zsh/5715 is trying to acquire lock:
  000002597926ef50 (pci_rescan_remove_lock){+.+.}-{3:3}, at: sriov_disable+0x34/0x140

  but task is already holding lock:
  000002597926ef50 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_stop_and_remove_bus_device_locked+0x24/0x80
  ...
  Call Trace:
   [<00000259778c4f90>] dump_stack_lvl+0xc0/0x110
   [<00000259779c844e>] print_deadlock_bug+0x31e/0x330
   [<00000259779c1908>] __lock_acquire+0x16c8/0x32f0
   [<00000259779bffac>] lock_acquire+0x14c/0x350
   [<00000259789643a6>] __mutex_lock_common+0xe6/0x1520
   [<000002597896413c>] mutex_lock_nested+0x3c/0x50
   [<00000259784a07e4>] sriov_disable+0x34/0x140
   [<00000258f7d6dd80>] mlx5_sriov_disable+0x50/0x80 [mlx5_core]
   [<00000258f7d5745e>] remove_one+0x5e/0xf0 [mlx5_core]
   [<00000259784857fc>] pci_device_remove+0x3c/0xa0
   [<000002597851012e>] device_release_driver_internal+0x18e/0x280
   [<000002597847ae22>] pci_stop_bus_device+0x82/0xa0
   [<000002597847afce>] pci_stop_and_remove_bus_device_locked+0x5e/0x80
   [<00000259784972c2>] remove_store+0x72/0x90
   [<0000025977e6661a>] kernfs_fop_write_iter+0x15a/0x200
   [<0000025977d7241c>] vfs_write+0x24c/0x300
   [<0000025977d72696>] ksys_write+0x86/0x110
   [<000002597895b61c>] __do_syscall+0x14c/0x400
   [<000002597896e0ee>] system_call+0x6e/0x90

This alone is not a complete fix as it restores the issue the cited commit
tried to solve. A new fix will be provided as a follow on.

Fixes: 05703271c3cd ("PCI/IOV: Add PCI rescan-remove locking when enabling/disabling SR-IOV")
Reported-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Acked-by: Gerd Bayer <gbayer@linux.ibm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251216-revert_sriov_lock-v3-1-dac4925a7621@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 77dee43b78583..ac4375954c947 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -629,18 +629,15 @@ static int sriov_add_vfs(struct pci_dev *dev, u16 num_vfs)
 	if (dev->no_vf_scan)
 		return 0;
 
-	pci_lock_rescan_remove();
 	for (i = 0; i < num_vfs; i++) {
 		rc = pci_iov_add_virtfn(dev, i);
 		if (rc)
 			goto failed;
 	}
-	pci_unlock_rescan_remove();
 	return 0;
 failed:
 	while (i--)
 		pci_iov_remove_virtfn(dev, i);
-	pci_unlock_rescan_remove();
 
 	return rc;
 }
@@ -765,10 +762,8 @@ static void sriov_del_vfs(struct pci_dev *dev)
 	struct pci_sriov *iov = dev->sriov;
 	int i;
 
-	pci_lock_rescan_remove();
 	for (i = 0; i < iov->num_VFs; i++)
 		pci_iov_remove_virtfn(dev, i);
-	pci_unlock_rescan_remove();
 }
 
 static void sriov_disable(struct pci_dev *dev)
-- 
2.51.0

