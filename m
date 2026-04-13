Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4371D5AD4;
	Mon, 13 Apr 2026 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098220; cv=none; b=fiZyrA7xDXqN0/2OvkbTyc2hDsFzqssa3CiT+ALWBEo4uVEfBqytyNI3lBbLRzrcFG3LEn5PWZ/kv4kt6ryEUHFzIW5ZnnVZMr+axg/FhpL0FzKnO770+TvSp0BlV229Q3KrVAT6tGGXg33g9aP7fTWnsPUzwRL8020UK8fBPp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098220; c=relaxed/simple;
	bh=Ou9gE2MKIoc5KeACEXI7D7Uj6JtUHww2i+fP8ktDts8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4/Yw0u33S4DTzlh2PkN1acl7lwfiy0lxF7SgRutp4Am/fiEj1WRU/XwiwSEAi/Knt3Zujvyi8ApSyyVPpfRnhLmOcqHB2ZKr4ot0L4RnzyAk/tB2Fst/tjGGgij3kE9THp0qt/Lt9/CqzwxkioMoFfyH1DDYrAycne84peNSjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMKvQ4bY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMKvQ4bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A59CC2BCAF;
	Mon, 13 Apr 2026 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098220;
	bh=Ou9gE2MKIoc5KeACEXI7D7Uj6JtUHww2i+fP8ktDts8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMKvQ4bY3sVMHEzcdYT2FNy+XcjGjEdYUfS/gfzMYMtai8OczBw+sR5gkSStrWL01
	 zlq7RV3BiEd2FUNkS/Kzx73QVteQ+894nKDm6XPvAdIObEYpVgV/VRRg/77IaaL2zT
	 KAPiHj8RfC/PB+C/12CIhIEGoRetUnnQS/08EbVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/570] tg3: Fix race for querying speed/duplex
Date: Mon, 13 Apr 2026 17:58:59 +0200
Message-ID: <20260413155845.751821049@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index bd3b56c7aab8d..e18e58f8258e6 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12223,7 +12223,7 @@ static int tg3_get_link_ksettings(struct net_device *dev,
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
 						advertising);
 
-	if (netif_running(dev) && tp->link_up) {
+	if (netif_running(dev) && netif_carrier_ok(dev)) {
 		cmd->base.speed = tp->link_config.active_speed;
 		cmd->base.duplex = tp->link_config.active_duplex;
 		ethtool_convert_legacy_u32_to_link_mode(
-- 
2.53.0



