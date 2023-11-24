Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87502E84A;
	Fri, 24 Nov 2023 18:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GH/bX+y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5832AC433C8;
	Fri, 24 Nov 2023 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852332;
	bh=ej3dpNEkAgs8hwHNzoelikn9ASslGVnidrocCCa0jWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GH/bX+y7J232qTs06qTved2u8fFLOfyxly3wfP7WbxOruVi++926N0emZb5wIiQ9C
	 kQMwr6EcGF4s5nUJFaMvanMthU97a/7dvqmg0bov0mrnaRo8i6Py3ITsOSW/91LQ6d
	 e1O5uJga9fdS4AlrgPsGCvirrqXKdvpxjF3AiXH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 314/372] net: phylink: initialize carrier state at creation
Date: Fri, 24 Nov 2023 17:51:41 +0000
Message-ID: <20231124172020.856951234@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1479,6 +1479,7 @@ struct phylink *phylink_create(struct ph
 	pl->config = config;
 	if (config->type == PHYLINK_NETDEV) {
 		pl->netdev = to_net_dev(config->dev);
+		netif_carrier_off(pl->netdev);
 	} else if (config->type == PHYLINK_DEV) {
 		pl->dev = config->dev;
 	} else {


