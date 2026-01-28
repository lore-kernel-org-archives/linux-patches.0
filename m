Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BFD2FBE05;
	Wed, 28 Jan 2026 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614932; cv=none; b=e3F3fHWXpdjZ6a49U4bHer4waJe+ZEp05IGHYqPMQj0mZ/OuhTkk6Vu2AlzPn9cBqCyk7k9PB7hN+IVmwyeGu7IEp8HIv0G5wCIr3DNATNz3Z8xfdGhOzt9bOGSwQ55Cb90jgPmzP5zTU/sUU0T0GI9RWeQip4BDVlcJyTtpgno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614932; c=relaxed/simple;
	bh=LMK9nYn7l7Zh0Oy9KPc9uTi3SFckS26yUP5TrQL/kxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p34RLmOzV6qNBOahcitVlo8CUqOPf+dItJAwkYQtulyemu0lblCJO/D7fX583k8CisIV+iCpkRCB//j1f1RrPrIVuJzbbdIiG8/lHXoCqAAA9f/kcVoZ4v0KEISEyEYB0sor7it5YHZizUxqtJzbF2VCuyN1k3GgvlEhKO29T4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpaz4nld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpaz4nld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C12BC4CEF1;
	Wed, 28 Jan 2026 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614931;
	bh=LMK9nYn7l7Zh0Oy9KPc9uTi3SFckS26yUP5TrQL/kxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpaz4nldn4Bg8qkD+XAgqOnxfmwGEG+2tzMIGGw8used+kiQ1TVsP6k0bnZpxc93g
	 mDuFRu4MalOJOygGyyrySXxmkEJl/Uo3mpH2EtGNyz+r+PR0D+RudBpfC9LCI6e/VC
	 A/XJETOQ03wBn33rZcr4+YhSgSZ2ROkXDkZbatss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/169] can: gs_usb: gs_usb_receive_bulk_callback(): unanchor URL on usb_submit_urb() error
Date: Wed, 28 Jan 2026 16:21:52 +0100
Message-ID: <20260128145335.071200175@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 79a6d1bfe1148bc921b8d7f3371a7fbce44e30f7 ]

In commit 7352e1d5932a ("can: gs_usb: gs_usb_receive_bulk_callback(): fix
URB memory leak"), the URB was re-anchored before usb_submit_urb() in
gs_usb_receive_bulk_callback() to prevent a leak of this URB during
cleanup.

However, this patch did not take into account that usb_submit_urb() could
fail. The URB remains anchored and
usb_kill_anchored_urbs(&parent->rx_submitted) in gs_can_close() loops
infinitely since the anchor list never becomes empty.

To fix the bug, unanchor the URB when an usb_submit_urb() error occurs,
also print an info message.

Fixes: 7352e1d5932a ("can: gs_usb: gs_usb_receive_bulk_callback(): fix URB memory leak")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/all/20260110223836.3890248-1-kuba@kernel.org/
Link: https://patch.msgid.link/20260116-can_usb-fix-reanchor-v1-1-9d74e7289225@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 1aa2f99f92b20..e63e77f21801c 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -751,6 +751,10 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	usb_anchor_urb(urb, &parent->rx_submitted);
 
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!rc)
+		return;
+
+	usb_unanchor_urb(urb);
 
 	/* USB failure take down all interfaces */
 	if (rc == -ENODEV) {
@@ -759,6 +763,9 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			if (parent->canch[rc])
 				netif_device_detach(parent->canch[rc]->netdev);
 		}
+	} else if (rc != -ESHUTDOWN && net_ratelimit()) {
+		netdev_info(netdev, "failed to re-submit IN URB: %pe\n",
+			    ERR_PTR(urb->status));
 	}
 }
 
-- 
2.51.0



