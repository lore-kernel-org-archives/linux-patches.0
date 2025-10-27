Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1893277AF;
	Mon, 27 Oct 2025 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593174; cv=none; b=BKQ5Pxpbc8xMLcWjTpVqaE3420HYgMzsLrIsCmx3ej7rrkdXFVepmOfokGvckKbY27WS1TQaKaiZ2bterGWm8OGt9FhTZrE1v7d6NXgdg5yO+e7yJJ7ZR25RaSNPLO4V2miTyXs7tGsYqIffH088fuqVmPqyIrXoROeowuUSZ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593174; c=relaxed/simple;
	bh=KOpsgQw9aw4uCEkT9m3yTCDeOWnR2V7Igq2354zLl+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErpsD5805g/0IfOg8IpHe6LJdSZwFiz0ozPKY08aDgKQ38NLQQeBqmuMU3m6SIvHt0EIB8kCzPJ6SW63uxFswGHrT2EwoxfXSDA3LWejQzZFjy2heYrF53t+Xrkq788QqVPt401DkBegNMvHOt5ecBsLYE78UAP3U+8APciqwYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Un7intwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Un7intwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D72CC4CEF1;
	Mon, 27 Oct 2025 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593174;
	bh=KOpsgQw9aw4uCEkT9m3yTCDeOWnR2V7Igq2354zLl+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Un7intwH6WzOfpUIXQgu1a4AG59yg5JLFGCgGZgmaVQ96CoQckCFvgxu6ikSk7B//
	 rDFoootBZVQedxg4sP3wvVBgPF0ivHVNB7glaOLFygyTHWEkfVLsoBm0DSJKXqEc0y
	 ZLA8tpNT/o8vCb/AZLlCRmFo2fq1DhFqJIAlPm7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 042/184] can: bxcan: bxcan_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()
Date: Mon, 27 Oct 2025 19:35:24 +0100
Message-ID: <20251027183516.041636946@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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



