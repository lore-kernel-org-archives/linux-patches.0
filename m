Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159512FD1DD;
	Tue, 30 Sep 2025 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245746; cv=none; b=HiGfwJjhdlPdqVNxpmYAyuZ5mW42jel6XFrpvNJQ3H9kPdQ5VO4AGzvLlxVE19XkO+EkEK4kyv1JVQEK7RwmTBLO7AFvvsA8JXy7VgGWIOUSdj7qczDWC764rc06lrffYQK6yMwzMI9wfslg5TAO51JYX1PSB+8OHP3L1LI83Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245746; c=relaxed/simple;
	bh=VY92Ty0vo+WkOIAu4HaUYs78Fv/2sVfDhiWFiFpu1IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vd+6YvmtNvZzYbVGayyicf2N6JZutL1Yh4chrNxw273BMHkLWqhEKiYVcqcLXQ1bcyTpjQDyILuD0xrZXI5nn8ri5/YUP/kk0oMXMYCtHtxlf7Z8AE5IWYlwIVE84AqV8GuLwZCGhttOYPSzYi9SugQAT6vLTOqieMfi/PsvBAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdJUXpYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdJUXpYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7783FC4CEF0;
	Tue, 30 Sep 2025 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245746;
	bh=VY92Ty0vo+WkOIAu4HaUYs78Fv/2sVfDhiWFiFpu1IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdJUXpYWPebLkmafOrNE4pRn22vdgT9wS4uvYgOl7vhOfb5N2YeYyfcTN8y4E8Khl
	 J94yRvmwWHnSMqLgMKJyXHEopj6Tv+lll3XAfTKuNmyFKd16IKTuRPuOaZXDNKkC2l
	 37xyr0GtAzukbIOUHXb1I7fYiRaRyWe50wB2fFTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 38/91] can: mcba_usb: populate ndo_change_mtu() to prevent buffer overflow
Date: Tue, 30 Sep 2025 16:47:37 +0200
Message-ID: <20250930143822.751990521@linuxfoundation.org>
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

[ Upstream commit 17c8d794527f01def0d1c8b7dc2d7b8d34fed0e6 ]

Sending an PF_PACKET allows to bypass the CAN framework logic and to
directly reach the xmit() function of a CAN driver. The only check
which is performed by the PF_PACKET framework is to make sure that
skb->len fits the interface's MTU.

Unfortunately, because the mcba_usb driver does not populate its
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

And so, mcba_usb_start_xmit() receives a CAN XL frame which it is not
able to correctly handle and will thus misinterpret it as a CAN frame.

This can result in a buffer overflow. The driver will consume cf->len
as-is with no further checks on these lines:

	usb_msg.dlc = cf->len;

	memcpy(usb_msg.data, cf->data, usb_msg.dlc);

Here, cf->len corresponds to the flags field of the CAN XL frame. In
our previous example, we set canxl_frame->flags to 0xff. Because the
maximum expected length is 8, a buffer overflow of 247 bytes occurs!

Populate net_device_ops->ndo_change_mtu() to ensure that the
interface's MTU can not be set to anything bigger than CAN_MTU. By
fixing the root cause, this prevents the buffer overflow.

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20250918-can-fix-mtu-v1-4-0d1cada9393b@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/mcba_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 47619e9cb0055..ecc489afb8416 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -761,6 +761,7 @@ static const struct net_device_ops mcba_netdev_ops = {
 	.ndo_open = mcba_usb_open,
 	.ndo_stop = mcba_usb_close,
 	.ndo_start_xmit = mcba_usb_start_xmit,
+	.ndo_change_mtu = can_change_mtu,
 };
 
 static const struct ethtool_ops mcba_ethtool_ops = {
-- 
2.51.0



