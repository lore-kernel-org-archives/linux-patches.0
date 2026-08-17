Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3614B04A7;
	Mon, 17 Aug 2026 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976419; cv=none; b=XLKPQhzRETCM6Y2gs42SiM/ogzq4EdrcFA1fpg5HkhLRucaDje9967BMZbiOTXzKxyP5JKeHABepBnXOTHahTdN5bZ0bzZ0gKq6iOF2XLp26/LZXR1jRQz3fzDY2YXsPK4adNP9Ma1V+DcBgaZkgPvcSO1TxnaUBQgEYkBmT8SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976419; c=relaxed/simple;
	bh=QzcYF1gHzaUedv6N4wqe7lvzTaM4xGyfMN7jKtxiqzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHWDrqIkLGCoGmxefuLn6SvyQAx+TR75x8wcy+JgRMNvvi20wObhUMJ+S1yB87lO5uWSTIunejBAJzkxsl2Em3triS346b7J6OMe3q8AUzu/7HXI+uy8FuNNdObjCUAvDmiiivcRGZDh4aTqc0Cm+MLSBFGht3nSqzYnnVLZPGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mt1hPZdl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mt1hPZdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE9A1F000E9;
	Mon, 17 Aug 2026 14:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976417;
	bh=Ac2tiRUXWe53KYU07iQncC5Yj36ef2+lTquVJym0MR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mt1hPZdlUnUXfUm4LrkhB3DiL2WFLUJzSDLi+cddF1OVfsgKmROTGCmwjgl6bGb+l
	 mXVvoIDW4MuOX5PX2frdL5zobFOyJ5I2qtcJKAVpDSvc5xvyw7XhbwKd7EkQcWfCmM
	 243PhcNRRm/hYPIA94b1la6G0ZRIKhOVNkEJYRtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/389] bnxt_en: Do not set EOP on RX AGG BDs on 5760X chips
Date: Mon, 17 Aug 2026 15:32:46 +0200
Message-ID: <20260817132551.663423144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: c3faf548a00f ("bnxt_en: Disable EOP for TPA on all chips to prevent data corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 9 ++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6dd4104025297..07fe6e55f28a6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3391,7 +3391,14 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 
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
index c2122d5cda622..1a7ff21f8cdb8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -99,6 +99,7 @@ struct rx_bd {
 	 #define RX_BD_TYPE_48B_BD_SIZE				 (2 << 4)
 	 #define RX_BD_TYPE_64B_BD_SIZE				 (3 << 4)
 	#define RX_BD_FLAGS_SOP					(1 << 6)
+	#define RX_BD_FLAGS_AGG_EOP				(1 << 6)
 	#define RX_BD_FLAGS_EOP					(1 << 7)
 	#define RX_BD_FLAGS_BUFFERS				(3 << 8)
 	 #define RX_BD_FLAGS_1_BUFFER_PACKET			 (0 << 8)
-- 
2.53.0



