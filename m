Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2FE42D760;
	Thu, 16 Jul 2026 14:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212396; cv=none; b=NCa/tkam9YMs7EFonAd54ZeUCGPen9dRHFMk3Q+z5Q6JkMshDAL4P0Dxd/8BOuBBvmUUoT1zNwhEuA64xcIEldnBo2GkRmO24JPExHxPjLyGtePixaQxWOJX+IM1/NFFAXJJlH7jAtHQIdgHUK98zNzwJJBM8H39GJUYfX0AvLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212396; c=relaxed/simple;
	bh=NcUoAZbYnxl77rLAxObNdC8ZlocoQwbqDAIpGkh23Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nljaXThpN4MWNIgG7G/gUxVdoVf5DwX0OzXH9KLKDB/Egykuspwj15MlVYhkTdrBNXYBSnaan22qqb9B6/XEXV/AyaCCIbBVvPAiZ+wQQQlJeegr7SMGBqsEUI56rS4QplGSCbBKoAnJ38Wr/PBiNMkTePc2HBegPssUyrSTlCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gmg+of3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gmg+of3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937341F000E9;
	Thu, 16 Jul 2026 14:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212395;
	bh=jUIhvGNchLsw4/GVRKh1gG2qGvB28hx+UJXWVzkjEAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gmg+of3i76eDRDThKLAqf2IJe/uwsfOeiKu+Uz9t0aqJ0X8MDbXePFsBuiNHlPUKt
	 lky4TeVeyz8dvnHfQM5sj4fZRybMZBbmNy/DWqvO1qF9VbVUyAbROORXwGlIdXvNvG
	 BNIHbwJEXkhBFVH5NgXMCA9WScCw56Yx1enV9WkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Han Gao <gaohan@iscas.ac.cn>
Subject: [PATCH 6.12 310/349] riscv: mm: Define DIRECT_MAP_PHYSMEM_END
Date: Thu, 16 Jul 2026 15:34:04 +0200
Message-ID: <20260716133040.256132969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit f3336b48cf9d3f2d1fc78e3289c0ded2f00876ee upstream.

On RISC-V, the actual mappable range of physical address space is
dependent on the current MMU mode i.e. satp_mode (See
Documentation/arch/riscv/vm-layout.rst).

Define the DIRECT_MAP_PHYSMEM_END macro based on the existing virtual
address space layout macros to expose this information to
get_free_mem_region(). Otherwise, it returns a region that couldn't be
mapped, which breaks ZONE_DEVICE.

Cc: stable@vger.kernel.org # v6.13+
Tested-by: Han Gao <gaohan@iscas.ac.cn> # SG2044
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Link: https://patch.msgid.link/20260309-riscv-sparsemem-vmemmap-limits-v1-2-f40efe18e3cd@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -89,6 +89,16 @@
  */
 #define vmemmap		((struct page *)VMEMMAP_START - vmemmap_start_pfn)
 
+/* Needed to limit get_free_mem_region() */
+#if defined(CONFIG_FLATMEM)
+#define DIRECT_MAP_PHYSMEM_END (phys_ram_base + KERN_VIRT_SIZE - 1)
+#elif defined(CONFIG_SPARSEMEM_VMEMMAP)
+#define DIRECT_MAP_PHYSMEM_END \
+	((vmemmap_start_pfn + VMEMMAP_SIZE / sizeof(struct page)) * PAGE_SIZE - 1)
+#elif defined(CONFIG_SPARSEMEM)
+/* DIRECT_MAP_PHYSMEM_END is not limited by VA space assignment in this case */
+#endif
+
 #define PCI_IO_SIZE      SZ_16M
 #define PCI_IO_END       VMEMMAP_START
 #define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)


