Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DF5217F55;
	Tue, 30 Sep 2025 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244717; cv=none; b=dUk0dfgXrDdxZojH/VXGMWqN/juV8N8+WH7dlYN854VFDJqFACj6h/DU9+Jth+RSt6qj5PrS30EZAX7mTP+hODRbedwS0BKzdxv2GYJQk5QDGCsW3NeNFfTkBYlDGUF2t8xE+YC0kwHI2/RVgxH1YE+v6jMShgaQqKFLjJRSf+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244717; c=relaxed/simple;
	bh=m/76tXDQXTUkpmgvjOrFKXH966epagIzfFY3mzJyFoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxScwE6sWls0wJKtj6JYnUmZgmSGuM3CNu5MB0nadHRwkJQhS9+7gJxIOisoe+nqDcUe0nCPEQt6z/EOevz+mZZOx8MrdT0Fk6FYJDP9Rd7kvwuxlqEkYupqKf2/zbQPIioEWWIKflBcJMumrBj2Zseal5Aw542eWwBnfFEaRtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ID3vUiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ID3vUiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB81AC4CEF0;
	Tue, 30 Sep 2025 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244716;
	bh=m/76tXDQXTUkpmgvjOrFKXH966epagIzfFY3mzJyFoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ID3vUiT4GJuAfNyaucYMnkxtw3seY3w4rDvzF8O5+Fuf+mplv0cwiqHLDDlxzjFf
	 z5OnlP7X42KVwTlXy0DfOkBrUQ4vNmQjj56wzpJDDINqCocMV3pn1qJHlnu+ASGtRD
	 DhqYrdCGv8yY4AHC7SbYhMbNitLueetzYeu9KW9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 060/143] can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow
Date: Tue, 30 Sep 2025 16:46:24 +0200
Message-ID: <20250930143833.622721021@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol@kernel.org>

[ Upstream commit 38c0abad45b190a30d8284a37264d2127a6ec303 ]

Sending an PF_PACKET allows to bypass the CAN framework logic and to
directly reach the xmit() function of a CAN driver. The only check
which is performed by the PF_PACKET framework is to make sure that
skb->len fits the interface's MTU.

Unfortunately, because the etas_es58x driver does not populate its
net_device_ops->ndo_change_mtu(), it is possible for an attacker to
configure an invalid MTU by doing, for example:

  $ ip link set can0 mtu 9999

After doing so, the attacker could open a PF_PACKET socket using the
ETH_P_CANXL protocol:

	socket(PF_PACKET, SOCK_RAW, htons(ETH_P_CANXL));

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

And so, es58x_start_xmit() receives a CAN XL frame which it is not
able to correctly handle and will thus misinterpret it as a CAN(FD)
frame.

This can result in a buffer overflow. For example, using the es581.4
variant, the frame will be dispatched to es581_4_tx_can_msg(), go
through the last check at the beginning of this function:

	if (can_is_canfd_skb(skb))
		return -EMSGSIZE;

and reach this line:

	memcpy(tx_can_msg->data, cf->data, cf->len);

Here, cf->len corresponds to the flags field of the CAN XL frame. In
our previous example, we set canxl_frame->flags to 0xff. Because the
maximum expected length is 8, a buffer overflow of 247 bytes occurs!

Populate net_device_ops->ndo_change_mtu() to ensure that the
interface's MTU can not be set to anything bigger than CAN_MTU or
CANFD_MTU (depending on the device capabilities). By fixing the root
cause, this prevents the buffer overflow.

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20250918-can-fix-mtu-v1-1-0d1cada9393b@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index db1acf6d504cf..adc91873c083f 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -7,7 +7,7 @@
  *
  * Copyright (c) 2019 Robert Bosch Engineering and Business Solutions. All rights reserved.
  * Copyright (c) 2020 ETAS K.K.. All rights reserved.
- * Copyright (c) 2020-2022 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ * Copyright (c) 2020-2025 Vincent Mailhol <mailhol@kernel.org>
  */
 
 #include <linux/unaligned.h>
@@ -1977,6 +1977,7 @@ static const struct net_device_ops es58x_netdev_ops = {
 	.ndo_stop = es58x_stop,
 	.ndo_start_xmit = es58x_start_xmit,
 	.ndo_eth_ioctl = can_eth_ioctl_hwts,
+	.ndo_change_mtu = can_change_mtu,
 };
 
 static const struct ethtool_ops es58x_ethtool_ops = {
-- 
2.51.0



