Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D0650E5A6;
	Thu, 17 Sep 2026 17:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666379; cv=none; b=ltFbr0Sg5+YBROVWuFS5rPQ8T/r8nosSQv1nn/5aL0xvahAvX5y3k7nlA5Sfcc5eB8yikBsE/R4ISquu6xuLkjeClTf+lUVVeGvxqi18zGoOX42J67b96ASrzMHFH4kUhZCLsJQ9Z5lLfOH6mW9SUAtljtITU6RroqHUJl7v+GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666379; c=relaxed/simple;
	bh=mkpQigpmmXR246U3N97LmFp9oE3p1cnqYrIjrA3pNQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViULWLdnT+Jy3oxbITTXC6fE1LhLgK58Ryz7AKhYavlooGfVELTNntwifOHWKw8Z+q2FbrygYMHqX0zp1B579cJd9RF5Mb+hCqNqXxTFtAozVCoAGfRfoXR1Yibl1QTqu7yemjyK02j7/0Um4GJTcnt7uogiNrjwS7yV9jRSbtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaauWXrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaauWXrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0911F000FF;
	Thu, 17 Sep 2026 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666377;
	bh=Zs4CBelvYmqK9UzJRqD8/br0s5YYgp7gH4C8EVIO1Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaauWXrtfKGmu7cq2T5wES0ILDIjce8HeYoB+3mtNZHYWa3YGllECYzJQC5+Dczpp
	 q+MD2oIhlt7sUMP8pGxvMT7Y20P/JVCVdNe8w3vR8B19WGC16QkpMqJ8G7w0JpISAo
	 zuaWa9BiNpk1HLuAXWlZq2GctXj8surDDrICaEAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+28eef7d8af9428e6@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1016/1250] net: dsa: tag_brcm: legacy FCS: request needed tailroom
Date: Thu, 17 Sep 2026 16:13:31 +0100
Message-ID: <20260917151619.586326675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 5be081b83abd3f17d908953b4bb77279f5a149e3 upstream.

The legacy FCS tagger calculates the CRC over skb->len bytes starting at
skb->data. When a nonlinear skb reaches the tagger, this reads past the
linear head into unrelated slab memory.

The tagger appends an Ethernet FCS but does not declare that tailroom. As a
result, DSA leaves NETIF_F_SG and NETIF_F_FRAGLIST enabled on the user
port, and nonlinear skbs can reach the CRC calculation.

Declare the required tailroom. DSA will then clear those features and the
networking core will linearize skbs before the tagger runs.

A KASAN-enabled dsa_loop test using this tagger reports:

  BUG: KASAN: slab-out-of-bounds in crc32_le
  Read of size 1 at addr ffff8880397086c0 by task exp/135

  Call Trace:
   crc32_le (lib/crc/crc32-main.c:38)
   brcm_leg_fcs_tag_xmit (net/dsa/tag_brcm.c:343)
   dsa_user_xmit (net/dsa/user.c:942)
   dev_hard_start_xmit (net/core/dev.c:3937)
   __dev_queue_xmit (net/core/dev.c:4926)
   packet_sendmsg (net/packet/af_packet.c:3110)
   __sys_sendto (net/socket.c:2281)

  The buggy address belongs to the object at ffff888039708400
   which belongs to the cache skbuff_small_head of size 704
  The buggy address is located 0 bytes to the right of
   allocated 704-byte region [ffff888039708400, ffff8880397086c0)

Fixes: ef07df397a62 ("net: dsa: tag_brcm: add support for legacy FCS tags")
Cc: stable@vger.kernel.org
Reported-by: co+28eef7d8af9428e6@bugs.sh
Closes: https://lore.kernel.org/all/jH6u350kaBRuqklDjd3k3BW4nWzp0tYRjq3p%40bugs.sh/
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260908165047.2786340-1-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_brcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -364,6 +364,7 @@ static const struct dsa_device_ops brcm_
 	.xmit = brcm_leg_fcs_tag_xmit,
 	.rcv = brcm_leg_tag_rcv,
 	.needed_headroom = BRCM_LEG_TAG_LEN,
+	.needed_tailroom = ETH_FCS_LEN,
 };
 
 DSA_TAG_DRIVER(brcm_legacy_fcs_netdev_ops);


