Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478FE5FF0E;
	Tue, 13 Feb 2024 17:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845222; cv=none; b=mce2DxYYt4AqR0pHBFglMvgsesFNUU7M05+xpfR8yMuCV/9UHzHwNa5pDh9KPZtQMK32u31nAOCByAtK60xHmPMFXsnguoM0HFmgc2mIcECcvNjXjVfswOhwEe4MSOBiKdzmuGow/Ap9YgoIxST5qNPnabTEVZxftufdJv+ufgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845222; c=relaxed/simple;
	bh=CXw9R1Gz53J4ucnuQDW1iWqtZdnseBP9KUzcGavDPrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJYJX67pXy4lXdJi1mDDCXc+6PvJ4LhaNNKCRmyTx4E5nyz9vpUxZRNOhsAeTTcN8EnBYi0wgEu6Qj0rYaAfZIEmjtzCaaWB/ED1Hc+UZheq2kCJKE0aALQSTyexMzdWmZ3XKIi+1ka2LMlqQXsS4BlA8aKE+URhsiX1EG3QIp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbQR6eOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbQR6eOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4CBC433F1;
	Tue, 13 Feb 2024 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845221;
	bh=CXw9R1Gz53J4ucnuQDW1iWqtZdnseBP9KUzcGavDPrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbQR6eOrfNDpMwgDY7ouzYV+QP1Dipu912rCkD1SEW+9ER2FTwuYUFbhZFJvA2rQM
	 Ehf3tCE97T7y76tmwdlFpQAOe5Hg9oyxobjH61zg98F3UY271CmZu/yxUnwNAEyJg7
	 cQz5u2/dKSVLyk2k5Ny6zSx6HwBaDvYfHkHDLr3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/121] phy: ti: phy-omap-usb2: Fix NULL pointer dereference for SRP
Date: Tue, 13 Feb 2024 18:20:18 +0100
Message-ID: <20240213171853.228770654@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 762d3de8b3c5..6bd3c7492330 100644
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



