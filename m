Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A82D47125C;
	Tue, 21 Jul 2026 18:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657983; cv=none; b=ZB0vGe9f7J72jLAE3QzJSIhREvfAAdJidZN7QeGpLnFI+5ANy0AuXhxC5tmoaxev2oKSRnZqyHaGkHd/T2BQZaWsFbD89WIjtQ43nZz1VWJnXOXaYZWoU5Wqk7WD5RVdXFqW+lq0B15xcEY7r4fxcblq+mrd8L8hSWi+1Sp01Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657983; c=relaxed/simple;
	bh=2mejnOaXe5oelPieX/6fjfgi5J19C76vQ0Qc5VgytkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwfzoocnSu1WSuO7oWSCdR5PSpKtYFBIzjfdZjf3cl93v2ELfcdMVoj4NPcEwNvlS2JoRBhHVPbm/ebq0+B96gIhZYp/TiyxtBQBWn+oT1Yu/ZTePmSZ37jQgnV7U5H/Vg8q9k+iMy4zTgqOSUlh/p1l9HRXNYbcSIPp4BaJqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/XEqwoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/XEqwoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BCF1F000E9;
	Tue, 21 Jul 2026 18:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657981;
	bh=UFHuYfA9FcZreN/8qXj3RM07avFYh5Sod6yC3hnXZl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/XEqwoERaQZ1kZbvFBRwdJYAaNWG8jvPGoCpnbG/JV2U4uWOwqI4BRf9PXDgaopA
	 qcUCnBmUonstu9ekYLhhJADrXoZuFTI/3KHdy5KuwTLyXBnpmQd3VCVZc5ZhuyMxGF
	 sOvPDyjNcMq3/ut4JFoesTZGWOn2c5ZSQFHu05K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0969/1611] usbnet: gl620a: fix out-of-bounds read in genelink_rx_fixup()
Date: Tue, 21 Jul 2026 17:18:05 +0200
Message-ID: <20260721152537.190029154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 8ff7f2a6da4fccaa5cc9be7251a24e71e29fbd1a ]

genelink_rx_fixup() splits an aggregated RX frame into its individual
packets, using a per-packet length taken from device-supplied data. That
length is only bounded by GL_MAX_PACKET_LEN (1514); it is never compared
against how many bytes were actually received.

A malicious GeneLink (GL620A) device can therefore send a short URB whose
header claims packet_count > 1 and a first packet of up to 1514 bytes.

	skb_put_data(gl_skb, packet->packet_data, size);

then copies past the end of the receive buffer and hands the adjacent slab
contents up the network stack, an out-of-bounds read that leaks kernel heap.
No privilege is required: the path runs in the usbnet RX softirq as soon as
the interface is up.

  BUG: KASAN: slab-out-of-bounds in genelink_rx_fixup (drivers/net/usb/gl620a.c:112)
  Read of size 1514 at addr ffff888011309708 by task ksoftirqd/0/14
  Call Trace:
    ...
    __asan_memcpy (mm/kasan/shadow.c:105)
    genelink_rx_fixup (include/linux/skbuff.h:2814 drivers/net/usb/gl620a.c:112)
    usbnet_bh (drivers/net/usb/usbnet.c:572 drivers/net/usb/usbnet.c:1589)
    process_one_work (kernel/workqueue.c:3322)
    bh_worker (kernel/workqueue.c:3405)
    tasklet_action (kernel/softirq.c:965)
    handle_softirqs (kernel/softirq.c:622)
    run_ksoftirqd (kernel/softirq.c:1076)
    ...

skb_pull() already verifies that the requested length fits the buffer and
returns NULL otherwise. Move it ahead of the copy and check its result, so
a packet that overruns the received data is rejected before it is read.
Well-formed frames, whose packets are fully present, are unaffected.

Fixes: 47ee3051c856 ("[PATCH] USB: usbnet (5/9) module for genesys gl620a cables")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260627205353.4000788-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/gl620a.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/gl620a.c b/drivers/net/usb/gl620a.c
index 0bfa37c1405918..09afd137b64e15 100644
--- a/drivers/net/usb/gl620a.c
+++ b/drivers/net/usb/gl620a.c
@@ -104,6 +104,9 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			return 0;
 		}
 
+		if (!skb_pull(skb, size + 4))
+			return 0;
+
 		// allocate the skb for the individual packet
 		gl_skb = alloc_skb(size, GFP_ATOMIC);
 		if (gl_skb) {
@@ -116,9 +119,6 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		// advance to the next packet
 		packet = (struct gl_packet *)&packet->packet_data[size];
 		count--;
-
-		// shift the data pointer to the next gl_packet
-		skb_pull(skb, size + 4);
 	}
 
 	// skip the packet length field 4 bytes
-- 
2.53.0



