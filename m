Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F078C42EEA2;
	Tue, 21 Jul 2026 19:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660855; cv=none; b=LqOIaV6MAoIqheKDiXNszLvk1NyCIVU6KyJuCB5OtVp+mu78EIjk2HmbOFqs3Az6z0MYKorkOJuteWcF0b0klXvg33rFViWovlejPAayl7B482w59sv3hhUGTzBQkBFhLQSkA2pyKgJ2G9HQP0O56cJngPc1D8IcyoUCLICn3V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660855; c=relaxed/simple;
	bh=FGJYSPoNsnfn316Qjda1FvpNcptweNKPjLfhgpk4sV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVluAXZZ0e8+Hik4cMLQhpPxHhuMIuGoNbeFVGgF3W3bzevw2KN+L8wJKBZGJ0FRo7f7jInNP8k/6INmY1QwNf7aPN92He1BVBsQlW4dXGfURcXwlWpEa+lvhgkKiTx89yEXnjvBqdefL5xHhetpnvEfbIaeGTANSbOMZy6RsFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhftLCaE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhftLCaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5494B1F000E9;
	Tue, 21 Jul 2026 19:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660853;
	bh=Uf3BYJyLQ86HniG1prQR+9d2WUWrz0gNfanLFEF0dKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhftLCaEE4RPNHUsXSbx0trhqQa1QS336tlJrkYC2ydqAU6vbSuhima3sRq4tn0sr
	 sJUhmL99hwGq+3vILRw/HWGZL4AO8wwDH+mqCQgBXrGst0qZP4vPMHdilxDdQOmlqL
	 GS8X5/J39uIbk/g2BuRQ/Z3RBi5MY/J92D3rP1bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1136/2077] ieee802154: Restore initial state on failed device_rename() in cfg802154_switch_netns()
Date: Tue, 21 Jul 2026 17:13:29 +0200
Message-ID: <20260721152619.615311896@linuxfoundation.org>
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

[ Upstream commit a2e06b4bef20b59446d5088e938c2be53cc4e6c6 ]

Currently, the return value of device_rename() is not acted upon.

To avoid an inconsistent state in case of failure, roll back the changes
made before the device_rename() call.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://lore.kernel.org/20250403101935.991385-2-i.abramov@mt-integration.ru
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/core.c | 45 ++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 89b671b12600f2..84d514430e45a5 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -233,31 +233,36 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 		wpan_dev->netdev->netns_immutable = true;
 	}
 
-	if (err) {
-		/* failed -- clean up to old netns */
-		net = wpan_phy_net(&rdev->wpan_phy);
-
-		list_for_each_entry_continue_reverse(wpan_dev,
-						     &rdev->wpan_dev_list,
-						     list) {
-			if (!wpan_dev->netdev)
-				continue;
-			wpan_dev->netdev->netns_immutable = false;
-			err = dev_change_net_namespace(wpan_dev->netdev, net,
-						       "wpan%d");
-			WARN_ON(err);
-			wpan_dev->netdev->netns_immutable = true;
-		}
-
-		return err;
-	}
-
-	wpan_phy_net_set(&rdev->wpan_phy, net);
+	if (err)
+		goto errout;
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
 	WARN_ON(err);
 
+	if (err)
+		goto errout;
+
+	wpan_phy_net_set(&rdev->wpan_phy, net);
+
 	return 0;
+
+errout:
+	/* failed -- clean up to old netns */
+	net = wpan_phy_net(&rdev->wpan_phy);
+
+	list_for_each_entry_continue_reverse(wpan_dev,
+					     &rdev->wpan_dev_list,
+					     list) {
+		if (!wpan_dev->netdev)
+			continue;
+		wpan_dev->netdev->netns_immutable = false;
+		err = dev_change_net_namespace(wpan_dev->netdev, net,
+					       "wpan%d");
+		WARN_ON(err);
+		wpan_dev->netdev->netns_immutable = true;
+	}
+
+	return err;
 }
 
 void cfg802154_dev_free(struct cfg802154_registered_device *rdev)
-- 
2.53.0



