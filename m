Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D928ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894DAC433EF;
	Mon, 12 Dec 2022 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852768;
	bh=Cl1GeB9WtY5pbsG0CurJhuAQ0LRtuVzB86m37uuEl7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRkaf140C/zr3NQaX3jDY2BR7jUwSMcnOGB5a77L+FT3U6/2KhV+/vPcSXwskSfx5
	 yxran6vlQMHgE4hNYIjs2SVtUE9r8wkl+wG4toE5mCA4QTs8NY6K4KySaw7EN8uDbN
	 pAjmx3ZB7a807hGddNPpIhw6IoZjTb99Fob6YT3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 120/157] net: mdiobus: fix double put fwnode in the error path
Date: Mon, 12 Dec 2022 14:17:48 +0100
Message-Id: <20221212130939.677649720@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 165df24186ecea95705505627df3dacf5e7ff6bf ]

If phy_device_register() or fwnode_mdiobus_phy_device_register()
fail, phy_device_free() is called, the device refcount is decreased
to 0, then fwnode_handle_put() will be called in phy_device_release(),
but in the error path, fwnode_handle_put() has already been called,
so set fwnode to NULL after fwnode_handle_put() in the error path to
avoid double put.

Fixes: cdde1560118f ("net: mdiobus: fix unbalanced node reference count")
Reported-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/fwnode_mdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 403b07f8ec2c..2c47efdae73b 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -77,6 +77,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	 */
 	rc = phy_device_register(phy);
 	if (rc) {
+		device_set_node(&phy->mdio.dev, NULL);
 		fwnode_handle_put(child);
 		return rc;
 	}
@@ -125,7 +126,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
 		if (rc) {
-			fwnode_handle_put(phy->mdio.dev.fwnode);
+			phy->mdio.dev.fwnode = NULL;
+			fwnode_handle_put(child);
 			goto clean_phy;
 		}
 	} else if (is_of_node(child)) {
-- 
2.35.1



