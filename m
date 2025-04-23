Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E490F18DB17;
	Wed, 23 Apr 2025 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420040; cv=none; b=C00kxcOae5RRiMR+9nAyAlA/WcmxN0cIsIdVXR7eSVJnQVVcRv3w3YRpg+UVDTq0CdTUgEEqSe/t69IN9WV3+Jte3AbXlgqb0qqCJJh32lRnlT3JArOlR6+i+6CwhWOmJUgVr4ocGuOku/ee2QWDY5jVjaQI/LvdILQz+bh3I7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420040; c=relaxed/simple;
	bh=gcxMeKa4i0X1Debv9JhfMPihW4TV7S2dBArdPX36wYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt2OK25aUW85Tm3peqXCHC6fpJPjiYnnOLg/tjBYeqmEpTBSa7Ajv6HrPOYouRP7uNcSwf1VZmz/M5yZKMY+ox+sB9X82D+ip1TpkJ1cTy57JeHkhRZKXZ7+hiqpP+BdMZ9Hge6vRyP1LMacb0ToHXp4ZIyOFOEp8mlvPYKiE38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ra0yqlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ra0yqlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A79C4CEE2;
	Wed, 23 Apr 2025 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420039;
	bh=gcxMeKa4i0X1Debv9JhfMPihW4TV7S2dBArdPX36wYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Ra0yqlwW9v8+vPhFYmAZzfP3oVHUHy3oSuX61EXlpn3NjoBVok9usmjo/KW+e09N
	 x+KVtseCjGUx+v8Wv9AcSmMs8DJFywKgWKk+pdJtcjkUlLltEFflGuTJBtLLw23rbQ
	 +U/W6jpo6jjN/H5G+82u+xm0VCjAsjhfVGM+aK7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weizhao Ouyang <o451686892@gmail.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 054/241] can: rockchip_canfd: fix broken quirks checks
Date: Wed, 23 Apr 2025 16:41:58 +0200
Message-ID: <20250423142622.714545855@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weizhao Ouyang <o451686892@gmail.com>

[ Upstream commit 6315d93541f8a5f77c5ef5c4f25233e66d189603 ]

First get the devtype_data then check quirks.

Fixes: bbdffb341498 ("can: rockchip_canfd: add quirk for broken CAN-FD support")
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250324114416.10160-1-o451686892@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rockchip/rockchip_canfd-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/rockchip/rockchip_canfd-core.c b/drivers/net/can/rockchip/rockchip_canfd-core.c
index 46201c126703c..7107a37da36c7 100644
--- a/drivers/net/can/rockchip/rockchip_canfd-core.c
+++ b/drivers/net/can/rockchip/rockchip_canfd-core.c
@@ -902,15 +902,16 @@ static int rkcanfd_probe(struct platform_device *pdev)
 	priv->can.data_bittiming_const = &rkcanfd_data_bittiming_const;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 		CAN_CTRLMODE_BERR_REPORTING;
-	if (!(priv->devtype_data.quirks & RKCANFD_QUIRK_CANFD_BROKEN))
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
 	priv->can.do_set_mode = rkcanfd_set_mode;
 	priv->can.do_get_berr_counter = rkcanfd_get_berr_counter;
 	priv->ndev = ndev;
 
 	match = device_get_match_data(&pdev->dev);
-	if (match)
+	if (match) {
 		priv->devtype_data = *(struct rkcanfd_devtype_data *)match;
+		if (!(priv->devtype_data.quirks & RKCANFD_QUIRK_CANFD_BROKEN))
+			priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+	}
 
 	err = can_rx_offload_add_manual(ndev, &priv->offload,
 					RKCANFD_NAPI_WEIGHT);
-- 
2.39.5



