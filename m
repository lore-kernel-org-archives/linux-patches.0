Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8586651AEC1;
	Wed, 30 Sep 2026 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789324; cv=none; b=gCVzhq0uMlGkUsbXqkljQXOo0oh7PXVQRQMLhrG9fYz7wqy/9cVxsfLjlTVFA9BIn7zdMFICvm9p8x7bdK/l7N53Jrp8a85LnUpPnPyueBNlAXEfqqRmbyIYjYOc0fi1mXkjVHzfZE7ZVdiV2lFexOIY1rp702SP+JPFTuwHAss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789324; c=relaxed/simple;
	bh=6ShwQMrj94gcN8OslvSJ0JLpruxA0KbAHndcOGCbsOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ylou7taNH6pKHiMYOHwVgnPEUTsnoo98APJX4p96PZm/SL7RZvoKhX+v+brV5Vx+aSpEC1ponxWNGd1HUsfR5PFjhnJnmZ0oTsyLZF8LYc/Iaj14U5LiBlHXUG4BDyTQBrewu+hWVgrskwgAn/P6l5C2sWOrkEQIFZk5ark7Hqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIJc5S2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIJc5S2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED931F000FF;
	Wed, 30 Sep 2026 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789323;
	bh=yWeCk0YmdxH2LLty7aubKMnfFJNMkkYE5xmbsBk8SNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIJc5S2TbeUsldvPAtr20AWQmzvWb23uH6FHJfnzCWetfg6FCqHjz30SvSJ71NZ0M
	 xrui7vcmEvDa5IZUy+lFY/ocf2dMtw2zdOhp4RBY0AKTQPHm/Id3sJRQrcVyEsV6ZP
	 RxOWR8W30Lb0j/z8XtZLwWgu21uTA1mFIwqWjzOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 436/877] macsec: inherit lower devices TSO limits when offloading
Date: Wed, 30 Sep 2026 17:22:27 +0200
Message-ID: <20260930152424.092713670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit de187a390838c0b3dfd00ae5399aa406d0a79f13 ]

If macsec is offloaded, we need to follow the lower device's
capabilities, like VLAN devices do.

Leave the limits unchanged when the offload is disabled.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/8240c0181e851f169d815f59658a01fb9dfc5073.1730929545.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c2de369c5c5b ("macsec: initialize SecY before registering the netdevice")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index b1eb6b5dde0fe..ce4a08f77724f 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2650,6 +2650,17 @@ static void macsec_set_head_tail_room(struct net_device *dev)
 	dev->needed_tailroom = real_dev->needed_tailroom + needed_tailroom;
 }
 
+static void macsec_inherit_tso_max(struct net_device *dev)
+{
+	struct macsec_dev *macsec = macsec_priv(dev);
+
+	/* if macsec is offloaded, we need to follow the lower
+	 * device's capabilities. otherwise, we can ignore them.
+	 */
+	if (macsec_is_offloaded(macsec))
+		netif_inherit_tso_max(dev, macsec->real_dev);
+}
+
 static int macsec_update_offload(struct net_device *dev, enum macsec_offload offload)
 {
 	enum macsec_offload prev_offload;
@@ -2695,6 +2706,8 @@ static int macsec_update_offload(struct net_device *dev, enum macsec_offload off
 	macsec_set_head_tail_room(dev);
 	macsec->insert_tx_tag = macsec_needs_tx_tag(macsec, ops);
 
+	macsec_inherit_tso_max(dev);
+
 	netdev_update_features(dev);
 
 	return ret;
@@ -3566,6 +3579,8 @@ static int macsec_dev_init(struct net_device *dev)
 	if (err)
 		return err;
 
+	macsec_inherit_tso_max(dev);
+
 	dev->hw_features = real_dev->hw_features & MACSEC_OFFLOAD_FEATURES;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 
@@ -4521,6 +4536,13 @@ static int macsec_notify(struct notifier_block *this, unsigned long event,
 			if (dev->mtu > mtu)
 				dev_set_mtu(dev, mtu);
 		}
+		break;
+	case NETDEV_FEAT_CHANGE:
+		list_for_each_entry(m, &rxd->secys, secys) {
+			macsec_inherit_tso_max(m->secy.netdev);
+			netdev_update_features(m->secy.netdev);
+		}
+		break;
 	}
 	}
 
-- 
2.53.0



