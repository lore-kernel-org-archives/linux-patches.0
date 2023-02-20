Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FB863B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAD1C433EF;
	Mon, 20 Feb 2023 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901327;
	bh=0BtGHP8qzGehECo05LflpqYz0qT/laFPyp8/43S/GMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fziYJNQukXhh3BGhrao5CD0XgmugfV2cqwKmjtTp7dSKqGP8HQNr7mloOnF7jE5iP
	 OYLZaqnU6NKj+ECA9HJPVKWL0TLCvfbis+JKgVpstaliKPz+bIp5qWl4nppa97VinY
	 OelWfXEfmeUkES9K8HhTSuYimuvDUmuI7ACWiHvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Mason <jdmason@kudzu.us>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 33/57] net: bgmac: fix BCM5358 support by setting correct flags
Date: Mon, 20 Feb 2023 14:36:41 +0100
Message-Id: <20230220133550.503497257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
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


