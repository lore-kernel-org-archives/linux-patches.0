Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17C12C237E;
	Mon, 17 Aug 2026 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977603; cv=none; b=Iohv+T+BFerYEBflTWPAgaTHsyjreGTYrfm0zmZcz+s0WS9rwYQSEmpNvTrXrfWg4Y93xVrE1YepBrvMWbf/KWemLCUbmAqo+etQuBEponS2TEZC3WFUZHjHojSwineSN8jSrCJ1JVCpHBNAV+rLT84wUxiJ/VBa84hP9317EgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977603; c=relaxed/simple;
	bh=tBIimfCf35LjmvqgNRqNRlC6JfXxgubJO5i4hP1ec1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCNWTUMM/SBMy9iPjI9Z+eCbmYflKxYeEc0wb61l4cpku0Kw/caiwXmMPHawzH7E8ka8hKV/lThAhy6pC9bX44xGNtGWKlpq6tPGsOdGs6gCRC/u60Mn+JktE/sur1d5sz911jXwsMzYEev4VmVViDOPxtv7LYsdms2Hcd8vam0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ou++p1Ii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ou++p1Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2747A1F000E9;
	Mon, 17 Aug 2026 14:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977602;
	bh=DbIER4Q31R7eeinOcE9kbM9WOjnEcB9rYOpIX9OP0HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ou++p1Ii43WfqMIZ1Mpbhr8lPCu0HQmQoPqRJkVX0CL2SAo/O/5Nlihjy7/mDPX+E
	 TXraenHz187wma1BFFyDBSp4J6VgsIfZdxcJz5Q2ijemymWkVJfRklXftLm9tnZ4mL
	 mtTh9Jb9LI0Vc+/udnFdi5Jn0jce9i8XBZXgdOsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 385/456] bnxt_en: Disable EOP for TPA on all chips to prevent data corruption
Date: Mon, 17 Aug 2026 15:32:55 +0200
Message-ID: <20260817132554.516844422@linuxfoundation.org>
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
index b512a3513e324..0b435bd3db9dc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3602,11 +3602,14 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
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



