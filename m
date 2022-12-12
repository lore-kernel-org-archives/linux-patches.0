Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9663928ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9963C433EF;
	Mon, 12 Dec 2022 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851944;
	bh=7+Amo6AetWv4l/+1najv7082ykulzXDYpCMqMg365wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFYI6Mfe7jdztyxRv/VS8vqGyMcqJxSB+5bB1wMYco3noE3APHxprqQIxVqeGK0I6
	 +Oj9ZE4doG/j/nDgzSzGK3OaUAmvy4KV6JzdlPye1jmwgbIh48V87rREVEZkX3Qg+C
	 vudrSVkUaYhypNvtFp5uXRWhIq/9wZpG8Res/cK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/123] net: mdio: fix unbalanced fwnode reference count in mdio_device_release()
Date: Mon, 12 Dec 2022 14:17:48 +0100
Message-Id: <20221212130931.485791372@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit cb37617687f2bfa5b675df7779f869147c9002bd ]

There is warning report about of_node refcount leak
while probing mdio device:

OF: ERROR: memory leak, expected refcount 1 instead of 2,
of_node_get()/of_node_put() unbalanced - destroy cset entry:
attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4

In of_mdiobus_register_device(), we increase fwnode refcount
by fwnode_handle_get() before associating the of_node with
mdio device, but it has never been decreased in normal path.
Since that, in mdio_device_release(), it needs to call
fwnode_handle_put() in addition instead of calling kfree()
directly.

After above, just calling mdio_device_free() in the error handle
path of of_mdiobus_register_device() is enough to keep the
refcount balanced.

Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20221203073441.3885317-1-zengheng4@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/of_mdio.c    | 3 ++-
 drivers/net/phy/mdio_device.c | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 796e9c7857d0..510822d6d0d9 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -68,8 +68,9 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	/* All data is now stored in the mdiodev struct; register it. */
 	rc = mdio_device_register(mdiodev);
 	if (rc) {
+		device_set_node(&mdiodev->dev, NULL);
+		fwnode_handle_put(fwnode);
 		mdio_device_free(mdiodev);
-		of_node_put(child);
 		return rc;
 	}
 
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 250742ffdfd9..044828d081d2 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/unistd.h>
+#include <linux/property.h>
 
 void mdio_device_free(struct mdio_device *mdiodev)
 {
@@ -30,6 +31,7 @@ EXPORT_SYMBOL(mdio_device_free);
 
 static void mdio_device_release(struct device *dev)
 {
+	fwnode_handle_put(dev->fwnode);
 	kfree(to_mdio_device(dev));
 }
 
-- 
2.35.1



