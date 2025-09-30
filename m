Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16FA846F;
	Tue, 30 Sep 2025 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245740; cv=none; b=ONWu1+K6Ce31btuUJ9Z973jefQDEYQsrXVSlQcP0bUyuBopLvjoIp54rfBurOJArVxjAumS4a/yCuojTiUgiE8y++rKy8hmc3DvIvyIPdEjVvGVnNg4LDzdaJ6ao+Xn/7MAHMeBsZhtXmBDQz7EeSbU2/FH7U5cH+38bVFZy8Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245740; c=relaxed/simple;
	bh=e3HjIcHh6FWv+7LJ3Mc/8PZjAmhy0kHu2gNiyMUeCTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr+BUiGNtul0JusxSkQ+00nj+BocfrgajiqE3OTrjyL7+xktK3mueWXJVQ0IcO3qAocd8C3sbI9OPVrrLiHZtflADTzmSopS2BTJ5Dj8KSswDDQNPq0dWBWUB7ebFHmp5Imya+OvQ7zgNbYfhY2WNVdGWCzESqHaCspg20Wy4KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10G57EZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10G57EZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5553C4CEF0;
	Tue, 30 Sep 2025 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245739;
	bh=e3HjIcHh6FWv+7LJ3Mc/8PZjAmhy0kHu2gNiyMUeCTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10G57EZcHvYF4UYVK4ZCkYazIJOHVa7nYKPrIYs5NioxZ7OKnXWaaJxTDJiqffGKo
	 99S71Zk4MtPjYK0QTRFel1AxkCEMWytUgta86Qsdpo8iXwrEpwxorbknTiKf40Z9oA
	 D0+ZvunJ8/neR4cwUqFW1E/61dvBySDgXeo1BBTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/91] can: hi311x: populate ndo_change_mtu() to prevent buffer overflow
Date: Tue, 30 Sep 2025 16:47:35 +0200
Message-ID: <20250930143822.662917494@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol@kernel.org>

[ Upstream commit ac1c7656fa717f29fac3ea073af63f0b9919ec9a ]

Sending an PF_PACKET allows to bypass the CAN framework logic and to
directly reach the xmit() function of a CAN driver. The only check
which is performed by the PF_PACKET framework is to make sure that
skb->len fits the interface's MTU.

Unfortunately, because the sun4i_can driver does not populate its
net_device_ops->ndo_change_mtu(), it is possible for an attacker to
configure an invalid MTU by doing, for example:

  $ ip link set can0 mtu 9999

After doing so, the attacker could open a PF_PACKET socket using the
ETH_P_CANXL protocol:

	socket(PF_PACKET, SOCK_RAW, htons(ETH_P_CANXL))

to inject a malicious CAN XL frames. For example:

	struct canxl_frame frame = {
		.flags = 0xff,
		.len = 2048,
	};

The CAN drivers' xmit() function are calling can_dev_dropped_skb() to
check that the skb is valid, unfortunately under above conditions, the
malicious packet is able to go through can_dev_dropped_skb() checks:

  1. the skb->protocol is set to ETH_P_CANXL which is valid (the
     function does not check the actual device capabilities).

  2. the length is a valid CAN XL length.

And so, hi3110_hard_start_xmit() receives a CAN XL frame which it is
not able to correctly handle and will thus misinterpret it as a CAN
frame. The driver will consume frame->len as-is with no further
checks.

This can result in a buffer overflow later on in hi3110_hw_tx() on
this line:

	memcpy(buf + HI3110_FIFO_EXT_DATA_OFF,
	       frame->data, frame->len);

Here, frame->len corresponds to the flags field of the CAN XL frame.
In our previous example, we set canxl_frame->flags to 0xff. Because
the maximum expected length is 8, a buffer overflow of 247 bytes
occurs!

Populate net_device_ops->ndo_change_mtu() to ensure that the
interface's MTU can not be set to anything bigger than CAN_MTU. By
fixing the root cause, this prevents the buffer overflow.

Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20250918-can-fix-mtu-v1-2-0d1cada9393b@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index b757555ed4c4f..57ea7dfe8a596 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -813,6 +813,7 @@ static const struct net_device_ops hi3110_netdev_ops = {
 	.ndo_open = hi3110_open,
 	.ndo_stop = hi3110_stop,
 	.ndo_start_xmit = hi3110_hard_start_xmit,
+	.ndo_change_mtu = can_change_mtu,
 };
 
 static const struct ethtool_ops hi3110_ethtool_ops = {
-- 
2.51.0



