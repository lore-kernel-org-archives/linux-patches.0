Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A0F32897A;
	Wed, 17 Sep 2025 12:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113860; cv=none; b=R2IF3riDQun5Dfc2Zz6OpipIbS39ywKgI2X14d69X2Wt8LHmkAndg74kf9CiJBz0qSvj9N5L7BUydC/tfRjHZweYa2s4NXOo2X2S5I1nMtFnxey2EPjqiKk3eDS7vA2ef0RDl37bCwihXmumjSdwahhTja+S5x8giKoax7Xqo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113860; c=relaxed/simple;
	bh=xq8cHzJyV0c9NrnESeE4GLmZgaF5TTK3J/binAlVerc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0FDECbbSjV9XHkvx8LI0Kwg8Uju11/flQf9SsBarlNf9kcixKRpHm/8P7LtyrgfUnDrriaA8Zj9eXvRRYJd27Hnmu9CWD4Hu4pfLEFVUym5C7BSnjN+1c/jwkvKzWl7TCiKMghUe+LAnt+KgS5leeErEeL+Gxzm66yTWvJ06GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQqQi0Ej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQqQi0Ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D89C4CEF0;
	Wed, 17 Sep 2025 12:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113860;
	bh=xq8cHzJyV0c9NrnESeE4GLmZgaF5TTK3J/binAlVerc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQqQi0Ejrw3o+0nS1Q89lTxv9FYqyTMydaYJbZfpCY1kPUXHR32C4NmnVQkMJl5v+
	 olm4t+yonNFgN4DkWVCSl0ZmDhHpSKRUoi7gnO+hMkonA3m4q6AfQ9vfrSKfyzAxBD
	 AmWfxKit6KXA1CKOOSkMtKDMreDqtLuX7/HKJUSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anssi Hannula <anssi.hannula@bitwise.fi>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/101] can: xilinx_can: xcan_write_frame(): fix use-after-free of transmitted SKB
Date: Wed, 17 Sep 2025 14:34:59 +0200
Message-ID: <20250917123338.674170411@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Anssi Hannula <anssi.hannula@bitwise.fi>

[ Upstream commit ef79f00be72bd81d2e1e6f060d83cf7e425deee4 ]

can_put_echo_skb() takes ownership of the SKB and it may be freed
during or after the call.

However, xilinx_can xcan_write_frame() keeps using SKB after the call.

Fix that by only calling can_put_echo_skb() after the code is done
touching the SKB.

The tx_lock is held for the entire xcan_write_frame() execution and
also on the can_get_echo_skb() side so the order of operations does not
matter.

An earlier fix commit 3d3c817c3a40 ("can: xilinx_can: Fix usage of skb
memory") did not move the can_put_echo_skb() call far enough.

Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Fixes: 1598efe57b3e ("can: xilinx_can: refactor code in preparation for CAN FD support")
Link: https://patch.msgid.link/20250822095002.168389-1-anssi.hannula@bitwise.fi
[mkl: add "commit" in front of sha1 in patch description]
[mkl: fix indention]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/xilinx_can.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index abe58f1030433..57d1209134f11 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -628,14 +628,6 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
 		dlc |= XCAN_DLCR_EDL_MASK;
 	}
 
-	if (!(priv->devtype.flags & XCAN_FLAG_TX_MAILBOXES) &&
-	    (priv->devtype.flags & XCAN_FLAG_TXFEMP))
-		can_put_echo_skb(skb, ndev, priv->tx_head % priv->tx_max, 0);
-	else
-		can_put_echo_skb(skb, ndev, 0, 0);
-
-	priv->tx_head++;
-
 	priv->write_reg(priv, XCAN_FRAME_ID_OFFSET(frame_offset), id);
 	/* If the CAN frame is RTR frame this write triggers transmission
 	 * (not on CAN FD)
@@ -668,6 +660,14 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
 					data[1]);
 		}
 	}
+
+	if (!(priv->devtype.flags & XCAN_FLAG_TX_MAILBOXES) &&
+	    (priv->devtype.flags & XCAN_FLAG_TXFEMP))
+		can_put_echo_skb(skb, ndev, priv->tx_head % priv->tx_max, 0);
+	else
+		can_put_echo_skb(skb, ndev, 0, 0);
+
+	priv->tx_head++;
 }
 
 /**
-- 
2.51.0



