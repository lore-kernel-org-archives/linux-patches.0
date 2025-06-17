Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2C0221F1F;
	Tue, 17 Jun 2025 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174490; cv=none; b=cT7mkXT0FRAphBSad+E4kA6i7JHzQADB5XZq4OEnEBafloAU7ol7zY8Dw52pz0Hvf6SMLlfTJ0aFALN6P2henjAQsSvkwSj1giLca7kiceC4IWE6BkTz12gni4Rz3usJ69Kv1n2I8FS6Jp2sgfsWInO08mO48IBNXzRtzD/1VN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174490; c=relaxed/simple;
	bh=u761bzk2I/mzuT2GrmfwoVjmJytihuoWvtbRLJRKkZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld92y3xVmJlMfTSFswMWJq4JHa2Kqpz1kRvcXFYx02rW8QUP/35RxEPC82HHYhK1DwPHKC1qAJidbNcepBo8oRR3s6B8XH8eziKUzkLt2FZLgd518GPtd9F6T0/x1wyNkgme7iZj0k1m1vYxaHzgy0KfUJAxx3mmAhgvdMnX5I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2atY8/qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2atY8/qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF11CC4CEE7;
	Tue, 17 Jun 2025 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174490;
	bh=u761bzk2I/mzuT2GrmfwoVjmJytihuoWvtbRLJRKkZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2atY8/qesbir+zAmuT5hA1UhtJm9Ebs/TFnPn5TNFaQv89zumHjxWvjU+ZqY2Gd3H
	 ZiR+K6MWMCdUA9s6fyDhaDvYBE/zdRtIxndHzrzfnI9QSssdl36jiGA2eYlpiqQc6h
	 AUHeHSE4C6wg4Co9E5d9/oayaHLMpjwtMl6G/etk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.ibm.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/512] powerpc/pseries/iommu: Fix kmemleak in TCE table userspace view
Date: Tue, 17 Jun 2025 17:19:52 +0200
Message-ID: <20250617152420.617239743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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



