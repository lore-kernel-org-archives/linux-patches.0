Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429B11A71D
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfWbHbb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA20CC433C8;
	Mon,  6 Nov 2023 13:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277689;
	bh=GRuFo+bmJwhH46SmB8wvHc/qkxxZPkAnOMWs5MKp4C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfWbHbb/ZEatDt6P/gmxpQFvwnfxheaGnjFvl550jwjqK0QUy7O+TixxDXjvcTJxa
	 vRB8Wveb03DZsNwlrL4NXKNe0W3t3rODUoDODV43z1tpHAHch3NUPypEG8UGIc751e
	 hE3pTt1PEcCUThdzuvr86OuQukA6SUhOybC+l5sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Oliver Hartkopp" <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH 5.10 86/95] can: isotp: isotp_bind(): do not validate unused address information
Date: Mon,  6 Nov 2023 14:04:54 +0100
Message-ID: <20231106130307.849829236@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit b76b163f46b661499921a0049982764a6659bfe7 upstream

With commit 2aa39889c463 ("can: isotp: isotp_bind(): return -EINVAL on
incorrect CAN ID formatting") the bind() syscall returns -EINVAL when
the given CAN ID needed to be sanitized. But in the case of an unconfirmed
broadcast mode the rx CAN ID is not needed and may be uninitialized from
the caller - which is ok.

This patch makes sure the result of an inproper CAN ID format is only
provided when the address information is needed.

Link: https://lore.kernel.org/all/20220517145653.2556-1-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1216,7 +1216,8 @@ static int isotp_bind(struct socket *soc
 	struct net *net = sock_net(sk);
 	int ifindex;
 	struct net_device *dev;
-	canid_t tx_id, rx_id;
+	canid_t tx_id = addr->can_addr.tp.tx_id;
+	canid_t rx_id = addr->can_addr.tp.rx_id;
 	int err = 0;
 	int notify_enetdown = 0;
 
@@ -1226,24 +1227,28 @@ static int isotp_bind(struct socket *soc
 	if (addr->can_family != AF_CAN)
 		return -EINVAL;
 
-	/* sanitize tx/rx CAN identifiers */
-	tx_id = addr->can_addr.tp.tx_id;
+	/* sanitize tx CAN identifier */
 	if (tx_id & CAN_EFF_FLAG)
 		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
 	else
 		tx_id &= CAN_SFF_MASK;
 
-	rx_id = addr->can_addr.tp.rx_id;
-	if (rx_id & CAN_EFF_FLAG)
-		rx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
-	else
-		rx_id &= CAN_SFF_MASK;
-
-	/* give feedback on wrong CAN-ID values */
-	if (tx_id != addr->can_addr.tp.tx_id ||
-	    rx_id != addr->can_addr.tp.rx_id)
+	/* give feedback on wrong CAN-ID value */
+	if (tx_id != addr->can_addr.tp.tx_id)
 		return -EINVAL;
 
+	/* sanitize rx CAN identifier (if needed) */
+	if (isotp_register_rxid(so)) {
+		if (rx_id & CAN_EFF_FLAG)
+			rx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
+		else
+			rx_id &= CAN_SFF_MASK;
+
+		/* give feedback on wrong CAN-ID value */
+		if (rx_id != addr->can_addr.tp.rx_id)
+			return -EINVAL;
+	}
+
 	if (!addr->can_ifindex)
 		return -ENODEV;
 


