Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D002DF12F;
	Mon, 13 Apr 2026 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097425; cv=none; b=hoZiBi4m8O5zSHPaqJBsj9BOfkKKe3o2lqPJC7GDb5HxILGHEUE4FOxbQENPIWY/FgPsVh3KKpQaoLLRTYHnxAue/IQKqzBsBRhY+JStBxY8ynmk/UnK3kSAdCSZdV1COuVNu1QPsfyMyOB2VqZuFPmaC7HXxKm42uvv3Iy1Ywo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097425; c=relaxed/simple;
	bh=U9k7OOXfNxBVV2Y2D5rlB7FNvLNaUh56KdTJJZX7z4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Amr1+5++Mrga6sxnHIFEGN0TyqR7vglGdXlxBfpLU57lwzF1tJHusZtHOt7PwGPZpdF8bfkMg12B3k3KdptTmqjfUABOXWZdtytsbQFXse8MQNQVQ7Xk3qDa7Mf9fKoaX025DIsA78VFuLvni7sVmUl/oma9HetWBf5DB6cqwyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQnxG0R4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQnxG0R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA9AC2BCAF;
	Mon, 13 Apr 2026 16:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097424;
	bh=U9k7OOXfNxBVV2Y2D5rlB7FNvLNaUh56KdTJJZX7z4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQnxG0R4kTsiz+PpDSGMVzgUvwWce4nWCqXzXMegsuw0lBRrKwsebuh9Qm8BaEHEc
	 D7EoV9dJRHKveHnOYm/zd/EYFlFBhEFztuv5/IOVcn6YBSMu3pDHLR3b+ijkixVxEr
	 Xg65jElKJdybhmBEbvSpfiwR1CydhYiGrL7nU30A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 132/570] net: usb: lan78xx: fix silent drop of packets with checksum errors
Date: Mon, 13 Apr 2026 17:54:23 +0200
Message-ID: <20260413155835.388742799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit e4f774a0cc955ce762aec91c66915a6e15087ab7 upstream.

Do not drop packets with checksum errors at the USB driver level;
pass them to the network stack.

Previously, the driver dropped all packets where the 'Receive Error
Detected' (RED) bit was set, regardless of the specific error type. This
caused packets with only IP or TCP/UDP checksum errors to be dropped
before reaching the kernel, preventing the network stack from accounting
for them or performing software fallback.

Add a mask for hard hardware errors to safely drop genuinely corrupt
frames, while allowing checksum-errored frames to pass with their
ip_summed field explicitly set to CHECKSUM_NONE.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260305143429.530909-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    4 +++-
 drivers/net/usb/lan78xx.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3334,6 +3334,7 @@ static void lan78xx_rx_csum_offload(stru
 	 */
 	if (!(dev->net->features & NETIF_F_RXCSUM) ||
 	    unlikely(rx_cmd_a & RX_CMD_A_ICSM_) ||
+	    unlikely(rx_cmd_a & RX_CMD_A_CSE_MASK_) ||
 	    ((rx_cmd_a & RX_CMD_A_FVTG_) &&
 	     !(dev->net->features & NETIF_F_HW_VLAN_CTAG_RX))) {
 		skb->ip_summed = CHECKSUM_NONE;
@@ -3401,7 +3402,8 @@ static int lan78xx_rx(struct lan78xx_net
 		size = (rx_cmd_a & RX_CMD_A_LEN_MASK_);
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
-		if (unlikely(rx_cmd_a & RX_CMD_A_RED_)) {
+		if (unlikely(rx_cmd_a & RX_CMD_A_RED_) &&
+		    (rx_cmd_a & RX_CMD_A_RX_HARD_ERRS_MASK_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
 		} else {
--- a/drivers/net/usb/lan78xx.h
+++ b/drivers/net/usb/lan78xx.h
@@ -74,6 +74,9 @@
 #define RX_CMD_A_ICSM_			(0x00004000)
 #define RX_CMD_A_LEN_MASK_		(0x00003FFF)
 
+#define RX_CMD_A_RX_HARD_ERRS_MASK_ \
+	(RX_CMD_A_RX_ERRS_MASK_ & ~RX_CMD_A_CSE_MASK_)
+
 /* Rx Command B */
 #define RX_CMD_B_CSUM_SHIFT_		(16)
 #define RX_CMD_B_CSUM_MASK_		(0xFFFF0000)


