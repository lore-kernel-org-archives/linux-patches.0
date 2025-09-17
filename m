Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434CF288DA;
	Wed, 17 Sep 2025 13:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114143; cv=none; b=rh/I0zBkcFiEtAMyk3pYidi44WXpW9DDTnql7xgvWL2LJ6gHaGQWH3ekJNC0okuYp/wLdV3TqGFMcy4GXahu2Ye7HsSqoNlyFJY+W6MR3GS4c3Gyb7h7UVIsfomVTLmYi4cG1c1TnNwQnL7c1KTbk0hFTZUq3aGjufDh1CfzKyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114143; c=relaxed/simple;
	bh=ix8hU52bXcN+QpQUQ6zE3+jS2lQReXGgeb4fHC4y0qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxN+aU+C5+LLJJ+UmX6nW74QEJVxEiNjaFH1WnfJoG6DC1rBwMxa/zV5gVkS3gqCT21ozKbN77prkanLWGg0oDyXSP7t7xHMofOcx9g07t6zLCWQ7DukZKGWHXl/v1Duhvu8/EFknYl9Tw8JqqkCWxnVidTwCe6K6m5UWYA75g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffEVJdkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffEVJdkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AC8C4CEF0;
	Wed, 17 Sep 2025 13:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114143;
	bh=ix8hU52bXcN+QpQUQ6zE3+jS2lQReXGgeb4fHC4y0qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffEVJdknqwwqRuiEX4kpzKMxlEQMBRda1p1o843288m1kLqpgTHuYAdgCfxWmf7pd
	 e5mZ/DGAVMbxaLdw0ORBtB1K2s6zLi+AaBMl/0qBll/x/TQZ+WFO033QBB443le6Of
	 sikZrfBxXHxT1Keaj3fJt92k+yjw/y7gS+e8+UGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anssi Hannula <anssi.hannula@bitwise.fi>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/78] can: xilinx_can: xcan_write_frame(): fix use-after-free of transmitted SKB
Date: Wed, 17 Sep 2025 14:35:19 +0200
Message-ID: <20250917123330.987337425@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 43c812ea1de02..7d8dc36c9bbd8 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -622,14 +622,6 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
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
@@ -662,6 +654,14 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
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



