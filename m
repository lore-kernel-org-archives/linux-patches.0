Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC493E3C4F;
	Mon, 17 Aug 2026 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974887; cv=none; b=a1AZzrCGR+2KjAi5VyLoIHe+m0Y2NoPNhh/aMFJuB3IeiN2fmLMXfVo5QHsv5cUCIdYIRrA4/SMiW3ioZ4nTh9b4abIfWmOo9Z1VSvEqguBksAoJOvfgRZIyGRV52UxJNXfkN7A01HLkgTWQgQZyHU6TId7hR4/cM0jnxSp4WNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974887; c=relaxed/simple;
	bh=srNO1OPSBBjWCcOcGAWTp7RJ25H66SF8Df9RE1V8KeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBk4NZE1nrBAosfmsXttkJ7dv0VU3dJMgMy3ZBegXg0eg61YhtZYwNTZ1vld1R8Mh5jGQAt+q4q0sBHlYjR33/zwNf7o43XpNSTMOO0CJJQq2KSbR+pfZYGtS9rh7p4oQS2uBlKHtN6KPewDRQLxB8c+szXkEKmTHh8MtQMkQJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPC3Cf69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPC3Cf69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DB31F000E9;
	Mon, 17 Aug 2026 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974879;
	bh=5bjGyB/Fs8/tyLnXYZn/OmLQEdxPF4+9E9jL85q2Cxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPC3Cf69tQy9E+T8HBlYn9WWj3x1mFtvBC3MhTSbITn2hNLCC4/L0/dJDK8xp2cRv
	 7OoqqkU4kDqZVam68O0aRWRjm3fEeH6ORmpo2j3as6mK/y3pB4+UxyKCC9KUEZEKcP
	 8Hxrh2W9m6J6ksxhWhH//6WcejXSr+SFHMv2EM5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/250] bnxt_en: Disable EOP for TPA on all chips to prevent data corruption
Date: Mon, 17 Aug 2026 15:30:48 +0200
Message-ID: <20260817132540.025162214@linuxfoundation.org>
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
index 0d6b6866154ab..83ddf753b8c99 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4506,11 +4506,14 @@ static void bnxt_init_one_rx_agg_ring_rxbd(struct bnxt *bp,
 		type = ((u32)rxr->rx_page_size << RX_BD_LEN_SHIFT) |
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



