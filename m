Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B921EE02F;
	Tue, 30 Sep 2025 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244614; cv=none; b=cNjSrP8n0KncmoCszFACCm17gJLStkLvBR+Kb0q0I+4MbQPu8AHCWQxlLk8P44lUy0SaQ9umJuixvFnrw7OwsGzMaRtGc4qBqJ3KGUfrfGeeNXcPqod0UgtiaAtC/01hjTiQV0d4cwuyRrhBwinbln159gpx4sMGyoWhvPeWQ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244614; c=relaxed/simple;
	bh=10BxeJ3y0dL4zRL2EUljyWw0CwcB5661Kx0WS8FOk10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8NNUWj2G2GaWE/U0pfVW3R6/6zMZ6D3kaBV7gvRXboRECkICLDmuA95a089nfkwwbLGExhuoYZpmFa5/iv4+GEM6eRExHgMf6PQUQn1b+Ex0g06ZyWGC+n1V1XBGYEysh8wmA1tMxKQh7Z1FN4sR5jK7j4GExFrfZ8fvgnAlO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8DFM3sU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8DFM3sU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCEDC4CEF0;
	Tue, 30 Sep 2025 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244614;
	bh=10BxeJ3y0dL4zRL2EUljyWw0CwcB5661Kx0WS8FOk10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8DFM3sUcqW/ByHk/gkTZdd+7yWp9P7aOYgXbZK/huqz1uAlRFE/X04i7RYZ4ef+1
	 1Uo12jXCFiOU1vx7CyAZsYeuCOzxfRtqBzwDNV251Y0MYYPE57e6zD/D0FoMeu4CrX
	 iLfQ9xcSrtBOtXdis5s9WnpP7KeQ3EIyt5yM75R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 062/143] can: sun4i_can: populate ndo_change_mtu() to prevent buffer overflow
Date: Tue, 30 Sep 2025 16:46:26 +0200
Message-ID: <20250930143833.701228734@linuxfoundation.org>
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

[ Upstream commit 61da0bd4102c459823fbe6b8b43b01fb6ace4a22 ]

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

And so, sun4ican_start_xmit() receives a CAN XL frame which it is not
able to correctly handle and will thus misinterpret it as a CAN frame.

This can result in a buffer overflow. The driver will consume cf->len
as-is with no further checks on this line:

	dlc = cf->len;

Here, cf->len corresponds to the flags field of the CAN XL frame. In
our previous example, we set canxl_frame->flags to 0xff. Because the
maximum expected length is 8, a buffer overflow of 247 bytes occurs a
couple line below when doing:

	for (i = 0; i < dlc; i++)
		writel(cf->data[i], priv->base + (dreg + i * 4));

Populate net_device_ops->ndo_change_mtu() to ensure that the
interface's MTU can not be set to anything bigger than CAN_MTU. By
fixing the root cause, this prevents the buffer overflow.

Fixes: 0738eff14d81 ("can: Allwinner A10/A20 CAN Controller support - Kernel module")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20250918-can-fix-mtu-v1-3-0d1cada9393b@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sun4i_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 6fcb301ef611d..53bfd873de9bd 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -768,6 +768,7 @@ static const struct net_device_ops sun4ican_netdev_ops = {
 	.ndo_open = sun4ican_open,
 	.ndo_stop = sun4ican_close,
 	.ndo_start_xmit = sun4ican_start_xmit,
+	.ndo_change_mtu = can_change_mtu,
 };
 
 static const struct ethtool_ops sun4ican_ethtool_ops = {
-- 
2.51.0



