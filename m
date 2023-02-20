Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C452F63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9E6C433EF;
	Mon, 20 Feb 2023 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900576;
	bh=0BtGHP8qzGehECo05LflpqYz0qT/laFPyp8/43S/GMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cuf07bdCfAY5Q1s1t8kvwPi3YyRZzK+JEsAA9+ZNMWbAvzXKv7NWcMs4H0NlPOsj
	 UH8gITmhDSVITNE34CNAUBxoC5+JuSfm9S22+wppO/jnW+lVTDZSM7F5xttQe/LMxR
	 iJCseGCT/wi+gpQ6toL7qwcyylWjFhZGOxSerYDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Mason <jdmason@kudzu.us>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 77/89] net: bgmac: fix BCM5358 support by setting correct flags
Date: Mon, 20 Feb 2023 14:36:16 +0100
Message-Id: <20230220133555.859997597@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

commit d61615c366a489646a1bfe5b33455f916762d5f4 upstream.

Code blocks handling BCMA_CHIP_ID_BCM5357 and BCMA_CHIP_ID_BCM53572 were
incorrectly unified. Chip package values are not unique and cannot be
checked independently. They are meaningful only in a context of a given
chip.

Packages BCM5358 and BCM47188 share the same value but then belong to
different chips. Code unification resulted in treating BCM5358 as
BCM47188 and broke its initialization.

Link: https://github.com/openwrt/openwrt/issues/8278
Fixes: cb1b0f90acfe ("net: ethernet: bgmac: unify code of the same family")
Cc: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230208091637.16291-1-zajec5@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bgmac-bcma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -228,12 +228,12 @@ static int bgmac_probe(struct bcma_devic
 		bgmac->feature_flags |= BGMAC_FEAT_CLKCTLST;
 		bgmac->feature_flags |= BGMAC_FEAT_FLW_CTRL1;
 		bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_PHY;
-		if (ci->pkg == BCMA_PKG_ID_BCM47188 ||
-		    ci->pkg == BCMA_PKG_ID_BCM47186) {
+		if ((ci->id == BCMA_CHIP_ID_BCM5357 && ci->pkg == BCMA_PKG_ID_BCM47186) ||
+		    (ci->id == BCMA_CHIP_ID_BCM53572 && ci->pkg == BCMA_PKG_ID_BCM47188)) {
 			bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_RGMII;
 			bgmac->feature_flags |= BGMAC_FEAT_IOST_ATTACHED;
 		}
-		if (ci->pkg == BCMA_PKG_ID_BCM5358)
+		if (ci->id == BCMA_CHIP_ID_BCM5357 && ci->pkg == BCMA_PKG_ID_BCM5358)
 			bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_EPHYRMII;
 		break;
 	case BCMA_CHIP_ID_BCM53573:


