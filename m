Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCDD125AB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2901AC433C0;
	Mon, 26 Jun 2023 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804862;
	bh=IMOzBSATkuH+OIU8aGFy/67obfGFI+Me6NJ7SoB1L84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0EYnTok1TSS5n+R90OegdR3rbk/DTWVPY4nAOLVdTbK0ebamtr3IJxrPlhPjdee9
	 VKByZlTuz4BxU8kCuHZaSwMzCIzl3dU/HXgMEGd2c7mAre+Y8/aKPrXZS/GkVbBXKF
	 v0H+W9OEM6PbeqwGzeaS+zli3NY20ESv+H4yHnk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexander Aring <aahringo@redhat.com>,
	Chen Aotian <chenaotian2@163.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/96] ieee802154: hwsim: Fix possible memory leaks
Date: Mon, 26 Jun 2023 20:11:54 +0200
Message-ID: <20230626180748.577252145@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Aotian <chenaotian2@163.com>

[ Upstream commit a61675294735570daca3779bd1dbb3715f7232bd ]

After replacing e->info, it is necessary to free the old einfo.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Chen Aotian <chenaotian2@163.com>
Link: https://lore.kernel.org/r/20230409022048.61223-1-chenaotian2@163.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 36f1c5aa98fc6..1ab1ba41c4305 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -522,7 +522,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 {
 	struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
-	struct hwsim_edge_info *einfo;
+	struct hwsim_edge_info *einfo, *einfo_old;
 	struct hwsim_phy *phy_v0;
 	struct hwsim_edge *e;
 	u32 v0, v1;
@@ -560,8 +560,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 	list_for_each_entry_rcu(e, &phy_v0->edges, list) {
 		if (e->endpoint->idx == v1) {
 			einfo->lqi = lqi;
-			rcu_assign_pointer(e->info, einfo);
+			einfo_old = rcu_replace_pointer(e->info, einfo,
+							lockdep_is_held(&hwsim_phys_lock));
 			rcu_read_unlock();
+			kfree_rcu(einfo_old, rcu);
 			mutex_unlock(&hwsim_phys_lock);
 			return 0;
 		}
-- 
2.39.2



