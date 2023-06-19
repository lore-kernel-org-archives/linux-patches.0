Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D833310961
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FDDC433C0;
	Mon, 19 Jun 2023 10:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170779;
	bh=awNbbUrZKfXcgaKH6JhIK8hfjJtLZGaowOiSziy/Zt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywKLJDvvDx6VoeuZC4qt+Icq8ZwAyXEJjrF2BVO6I25Nf2smB/3CGSF3qgUHUAZbx
	 c4j6GtXul8eLKt8Oi7t1rTGCChPnXJAD/0rRupJaM8f54YrSybBz+xGHgfHHauh6Z0
	 uce3UH/DqNiCFn+qqj+Sh9TxVHOKtVsaqhKVY+0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 032/187] parisc: Flush gatt writes and adjust gatt mask in parisc_agp_mask_memory()
Date: Mon, 19 Jun 2023 12:27:30 +0200
Message-ID: <20230619102159.200702878@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

[ Upstream commit d703797380c540bbeac03f104ebcfc364eaf47cc ]

Flush caches after changing gatt entries and calculate entry according
to SBA requirements.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/agp/parisc-agp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index d68d05d5d3838..514f9f287a781 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -90,6 +90,9 @@ parisc_agp_tlbflush(struct agp_memory *mem)
 {
 	struct _parisc_agp_info *info = &parisc_agp_info;
 
+	/* force fdc ops to be visible to IOMMU */
+	asm_io_sync();
+
 	writeq(info->gart_base | ilog2(info->gart_size), info->ioc_regs+IOC_PCOM);
 	readq(info->ioc_regs+IOC_PCOM);	/* flush */
 }
@@ -158,6 +161,7 @@ parisc_agp_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 			info->gatt[j] =
 				parisc_agp_mask_memory(agp_bridge,
 					paddr, type);
+			asm_io_fdc(&info->gatt[j]);
 		}
 	}
 
@@ -191,7 +195,16 @@ static unsigned long
 parisc_agp_mask_memory(struct agp_bridge_data *bridge, dma_addr_t addr,
 		       int type)
 {
-	return SBA_PDIR_VALID_BIT | addr;
+	unsigned ci;			/* coherent index */
+	dma_addr_t pa;
+
+	pa = addr & IOVP_MASK;
+	asm("lci 0(%1), %0" : "=r" (ci) : "r" (phys_to_virt(pa)));
+
+	pa |= (ci >> PAGE_SHIFT) & 0xff;/* move CI (8 bits) into lowest byte */
+	pa |= SBA_PDIR_VALID_BIT;	/* set "valid" bit */
+
+	return cpu_to_le64(pa);
 }
 
 static void
-- 
2.39.2



