Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4498328B4B;
	Mon, 13 Apr 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099399; cv=none; b=ChlJNhX5FSUbLLvL2DO//7fAH1/Q7w9OB7fL18rGhaHDHlfhAU2aFQb56hkNSATD9S1XeXVv6rQxzaOZvVD2ZEE+SuPgAlBcGXtvvdvDr2p8DTSD5Vmm4Oy8geSq5x9wwCeH4GrMT0MQFimZTx9jcB+MDGmewluXWuF4m91DF/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099399; c=relaxed/simple;
	bh=uZt3zjADzQlWu2pM5H3zPlxYupBpd+1XakTag1nCuac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAxtfR+ruualZ1m93ogOlkQ48Q6BJYeDPZYnto2/tmF/Y+9ZaTNMYe4g95v+TcCm6G6sYJYf7yXAw57XDjJlHtLfmEl+6jSzxcSWgYXqHchMKeL8i5+moW7CuLHJGL1AmvdBfs31s+dcPuzZ6me+bWOVzNdiXoOH9K9DE7Ga46c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I82689vo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I82689vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69961C2BCFC;
	Mon, 13 Apr 2026 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099398;
	bh=uZt3zjADzQlWu2pM5H3zPlxYupBpd+1XakTag1nCuac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I82689vow7n/FGYnvjSNAvFgL0UpKMM5B7ViIlOKNqoignsdV28YwRRMoydK1unjj
	 F0gXYnni3qLUW71UgufytsCxJm/B7t4/Lk0cFri1klKagGBf04h9nvN3S9UdJvoouV
	 fAcYYF+4DWi3BZMgfV3vtEQnohrhpB95/peGLer0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/491] tg3: Fix race for querying speed/duplex
Date: Mon, 13 Apr 2026 17:59:31 +0200
Message-ID: <20260413155831.248096716@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e8be9e5a244fd..954a51fe0cd70 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12232,7 +12232,7 @@ static int tg3_get_link_ksettings(struct net_device *dev,
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
 						advertising);
 
-	if (netif_running(dev) && tp->link_up) {
+	if (netif_running(dev) && netif_carrier_ok(dev)) {
 		cmd->base.speed = tp->link_config.active_speed;
 		cmd->base.duplex = tp->link_config.active_duplex;
 		ethtool_convert_legacy_u32_to_link_mode(
-- 
2.53.0



