Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26EB42D763;
	Mon, 17 Aug 2026 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974805; cv=none; b=ln5o+h/mOKKneD9CTAtVo/J9tzmYywuVV7YfOAZeq2g54FdVPhRt8NO5/Mp953Xg8yvfxACXQ+J9pY+8TkYqE/mnu0cyNg7Sj2gGPB7inmE5xTYIvqM0QfvmoMfCxvdoOj8yxkalk/DHjh1BcbD3S1Oo+jjhlfobVik7x7KuEls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974805; c=relaxed/simple;
	bh=lYr9G7psHtT3NSSQdmrMeSAiJDAvvrazYJf4vbAIX8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4KbkuOIvpNf2YDNVzH96XWctuzxU3BZbEMt7bimEvC0rZJqxF4VtPgw8lIWHEpxBWGAkArj+xzO7En/qQLuEfxE2Cb41ch4Z/mVReqqMg+M9QfYfz9QRhWAxmULeoDJ0RhwGfDCBBa6BvJkTwPoI6Qry6ZC5he8I/3DE9UqrBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8kKRoMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8kKRoMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C891F00A3E;
	Mon, 17 Aug 2026 13:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974801;
	bh=1bRrGOSnBZ5wvfnxSGl2YQ985uXAgikOBmhDgV8zaKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8kKRoMlw/HaXiB7Dtb28gKreT4CVL82ubcPWz/4B9/arc91SVn9W+/1m3I2gLIKL
	 kF8LZU3Y1MhI/PVihNthlsUuN8B2Iv/wMOK5RWhR+pkG3ONEIrlaPB4WQGVK6A3Zq2
	 dZx3Ixx3iCHip95nITmmt+o7vsOkhpW/xsllAiHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/250] bnxt_en: Do not set EOP on RX AGG BDs on 5760X chips
Date: Mon, 17 Aug 2026 15:30:19 +0200
Message-ID: <20260817132538.808454124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 30f253f8d9a01d532fdb7ec6c8a9d4c15fe29241 ]

With End-of-Packet padding (EOP) set, the chip will disable Relaxed
Ordering (RO) of TPA data packets.  A TPA segment with EOP set will be
padded to the next cache boundary and can potentially overwrite the
beginning bytes of the next TPA segment when RO is enabled on 5760X.
To prevent that, the chip disables RO for TPA when EOP is set.

To take advantge of RO and higher performance, do not set EOP on
5760X chips when TPA is enabled.  Define a proper RX_BD_FLAGS_AGG_EOP
constant to make it clear that we are setting EOP.

Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251126215648.1885936-6-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d1000fd7995e ("bnxt: fix memory leak in bnxt_queue_mem_alloc error cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 9 ++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 98a911eae8eac..1efd1f8776abe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4495,7 +4495,14 @@ static void bnxt_init_one_rx_agg_ring_rxbd(struct bnxt *bp,
 	ring->fw_ring_id = INVALID_HW_RING_ID;
 	if ((bp->flags & BNXT_FLAG_AGG_RINGS)) {
 		type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
-			RX_BD_TYPE_RX_AGG_BD | RX_BD_FLAGS_SOP;
+			RX_BD_TYPE_RX_AGG_BD;
+
+		/* On P7, setting EOP will cause the chip to disable
+		 * Relaxed Ordering (RO) for TPA data.  Disable EOP for
+		 * potentially higher performance with RO.
+		 */
+		if (BNXT_CHIP_P5_AND_MINUS(bp) || !(bp->flags & BNXT_FLAG_TPA))
+			type |= RX_BD_FLAGS_AGG_EOP;
 
 		bnxt_init_rxbd_pages(ring, type);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d55987e24ad6e..b140799f07d69 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -131,6 +131,7 @@ struct rx_bd {
 	 #define RX_BD_TYPE_48B_BD_SIZE				 (2 << 4)
 	 #define RX_BD_TYPE_64B_BD_SIZE				 (3 << 4)
 	#define RX_BD_FLAGS_SOP					(1 << 6)
+	#define RX_BD_FLAGS_AGG_EOP				(1 << 6)
 	#define RX_BD_FLAGS_EOP					(1 << 7)
 	#define RX_BD_FLAGS_BUFFERS				(3 << 8)
 	 #define RX_BD_FLAGS_1_BUFFER_PACKET			 (0 << 8)
-- 
2.53.0



