Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20562EA487;
	Tue, 17 Jun 2025 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174983; cv=none; b=TSR6Q2QKfMyJ0DtOR9pl6PKovWJNTTBAUJeuHTzHRd/DYheUOXiN0i/wCSinx4BAkqplkBZq/vg7nbgPapEWCMPChxTrffNWpwOQ7b0cqee0XwmDiZ168Ctwkpk5Rd3tO6/nqUjhnC0bCpKWzN+gjpg52pwRpTy1DuW6NLXXwU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174983; c=relaxed/simple;
	bh=5XxaZV6odZChrIbeJnfSrZVqaL9+jmeI4fDM12bKfUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4hdFDbayLBtX7s9J8S1jB05JnQOEAI2fo3587Psh242YRJW7TW0mJmN4tMmxdRLTVrpsDKkIatMdxfX1LmCiWdpuYAPeoqXHh4QaSmTSOlKBIBD6thq5qQnNrv1ddHhQMsvTpbSVcNPBhuC8PnIBHqd0gIwEilXvoE2nhVTBBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmtzqw5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmtzqw5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC88C4CEE3;
	Tue, 17 Jun 2025 15:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174983;
	bh=5XxaZV6odZChrIbeJnfSrZVqaL9+jmeI4fDM12bKfUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmtzqw5AYcZEVZWAfE1ThMg6ilF/6NPlP3dU1K4HhmJvFMUvfW9R0I7BR0NRZEkTc
	 OE2/Wov5+XvRxO3pyqZfTHkBRPc2hc9IaaQjMW1Dl/lhQc1iEwyt/+Io6YjmSHa+hh
	 lnSm7QQ5EwVt5pYHISthiUF0G5byUSiUKgZ/aqy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.ibm.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 039/780] powerpc/pseries/iommu: Fix kmemleak in TCE table userspace view
Date: Tue, 17 Jun 2025 17:15:47 +0200
Message-ID: <20250617152453.089683458@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Batra <gbatra@linux.ibm.com>

[ Upstream commit d36e3f11fe8b55b801bdbe84ad51f612b1bd84da ]

When a device is opened by a userspace driver, via VFIO interface, DMA
window is created. This DMA window has TCE Table and a corresponding
data for userview of TCE table.

When the userspace driver closes the device, all the above infrastructure
is free'ed and the device control given back to kernel. Both DMA window
and TCE table is getting free'ed. But due to a code bug, userview of the
TCE table is not getting free'ed. This is resulting in a memory leak.

Befow is the information from KMEMLEAK

unreferenced object 0xc008000022af0000 (size 16777216):
  comm "senlib_unit_tes", pid 9346, jiffies 4294983174
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_vmalloc+0xc8/0x1a0
    __vmalloc_node_range+0x284/0x340
    vzalloc+0x58/0x70
    spapr_tce_create_table+0x4b0/0x8d0
    tce_iommu_create_table+0xcc/0x170 [vfio_iommu_spapr_tce]
    tce_iommu_create_window+0x144/0x2f0 [vfio_iommu_spapr_tce]
    tce_iommu_ioctl.part.0+0x59c/0xc90 [vfio_iommu_spapr_tce]
    vfio_fops_unl_ioctl+0x88/0x280 [vfio]
    sys_ioctl+0xf4/0x160
    system_call_exception+0x164/0x310
    system_call_vectored_common+0xe8/0x278
unreferenced object 0xc008000023b00000 (size 4194304):
  comm "senlib_unit_tes", pid 9351, jiffies 4294984116
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_vmalloc+0xc8/0x1a0
    __vmalloc_node_range+0x284/0x340
    vzalloc+0x58/0x70
    spapr_tce_create_table+0x4b0/0x8d0
    tce_iommu_create_table+0xcc/0x170 [vfio_iommu_spapr_tce]
    tce_iommu_create_window+0x144/0x2f0 [vfio_iommu_spapr_tce]
    tce_iommu_create_default_window+0x88/0x120 [vfio_iommu_spapr_tce]
    tce_iommu_ioctl.part.0+0x57c/0xc90 [vfio_iommu_spapr_tce]
    vfio_fops_unl_ioctl+0x88/0x280 [vfio]
    sys_ioctl+0xf4/0x160
    system_call_exception+0x164/0x310
    system_call_vectored_common+0xe8/0x278

Fixes: f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
Signed-off-by: Gaurav Batra <gbatra@linux.ibm.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250512224653.35697-1-gbatra@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index d6ebc19fb99c5..eec333dd2e598 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -197,7 +197,7 @@ static void tce_iommu_userspace_view_free(struct iommu_table *tbl)
 
 static void tce_free_pSeries(struct iommu_table *tbl)
 {
-	if (!tbl->it_userspace)
+	if (tbl->it_userspace)
 		tce_iommu_userspace_view_free(tbl);
 }
 
-- 
2.39.5



