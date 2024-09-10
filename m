Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5357E46444;
	Tue, 10 Sep 2024 09:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961917; cv=none; b=i7+/nXRLoaPCKwIcTfGG3fcj6Aq/xmxGou9kaN5LI/SmrGb+rp9DSFA3vSu9cBnVX+7dRVvKl9Y6sOv4i7qfS2Qy4ADucrcgT4cw8XaYakswMljjhkQbrozol63BbFqrZ7irTtKVzdBF8Z2gvBVA62TAxtCj97s1WgQB7zerYjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961917; c=relaxed/simple;
	bh=4M80gBnWJSktkWO5Lp3R0Ci1+qNHHZURNPuwi4pY28I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdU4V/k3eSKdB/jM7LGtbzTBL3qI8dcEwI/j8Niw7hDQaEyzWyz8ZYZpw0SAhXMhHXIodHdLX3NrqKY4Nz3LA1xsR9ALd44IRyi5NfANWQgXmuS7d+Os+h4ljDVJCB0NzblbWNmKSmNenrlS3pzsQKce2LTTUsvOSHVnxIZgEzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXXC1bOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXXC1bOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41AAC4CEC3;
	Tue, 10 Sep 2024 09:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961917;
	bh=4M80gBnWJSktkWO5Lp3R0Ci1+qNHHZURNPuwi4pY28I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXXC1bOyMAqiWDbdxZtTvTXC5NmDBeSvOtEQfPOY4L7Cd1wqKZaq8+7/eebfprabF
	 g8GvGS9qlfgOZNSiomi9P62QZrLJ5Op0tdGfMF57sPsGbenVmDL1lu0Zp2L0G4topS
	 PiuSCdq2N3XM5ehkQ8tPvgxf5NWKwjpeksjf4WhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 233/375] iommufd: Require drivers to supply the cache_invalidate_user ops
Date: Tue, 10 Sep 2024 11:30:30 +0200
Message-ID: <20240910092630.371899427@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit a11dda723c6493bb1853bbc61c093377f96e2d47 ]

If drivers don't do this then iommufd will oops invalidation ioctls with
something like:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  Mem abort info:
    ESR = 0x0000000086000004
    EC = 0x21: IABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x04: level 0 translation fault
  user pgtable: 4k pages, 48-bit VAs, pgdp=0000000101059000
  [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
  Internal error: Oops: 0000000086000004 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 2 PID: 371 Comm: qemu-system-aar Not tainted 6.8.0-rc7-gde77230ac23a #9
  Hardware name: linux,dummy-virt (DT)
  pstate: 81400809 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=-c)
  pc : 0x0
  lr : iommufd_hwpt_invalidate+0xa4/0x204
  sp : ffff800080f3bcc0
  x29: ffff800080f3bcf0 x28: ffff0000c369b300 x27: 0000000000000000
  x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
  x23: 0000000000000000 x22: 00000000c1e334a0 x21: ffff0000c1e334a0
  x20: ffff800080f3bd38 x19: ffff800080f3bd58 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffff8240d6d8
  x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
  x8 : 0000001000000002 x7 : 0000fffeac1ec950 x6 : 0000000000000000
  x5 : ffff800080f3bd78 x4 : 0000000000000003 x3 : 0000000000000002
  x2 : 0000000000000000 x1 : ffff800080f3bcc8 x0 : ffff0000c6034d80
  Call trace:
   0x0
   iommufd_fops_ioctl+0x154/0x274
   __arm64_sys_ioctl+0xac/0xf0
   invoke_syscall+0x48/0x110
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x34/0xb4
   el0t_64_sync_handler+0x120/0x12c
   el0t_64_sync+0x190/0x194

All existing drivers implement this op for nesting, this is mostly a
bisection aid.

Fixes: 8c6eabae3807 ("iommufd: Add IOMMU_HWPT_INVALIDATE")
Link: https://lore.kernel.org/r/0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 33d142f8057d..a9f1fe44c4c0 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -236,7 +236,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	}
 	hwpt->domain->owner = ops;
 
-	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
+	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED ||
+			 !hwpt->domain->ops->cache_invalidate_user)) {
 		rc = -EINVAL;
 		goto out_abort;
 	}
-- 
2.43.0



