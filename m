Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52315471273;
	Tue, 21 Jul 2026 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657604; cv=none; b=X2/MiPWrP7oljvsxvXXiTcb9lDuyZN9qeFz8jN6olyOYaG3QQkWvF3bGLx5spIfG4s4VBqh4ssKMlaUbDJF9l9KKAkPa0Q/mMpu8SmZbK8ij0QunHZ0vmBT1hciLFycQIkBQ92lPgYT2mUMO3ck1shfptf67Pxv9tqB1FJnYViE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657604; c=relaxed/simple;
	bh=u4LfZICzaYYLsRig7fL/89jZ4dvZiGswAB5fcT+JxGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3UXwkq3R2+baBk977AEfVTJR19ObsrRzjdEsJUPSnxDc9uou0e4TFQCUzRitv9DfCC3MPzpgpFCTWoPAf3osXZWmCSpIxGSknN/NEi7whWnDRn3v+o+swCeBIzDEpTWSxM/ubGzH4bItPf985KuN62mlAMBdZBt/0Cpuiu0aRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxjrVqSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxjrVqSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33E51F000E9;
	Tue, 21 Jul 2026 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657603;
	bh=1nz/Cj7waumUgSJaxs3huVfifFWAZS7+nD2Dj4e4/5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxjrVqSATNlLGH2V8+2Pu81JYajkhplms0Ch+4Ja872d4516ZyflLqYhGa7mapcNj
	 t2jRv9lYt8lP7DAzRgSLnxaf0OkwnMeHwRUNfeWR29cHUkn0ppCHffcopofANGCn3c
	 OpzcYj3M3qT377FV+T7phLm8Ji7yGgytgGESa2TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0826/1611] ieee802154: Restore initial state on failed device_rename() in cfg802154_switch_netns()
Date: Tue, 21 Jul 2026 17:15:42 +0200
Message-ID: <20260721152533.967518581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



