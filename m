Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A5525A321;
	Wed,  8 Apr 2026 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674319; cv=none; b=bG+8EJYXg6c2olNG7UNXNzggx97vUdBi9SNdV5X+Uiifi3efxejNF61r3zucKdHLvi0tws/1hgS/qja9c+3gmrqcfSvUcScSIpAH3Bv1NQu4HkatFFtkuYFiCuov1e6m2+ggbwDBiGAH8kvgXEcPl9v0fvMEM8efC64BI/gSKHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674319; c=relaxed/simple;
	bh=Ngw8Gqpw/eYxS0+fSFHoCY9R6LX0vkBLtOjvA3kvwqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOk2HD5xo5D3CO5ZWPdRBw55b7DVpMnFgA0RSh8rokz7Liq1mPoen5SdgO5J35qJPEBauBI7JoQ8FDjVuDv06+cQEM8iESvGY2yBVVqmXWQ6wyPMDIvOekls7bSIkc4rjsEaDkjEsQXK71/swvuEgjjrQ0R4PzYnbnwoeyzndiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sr8WRnvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sr8WRnvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30745C19421;
	Wed,  8 Apr 2026 18:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674319;
	bh=Ngw8Gqpw/eYxS0+fSFHoCY9R6LX0vkBLtOjvA3kvwqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sr8WRnvRyUkSZLpE+BSj+GKv3CG6K0SOliODk9g8ejYWVE77X0/ig4VvnBG3DdBe1
	 mYYpnnqa0YupwJTX9L4XEToUTmPGHPYWVL7JNcea9mEcnyOzQ1JZ3I9fMhNgZ+WA30
	 58PtP6/FDiBVdjbGE0H8+vujrANhSFw9ffnzOBHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 051/311] tg3: Fix race for querying speed/duplex
Date: Wed,  8 Apr 2026 20:00:51 +0200
Message-ID: <20260408175941.320568235@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index a80f27e66ab52..1a59a2e53d865 100644
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



