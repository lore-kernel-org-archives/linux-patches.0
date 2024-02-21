Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020C973161;
	Wed, 21 Feb 2024 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523061; cv=none; b=YgIBZ7ZjTryBogQCrI7UxjPhYkEdMAWPMQLc3rR4TMiglFocbRJ8e7vgxRUgCw7NGr+kC/tc4clv4LRRIJ5y+WnfCtlMH7aLLwhDme9GxPlzJurt9mIovX3mc+IEQugo5DieDV77Gy3BywF50M+U+/G9GVErTOFljmskJTdXtNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523061; c=relaxed/simple;
	bh=jFymhAY/Wzq73RghWY3Knq6HMfpXwi5D3fuKToz24es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJdS/vJMzVlci6H/RPR+IT7hqlpamERmwhqzXlHntv8eWnYu3UeUCQlbwRn4fYNr+IWUAQ1yNbtlCTOWkT13DCvrYM0leg10QDHh3VOmAKrmOCI+w07MjyZk/6/BKuvtLufnFc0b1nyKqcM0U/XwmSX8iPiXU/F0mjQed9/c/UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neu+m7tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neu+m7tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E0DC433C7;
	Wed, 21 Feb 2024 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523060;
	bh=jFymhAY/Wzq73RghWY3Knq6HMfpXwi5D3fuKToz24es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neu+m7tmHV4/LBOY0hvmjIyfkFJfHfXzarikdtkDOSzFDvfb6+L1VzmbtNX8UjQWp
	 3wxQg2QX7lYnabPZ2Vccb/3MuIzFuUI4hcA0fTUyfSU82ppCNY6v73xHjREXLQKCfK
	 YtU9NkxbWd8r722WPphTsznzOiv7A7pA1QVRBq9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/476] phy: ti: phy-omap-usb2: Fix NULL pointer dereference for SRP
Date: Wed, 21 Feb 2024 14:05:53 +0100
Message-ID: <20240221130019.160832348@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 7104ba0f1958adb250319e68a15eff89ec4fd36d ]

If the external phy working together with phy-omap-usb2 does not implement
send_srp(), we may still attempt to call it. This can happen on an idle
Ethernet gadget triggering a wakeup for example:

configfs-gadget.g1 gadget.0: ECM Suspend
configfs-gadget.g1 gadget.0: Port suspended. Triggering wakeup
...
Unable to handle kernel NULL pointer dereference at virtual address
00000000 when execute
...
PC is at 0x0
LR is at musb_gadget_wakeup+0x1d4/0x254 [musb_hdrc]
...
musb_gadget_wakeup [musb_hdrc] from usb_gadget_wakeup+0x1c/0x3c [udc_core]
usb_gadget_wakeup [udc_core] from eth_start_xmit+0x3b0/0x3d4 [u_ether]
eth_start_xmit [u_ether] from dev_hard_start_xmit+0x94/0x24c
dev_hard_start_xmit from sch_direct_xmit+0x104/0x2e4
sch_direct_xmit from __dev_queue_xmit+0x334/0xd88
__dev_queue_xmit from arp_solicit+0xf0/0x268
arp_solicit from neigh_probe+0x54/0x7c
neigh_probe from __neigh_event_send+0x22c/0x47c
__neigh_event_send from neigh_resolve_output+0x14c/0x1c0
neigh_resolve_output from ip_finish_output2+0x1c8/0x628
ip_finish_output2 from ip_send_skb+0x40/0xd8
ip_send_skb from udp_send_skb+0x124/0x340
udp_send_skb from udp_sendmsg+0x780/0x984
udp_sendmsg from __sys_sendto+0xd8/0x158
__sys_sendto from ret_fast_syscall+0x0/0x58

Let's fix the issue by checking for send_srp() and set_vbus() before
calling them. For USB peripheral only cases these both could be NULL.

Fixes: 657b306a7bdf ("usb: phy: add a new driver for omap usb2 phy")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20240128120556.8848-1-tony@atomide.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-omap-usb2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ti/phy-omap-usb2.c b/drivers/phy/ti/phy-omap-usb2.c
index ca8532a3f193..59d3a692c725 100644
--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -116,7 +116,7 @@ static int omap_usb_set_vbus(struct usb_otg *otg, bool enabled)
 {
 	struct omap_usb *phy = phy_to_omapusb(otg->usb_phy);
 
-	if (!phy->comparator)
+	if (!phy->comparator || !phy->comparator->set_vbus)
 		return -ENODEV;
 
 	return phy->comparator->set_vbus(phy->comparator, enabled);
@@ -126,7 +126,7 @@ static int omap_usb_start_srp(struct usb_otg *otg)
 {
 	struct omap_usb *phy = phy_to_omapusb(otg->usb_phy);
 
-	if (!phy->comparator)
+	if (!phy->comparator || !phy->comparator->start_srp)
 		return -ENODEV;
 
 	return phy->comparator->start_srp(phy->comparator);
-- 
2.43.0



