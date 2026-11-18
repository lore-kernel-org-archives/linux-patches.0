Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028286;
	b=Dr80R7w7CflCv5BquDE6HBOoitRu1SHFnITPTVZfe2b9wskTEUEbFmnzrXDEbCBsnP9G
	 03GEmzGyLvfO6/Rzl/8EvM8bdEK25QTjiQJPLWq1uHWIlrFetClqP02TkTulmK2C+uGch
	 PXsWGFHUly8t+cTFTMp1xlgBmPKFVVK51gzshLyJKYtu15LOx5WWreN/l9cPJyUdSGUAd
	 ElA9kVpb+L1zZMPCuCRDSj0ipff8IaIh/GaC2XA1ecYJ51ISaYUKdm5PZvtuzAZUnW1S3
	 LXlAUety7sG8umOof9G475E7wYqDkIxgTT1H/JT5lCdelNRfUDMbC81DNRkMHZwnPaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZVhEgbw9/zGbEH4Kr68KCte2jOyYxWkhMDpeh4tV2Ao=;
	b=aNeCfrmwPQ+BCucEdVop3KXsTwVLypG/gtXxrz4+sGawK0i/ybgZ5ll6THzQu+KM1Asx
	 fkGLG6yLA82biDLdZ16wf4NCaJAkxhvsHLF+dVjzsyK14VhWTpUG5hpiE46UaWLZpIYXx
	 pHmGbDzi1DoUKTCE/amXirszCm6NcV+NdSMVDxTRMqrB1Oj8Irft8wlr2/qiITR05wEoV
	 UpIaj/a/o6d6GyLGgmlXWbipoLOuXqvFLvUB5lpmd6sXEGo7r2N05AvcDi7QosUNPxGMc
	 Re1+ipXOCP900I+AAmHqKT0pTst1837bJ8lEAFutWewr6X7tBBZPy552WLjm4pdPP5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GPEi0kX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC54606A325;
	Wed, 18 Nov 2026 18:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GPEi0kX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD151F000C7;
	Wed, 18 Nov 2026 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028286;
	bh=ZVhEgbw9/zGbEH4Kr68KCte2jOyYxWkhMDpeh4tV2Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GPEi0kXjLubm7WMwjfLdz8RXzBae5oy4ZVKtniKaGyE9lkOHnLaUro9utt9Hd2F/
	 x6YIWafgV20l5qVeFJ1po0Q7LxgNoajBBDKNwuC0qgQ9RIPyBdj7DXYai+NTWmHtnp
	 IhLx8irMGoJd1Nm37omW5ZUbGzVM+Q7e/nAcuxRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2049/2151] bnge: fix RSS table sizing for large RX ring counts
Date: Wed, 18 Nov 2026 16:03:04 +0100
Message-ID: <20261118150236.363134035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dharmender Garg <dharmender.garg@broadcom.com>

[ Upstream commit 8b97091eae744a577573797e5d5abc3e0da10769 ]

bnge_adjust_pow_two() adds one block before rounding up to a power of
two only when the quotient is 0 or 1. A larger quotient that is
already a power of two is returned unchanged, so 129-192 RX rings
get a 128-entry RSS indirection table and 257-320 rings a 256-entry
one. The rings above the table size never receive default RSS traffic.
bnxt_calc_nr_ring_pages() always adds one, which is correct.

Make bnge_adjust_pow_two() always add one block before rounding up.

bnge_adjust_pow_two() also sizes the RX, RX aggregation, TX and
completion ring pages. For the default 511-entry rings their page
counts do not change. The completion ring is sized from more than
the default depth, so its page count changes where the old code
dropped a partial page. With 8K ring pages, TPA off and the default
rings, its budget is 1533 entries and the page count goes from 2 to 4.
With 4K ring pages and TPA on, when the firmware reports a
max_aggs_supported of 260 to 387, it goes from 16 to 32.
In these cases the old completion ring held fewer entries than
its budget.

Fixes: 627c67f038d2 ("bng_en: Add resource management support")
Signed-off-by: Dharmender Garg <dharmender.garg@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261026092757.9168-3-vikas.gupta@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_resc.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_resc.h b/drivers/net/ethernet/broadcom/bnge/bnge_resc.h
index 0d6213b275800..ca234ec0a7ca1 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_resc.h
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_resc.h
@@ -80,13 +80,10 @@ bnge_adjust_pow_two(u32 total_ent, u16 ent_per_blk)
 {
 	u32 blks = total_ent / ent_per_blk;
 
-	if (blks == 0 || blks == 1)
-		return ++blks;
+	if (!blks)
+		return 1;
 
-	if (!is_power_of_2(blks))
-		blks = roundup_pow_of_two(blks);
-
-	return blks;
+	return roundup_pow_of_two(blks + 1);
 }
 
 #define BNGE_MAX_ROCE_MSIX		64
-- 
2.53.0



