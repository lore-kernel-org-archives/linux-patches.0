Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB4922257E;
	Tue,  8 Apr 2025 11:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112950; cv=none; b=KEFPsCTTP3KdCNofNcNrgUQDpRML7JYU3RkIQ/K+/aihI2wm9WQuzmPogxir53uujV0wkc538BZrLxLQcr18a92k25drWic6oBLFxRTCu3BNd/qGX90cAyKoBwdRosHsvawnrhv89WiZsTBd2NW1vGAc54xcxsLwFSpJylAnGJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112950; c=relaxed/simple;
	bh=CSVekPpzhh2aZwMWMOq138WPBR3Kk2NXCrT5mV/H/j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NBvuraiRzyLOoovg3wcBdI4DaaxPUv+gE7jaqdrBBEqEq5keCljXTcd2bFh40HmgHt6xYr54fj7FmXSjUD3RCyJCj7F/RNCZ3/jUdWF+n+Twt3cEOiRuvAUfj2tWQ921ya2F9Hq9czpRI65sshDRFwhYZZyB08aJGL6PJ0tsr0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqUDx31L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqUDx31L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E44FC4CEE5;
	Tue,  8 Apr 2025 11:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112950;
	bh=CSVekPpzhh2aZwMWMOq138WPBR3Kk2NXCrT5mV/H/j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqUDx31Lc/S6mMHmxU8pacHdXTZIetUZBiOR70c38yp2K9p+dpD9s4UFXiCrKcBCk
	 GFPJEuAn3tGKXTAMUY2nc6qn3XZAJ9b05oQFerHFkzW/7nx1fvADSr40H7PKvwUSyh
	 6KasvWbmWhVXEMaXRpVWYx95OJxU/mBynK/FFG5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Lu <luying1@xiaomi.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 259/279] usbnet:fix NPE during rx_complete
Date: Tue,  8 Apr 2025 12:50:42 +0200
Message-ID: <20250408104833.372507179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Lu <luying1@xiaomi.com>

commit 51de3600093429e3b712e5f091d767babc5dd6df upstream.

Missing usbnet_going_away Check in Critical Path.
The usb_submit_urb function lacks a usbnet_going_away
validation, whereas __usbnet_queue_skb includes this check.

This inconsistency creates a race condition where:
A URB request may succeed, but the corresponding SKB data
fails to be queued.

Subsequent processes:
(e.g., rx_complete → defer_bh → __skb_unlink(skb, list))
attempt to access skb->next, triggering a NULL pointer
dereference (Kernel Panic).

Fixes: 04e906839a05 ("usbnet: fix cyclical race on disconnect with work queue")
Cc: stable@vger.kernel.org
Signed-off-by: Ying Lu <luying1@xiaomi.com>
Link: https://patch.msgid.link/4c9ef2efaa07eb7f9a5042b74348a67e5a3a7aea.1743584159.git.luying1@xiaomi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -533,7 +533,8 @@ static int rx_submit (struct usbnet *dev
 	    netif_device_present (dev->net) &&
 	    test_bit(EVENT_DEV_OPEN, &dev->flags) &&
 	    !test_bit (EVENT_RX_HALT, &dev->flags) &&
-	    !test_bit (EVENT_DEV_ASLEEP, &dev->flags)) {
+	    !test_bit (EVENT_DEV_ASLEEP, &dev->flags) &&
+	    !usbnet_going_away(dev)) {
 		switch (retval = usb_submit_urb (urb, GFP_ATOMIC)) {
 		case -EPIPE:
 			usbnet_defer_kevent (dev, EVENT_RX_HALT);
@@ -554,8 +555,7 @@ static int rx_submit (struct usbnet *dev
 			tasklet_schedule (&dev->bh);
 			break;
 		case 0:
-			if (!usbnet_going_away(dev))
-				__usbnet_queue_skb(&dev->rxq, skb, rx_start);
+			__usbnet_queue_skb(&dev->rxq, skb, rx_start);
 		}
 	} else {
 		netif_dbg(dev, ifdown, dev->net, "rx: stopped\n");


