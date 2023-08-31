Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F578F4B
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53516C433C7;
	Thu, 31 Aug 2023 11:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480235;
	bh=JtTapC4AtWFBWOhPlICr4Fsm41ax+7d1GoZbQO6vOj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tb5uXjX3mRjSQILUT3yJ8eKzZGV3oEkO5xBq5bzDroCrZ7CQgr0KdyWS+48OMr1LD
	 XfTPzZTQ4/k0mV1Cs6iXorKVCEjwxXx4p32+A0N3fu630XDJ8VGRJpld9NFiwijjbC
	 aJfiBXiTJj2kNL1f+i2RSIcDnIPsuQUA27Bioq5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/11] Revert "MIPS: Alchemy: fix dbdma2"
Date: Thu, 31 Aug 2023 13:09:59 +0200
Message-ID: <20230831110830.744701188@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
References: <20230831110830.455765526@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 619672bf2d04cdc1bc3925defd0312c2ef11e5d0 which is
commit 2d645604f69f3a772d58ead702f9a8e84ab2b342 upstream.

It breaks the build, so should be dropped.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/alchemy/common/dbdma.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/arch/mips/alchemy/common/dbdma.c
+++ b/arch/mips/alchemy/common/dbdma.c
@@ -30,7 +30,6 @@
  *
  */
 
-#include <linux/dma-map-ops.h> /* for dma_default_coherent */
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -624,18 +623,17 @@ u32 au1xxx_dbdma_put_source(u32 chanid,
 		dp->dscr_cmd0 &= ~DSCR_CMD0_IE;
 
 	/*
-	 * There is an erratum on certain Au1200/Au1550 revisions that could
-	 * result in "stale" data being DMA'ed. It has to do with the snoop
-	 * logic on the cache eviction buffer.  dma_default_coherent is set
-	 * to false on these parts.
+	 * There is an errata on the Au1200/Au1550 parts that could result
+	 * in "stale" data being DMA'ed. It has to do with the snoop logic on
+	 * the cache eviction buffer.  DMA_NONCOHERENT is on by default for
+	 * these parts. If it is fixed in the future, these dma_cache_inv will
+	 * just be nothing more than empty macros. See io.h.
 	 */
-	if (!dma_default_coherent)
-		dma_cache_wback_inv(KSEG0ADDR(buf), nbytes);
+	dma_cache_wback_inv((unsigned long)buf, nbytes);
 	dp->dscr_cmd0 |= DSCR_CMD0_V;	/* Let it rip */
 	wmb(); /* drain writebuffer */
 	dma_cache_wback_inv((unsigned long)dp, sizeof(*dp));
 	ctp->chan_ptr->ddma_dbell = 0;
-	wmb(); /* force doorbell write out to dma engine */
 
 	/* Get next descriptor pointer. */
 	ctp->put_ptr = phys_to_virt(DSCR_GET_NXTPTR(dp->dscr_nxtptr));
@@ -687,18 +685,17 @@ u32 au1xxx_dbdma_put_dest(u32 chanid, dm
 			  dp->dscr_source1, dp->dscr_dest0, dp->dscr_dest1);
 #endif
 	/*
-	 * There is an erratum on certain Au1200/Au1550 revisions that could
-	 * result in "stale" data being DMA'ed. It has to do with the snoop
-	 * logic on the cache eviction buffer.  dma_default_coherent is set
-	 * to false on these parts.
+	 * There is an errata on the Au1200/Au1550 parts that could result in
+	 * "stale" data being DMA'ed. It has to do with the snoop logic on the
+	 * cache eviction buffer.  DMA_NONCOHERENT is on by default for these
+	 * parts. If it is fixed in the future, these dma_cache_inv will just
+	 * be nothing more than empty macros. See io.h.
 	 */
-	if (!dma_default_coherent)
-		dma_cache_inv(KSEG0ADDR(buf), nbytes);
+	dma_cache_inv((unsigned long)buf, nbytes);
 	dp->dscr_cmd0 |= DSCR_CMD0_V;	/* Let it rip */
 	wmb(); /* drain writebuffer */
 	dma_cache_wback_inv((unsigned long)dp, sizeof(*dp));
 	ctp->chan_ptr->ddma_dbell = 0;
-	wmb(); /* force doorbell write out to dma engine */
 
 	/* Get next descriptor pointer. */
 	ctp->put_ptr = phys_to_virt(DSCR_GET_NXTPTR(dp->dscr_nxtptr));


