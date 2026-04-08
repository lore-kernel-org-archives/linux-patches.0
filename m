Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C1C3D4134;
	Wed,  8 Apr 2026 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672003; cv=none; b=cJCHaWZxu0CR0homDCLl0istVxrXz6x8wtjk6M2pUmY+gWzfdLS7WDXzs/ElAyUl0z+jhFBT2yAZDu7MrEykB7bA+cKcq8M0VyFCgdhLWM/hl48yXUZSnq+E0DxOwoBB/gV7F3oYfKouu758zRwim4v6UggXAaWGE5YUvXd5a4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672003; c=relaxed/simple;
	bh=wXgkoOTCqTkID6ius1q7VS+XkHbsglpg2KzRgxF/KVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO2CfHmoptX4hEvR9xwO945yk0VdQ+8kdnybP66DVytcc2IrgNYC/wBZFurZWL8l4QP5B6+xYpRTfZPO80QejajogIxkCIBqEH1X50WpKCxhFev7KhLEZYAGXaULuCFe73X1gcGOfnli/ys6y5InEuy1Jl3LiwNAzdtBxc3AM/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zznIO1xW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zznIO1xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDB5C19421;
	Wed,  8 Apr 2026 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672002;
	bh=wXgkoOTCqTkID6ius1q7VS+XkHbsglpg2KzRgxF/KVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zznIO1xWvM7PlDdaFcIxz32D1bSc+byyLGzxzDd+8MqBYxcH6y4+8CFqtP3TkgaHl
	 Ku95NQJxubPqeP+U64HkAbk9n13Y9L5QsWcbjrxoPYHh28ALCNCZP5Fl++28lEgN14
	 rxe9dm4VHvwg2VVvIVjATOPZg6IF5TVOHMjGngoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/312] tg3: Fix race for querying speed/duplex
Date: Wed,  8 Apr 2026 20:01:07 +0200
Message-ID: <20260408175939.369539191@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e93e7d37c8262..5e8c11fc5912a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12217,7 +12217,7 @@ static int tg3_get_link_ksettings(struct net_device *dev,
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
 						advertising);
 
-	if (netif_running(dev) && tp->link_up) {
+	if (netif_running(dev) && netif_carrier_ok(dev)) {
 		cmd->base.speed = tp->link_config.active_speed;
 		cmd->base.duplex = tp->link_config.active_duplex;
 		ethtool_convert_legacy_u32_to_link_mode(
-- 
2.53.0



