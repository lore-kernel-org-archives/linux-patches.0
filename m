Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED5618A6A5;
	Mon, 27 Oct 2025 19:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592597; cv=none; b=CRSDh/2m89LPVYgudDlVAL2Bu0ybUXCKkrya5QgpRyQLBK3z6Je4rnNACQ2s+jpLuSaOv4OIfw4SPaxuQBvuOsbTMmaO/RcTHPGiicu1bzkJQFk7ov51BLFigQmRkuZczJ1TZezanmZ9kkvmq0N5bO5kpKyFyJfF9yrm3SKaWZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592597; c=relaxed/simple;
	bh=9qtvyp0kWvUa3HTxHML+9nxY/UDWtKrrxQUKY7l3ehY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLwG9OGUO7j+3leXgm/pnpmln6kTrw8WJ0IWzwa3E0JoDktUTrXMT0pnAmmTA0v6pgMHky+hcPAhC9sCCvewAzg7H8DryisbEp7gbKOTmisdQ/iXG7qGTEakg+8VqKaC91p6km2zum1K8c4/mRRmjlkyo86vnksxjmoCnmFLeSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7UHLVY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7UHLVY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07528C4CEF1;
	Mon, 27 Oct 2025 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592596;
	bh=9qtvyp0kWvUa3HTxHML+9nxY/UDWtKrrxQUKY7l3ehY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7UHLVY/agh45x38k2l9IMPZhhNrLBYBPYOsG5LBastHZt9JVATZ3xjck/mK8XC89
	 we+0XGLxLCEoeYTYk41EvwFBI5W2obab1eX45YxAT5fT/VNdUboW7scREy4A3b6cmv
	 wM0mAU5gyzneArOOc1EWgOhULYtb12d2ylI/WpA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/84] can: bxcan: bxcan_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()
Date: Mon, 27 Oct 2025 19:36:12 +0100
Message-ID: <20251027183439.436283708@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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
index 49cf9682b9254..247d02447fc3f 100644
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



