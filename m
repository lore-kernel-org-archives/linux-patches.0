Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66871322DC1;
	Wed,  3 Dec 2025 15:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776931; cv=none; b=BGz/InIrXwp4scpiCE8Jk3ZLkpglkTDY5zUCwr3C7YwH25pAGdF47qlJBgA39oETV29ubbyq4mxiWvPH1MP1+DY3GFpJXPhuYWHcOShUUrrQd+OUsdqRzpSH9exOx2JlWIA90qX/ADzBkvww16c14yPKM9lEtbXP1MgtongysEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776931; c=relaxed/simple;
	bh=gYiJFb53ThhYc0qUMPYfRulrVJ8mG74zj6dRb5sEiOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGzIim9w/YqzozGFg0gMTV8L0y2x8dl/jLHQJd3yibtzeTLKuA9LIQvhyoMgtFKC7lDgttdte14wqkM+WC8MDTeDisDzQC1QVpd6y0+A8BAwTuD/t8hjO3+/GCrYlboxXDUfMtDwXy2GnAKAVJdRAQPVrUB3hDALC9JGDFm1ys8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dls2rMtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dls2rMtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71842C4CEF5;
	Wed,  3 Dec 2025 15:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776930;
	bh=gYiJFb53ThhYc0qUMPYfRulrVJ8mG74zj6dRb5sEiOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dls2rMtkHGibcdw2WivIAERJIXDsaxhSLPUaJcHQKMCXy435Znz8+HkXBngLbw3yW
	 onCqffHrixuQlCgeQHlrm13RCl1RVQEAOuKqQfArjU5k26YihpUDCd9zGFwkRDiluH
	 R8wU2nsvynWbQXxKtITwsHlc764jztLX1zok6MhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 003/146] can: gs_usb: gs_usb_receive_bulk_callback(): check actual_length before accessing header
Date: Wed,  3 Dec 2025 16:26:21 +0100
Message-ID: <20251203152346.588107764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index fa9bab8c89aea..51f8d694104d9 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -262,13 +262,15 @@ struct canfd_quirk {
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
@@ -576,6 +578,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	int rc;
 	struct net_device_stats *stats;
 	struct gs_host_frame *hf = urb->transfer_buffer;
+	unsigned int minimum_length;
 	struct gs_tx_context *txc;
 	struct can_frame *cf;
 	struct canfd_frame *cfd;
@@ -594,6 +597,15 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
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
@@ -687,7 +699,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 resubmit_urb:
 	usb_fill_bulk_urb(urb, parent->udev,
 			  parent->pipe_in,
-			  hf, dev->parent->hf_size_rx,
+			  hf, parent->hf_size_rx,
 			  gs_usb_receive_bulk_callback, parent);
 
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
-- 
2.51.0



