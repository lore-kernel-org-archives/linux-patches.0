Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762C93A3E9C;
	Wed, 20 May 2026 17:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297287; cv=none; b=o4cY+sxaV3pgCyab9NBjwpBnA1Ls8HHYOgbOXO3e3+SEwLgz2Xj3qb05j8RWqeRufx4A9deGADfZtbp8JDQdLxA2lxUatWgYXfeyCowxp7AQdeHuaEclVe4HqEqdQ5yFNB0zFW0QzMyWuv+Rn3oiDSnqXhnA7FQZpDPO1DGKoRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297287; c=relaxed/simple;
	bh=FCnMNgOOVHyvfly9DEXjQ5eqUcXD4itXjFg6HymaIRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEhVz4pl2hnvaBaKyimZcKbP3UErp4YM2Fu8uNB3LGuSIfMIRaaD/MHfZk9XuyE1RP+hTWkgjQ8mrt/XPoiHHgwdZheAooTSSAexb55Or5/XwSkeFU4LoraEipkrEW5aE04xfDE3SfI6Q+METpuVGqdnmhlZVLAq+jeBGA0v8bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txn3u5EQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txn3u5EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960FB1F000E9;
	Wed, 20 May 2026 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297286;
	bh=bxjmefAXM5ntTrhhN9G15NGpOV5fPuxPxEfWU9tkTlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txn3u5EQaCe6dTfTNlcUBpYuBMBty8tQhGeSFpmmueSJvT470SU6+PpFPnQICoCV/
	 X0h9EudSVba9q1iuHSGlNg8Jm8JUrfVVNpEK1RvX7M0XelgYxuborQfxVdPg3ihT7b
	 lY0r5WbVLyAuAWeJL7vHZnvt3g+ruvBHjtP8cgPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.0 1120/1146] iommu/vt-d: Fix oops due to out of scope access
Date: Wed, 20 May 2026 18:22:50 +0200
Message-ID: <20260520162213.589093252@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

commit a6dea58d8625c06b9654c0555f101742481335c3 upstream.

Below oops triggers when kill QEMU process:

  Oops: general protection fault, probably for non-canonical address 0x7fffffff844eaaa7: 0000 [#1] SMP NOPTI
  Call Trace:
   <TASK>
   do_raw_spin_lock+0xaa/0xc0
   _raw_spin_lock_irqsave+0x21/0x40
   domain_remove_dev_pasid+0x52/0x160
   intel_nested_set_dev_pasid+0x1b9/0x1e0
   __iommu_set_group_pasid+0x56/0x120
   pci_dev_reset_iommu_done+0xe3/0x180
   pcie_flr+0x65/0x160
   __pci_reset_function_locked+0x5b/0x120
   vfio_pci_core_close_device+0x63/0xe0 [vfio_pci_core]
   vfio_df_close+0x4f/0xa0
   vfio_df_unbind_iommufd+0x2d/0x60
   vfio_device_fops_release+0x3e/0x40
   __fput+0xe5/0x2c0
   task_work_run+0x58/0xa0
   do_exit+0x2c8/0x600
   do_group_exit+0x2f/0xa0
   get_signal+0x863/0x8c0
   arch_do_signal_or_restart+0x24/0x100
   exit_to_user_mode_loop+0x87/0x380
   do_syscall_64+0x2ff/0x11e0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

The global static blocked domain is a dummy domain without corresponding
dmar_domain structure, accessing beyond iommu_domain structure triggers
oops easily. Fix it by return early in domain_remove_dev_pasid() like
identity domain.

Fixes: 7d0c9da6c150 ("iommu/vt-d: Add set_dev_pasid callback for dma domain")
Cc: stable@vger.kernel.org
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260421031347.1408890-1-zhenzhong.duan@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3529,8 +3529,8 @@ void domain_remove_dev_pasid(struct iomm
 	if (!domain)
 		return;
 
-	/* Identity domain has no meta data for pasid. */
-	if (domain->type == IOMMU_DOMAIN_IDENTITY)
+	/* Identity domain and blocked domain have no meta data for pasid. */
+	if (domain->type == IOMMU_DOMAIN_IDENTITY || domain->type == IOMMU_DOMAIN_BLOCKED)
 		return;
 
 	dmar_domain = to_dmar_domain(domain);


