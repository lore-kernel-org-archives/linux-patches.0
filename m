Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FC8339BE;
	Fri, 24 Nov 2023 19:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3A3sUVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A813EC433C9;
	Fri, 24 Nov 2023 19:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852985;
	bh=BgyvIlohnO1wme7nnxIBDzIX6trc760T80A1goMxzts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3A3sUVHwHQZglctWHpPnSgKnphnmQrkKfpIEtik3BYLU3y/ZoeKHeN66W1cSs0a0
	 /oEEoB44J8dmAVeSS+WpbrcW/hpVxa4Hz/iy+tgeshRLCFW08U/9jZW9Ouw3l4gf0I
	 3OA1158hhfPxPt4+vOzMBcbrDDA+fp+utPMgJo0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 167/193] net: phylink: initialize carrier state at creation
Date: Fri, 24 Nov 2023 17:54:54 +0000
Message-ID: <20231124171953.860314850@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Klaus Kudielka <klaus.kudielka@gmail.com>

commit 02d5fdbf4f2b8c406f7a4c98fa52aa181a11d733 upstream.

Background: Turris Omnia (Armada 385); eth2 (mvneta) connected to SFP bus;
SFP module is present, but no fiber connected, so definitely no carrier.

After booting, eth2 is down, but netdev LED trigger surprisingly reports
link active. Then, after "ip link set eth2 up", the link indicator goes
away - as I would have expected it from the beginning.

It turns out, that the default carrier state after netdev creation is
"carrier ok". Some ethernet drivers explicitly call netif_carrier_off
during probing, others (like mvneta) don't - which explains the current
behaviour: only when the device is brought up, phylink_start calls
netif_carrier_off.

Fix this for all drivers using phylink, by calling netif_carrier_off in
phylink_create.

Fixes: 089381b27abe ("leds: initial support for Turris Omnia LEDs")
Cc: stable@vger.kernel.org
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -838,6 +838,7 @@ struct phylink *phylink_create(struct ph
 	pl->config = config;
 	if (config->type == PHYLINK_NETDEV) {
 		pl->netdev = to_net_dev(config->dev);
+		netif_carrier_off(pl->netdev);
 	} else if (config->type == PHYLINK_DEV) {
 		pl->dev = config->dev;
 	} else {


