Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB5C13B7A3;
	Wed, 28 Jan 2026 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614390; cv=none; b=UzLfAPyAXgn9/n5NZ+XsXyPKDoxr5wHFuGIXE7RA4ki99hnBHVy8nGJSGIuemxbBbhb8FwqTzVSGMObeL7rYCcBkWu33Svku43Zr1qhadK6GbvLwIrHXj1niLGB6Zw5O5LknDR6StEG+eCeqbsyVjJG5fOHby0NHmzKJjR+3E9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614390; c=relaxed/simple;
	bh=1RXEL9p21Zf1EHejfvjffNU383UngfL6ZKbCxesdQ3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sa4GwMKNyjCRcw6npTkQVwzkEbxxKYOfhp//DkbACCBGJ3qhFQJC6xk20npe9++tnpVmmjrPzukdBo+SrrGs3o3jhzH0F2k2dEr1gjO79fI32tO5VaqNpNyXQstsL2W40OvNkdbCezjsGHPWO2LVyuQOVBi6uSKcUZrk5OLaaIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0cZkQwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0cZkQwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158B4C16AAE;
	Wed, 28 Jan 2026 15:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614390;
	bh=1RXEL9p21Zf1EHejfvjffNU383UngfL6ZKbCxesdQ3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0cZkQwKg1oKNOvB+0jQBXSWHkkdwasgf5wQXsoqp0mcfl9G90mx/QhKZAprEKjnq
	 Ac39am652cEIPnuP5wNtBt/Rsj9ETUuMK3RTdQdoWk4XWZykR54ac+ko1itNzIbsXL
	 C+DhAkoHQ3IFiqZMckBsMiGmFFFYOMeUeD2yFyWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/254] can: gs_usb: gs_usb_receive_bulk_callback(): unanchor URL on usb_submit_urb() error
Date: Wed, 28 Jan 2026 16:21:38 +0100
Message-ID: <20260128145349.213417319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d3837252e505a..63439affd59d5 100644
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



