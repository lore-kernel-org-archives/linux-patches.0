Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24C12236EB;
	Tue, 30 Sep 2025 15:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245038; cv=none; b=fm1a+PK2QgUBuoyv+MTMjS+BUfTM7HsjZPbYzz219dtRzxshU60yN4mBUA44db9YIgWIF4PDo4r0TYo6bbGdgt9WG+st7U+RuNA/PgFQwS78IexSliTOoUeGNmzvbAs5SEA4m/PAnwbHeem33x5A630D3t+KZSG24cS15FtP9nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245038; c=relaxed/simple;
	bh=EfwP+73d/Rq+v93ATjheJL0XA9K44d5vY6+zzqoDCuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuP+yzikk3bCo4+9OIRfkE4DquKtzcgnxvKtVbvJwcchtpP5coxqiryooRwZgaPOSEnTQb1wsSTnXaoq9I/oZLr9w1UHV+CQAXV8aa/8FRkE1jbhLFx2ZR8HqUAPjx27tNNe84fDecTlB+WiurPJzpuL+6uAB4UkYD0dXjRPO3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miQrqRIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miQrqRIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07341C4CEF0;
	Tue, 30 Sep 2025 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245038;
	bh=EfwP+73d/Rq+v93ATjheJL0XA9K44d5vY6+zzqoDCuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miQrqRIXOnt4qRsI77he+coy329BpFahWTAUjF7mzEmg99VTeWxw8V5oWbA2E6MTR
	 Pjj/4f6LEMijL9nKE448U789Ic91JM5NKgUPOATcx+RWHGHlQifYbQsi4v64liz3Ke
	 IWlkKIJJHfvwJoxtbzGGDagNq3UHivhxsmxdk6NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anssi Hannula <anssi.hannula@bitwise.fi>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/151] can: xilinx_can: xcan_write_frame(): fix use-after-free of transmitted SKB
Date: Tue, 30 Sep 2025 16:46:16 +0200
Message-ID: <20250930143829.446929467@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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
index cb48598e32ad8..ac63e89397774 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -590,14 +590,6 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
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
@@ -630,6 +622,14 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
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



