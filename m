Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8C9255E43;
	Sat, 17 Oct 2026 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259441; cv=none; b=EnlP4DcellbVM5OMAwbcNFmMpVFAB99y8fSX1703wc2mByL2oWEhghVLEJyStnqF4IlQWA74VIk4xSdFu9ArEMzGqA2LsLnYLVFoRtaV1uB8GejjqXb+S0GglETKibuRsTfpvzLk/SvLLtCdUj8fy9S55RKO8AXNrdHzzYPcg2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259441; c=relaxed/simple;
	bh=FnKllbeQHZ1bdgzn8eqX+O/eyg46sVMNDG+E3MIrxvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcR2YSl4T/pJ6zRYbF+oODr+xnhGI6uOc3xymskZlIgxf0VdAd4PSSnq/L9PrCr+uVzkhGP+zgiL0qRktQludTHLssUsXQXonUsn9bgL4Qd4gTQYIYSXRTXCIjKCHlHkMHcWCZ6RrIGFswZlC/+zsguoQ0rND2ngeyAoz+IULhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeZu6wsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeZu6wsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4623A1F000C4;
	Sat, 17 Oct 2026 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259440;
	bh=gd5uU9jLhM9nwI3H6exB6/xl91ICXR/dC4mPqnjbQOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UeZu6wsEkI5Nm8YRMOMn1mEcKua4td1ULIW+MKYHXOGbKh2W80Xaa7HfXuhyf74wF
	 fHxR/ZQ43d8LsLz/Xirmd5yo9tgmKYTneORX3Dp9gWoX+PufyXz3ymYOz245qhZ4Q4
	 GJvDdaAeR4DbLe7+yEPqR1UaqqENcxYXcfFuKaPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e0bd4e4815a910c0daa8@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1215/1674] ieee802154: Avoid calling WARN_ON() on -ENOMEM in cfg802154_switch_netns()
Date: Sat, 17 Oct 2026 17:58:07 +0200
Message-ID: <20261017160502.328164127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 0569f67ed6a7af838e2141da93c68e6b6013f483 ]

It's pointless to call WARN_ON() in case of an allocation failure in
dev_change_net_namespace() and device_rename(), since it only leads to
useless splats caused by deliberate fault injections, so avoid it.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
Reported-by: syzbot+e0bd4e4815a910c0daa8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/000000000000f4a1b7061f9421de@google.com/#t
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://lore.kernel.org/20250403101935.991385-3-i.abramov@mt-integration.ru
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index cdf4b41c54b2b..73744459e5e08 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -209,8 +209,10 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			continue;
 		wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
-		if (err)
+		if (err) {
+			WARN_ON(err && err != -ENOMEM);
 			break;
+		}
 		wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
 	}
 
@@ -226,7 +228,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
-			WARN_ON(err);
+			WARN_ON(err && err != -ENOMEM);
 			wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
 		}
 
@@ -236,7 +238,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	wpan_phy_net_set(&rdev->wpan_phy, net);
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	WARN_ON(err && err != -ENOMEM);
 
 	return 0;
 }
-- 
2.53.0



