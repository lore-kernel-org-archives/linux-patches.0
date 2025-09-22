Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CCB222590;
	Mon, 22 Sep 2025 19:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570161; cv=none; b=afJMh3oR6vs+sNSzTCW7olopa404tWoZVmwvH4s5bVlg5n+AbfQUH8PfTEO96eXPkIoj56yIhUnqFMGlwtMeemIADI55WcSiyFSZKv2hVS9iFWF58iXhaRPAEXix1xe4SO1ObdWkKCzjlRojqKErDQcJ9GG0bbs2sq6JSx/OqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570161; c=relaxed/simple;
	bh=UyiE5sjXsI8DbTrWHH2a/gyEfcvTP+S9+z8Ln8oiBZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8t7e8QdDMGx7hsXx6BGPzKo/Vi2FigB5ecnwlrWwcLpuQLkgJvLBMpkhpSIs/OTMCIdepdC0VENJEdwEHB3zfNDFp0yI5qTfovxs49obV2Nu3XWMCFMurp3dj7KNHMqytN13fsCC2JmQSHqxUowuG7hmF3IlAzt3ArSyks+q+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ho/x53zH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ho/x53zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDD5C4CEF0;
	Mon, 22 Sep 2025 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570160;
	bh=UyiE5sjXsI8DbTrWHH2a/gyEfcvTP+S9+z8Ln8oiBZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ho/x53zHkf/ob5TIHJYzEXFrCIJlMfG/tcJHz+cKQZchZ+vrbbkgIth2/PdPRGRl8
	 WtYhhyrbOhi5FMp0H1EFXGtNOG2+m3+Yf8R+X3hMcXZCI/gwktI3f4lMxpzv7mGXiB
	 mj9y5aT7uVmaL645HmIN4dXo8yye/yXpfqQeG/54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 029/149] net: natsemi: fix `rx_dropped` double accounting on `netif_rx()` failure
Date: Mon, 22 Sep 2025 21:28:49 +0200
Message-ID: <20250922192413.602277222@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeounsu Moon <yyyynoom@gmail.com>

[ Upstream commit 93ab4881a4e2b9657bdce4b8940073bfb4ed5eab ]

`netif_rx()` already increments `rx_dropped` core stat when it fails.
The driver was also updating `ndev->stats.rx_dropped` in the same path.
Since both are reported together via `ip -s -s` command, this resulted
in drops being counted twice in user-visible stats.

Keep the driver update on `if (unlikely(!skb))`, but skip it after
`netif_rx()` errors.

Fixes: caf586e5f23c ("net: add a core netdev->rx_dropped counter")
Signed-off-by: Yeounsu Moon <yyyynoom@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250913060135.35282-3-yyyynoom@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/ns83820.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 56d5464222d97..cdbf82affa7be 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -820,7 +820,7 @@ static void rx_irq(struct net_device *ndev)
 	struct ns83820 *dev = PRIV(ndev);
 	struct rx_info *info = &dev->rx_info;
 	unsigned next_rx;
-	int rx_rc, len;
+	int len;
 	u32 cmdsts;
 	__le32 *desc;
 	unsigned long flags;
@@ -881,8 +881,10 @@ static void rx_irq(struct net_device *ndev)
 		if (likely(CMDSTS_OK & cmdsts)) {
 #endif
 			skb_put(skb, len);
-			if (unlikely(!skb))
+			if (unlikely(!skb)) {
+				ndev->stats.rx_dropped++;
 				goto netdev_mangle_me_harder_failed;
+			}
 			if (cmdsts & CMDSTS_DEST_MULTI)
 				ndev->stats.multicast++;
 			ndev->stats.rx_packets++;
@@ -901,15 +903,12 @@ static void rx_irq(struct net_device *ndev)
 				__vlan_hwaccel_put_tag(skb, htons(ETH_P_IPV6), tag);
 			}
 #endif
-			rx_rc = netif_rx(skb);
-			if (NET_RX_DROP == rx_rc) {
-netdev_mangle_me_harder_failed:
-				ndev->stats.rx_dropped++;
-			}
+			netif_rx(skb);
 		} else {
 			dev_kfree_skb_irq(skb);
 		}
 
+netdev_mangle_me_harder_failed:
 		nr++;
 		next_rx = info->next_rx;
 		desc = info->descs + (DESC_SIZE * next_rx);
-- 
2.51.0



