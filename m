Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5FD30F534;
	Mon, 27 Oct 2025 19:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592880; cv=none; b=u5K4swGcfNNW0pnC2vm5qfYAqUe86hnzIsWSyOa0kPd6rFluQd5IJCSffj9fuqwRxkotzvh+M2/PXXlqAaUcF/Q9JbxAYPsgcwPiujuHmthRfKQPcx2iAdwvqIvkQDvHgJv6MCkj8QFtMqHBRpc45a6Y+s6TKEPsIHSULxz1Bwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592880; c=relaxed/simple;
	bh=UoSIvBjiFjFvpbXSgWK+FJZZ7/QHzys1MCD8wI5J2RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtBFO680Y3D7OE3csnjGYw3halNgWUIxzy0xY9VqAjLveSKCBW3TtM2WNDzn6t0KuZ6HDhQyUE5DPy6tcyvSSyxa85lY3hcXzoEx2ztbde65vAG+cE+1nt+ynavW8HOmpMiFP3cfKW13dgK6ugazfwCnJfkoOyvjMfofpL+6Q+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZ9fahMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZ9fahMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C4AC4CEF1;
	Mon, 27 Oct 2025 19:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592880;
	bh=UoSIvBjiFjFvpbXSgWK+FJZZ7/QHzys1MCD8wI5J2RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZ9fahMM2HJnMw0Amnd0giIn8VGANvpBoy57aFY499nM0c9M5SamB5vBBektiDaJ4
	 +Lvh35/BjXFD/8G4eJRFNIc+2SS4HqsMwPvqjk5B5CdknK9fV36UBZXhw1qS0D23gX
	 voW7Gyg9LftpX+o7W+/QQTJtNbubn+o0co4nUlIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/117] can: bxcan: bxcan_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()
Date: Mon, 27 Oct 2025 19:35:56 +0100
Message-ID: <20251027183454.784129071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

[ Upstream commit 3a20c444cd123e820e10ae22eeaf00e189315aa1 ]

In addition to can_dropped_invalid_skb(), the helper function
can_dev_dropped_skb() checks whether the device is in listen-only mode and
discards the skb accordingly.

Replace can_dropped_invalid_skb() by can_dev_dropped_skb() to also drop
skbs in for listen-only mode.

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Closes: https://lore.kernel.org/all/20251017-bizarre-enchanted-quokka-f3c704-mkl@pengutronix.de/
Fixes: f00647d8127b ("can: bxcan: add support for ST bxCAN controller")
Link: https://patch.msgid.link/20251017-fix-skb-drop-check-v1-1-556665793fa4@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/bxcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
index bfc60eb33dc37..333ad42ea73bc 100644
--- a/drivers/net/can/bxcan.c
+++ b/drivers/net/can/bxcan.c
@@ -842,7 +842,7 @@ static netdev_tx_t bxcan_start_xmit(struct sk_buff *skb,
 	u32 id;
 	int i, j;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (bxcan_tx_busy(priv))
-- 
2.51.0



