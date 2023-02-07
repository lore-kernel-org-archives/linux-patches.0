Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2203212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC94C433EF;
	Tue,  7 Feb 2023 13:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775046;
	bh=mioz/qpi8BJ3OFa7/gLnj2gJ2G9Cfjkn96jv3tWsk0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPOfq4TP/OvlKbaNnBJ5crRBXIBSQTjqaDATBT/XNl5oU3oJO4TNx1alp/3iP/aRD
	 p0EKeAfCwjj2URo32/gQJL9M1dU42Gmi93DPy+WZ3+udLpwv7l7Jz6AkQDSKq2V8Bu
	 TPTukDsRA9WxIPGROwI3byjVssvIwLU53ylPIp4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/208] can: raw: fix CAN FD frame transmissions over CAN XL devices
Date: Tue,  7 Feb 2023 13:55:34 +0100
Message-Id: <20230207125637.958938165@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 3793301cbaa4a62d83e21f685307da7671f812ab ]

A CAN XL device is always capable to process CAN FD frames. The former
check when sending CAN FD frames relied on the existence of a CAN FD
device and did not check for a CAN XL device that would be correct
too.

With this patch the CAN FD feature is enabled automatically when CAN
XL is switched on - and CAN FD cannot be switch off while CAN XL is
enabled.

This precondition also leads to a clean up and reduction of checks in
the hot path in raw_rcv() and raw_sendmsg(). Some conditions are
reordered to handle simple checks first.

changes since v1: https://lore.kernel.org/all/20230131091012.50553-1-socketcan@hartkopp.net
- fixed typo: devive -> device
changes since v2: https://lore.kernel.org/all/20230131091824.51026-1-socketcan@hartkopp.net/
- reorder checks in if statements to handle simple checks first

Fixes: 626332696d75 ("can: raw: add CAN XL support")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230131105613.55228-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/raw.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index 3eb7d3e2b541..4abab2c3011a 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -132,8 +132,8 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 		return;
 
 	/* make sure to not pass oversized frames to the socket */
-	if ((can_is_canfd_skb(oskb) && !ro->fd_frames && !ro->xl_frames) ||
-	    (can_is_canxl_skb(oskb) && !ro->xl_frames))
+	if ((!ro->fd_frames && can_is_canfd_skb(oskb)) ||
+	    (!ro->xl_frames && can_is_canxl_skb(oskb)))
 		return;
 
 	/* eliminate multiple filter matches for the same skb */
@@ -670,6 +670,11 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		if (copy_from_sockptr(&ro->fd_frames, optval, optlen))
 			return -EFAULT;
 
+		/* Enabling CAN XL includes CAN FD */
+		if (ro->xl_frames && !ro->fd_frames) {
+			ro->fd_frames = ro->xl_frames;
+			return -EINVAL;
+		}
 		break;
 
 	case CAN_RAW_XL_FRAMES:
@@ -679,6 +684,9 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		if (copy_from_sockptr(&ro->xl_frames, optval, optlen))
 			return -EFAULT;
 
+		/* Enabling CAN XL includes CAN FD */
+		if (ro->xl_frames)
+			ro->fd_frames = ro->xl_frames;
 		break;
 
 	case CAN_RAW_JOIN_FILTERS:
@@ -786,6 +794,25 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 	return 0;
 }
 
+static bool raw_bad_txframe(struct raw_sock *ro, struct sk_buff *skb, int mtu)
+{
+	/* Classical CAN -> no checks for flags and device capabilities */
+	if (can_is_can_skb(skb))
+		return false;
+
+	/* CAN FD -> needs to be enabled and a CAN FD or CAN XL device */
+	if (ro->fd_frames && can_is_canfd_skb(skb) &&
+	    (mtu == CANFD_MTU || can_is_canxl_dev_mtu(mtu)))
+		return false;
+
+	/* CAN XL -> needs to be enabled and a CAN XL device */
+	if (ro->xl_frames && can_is_canxl_skb(skb) &&
+	    can_is_canxl_dev_mtu(mtu))
+		return false;
+
+	return true;
+}
+
 static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
@@ -833,20 +860,8 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		goto free_skb;
 
 	err = -EINVAL;
-	if (ro->xl_frames && can_is_canxl_dev_mtu(dev->mtu)) {
-		/* CAN XL, CAN FD and Classical CAN */
-		if (!can_is_canxl_skb(skb) && !can_is_canfd_skb(skb) &&
-		    !can_is_can_skb(skb))
-			goto free_skb;
-	} else if (ro->fd_frames && dev->mtu == CANFD_MTU) {
-		/* CAN FD and Classical CAN */
-		if (!can_is_canfd_skb(skb) && !can_is_can_skb(skb))
-			goto free_skb;
-	} else {
-		/* Classical CAN */
-		if (!can_is_can_skb(skb))
-			goto free_skb;
-	}
+	if (raw_bad_txframe(ro, skb, dev->mtu))
+		goto free_skb;
 
 	sockcm_init(&sockc, sk);
 	if (msg->msg_controllen) {
-- 
2.39.0



