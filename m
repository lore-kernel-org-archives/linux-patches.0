Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80A739EF05;
	Mon, 17 Aug 2026 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977601; cv=none; b=i5qPS+VE8V1vFiM4M2nIEhLUZBUN2yQ/DV0RyXICuQgrrMwGvEl2SxIF4BnNSuncxcruE7IOX7aufIod79m9zf4bo/qYmEdrZQMythHIkDGLLItUffBOwRzRiNm/UFa9HKk+9i8OootiTax2/3CsDOsZ4Z5iCT3llDqVlDTeWbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977601; c=relaxed/simple;
	bh=gJ2Yn8FlBjFeTBDKruaUL7CfxsnoE3PpHZ6slYCJb5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEMiqCMFpe2DPPED+iobBTkH7elds8Y9N8eIekyv2XaE8F4ZRDHyD8M+hu0/Qan5OVFgptm/05mJr2g9ImOjPu90FkLxUbrnFO4HcjRsryPvrcqelqMbvR9CqtLptHvu0rP+LJ4R+cKi9o8QZIQ5yOmkXKEe3e+hoYcLC/wkflY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYhJ68hJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYhJ68hJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1B91F000E9;
	Mon, 17 Aug 2026 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977599;
	bh=7OoX0WcHaihCB7oqY7LPTmmJQHLuuwQxYKBCOxwSyxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wYhJ68hJPYtRg+DJOR1ZiCLZ6PAOKUiKo6EOFcWjuSAp7xX5Abo7tvkfgIcVPFRb+
	 jkzUW5lVpo5lI0XoSYu7PW3Z+sdtHq2bYvzapUdLKBQ7HzbwpVOHPj5kuEX1HJGTGq
	 bojoHXWITLD6kUJX5FCpr8WZvmA9/gQF8+aOJ2nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/456] bnxt_en: Do not set EOP on RX AGG BDs on 5760X chips
Date: Mon, 17 Aug 2026 15:32:54 +0200
Message-ID: <20260817132554.486124096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 79aa239fa7cc4..b512a3513e324 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3600,7 +3600,14 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 
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
index 56aae0d654e8a..1f844798abc4e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -103,6 +103,7 @@ struct rx_bd {
 	 #define RX_BD_TYPE_48B_BD_SIZE				 (2 << 4)
 	 #define RX_BD_TYPE_64B_BD_SIZE				 (3 << 4)
 	#define RX_BD_FLAGS_SOP					(1 << 6)
+	#define RX_BD_FLAGS_AGG_EOP				(1 << 6)
 	#define RX_BD_FLAGS_EOP					(1 << 7)
 	#define RX_BD_FLAGS_BUFFERS				(3 << 8)
 	 #define RX_BD_FLAGS_1_BUFFER_PACKET			 (0 << 8)
-- 
2.53.0



