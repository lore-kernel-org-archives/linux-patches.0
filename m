Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE37B2F7ADF;
	Wed,  3 Dec 2025 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780324; cv=none; b=V0r7h9KO2FgDY05Vdx27KNTgY+O+O6ALNisrcrfwrmdJcF6w8KuG6WReOYV7PUCywpuQMqWMPmbQJ1niyeiX4md2HugQh1w65t5fa5//m1O93MEVIGHnuiWt2ShzC6howWka+17w6KkXZ/vp90d9gGIxc9hrmronZNM7D8qUfOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780324; c=relaxed/simple;
	bh=rU0bQKg7HhRWfgYcjt+d/j+m67Zu/zb9U8mAg+Mvn/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nm+2LxuCI6HdqmI63Amo406p2UX8slrJIp9pQcp9pTyL63axjJwwE9UUQpjch0W8/dfqceShV2KBeaQy17p8BwMHEeM90ZRchHrqeRcaTTDgKTNajs3pPq8xQLmMqHnBJKGSaKqdmYtnaEKyIgnpi1MGcVuKOORErYcwao/ZeWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEeLwl/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEeLwl/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE506C4CEF5;
	Wed,  3 Dec 2025 16:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780323;
	bh=rU0bQKg7HhRWfgYcjt+d/j+m67Zu/zb9U8mAg+Mvn/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEeLwl/d2wn4y329W+bMRGOiYYRct/DRIGDzOPS2M2BHGVfK4GsuhU0olAdV34Hkm
	 wCbsW5QOhJh0MqxMg2UKcG0gybGMxgPpMUi34WO30nUzWSaPWrOdD2pu0AHc2Xs3hu
	 WdACq563Cj/ojbURz0ndYoc1z3TM9UIKH6TVXnPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 495/568] can: gs_usb: gs_usb_receive_bulk_callback(): check actual_length before accessing header
Date: Wed,  3 Dec 2025 16:28:17 +0100
Message-ID: <20251203152458.845320922@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 6fe9f3279f7d2518439a7962c5870c6e9ecbadcf ]

The driver expects to receive a struct gs_host_frame in
gs_usb_receive_bulk_callback().

Use struct_group to describe the header of the struct gs_host_frame and
check that we have at least received the header before accessing any
members of it.

To resubmit the URB, do not dereference the pointer chain
"dev->parent->hf_size_rx" but use "parent->hf_size_rx" instead. Since
"urb->context" contains "parent", it is always defined, while "dev" is not
defined if the URB it too short.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://patch.msgid.link/20251114-gs_usb-fix-usb-callbacks-v1-2-a29b42eacada@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 7fe9d497491d1..5d0cee57ab970 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -252,13 +252,15 @@ struct canfd_quirk {
 } __packed;
 
 struct gs_host_frame {
-	u32 echo_id;
-	__le32 can_id;
+	struct_group(header,
+		u32 echo_id;
+		__le32 can_id;
 
-	u8 can_dlc;
-	u8 channel;
-	u8 flags;
-	u8 reserved;
+		u8 can_dlc;
+		u8 channel;
+		u8 flags;
+		u8 reserved;
+	);
 
 	union {
 		DECLARE_FLEX_ARRAY(struct classic_can, classic_can);
@@ -528,6 +530,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	int rc;
 	struct net_device_stats *stats;
 	struct gs_host_frame *hf = urb->transfer_buffer;
+	unsigned int minimum_length;
 	struct gs_tx_context *txc;
 	struct can_frame *cf;
 	struct canfd_frame *cfd;
@@ -546,6 +549,15 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		return;
 	}
 
+	minimum_length = sizeof(hf->header);
+	if (urb->actual_length < minimum_length) {
+		dev_err_ratelimited(&parent->udev->dev,
+				    "short read (actual_length=%u, minimum_length=%u)\n",
+				    urb->actual_length, minimum_length);
+
+		goto resubmit_urb;
+	}
+
 	/* device reports out of range channel id */
 	if (hf->channel >= parent->channel_cnt)
 		goto device_detach;
@@ -642,7 +654,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 resubmit_urb:
 	usb_fill_bulk_urb(urb, parent->udev,
 			  parent->pipe_in,
-			  hf, dev->parent->hf_size_rx,
+			  hf, parent->hf_size_rx,
 			  gs_usb_receive_bulk_callback, parent);
 
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
-- 
2.51.0



