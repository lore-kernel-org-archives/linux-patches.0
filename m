Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530893CB2E9;
	Mon, 17 Aug 2026 15:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980101; cv=none; b=tyQ38uroCoQesQvVewJTemj5V1i3TDAiCK2vFmL1MxMsQy/svu3EqIx6Bi4PA73VAAuPYHKs/Ak2nblWvOFRfg7KSwVdCA8sxGCuXbtcipwYqT6w7xaKANvDDnuLhrHpk3HtPFF9smfTOX5ZVNFNnud74c56hzy66FUhPzDRSoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980101; c=relaxed/simple;
	bh=x6ecC6yFYjW66JROJ9oVQhAT7UnfzWrDviFOCSmnUkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKWL63HyjNHIELiJ7YYoHttYtJjxIVYjeu0GNPPS4a0NwMbEbrQJ8nT8FviOYtNBoND7ATukeW1YyLX8OA6QXTo7LlN0PUYeDAMfVLCH4cRM61Kwq8ZTVRv7P4skoYmayvGrsEWGksIJnHQYVAgw1EVu6COGlm7+3XCWh+NxmVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zh2ah+OR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zh2ah+OR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755F61F000E9;
	Mon, 17 Aug 2026 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980100;
	bh=8UpIcwDKyIX4ow8V3Cr0+Eb2Eq+Q1NFzvt5EZv6KiSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zh2ah+ORYYD7UzpEVuZ2OPjt2bLhPHFyMDFLrUYut5whl5W26nQHlM/GfiaYiLQqh
	 yL9pWRvdIXiBVmrPi+z1zihwfXXsH5HmPYWhPCfQZSfxe2ivjmbeHkjlWr602cE6DW
	 J+JZ/G3DU8UepsMNTIQxyXxJAD8KE20cLixQf1r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Gao <jamesgao5@outlook.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 457/609] can: peak_usb: add bounds check for USB channel index
Date: Mon, 17 Aug 2026 15:32:33 +0200
Message-ID: <20260817132559.321079449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Gao <jamesgao5@outlook.com>

commit 39132f166ca8ce00ae60d8a9068e06a60943cc4b upstream.

The channel control index ctrl_idx is derived from rx->len which comes
directly from a device USB payload. The mask 0x0f allows values 0-15, but
the array size of usb_if->dev[] is only 2. Values 2-15 cause heap
out-of-bounds read, eventually causing kernel panic in the IRQ context.

Add bounds checking for ctrl_idx before the array access in both
pcan_usb_pro_handle_canmsg() and pcan_usb_pro_handle_error().

Fixes: d8a199355f8f ("can: usb: PEAK-System Technik PCAN-USB Pro specific part")
Signed-off-by: James Gao <jamesgao5@outlook.com>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/TYWPR01MB8559DBAAAA6A7F410400329CF0012@TYWPR01MB8559.jpnprd01.prod.outlook.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -520,12 +520,18 @@ static int pcan_usb_pro_handle_canmsg(st
 				      struct pcan_usb_pro_rxmsg *rx)
 {
 	const unsigned int ctrl_idx = (rx->len >> 4) & 0x0f;
-	struct peak_usb_device *dev = usb_if->dev[ctrl_idx];
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct can_frame *can_frame;
 	struct sk_buff *skb;
 	struct skb_shared_hwtstamps *hwts;
 
+	if (ctrl_idx >= ARRAY_SIZE(usb_if->dev))
+		return -EINVAL;
+
+	dev = usb_if->dev[ctrl_idx];
+	netdev = dev->netdev;
+
 	skb = alloc_can_skb(netdev, &can_frame);
 	if (!skb)
 		return -ENOMEM;
@@ -559,14 +565,20 @@ static int pcan_usb_pro_handle_error(str
 {
 	const u16 raw_status = le16_to_cpu(er->status);
 	const unsigned int ctrl_idx = (er->channel >> 4) & 0x0f;
-	struct peak_usb_device *dev = usb_if->dev[ctrl_idx];
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct can_frame *can_frame;
 	enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
 	u8 err_mask = 0;
 	struct sk_buff *skb;
 	struct skb_shared_hwtstamps *hwts;
 
+	if (ctrl_idx >= ARRAY_SIZE(usb_if->dev))
+		return -EINVAL;
+
+	dev = usb_if->dev[ctrl_idx];
+	netdev = dev->netdev;
+
 	/* nothing should be sent while in BUS_OFF state */
 	if (dev->can.state == CAN_STATE_BUS_OFF)
 		return 0;


