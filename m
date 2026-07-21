Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803CE46D2C1;
	Tue, 21 Jul 2026 19:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660858; cv=none; b=lvQ6ymBXapg2C2AeCtASd1vECVPjD6V+hch3Y3autH8DqYCxOrRobge8zrNz/kLhBNIzGUlhKFcaOzCgxfe38c4UlofJNmZIfUIFEaZGV/YkVxIk/l7hk3kJPtxCoHLZ2317N/4AObNRxeke/PsAChN6j9rtubUwnWKu/ZyCf6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660858; c=relaxed/simple;
	bh=0Bog4TsgymlxcHNpW2S+gNR5JBipt4wLYRR/30xGjko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEDUQtfbRfsoKFp9ebACR8SdSAHWpN/uLRO4+b3whx27erI9dJ00Ahrluf0OqktS7c9dv+IDnHEzLGV42up+5ZPUyzVcwkyqmXm3HixajOcmph2hLUWzLWE6fyrzM7eAsq8kx1mVvYATlHvKDnnuaL3gQ1X274oZsC3AgimLOic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYpgve3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYpgve3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2C51F000E9;
	Tue, 21 Jul 2026 19:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660856;
	bh=2uOwrq95BgPTBSt4jLPc0fFmBl1QST3qG5ZuAiReUqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYpgve3effipaqETpYLP4V2hZ+6iDhTTy5+vOhXTiLD5jOdy2GtpnVeVtc2Q1C+VQ
	 r4Lnfljla8gxnv2Q0srnvW5YxM9Wln2YYAgtLDiM6AQs2+iPdZWiO6kJzNlBKxUzvj
	 mHvzsrdInKOERznl9+ulVb+oDd8RoywnETCWSozc=
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
Subject: [PATCH 7.1 1137/2077] ieee802154: Avoid calling WARN_ON() on -ENOMEM in cfg802154_switch_netns()
Date: Tue, 21 Jul 2026 17:13:30 +0200
Message-ID: <20260721152619.639683743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 84d514430e45a5..987c633e2c549f 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -228,8 +228,10 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			continue;
 		wpan_dev->netdev->netns_immutable = false;
 		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
-		if (err)
+		if (err) {
+			WARN_ON(err && err != -ENOMEM);
 			break;
+		}
 		wpan_dev->netdev->netns_immutable = true;
 	}
 
@@ -237,7 +239,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 		goto errout;
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	WARN_ON(err && err != -ENOMEM);
 
 	if (err)
 		goto errout;
@@ -258,7 +260,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 		wpan_dev->netdev->netns_immutable = false;
 		err = dev_change_net_namespace(wpan_dev->netdev, net,
 					       "wpan%d");
-		WARN_ON(err);
+		WARN_ON(err && err != -ENOMEM);
 		wpan_dev->netdev->netns_immutable = true;
 	}
 
-- 
2.53.0



