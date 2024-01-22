Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB1E15A4A9;
	Tue, 23 Jan 2024 00:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969747; cv=none; b=E/v0pEXa41xm/P7d3A3H2Rv9JhOBigrOz6V1xMVHmkJ0Tu7X+qhHieb4YhUIEukhcM6F2dKaeNkKcoJilReFCo25NiNAnHkGvENmtKpFlI2gHo7U2FdnREE45SGZIh9xg1dKR8F7XBnFV2nvu+ESgQccj4iXLKYSX0ZDzva/2Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969747; c=relaxed/simple;
	bh=KeSrit1J9rEMH6pDaCBkSqQ5qlb8RgZSXDCvr1usmPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dMZc4gOxR6t3wz7XDCPOG2QrIFJIyH47+KImIyGExSQShoAFa827IvNwayDwLzGmQZLQyUtCJudDb03atTmbQ1h/HgK3XZtl0XcDF+WtfsbpakSjFFUDyVxNkkevzmIt5qkyCZzfOIaXnkhoS+7nU5CrQvFgsb13kKhNG/Yt0MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOUGw7TV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOUGw7TV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700B5C43399;
	Tue, 23 Jan 2024 00:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969746;
	bh=KeSrit1J9rEMH6pDaCBkSqQ5qlb8RgZSXDCvr1usmPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOUGw7TVxcSbP50HoygN+VncO0lv6yf7apKRze+W7ffKUl4bbfOU7Y91WIpJ7tOLu
	 NeqaY3DAdRp/jtZjvnC+N1IYVWtOT3Ls6xMUsJBW96JEDcIOPGQJLU/xKRk2NldM7M
	 KR2DMUD+2atLOFF47Sh64ogad21L4+EbxTghYh/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Richard Acayan <mailingradian@gmail.com>,
	Luca Weiss <luca@z3ntu.xyz>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>
Subject: [PATCH 6.7 394/641] usb: gadget: u_ether: Re-attach netif device to mirror detachment
Date: Mon, 22 Jan 2024 15:54:58 -0800
Message-ID: <20240122235830.290967202@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Acayan <mailingradian@gmail.com>

commit 76c945730cdffb572c7767073cc6515fd3f646b4 upstream.

In 6.7-rc1, there was a netif_device_detach call added to the
gether_disconnect function. This clears the __LINK_STATE_PRESENT bit of
the netif device and suppresses pings (ICMP messages) and TCP connection
requests from the connected host. If userspace temporarily disconnects
the gadget, such as by temporarily removing configuration in the gadget
configfs interface, network activity should continue to be processed
when the gadget is re-connected. Mirror the netif_device_detach call
with a netif_device_attach call in gether_connect to fix re-connecting
gadgets.

Link: https://gitlab.com/postmarketOS/pmaports/-/tree/6002e51b7090aeeb42947e0ca7ec22278d7227d0/main/postmarketos-base-ui/rootfs-usr-lib-NetworkManager-dispatcher.d-50-tethering.sh
Cc: stable <stable@kernel.org>
Fixes: f49449fbc21e ("usb: gadget: u_ether: Replace netif_stop_queue with netif_device_detach")
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Tested-by: Luca Weiss <luca@z3ntu.xyz>
Tested-by: Duje Mihanović <duje.mihanovic@skole.hr>
Link: https://lore.kernel.org/r/20231218164532.411125-2-mailingradian@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 9d1c40c152d8..3c5a6f6ac341 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -1163,6 +1163,8 @@ struct net_device *gether_connect(struct gether *link)
 		if (netif_running(dev->net))
 			eth_start(dev, GFP_ATOMIC);
 
+		netif_device_attach(dev->net);
+
 	/* on error, disable any endpoints  */
 	} else {
 		(void) usb_ep_disable(link->out_ep);
-- 
2.43.0



