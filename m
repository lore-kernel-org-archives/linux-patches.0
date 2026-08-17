Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9EC4B04A7;
	Mon, 17 Aug 2026 14:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976422; cv=none; b=QcYE9RfBBy5eRlLA9eoRsM45Ay9baJ2tEX1m+bUTbWj+K/zd/FSIB1z8ORbcVpRLAAxQBEJEoZlt9CaajbAXwsZQdll/l+XlOOCm81JLJ9IaHN+fEDvoq+0yHLZFQEeDi8aoSECDJv071OWDOIuTQJoIvTuAkRi4nS+/DEEybPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976422; c=relaxed/simple;
	bh=m0qu0Xvi8U4V0xpCHxBOoPzjvwdkG30HJnxk0IuT1Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsARVDFMePvruDamsOqGX2TL40jCC/QbiM6d1wFs1666nDPDB9L/lTSKxmIZsXz72NsyZLyAMSYPCVzuuxDJ/94OTGnH8YyaDjHUMY7QK4leqqt/QNUqmKYVXIOBS2DZHo46FrS/lh00gu/ucSGxlTOJw27PK0KR7OluFz7q+0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWhlX97V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWhlX97V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0151F000E9;
	Mon, 17 Aug 2026 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976421;
	bh=kiKs/E/8hP8Knvpv1Cj+YKWX4Ev61EsoOXWnJgUGAuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWhlX97VUWGs86OzXVEF653OktqrTTRkoUTCWu+BNHrvm5mo6yG2CuhzDU+YD2HzG
	 /LPj+9/eIx/oN/mUa7qIrwTeL567c0D+mht3S91gxUslcrlk4wAlyFJYqeUtgU0LXu
	 z0PgLV8XGrlU9Ul8fBVMTFz3M38BkwRXEaAKBoi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/389] bnxt_en: Disable EOP for TPA on all chips to prevent data corruption
Date: Mon, 17 Aug 2026 15:32:47 +0200
Message-ID: <20260817132551.696412997@linuxfoundation.org>
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

[ Upstream commit c3faf548a00f4c17100cc9204746975fa46a73b9 ]

EOP (End of frame padding) on the AGG ring may cause overlapping of
zero padding at the end of one segment with the next segment's data.
If Relaxed Ordering (RO) is enabled, the zero padding may overwrite
valid data in the next segment and corrupt the data.  Older chips
(P5 and older) do not automatically disable RO when EOP is enabled.
On some ARM systems, data corruption was reported on 57508 (P5)
chips with RO enabled.

Always disable EOP on all chips on the AGG rings when TPA is enabled
to fix the data corruption.

Fixes: bfcd8d791ec1 ("bnxt_en: Add fast path logic for TPA on 57500 chips.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260731190937.807270-5-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 07fe6e55f28a6..f36b2bae37999 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3393,11 +3393,14 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 		type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
 			RX_BD_TYPE_RX_AGG_BD;
 
-		/* On P7, setting EOP will cause the chip to disable
-		 * Relaxed Ordering (RO) for TPA data.  Disable EOP for
-		 * potentially higher performance with RO.
+		/* Disable EOP if TPA is enabled to prevent overlapping zero
+		 * padding with the next segment's data.  On P7_PLUS, EOP will
+		 * automatically disable Relaxed Ordering (RO) to prevent
+		 * potential data corruption (and may degrade performance).  On
+		 * older chips, RO will not be automatically disabled and may
+		 * cause corruption.
 		 */
-		if (BNXT_CHIP_P5_AND_MINUS(bp) || !(bp->flags & BNXT_FLAG_TPA))
+		if (!(bp->flags & BNXT_FLAG_TPA))
 			type |= RX_BD_FLAGS_AGG_EOP;
 
 		bnxt_init_rxbd_pages(ring, type);
-- 
2.53.0



