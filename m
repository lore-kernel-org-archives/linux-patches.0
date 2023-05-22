Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F959171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946B1C433EF;
	Mon, 22 May 2023 19:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784297;
	bh=gSfNyj6j0EhvMpAjbxXVOIqg/5v6kOJCFKd6br90XFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2J94HFyqUS/bSOS1O08ohgJ+5I/px8w+QldcvE9snujNfWSGoY51w7mrdGfgvqPm
	 XaEfV9vnKahklIAx/BtMWOcKqGDRNecZjpOM7V/pVtlPNlvlxx7IZMJ6mx08too5v0
	 ED0xjbmpxX9zMDY36cuF+ROg0T+wb1m55mAXprl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@corigine.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 008/364] net: mdio: mvusb: Fix an error handling path in mvusb_mdio_probe()
Date: Mon, 22 May 2023 20:05:13 +0100
Message-Id: <20230522190413.022443806@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 27c1eaa07283b0c94becf8241f95368267cf558b ]

Should of_mdiobus_register() fail, a previous usb_get_dev() call should be
undone as in the .disconnect function.

Fixes: 04e37d92fbed ("net: phy: add marvell usb to mdio controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-mvusb.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mvusb.c b/drivers/net/mdio/mdio-mvusb.c
index 68fc55906e788..554837c21e73c 100644
--- a/drivers/net/mdio/mdio-mvusb.c
+++ b/drivers/net/mdio/mdio-mvusb.c
@@ -67,6 +67,7 @@ static int mvusb_mdio_probe(struct usb_interface *interface,
 	struct device *dev = &interface->dev;
 	struct mvusb_mdio *mvusb;
 	struct mii_bus *mdio;
+	int ret;
 
 	mdio = devm_mdiobus_alloc_size(dev, sizeof(*mvusb));
 	if (!mdio)
@@ -87,7 +88,15 @@ static int mvusb_mdio_probe(struct usb_interface *interface,
 	mdio->write = mvusb_mdio_write;
 
 	usb_set_intfdata(interface, mvusb);
-	return of_mdiobus_register(mdio, dev->of_node);
+	ret = of_mdiobus_register(mdio, dev->of_node);
+	if (ret)
+		goto put_dev;
+
+	return 0;
+
+put_dev:
+	usb_put_dev(mvusb->udev);
+	return ret;
 }
 
 static void mvusb_mdio_disconnect(struct usb_interface *interface)
-- 
2.39.2



