Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA39C30AD05;
	Thu, 16 Jul 2026 14:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211361; cv=none; b=kw33Z08b9a3PvTQXF2OPcHuWVG+FBSIOWQD74xjc9lXRVmax3oGQEAJEciKB+xEbYV4OolTUS1ZPIo3JxOZwwJsjuux/8bb6ZiZBmTYKJNgEogVsHyPOpzZCXtTJc1J6W2uFrncPNKqQA8n1walhVDG6e9KI57Aw+Vvz5+N8cp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211361; c=relaxed/simple;
	bh=fxMzvdG4fneKiue3VuzH72QSCSJWfxlw4YKEo4kG0pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRXxBH5b0BQeUDfv5tidW30MWIrEOOzZTD8Nb9yqHVE/UYARBD+zgIzt4SyWDKyAvsBlx/iWALZFebyAJ3/dSwh7SKvrw0ZHD5wOr71ZKgsheUppsgdguPY0/DGOHYMQI/51avyUxOaVmWm935wukoJx7/g1ZKFEWQm1GZ/bGN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0M9IAMoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0M9IAMoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A75F1F000E9;
	Thu, 16 Jul 2026 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211359;
	bh=hesertC6yPfhm7/mGy8W0ovs06EdlQw5DacAmVDaE5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0M9IAMozsNXUnUB0Pu9jUYvArwVHn3uVBY43WOft7A/+6KTU/CTNiH1zwLtjZ2cFh
	 4h+1zOLc5fNJtCtIVoBOiTHKE9Qg3DzaoNUSrvHmo25dcOFNxexdNVBWCjrgw+FRqR
	 bZNNK3syACcTdQO3OJGiwWrwf6Hg9vdHpP5GKJ+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Han Gao <gaohan@iscas.ac.cn>
Subject: [PATCH 6.18 398/480] riscv: mm: Define DIRECT_MAP_PHYSMEM_END
Date: Thu, 16 Jul 2026 15:32:25 +0200
Message-ID: <20260716133053.414803969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -93,6 +93,16 @@
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


