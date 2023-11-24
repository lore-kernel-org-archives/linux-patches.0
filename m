Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C264139FF7;
	Fri, 24 Nov 2023 18:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWdgCHGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC3FC433C8;
	Fri, 24 Nov 2023 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849755;
	bh=VVLfcdWMTMbzbKRCDB7RVXpXdTD+KcRxJbG/tHPoxGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWdgCHGsY9/rAxcp2aN/0S3iWIZLU/F6mq+KX25PSeYLfOWPESmou/INb7mPAC+qZ
	 lydT9a5iq2z+IKabFVW7KWm96Adh4ogkO1BfeUZkLAesnfayJwA3RTQwfcq0m6eQpj
	 7kwUx962PepYsNhwBwVQcfcFe+N7h0feTNVO7NMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 308/530] parisc/agp: Use 64-bit LE values in SBA IOMMU PDIR table
Date: Fri, 24 Nov 2023 17:47:54 +0000
Message-ID: <20231124172037.408233054@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 86bb854d134f4429feb35d2e05f55c6e036770d2 upstream.

The PDIR table of the System Bus Adapter (SBA) I/O MMU uses 64-bit
little-endian pointers.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/agp/parisc-agp.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -38,7 +38,7 @@ static struct _parisc_agp_info {
 
 	int lba_cap_offset;
 
-	u64 *gatt;
+	__le64 *gatt;
 	u64 gatt_entries;
 
 	u64 gart_base;
@@ -104,7 +104,7 @@ parisc_agp_create_gatt_table(struct agp_
 	int i;
 
 	for (i = 0; i < info->gatt_entries; i++) {
-		info->gatt[i] = (unsigned long)agp_bridge->scratch_page;
+		info->gatt[i] = cpu_to_le64(agp_bridge->scratch_page);
 	}
 
 	return 0;
@@ -158,9 +158,9 @@ parisc_agp_insert_memory(struct agp_memo
 		for (k = 0;
 		     k < info->io_pages_per_kpage;
 		     k++, j++, paddr += info->io_page_size) {
-			info->gatt[j] =
+			info->gatt[j] = cpu_to_le64(
 				parisc_agp_mask_memory(agp_bridge,
-					paddr, type);
+					paddr, type));
 			asm_io_fdc(&info->gatt[j]);
 		}
 	}
@@ -184,7 +184,7 @@ parisc_agp_remove_memory(struct agp_memo
 	io_pg_start = info->io_pages_per_kpage * pg_start;
 	io_pg_count = info->io_pages_per_kpage * mem->page_count;
 	for (i = io_pg_start; i < io_pg_count + io_pg_start; i++) {
-		info->gatt[i] = agp_bridge->scratch_page;
+		info->gatt[i] = cpu_to_le64(agp_bridge->scratch_page);
 	}
 
 	agp_bridge->driver->tlb_flush(mem);
@@ -204,7 +204,8 @@ parisc_agp_mask_memory(struct agp_bridge
 	pa |= (ci >> PAGE_SHIFT) & 0xff;/* move CI (8 bits) into lowest byte */
 	pa |= SBA_PDIR_VALID_BIT;	/* set "valid" bit */
 
-	return cpu_to_le64(pa);
+	/* return native (big-endian) PDIR entry */
+	return pa;
 }
 
 static void
@@ -251,7 +252,8 @@ static int __init
 agp_ioc_init(void __iomem *ioc_regs)
 {
 	struct _parisc_agp_info *info = &parisc_agp_info;
-        u64 iova_base, *io_pdir, io_tlb_ps;
+        u64 iova_base, io_tlb_ps;
+	__le64 *io_pdir;
         int io_tlb_shift;
 
         printk(KERN_INFO DRVPFX "IO PDIR shared with sba_iommu\n");


