Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20BC3537EF;
	Wed,  8 Apr 2026 18:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672936; cv=none; b=CRI3+Kr/++H81e9t4HIapb5mM6mjiJkk/DF7wL+8y21oT6S87evDe/SlyF/72LHwU3F6cB5GtjOQDAhXzIP4IosXOqCoV18LLi7HEChpjmIn/auLOkZdCwjc9PRpRFoi/lkXdL7xMyAFKNpYL4sI2a+wcn3RXwkGKaYrIJth+/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672936; c=relaxed/simple;
	bh=1FdJgrJpKO+KXz9IExk3ds1LBnj4hoCn8cG4E16JaPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPfh8vyNorrWwQjbakr3CdjOC+7wXqiymAWOTXrD3ccf1Y2aQnKmRFO0tMlyqLBdqnoeEOA4IFz3Hyc4pZPfWwc0ueNfKpW22qlY0Y8Xcw/ov+aWnVDbxYNpTfBTOk6rO3mmfvPnPu9a96djoFmiOJAl7fLKw1h9dbWTiQ3pF+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnMcgrGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnMcgrGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77846C19421;
	Wed,  8 Apr 2026 18:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672935;
	bh=1FdJgrJpKO+KXz9IExk3ds1LBnj4hoCn8cG4E16JaPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnMcgrGCbycegE1o/Y/Kb3+k6poYXQWYbeVIn82DFQzVE7b8gllbyfRswI4hTk7/1
	 PAbcf+idi+lO+r7sftulowurLvzFY7+fUXdkiHsULPpFkqz3Z76njRtnB/zcNSN9Sd
	 k62tHCf8/R/bp57j3riiWh/r0+ROo4jDCBAEmu8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/277] tg3: Fix race for querying speed/duplex
Date: Wed,  8 Apr 2026 20:00:21 +0200
Message-ID: <20260408175935.201268034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit bb417456c7814d1493d98b7dd9c040bf3ce3b4ed ]

When driver signals carrier up via netif_carrier_on() its internal
link_up state isn't updated immediately. This leads to inconsistent
speed/duplex in /proc/net/bonding/bondX where the speed and duplex
is shown as unknown while ethtool shows correct values. Fix this by
using netif_carrier_ok() for link checking in get_ksettings function.

Fixes: 84421b99cedc ("tg3: Update link_up flag for phylib devices")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index a04b5eb02689d..af21952373ea1 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12300,7 +12300,7 @@ static int tg3_get_link_ksettings(struct net_device *dev,
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
 						advertising);
 
-	if (netif_running(dev) && tp->link_up) {
+	if (netif_running(dev) && netif_carrier_ok(dev)) {
 		cmd->base.speed = tp->link_config.active_speed;
 		cmd->base.duplex = tp->link_config.active_duplex;
 		ethtool_convert_legacy_u32_to_link_mode(
-- 
2.53.0



