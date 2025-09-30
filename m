Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8D41F3BAC;
	Tue, 30 Sep 2025 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244329; cv=none; b=G86CcJcPyaxVMK4TGaIb/hBThLh1j8tERIOISQtWk/pseNO9ldlhRrM/0MR3ixzt7hRPCmKlPtqCz8gUAiFKMRrjJLwXC3eN3Q52gUrJsC2EvOEL84mw5kN9GDlYeQwJJjh1uRutx5qZa48dp5z7OnbO+NcXFwPLO/CCr+pF2cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244329; c=relaxed/simple;
	bh=hzmCAELExdt/vlKFxQrzWgZzk+zGClDbwTMYot9Pdmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRsiJK6wzbF8i5JpXkberjL08CesGiOIIOdBi4sORqF61odoaFIjK4MXAfjDLvA/t10x+E9pfQaq6dJUryGuMf4qWNMd0vjlhDyNdrdcVKV83pLvii0broV1CaN89sRcL1vcx4utpQZ1wMZtA8yrNOUd1Jfep96dbx5YZI0J9L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2t+3AEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2t+3AEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7102CC4CEF0;
	Tue, 30 Sep 2025 14:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244328;
	bh=hzmCAELExdt/vlKFxQrzWgZzk+zGClDbwTMYot9Pdmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2t+3AEzi3+3TC8puj4NG0+HTxJepI0wMPbyJD84f5KAozIBSfMVb4vVVja71jysd
	 xFXdLq9RsMvM30Xe1zXjQL0/NyWrw6Sw9QryHaZV2uPsKR1M/H+/LWLngvUzp5HEUv
	 qHqcBv+Gh6SSYrgEPXyf1k+PAqvN7QwyaaFGvgiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/122] can: hi311x: populate ndo_change_mtu() to prevent buffer overflow
Date: Tue, 30 Sep 2025 16:47:08 +0200
Message-ID: <20250930143826.961707185@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 28273e84171a2..a7d594a5ad36f 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -807,6 +807,7 @@ static const struct net_device_ops hi3110_netdev_ops = {
 	.ndo_open = hi3110_open,
 	.ndo_stop = hi3110_stop,
 	.ndo_start_xmit = hi3110_hard_start_xmit,
+	.ndo_change_mtu = can_change_mtu,
 };
 
 static const struct of_device_id hi3110_of_match[] = {
-- 
2.51.0



