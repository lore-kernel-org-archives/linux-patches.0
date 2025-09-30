Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4241B3C465;
	Tue, 30 Sep 2025 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246069; cv=none; b=qi3Dyt0lvyc8XrYMRLoq2htzMe/JsBjytmoSFdupqcmYfoaI/Ui/VQDucxChG/GhAjp5ajTHPzNbsp3fIfTYUemxgjOvOSD8SKWbn19gjC1arlIptWRzbufBI0FTpqRPCH0gJ98R+UGqodGCda/xPpvaMU3Jrv/vARXOSm7SNNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246069; c=relaxed/simple;
	bh=J2meybfbKLzo+eD+vmXtmWyuXDX/pfqsvi/E1kVzYTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDKb9LKUar/IAAZ+B8VLvGSL4vnbx3nPUpEyWgPLSnJ1IAmVIfujuzb6oJSVqYhH58rKeNN9sdNgwZgFRUiNAJEGTlOcC9+nWKCEjFVI/8zx4MDwQgngj6R9l7bFObgmkNwoJd7gq6+OOhvUKhmdrzh5TDfaApMkFllFsY3teOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlGaxqEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlGaxqEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A519EC4CEF0;
	Tue, 30 Sep 2025 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246069;
	bh=J2meybfbKLzo+eD+vmXtmWyuXDX/pfqsvi/E1kVzYTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlGaxqEJXemn6nH6SxDJ76S5SQ6HEjvo2cdClrJwIC5qhVvaKxs9pMpaADxzo9N8L
	 +gG+nDDgOa/W+LCJMsNwAwkFvoX7ETtn9V/apKe7GGGiQgveNQhBqE386BMPrvV6DI
	 aK8n7o+xkyXPCO0mHHX4yvCGgII1oWaXFZNgiIZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 43/89] can: mcba_usb: populate ndo_change_mtu() to prevent buffer overflow
Date: Tue, 30 Sep 2025 16:47:57 +0200
Message-ID: <20250930143823.704974369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 41c0a1c399bf3..1f9b915094e64 100644
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



