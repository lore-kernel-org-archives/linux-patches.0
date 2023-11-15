Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8496D43AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrHQj4uU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338FBC433B7;
	Wed, 15 Nov 2023 20:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081248;
	bh=CJhZIPW9AqzMF4t9nGtVjZambGlmMGt1WrKwmlo9FTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrHQj4uUIew1+nUuP1rnquZsSGWXNbHL2LMzGGElORQHqVRs7TKUdaDa2ycicYx5t
	 hWp6QTHSR0275l4/RKcq/BtfNT0lRqHE4CMriH8sGw+aAnC0dwQUKR4Fc0D2rScqom
	 D/yJTs9JX3JIJxlCEN/sxad+Sq1zBqECr8YdAyPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juhee Kang <claudiajkang@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/244] r8169: use tp_to_dev instead of open code
Date: Wed, 15 Nov 2023 15:33:51 -0500
Message-ID: <20231115203550.710365363@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Juhee Kang <claudiajkang@gmail.com>

[ Upstream commit 4b6c6065fca123d419afef005a696f51e6590470 ]

The open code is defined as a helper function(tp_to_dev) on r8169_main.c,
which the open code is &tp->pci_dev->dev. The helper function was added
in commit 1e1205b7d3e9 ("r8169: add helper tp_to_dev"). And then later,
commit f1e911d5d0df ("r8169: add basic phylib support") added
r8169_phylink_handler function but it didn't use the helper function.
Thus, tp_to_dev() replaces the open code. This patch doesn't change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/20221129161244.5356-1-claudiajkang@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 621735f59064 ("r8169: fix rare issue with broken rx after link-down on RTL8125")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1cd0928472c0c..73bbcb72cf3f0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4656,12 +4656,13 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 static void r8169_phylink_handler(struct net_device *ndev)
 {
 	struct rtl8169_private *tp = netdev_priv(ndev);
+	struct device *d = tp_to_dev(tp);
 
 	if (netif_carrier_ok(ndev)) {
 		rtl_link_chg_patch(tp);
-		pm_request_resume(&tp->pci_dev->dev);
+		pm_request_resume(d);
 	} else {
-		pm_runtime_idle(&tp->pci_dev->dev);
+		pm_runtime_idle(d);
 	}
 
 	if (net_ratelimit())
-- 
2.42.0



