Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4E21F8903;
	Tue, 17 Dec 2024 17:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456569; cv=none; b=B4rcDoEPeLHudRhj8wt/08JBJR1wQlF5PfRwMMRw3t/sEhFuyw88ihF6CBhZzwWDj6DFZpzK+0NoOgCdLTcebZyVVyizHnrL0rTymhthE4qxxbGvwJdIpMeQ5IFR9a8sqIIhc+MIqPXFBj4xpz5zNQazUhUHNSDN1a/jruTzXuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456569; c=relaxed/simple;
	bh=KtTE3qarCNO5dIrGuBZevaJw/+2dS0oUzH1yCx3emVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQXBYYSCs7AqqthYV3hHjtsHTACSuouIfXqwRyy94pzCDR4SYL8eKnYwKiXm9f5ypEVdHKphqiIIE125sdg3lZpVP0U+2DlOWETYdcBD3VMySFyeHCwK7dVGx1GRWKC5tXM5tnQda2+7FHm1d8Kzu8MlXpGss+qPG82A4laNGXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV8pAZcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV8pAZcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697F0C4CEDE;
	Tue, 17 Dec 2024 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456568;
	bh=KtTE3qarCNO5dIrGuBZevaJw/+2dS0oUzH1yCx3emVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZV8pAZcwHZN6O6no0J0XTSaw3Vo9hOIew0wVUxuKUR1sRrIPKrs49qI+Fnd1eYoRy
	 pONFa4vIAhZtyPNZ/7EcDBAoXCR8ZYIwm89+eV/xt+Lkf7WDDBxPH4Hbayt2Eo/mYk
	 TRd08A24TkwNtMNbhGsW2D0qcsmk6MooXJfQAdDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Winegarden <colin.winegarden@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/172] bnxt_en: Fix GSO type for HW GRO packets on 5750X chips
Date: Tue, 17 Dec 2024 18:07:36 +0100
Message-ID: <20241217170550.455739731@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit de37faf41ac55619dd329229a9bd9698faeabc52 ]

The existing code is using RSS profile to determine IPV4/IPV6 GSO type
on all chips older than 5760X.  This won't work on 5750X chips that may
be using modified RSS profiles.  This commit from 2018 has updated the
driver to not use RSS profile for HW GRO packets on newer chips:

50f011b63d8c ("bnxt_en: Update RSS setup and GRO-HW logic according to the latest spec.")

However, a recent commit to add support for the newest 5760X chip broke
the logic.  If the GRO packet needs to be re-segmented by the stack, the
wrong GSO type will cause the packet to be dropped.

Fix it to only use RSS profile to determine GSO type on the oldest
5730X/5740X chips which cannot use the new method and is safe to use the
RSS profiles.

Also fix the L3/L4 hash type for RX packets by not using the RSS
profile for the same reason.  Use the ITYPE field in the RX completion
to determine L3/L4 hash types correctly.

Fixes: a7445d69809f ("bnxt_en: Add support for new RX and TPA_START completion types for P7")
Reviewed-by: Colin Winegarden <colin.winegarden@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20241204215918.1692597-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 ++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  3 +++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3d9ee91e1f8b..dafc5a4039cd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1518,7 +1518,7 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		if (TPA_START_IS_IPV6(tpa_start1))
 			tpa_info->gso_type = SKB_GSO_TCPV6;
 		/* RSS profiles 1 and 3 with extract code 0 for inner 4-tuple */
-		else if (cmp_type == CMP_TYPE_RX_L2_TPA_START_CMP &&
+		else if (!BNXT_CHIP_P4_PLUS(bp) &&
 			 TPA_START_HASH_TYPE(tpa_start) == 3)
 			tpa_info->gso_type = SKB_GSO_TCPV6;
 		tpa_info->rss_hash =
@@ -2212,15 +2212,13 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		if (cmp_type == CMP_TYPE_RX_L2_V3_CMP) {
 			type = bnxt_rss_ext_op(bp, rxcmp);
 		} else {
-			u32 hash_type = RX_CMP_HASH_TYPE(rxcmp);
+			u32 itypes = RX_CMP_ITYPES(rxcmp);
 
-			/* RSS profiles 1 and 3 with extract code 0 for inner
-			 * 4-tuple
-			 */
-			if (hash_type != 1 && hash_type != 3)
-				type = PKT_HASH_TYPE_L3;
-			else
+			if (itypes == RX_CMP_FLAGS_ITYPE_TCP ||
+			    itypes == RX_CMP_FLAGS_ITYPE_UDP)
 				type = PKT_HASH_TYPE_L4;
+			else
+				type = PKT_HASH_TYPE_L3;
 		}
 		skb_set_hash(skb, le32_to_cpu(rxcmp->rx_cmp_rss_hash), type);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 69231e85140b..1d97219369c5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -267,6 +267,9 @@ struct rx_cmp {
 	(((le32_to_cpu((rxcmp)->rx_cmp_misc_v1) & RX_CMP_RSS_HASH_TYPE) >>\
 	  RX_CMP_RSS_HASH_TYPE_SHIFT) & RSS_PROFILE_ID_MASK)
 
+#define RX_CMP_ITYPES(rxcmp)					\
+	(le32_to_cpu((rxcmp)->rx_cmp_len_flags_type) & RX_CMP_FLAGS_ITYPES_MASK)
+
 #define RX_CMP_V3_HASH_TYPE_LEGACY(rxcmp)				\
 	((le32_to_cpu((rxcmp)->rx_cmp_misc_v1) & RX_CMP_V3_RSS_EXT_OP_LEGACY) >>\
 	 RX_CMP_V3_RSS_EXT_OP_LEGACY_SHIFT)
-- 
2.39.5



