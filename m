Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307B73101A7;
	Fri,  7 Aug 2026 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113929; cv=none; b=mcK0mCHKmKdMtv0DR0FwuMn72bbnOq8eOOtDveOIjNqEoUa1ukT8WyMdHyoreAitlkI6vLYRC2ojPIxMNjRuNTeXfKkP4bTccbnUjFVHc2D/TkfsxjyeLEVMGjb+9gqemYPD4UJRPTQFQ49q1Xjfa4N4hJWtP6LB2qJyhoJkim4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113929; c=relaxed/simple;
	bh=XECQIdOxiyiCKVmufUjqWrV7iRU0VYFsSVHs1w8HyRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HL64JoBA9gE2WTglJBfzkGfz2DUu2mj3O5N6q1bri9zs/V+Kc1I+mI+WmyBTxQZodLpoykUBXLkr3XiutnMJ/lQm1tNBtgibAwH0xx3hSdBiTDoWMfAUxWGwso6K7SWZQiuTDhdN1HsxcydrfEg207J48c8up5MZSgoay1PZVV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNwt+Aht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNwt+Aht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6159E1F00A3D;
	Fri,  7 Aug 2026 14:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113923;
	bh=qy0gdL+aCeczDwFKLhJx1iZHg9i6US5afo+e5U5LQiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNwt+AhtL4WRKhJV3MSOEZjJ91DIJ30L2+52eMe952DFgaVvRPIsIVLmUlXkhgCWw
	 Mv+SvO+zVLC7QxEyn1/RXIGOx4aXuk9y1c+qUxL6YZoEPHMe6azp0/PbC8VVQxSqMq
	 M+bCz9ZWedUPw/Y1Ni6IU4G5WODXWGwesbpea9sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/337] forcedeth: fix UAF of txrx_stats in nv_remove
Date: Fri,  7 Aug 2026 16:34:38 +0200
Message-ID: <20260807143420.140850399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 22666ba1420164753d7b0f5a841986b25ace5435 ]

nv_remove() frees the per-CPU txrx_stats before unregister_netdev().
Until unregister completes, ndo_get_stats64, the NAPI/xmit data path,
and nv_close()/drain may still access txrx_stats, leading to a
use-after-free.

Free the stats only after unregister_netdev().

Fixes: f4b633b911fd ("forcedeth: use per cpu to collect xmit/recv statistics")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20260723092637.2135095-1-chenguang.zhao@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 720f577929dbf..11eb3751ad27b 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -6199,10 +6199,10 @@ static void nv_remove(struct pci_dev *pci_dev)
 	struct net_device *dev = pci_get_drvdata(pci_dev);
 	struct fe_priv *np = netdev_priv(dev);
 
-	free_percpu(np->txrx_stats);
-
 	unregister_netdev(dev);
 
+	free_percpu(np->txrx_stats);
+
 	nv_restore_mac_addr(pci_dev);
 
 	/* restore any phy related changes */
-- 
2.53.0



