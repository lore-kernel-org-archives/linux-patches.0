Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71618F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C413C433C8;
	Sun, 16 Jul 2023 20:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539335;
	bh=01jCrS5B+z6Nw4qJZ5yxfHzFJ9JmhhnKwbAGUAnjkPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkZCFL1M1rt0lJ7iDPD8saceCsjHtoWTLvqpm3rh3LLJHB13/ZCh3Efpo//vY7zcm
	 iKa19C+NPrz3efB7C/Kc5puWN2QmhwuL9sfcq93p+eCslijqv9qy+jW/hRrx3BZJyY
	 4kS+/a9e75ST3JdugPqxG9/2U7WNRcYAYfme2Cpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.4 772/800] leds: trigger: netdev: Recheck NETDEV_LED_MODE_LINKUP on dev rename
Date: Sun, 16 Jul 2023 21:50:25 +0200
Message-ID: <20230716195007.080179743@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

commit cee4bd16c3195a701be683f7da9e88c6e11acb73 upstream.

Dev can be renamed also while up for supported device. We currently
wrongly clear the NETDEV_LED_MODE_LINKUP flag on NETDEV_CHANGENAME
event.

Fix this by rechecking if the carrier is ok on NETDEV_CHANGENAME and
correctly set the NETDEV_LED_MODE_LINKUP bit.

Fixes: 5f820ed52371 ("leds: trigger: netdev: fix handling on interface rename")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230419210743.3594-2-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/trigger/ledtrig-netdev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -318,6 +318,9 @@ static int netdev_trig_notify(struct not
 	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
 	switch (evt) {
 	case NETDEV_CHANGENAME:
+		if (netif_carrier_ok(dev))
+			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+		fallthrough;
 	case NETDEV_REGISTER:
 		if (trigger_data->net_dev)
 			dev_put(trigger_data->net_dev);


