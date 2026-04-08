Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802D324B1F;
	Wed,  8 Apr 2026 18:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672478; cv=none; b=iZizT+FqV8yOKAb9xHXE266/CB+FyHF6uYtaxCPFmxiP3JL8QW/uPBJZGgKsX1bO31xF2mNzbOjbbRlX6dbkbRlsZ+8EER7hfh8O3SCE4jJdT73yqDDtmM0YZqgjMNQ6xGd2GJTzf3UarSTT4X4NDYycVqq2DnHcsU5VA9AEO+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672478; c=relaxed/simple;
	bh=fdQHc6N+0Lv16xQfcH6I3XSgdjMalr9q6W0xedTrG8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmTuRPr6wOHsx4ml271ibVvgNb2HtPLtJ5V5eAzhv+OoTLWrqtJst9cWOYSYwqj+ZqIJ8R7hXuCItUPRmHKzqp5JEl+hwIzAvIGQg3uPamYFIyssm+qUkGg/fUv0u7O3sXildzq7gLv+N5I5wNpCfedope07ltgqRjuhmCEC6ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2E8aWlnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2E8aWlnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF69C19421;
	Wed,  8 Apr 2026 18:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672478;
	bh=fdQHc6N+0Lv16xQfcH6I3XSgdjMalr9q6W0xedTrG8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2E8aWlnjf0kHiEEHpAMXMuon76PEbH2nRtK9JVQ1wlfOVtraXi+pTDSIrB6MTThHa
	 pQiKFpP4xLSu0pjVnnkD1UGiyPmuD4qOcUbeDkiQFreR6SU2tVbimIC+FEloSpRQFW
	 lroBF9bNDAQNjDHe2A8Zw6l2ktywS/Ayj7UkOakw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/160] tg3: Fix race for querying speed/duplex
Date: Wed,  8 Apr 2026 20:01:49 +0200
Message-ID: <20260408175914.029999391@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 840231ebbef71..1ffd98a1c7417 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12212,7 +12212,7 @@ static int tg3_get_link_ksettings(struct net_device *dev,
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
 						advertising);
 
-	if (netif_running(dev) && tp->link_up) {
+	if (netif_running(dev) && netif_carrier_ok(dev)) {
 		cmd->base.speed = tp->link_config.active_speed;
 		cmd->base.duplex = tp->link_config.active_duplex;
 		ethtool_convert_legacy_u32_to_link_mode(
-- 
2.53.0



