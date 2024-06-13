Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D045161;
	Thu, 13 Jun 2024 12:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281959; cv=none; b=mXyAroK4Bha/pVwqi/TAegXPF4YHSoiJ8Pb2pJMxcnnmF3LwUm/OKeHGq1k/I9HWbLhy0CBTEggEIuSvV9kVtnfU5NXjSmlB7oa7JyKH3swxcu6vJS0+lfF1hqX4ozdiLUZyddzD5XlXcLiH8p/1gd1k3eniM8k+rdATedbWQ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281959; c=relaxed/simple;
	bh=2m64ye5IGMeAy8rdBK9h3I0N87Cu2Se99ZYRbo1hIms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm7SceQg4IFaaoXxyc3zKAJz9PwxaALmR4IvOaklUxiILbFAsDJDxxE+Dn9zj8tr2nSedgS7TKXcOT+BT2ac2Xf/p7C9o3r4Vy1hd7u9P8P82FcNCkN9bz5qJOpAvkJbWsBUKDyNBxXWMbHMT/c2QFk/UmUFP9zOqpb+tBMwLKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTZa/gsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTZa/gsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14249C2BBFC;
	Thu, 13 Jun 2024 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281959;
	bh=2m64ye5IGMeAy8rdBK9h3I0N87Cu2Se99ZYRbo1hIms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTZa/gsze8rI3+KWlbO4HvID5sQB8dpiElOFQmxZy3pd+h1Oo7ADa5x2SAV/bT3ga
	 DD6qKZQAoqay1NigPGJoSn8QEagh1Gp5Mam+VOUU3rpNnZxxr/8CstUzMgsAlk5R25
	 pyPoYmBNaWPZ1/KIcOc3nSi/0eh+Ls1reiWzKwf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Steve Glendinning <steve.glendinning@shawell.net>,
	UNGLinuxDriver@microchip.com,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/402] net: usb: smsc95xx: stop lying about skb->truesize
Date: Thu, 13 Jun 2024 13:31:10 +0200
Message-ID: <20240613113306.541276017@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d50729f1d60bca822ef6d9c1a5fb28d486bd7593 ]

Some usb drivers try to set small skb->truesize and break
core networking stacks.

In this patch, I removed one of the skb->truesize override.

I also replaced one skb_clone() by an allocation of a fresh
and small skb, to get minimally sized skbs, like we did
in commit 1e2c61172342 ("net: cdc_ncm: reduce skb truesize
in rx path") and 4ce62d5b2f7a ("net: usb: ax88179_178a:
stop lying about skb->truesize")

v3: also fix a sparse error ( https://lore.kernel.org/oe-kbuild-all/202405091310.KvncIecx-lkp@intel.com/ )
v2: leave the skb_trim() game because smsc95xx_rx_csum_offload()
    needs the csum part. (Jakub)
    While we are it, use get_unaligned() in smsc95xx_rx_csum_offload().

Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steve Glendinning <steve.glendinning@shawell.net>
Cc: UNGLinuxDriver@microchip.com
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240509083313.2113832-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 5f962f58ff496..10fae3989fbdb 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1785,9 +1785,11 @@ static int smsc95xx_reset_resume(struct usb_interface *intf)
 
 static void smsc95xx_rx_csum_offload(struct sk_buff *skb)
 {
-	skb->csum = *(u16 *)(skb_tail_pointer(skb) - 2);
+	u16 *csum_ptr = (u16 *)(skb_tail_pointer(skb) - 2);
+
+	skb->csum = (__force __wsum)get_unaligned(csum_ptr);
 	skb->ip_summed = CHECKSUM_COMPLETE;
-	skb_trim(skb, skb->len - 2);
+	skb_trim(skb, skb->len - 2); /* remove csum */
 }
 
 static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
@@ -1845,25 +1847,22 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 				if (dev->net->features & NETIF_F_RXCSUM)
 					smsc95xx_rx_csum_offload(skb);
 				skb_trim(skb, skb->len - 4); /* remove fcs */
-				skb->truesize = size + sizeof(struct sk_buff);
 
 				return 1;
 			}
 
-			ax_skb = skb_clone(skb, GFP_ATOMIC);
+			ax_skb = netdev_alloc_skb_ip_align(dev->net, size);
 			if (unlikely(!ax_skb)) {
 				netdev_warn(dev->net, "Error allocating skb\n");
 				return 0;
 			}
 
-			ax_skb->len = size;
-			ax_skb->data = packet;
-			skb_set_tail_pointer(ax_skb, size);
+			skb_put(ax_skb, size);
+			memcpy(ax_skb->data, packet, size);
 
 			if (dev->net->features & NETIF_F_RXCSUM)
 				smsc95xx_rx_csum_offload(ax_skb);
 			skb_trim(ax_skb, ax_skb->len - 4); /* remove fcs */
-			ax_skb->truesize = size + sizeof(struct sk_buff);
 
 			usbnet_skb_return(dev, ax_skb);
 		}
-- 
2.43.0



