Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591184;
	b=xo8AP7+45SYuSxcts78ZInXkIvoo28wbvSf9mGmg/wuc968xHis9LtukrDVdIkwxwAoy
	 KORXewMVa8nE5JTTbhsM/3M6UMDOT9sFjKEnWtoRdixS69Rwdnlivprvim/167OK845Gt
	 BgOjPLP8R3cVnZ+sAUwEtJQSzvUtQ5YyqSZprd2m/9200+9tfUyxH0cgrGY5thtWlec7r
	 PTU2w1tLg06IJ52tZ+krX5gAUYZmOxSVXUTOjDkkz7CLFJBcsWDFtmOd1MDO4mRs+G/us
	 FOVynqfHMPrYAyBaEndsv7XKTujiyjd2EPB6YY+Boics7ea7qpdz+uk8x0zziDrn5ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S1wtaGvFzfWQ1FcdFjd2XcZNeQKlTH4hG9ePPSgjHx4=;
	b=AvlISBmzfICJyRxnBawmkgw/15RVtSLIsVG7QW5LdoStTAYEfzPTBT6i9j2Le3ZhsK7s
	 vds6fT4FIPeH8gDek7OYbugUXZVbim4ersgH9zC1IelyaCborYC+3L6788KkZ+lzxYiSK
	 zOWX7GooaFxxpUj3S3/M6SzSPtsmrcXhXMNdoXa7LCLUhy4Wwng0lOkLdEFj0RfssjNCL
	 ba3u0b0unkarbeDGc0Jhm8Ebtic5sDQJ9YMEBOoGHMTOIOKnKrov4AowR5cZpcmQy3QwA
	 cossXW0g+ElWT39vPTrE1rfPrByCQ3JTXlYZsL1V4mFK9VDLSoBqVE3wTaTRJu1qeGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QGUGHju3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7542B606C0B1;
	Fri, 13 Nov 2026 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QGUGHju3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F301F000C4;
	Fri, 13 Nov 2026 17:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591184;
	bh=S1wtaGvFzfWQ1FcdFjd2XcZNeQKlTH4hG9ePPSgjHx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGUGHju3QnDnytL7Ko5d0DZeq0Qiz0kuIXCwtuIix493QNTFI+JGWvbdZl1PJS6GN
	 pzVRYd1mRloJ6R60V6rxNP7gHD2F0pDg7YTM5gYBxcjtUClyDfeqbk4xqAQ/Zttyje
	 SbP+9M+xqQZHz5kl0VTlaCf3qzLnukTp0SLdqbKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/670] can: dev: can_fill_info(): dont wake up controller if interface is down
Date: Fri, 13 Nov 2026 10:48:05 -0500
Message-ID: <20261113153822.775967928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>

[ Upstream commit 75332c410c8190d61499001c5516af977ca426c3 ]

If the interface is down, the CAN controller might be powered down and
its clocks gated. Don't call do_get_berr_counter() to read the bus error
counters if the interface is down, and adjust can_get_size() to match.

This removes one trigger for a synchronous external abort seen on
i.MX8QXP when "ip link show" is run on a flexcan interface that was
never brought up. The underlying cause is platform-specific: on i.MX8QXP
the CAN clocks are gated through the SCU LPCG and the subsystem shares
the IMX_SC_R_CAN_0 power domain, and there is a window after
pm_runtime_resume_and_get() returns where the clock has not reached the
module yet. This patch avoids the netlink query path while the interface
is down, but does not root-cause the LPCG window itself.

As a result, IFLA_CAN_BERR_COUNTER is no longer reported for down
interfaces. Userspace must treat the attribute as optional.

The issue was triggered on an i.MX8QXP board by running "ip link show"
without ever bringing the interface up:

    Internal error: synchronous external abort: 0000000096000210

    pc : flexcan_read_le+0x0/0x18
    lr : flexcan_get_berr_counter+0x4c/0x8c
    Call trace:
     flexcan_read_le+0x0/0x18
     flexcan_get_berr_counter+0x4c/0x8c
     can_fill_info+0x1f8/0x434
     rtnl_fill_ifinfo+0x8fc/0xbb4
     rtnl_dump_ifinfo+0x364/0x448

This is the same class of problem fixed for m_can in
commit 91a55c72a821 ("can: m_can: m_can_get_berr_counter(): don't
wake up controller if interface is down").

Fixes: ec56acfef2af1 ("can: flexcan: flexcan_get_berr_counter(): switch on clocks before accessing ecr register")
Cc: stable@vger.kernel.org
Signed-off-by: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20261027065012.191348-1-chunyuzhiqiang@yinhe.ht
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 77d165ed0d534..884313a5cdd31 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -454,7 +454,7 @@ static size_t can_get_size(const struct net_device *dev)
 	size += nla_total_size(sizeof(u32));			/* IFLA_CAN_STATE */
 	size += nla_total_size(sizeof(struct can_ctrlmode));	/* IFLA_CAN_CTRLMODE */
 	size += nla_total_size(sizeof(u32));			/* IFLA_CAN_RESTART_MS */
-	if (priv->do_get_berr_counter)				/* IFLA_CAN_BERR_COUNTER */
+	if (priv->do_get_berr_counter && netif_running(dev))	/* IFLA_CAN_BERR_COUNTER */
 		size += nla_total_size(sizeof(struct can_berr_counter));
 	if (priv->data_bittiming.bitrate)			/* IFLA_CAN_DATA_BITTIMING */
 		size += nla_total_size(sizeof(struct can_bittiming));
@@ -574,7 +574,7 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put(skb, IFLA_CAN_CTRLMODE, sizeof(cm), &cm) ||
 	    nla_put_u32(skb, IFLA_CAN_RESTART_MS, priv->restart_ms) ||
 
-	    (priv->do_get_berr_counter &&
+	    (priv->do_get_berr_counter && netif_running(dev) &&
 	     !priv->do_get_berr_counter(dev, &bec) &&
 	     nla_put(skb, IFLA_CAN_BERR_COUNTER, sizeof(bec), &bec)) ||
 
-- 
2.53.0



