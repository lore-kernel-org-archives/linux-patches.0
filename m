Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50612449ECB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301153; cv=none; b=eY7FOUyiJslll/SnON0sDosTwY1x92g/iaeVuL54vVpqVpng2Y1XI2XkbbGQYJyeKjc3GXUyqc6WKFQ5NpHiu23EPfCfAfo8U2RDA4fXhwPaacnuAysD6/XeyOAApRfG1fh63SO4GT6Ys/cDrKrX2co6Myl0lf/PtSc3VOJyotQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301153; c=relaxed/simple;
	bh=XEa/VH/PEJZzdsCFQkRXMz14ayIsfwmMUepq86+UQWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PAyLdfYwa6pYJJ5EAvIhfuIhyPY227iPG+pS3YTBi6ig2f/Hc5qvWSwlVPiIH+gpQeYA3PV9FP8fSyYUMe8U3PNp4BuBpsNDYU0E/nVUhKw6RYEIURVzrRxJzEVXvxVDnZk2CHQXN0QzHlfQg+DF3Xy0yC24zh+cKPxgjyKpRRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVRFNrSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVRFNrSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF10FC116D0;
	Sat, 28 Feb 2026 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301153;
	bh=XEa/VH/PEJZzdsCFQkRXMz14ayIsfwmMUepq86+UQWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVRFNrSSWSCKEdkX5TffvvxHZp/OZqUPrWwSY5Xp+1n6bAG6yeYKlTO6eyLRfTbhe
	 y60If0wR2DOXj4JLtK6D+WreSwqMCS/HgVaqYhzRWxqvUcrfvk2BQ/peQcaetgHi5+
	 1BKn18IWAF4RCiffEqs/l2VHuC27e0QrXe5Tc0WmvYJ9EfmFnbR8L8AwDhnrfRp8sK
	 Nok9gsrdDotEdZg3UOdZOIpFv8bHN8amzhSzWxEeojlbIZ+yEimGbT+MjrD1eJ/6DU
	 AEA0AH5lGuAAT9c3vMXMX45cwQP4LK6rwnvddvZES0dSyHfSflrz1FJjAx+i2RD2VO
	 +814EylCiaYzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Otto=20Pfl=C3=BCger?= <otto.pflueger@abscue.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 316/752] mailbox: sprd: clear delivery flag before handling TX done
Date: Sat, 28 Feb 2026 12:40:27 -0500
Message-ID: <20260228174750.1542406-316-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Otto Pflüger <otto.pflueger@abscue.de>

[ Upstream commit c77661d60d4223bf2ff10d409beb0c3b2021183b ]

If there are any pending messages in the mailbox queue, they are sent
as soon as a TX done event arrives from the driver. This may trigger a
new delivery interrupt while the previous one is still being handled.
If the delivery status is cleared after this, the interrupt is lost.
To prevent this from happening, clear the delivery status immediately
after checking it and before any new messages are sent.

Signed-off-by: Otto Pflüger <otto.pflueger@abscue.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/sprd-mailbox.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/sprd-mailbox.c b/drivers/mailbox/sprd-mailbox.c
index c1a5fe6cc8771..46d0c34177ab9 100644
--- a/drivers/mailbox/sprd-mailbox.c
+++ b/drivers/mailbox/sprd-mailbox.c
@@ -166,6 +166,11 @@ static irqreturn_t sprd_mbox_inbox_isr(int irq, void *data)
 		return IRQ_NONE;
 	}
 
+	/* Clear FIFO delivery and overflow status first */
+	writel(fifo_sts &
+	       (SPRD_INBOX_FIFO_DELIVER_MASK | SPRD_INBOX_FIFO_OVERLOW_MASK),
+	       priv->inbox_base + SPRD_MBOX_FIFO_RST);
+
 	while (send_sts) {
 		id = __ffs(send_sts);
 		send_sts &= (send_sts - 1);
@@ -181,11 +186,6 @@ static irqreturn_t sprd_mbox_inbox_isr(int irq, void *data)
 			mbox_chan_txdone(chan, 0);
 	}
 
-	/* Clear FIFO delivery and overflow status */
-	writel(fifo_sts &
-	       (SPRD_INBOX_FIFO_DELIVER_MASK | SPRD_INBOX_FIFO_OVERLOW_MASK),
-	       priv->inbox_base + SPRD_MBOX_FIFO_RST);
-
 	/* Clear irq status */
 	writel(SPRD_MBOX_IRQ_CLR, priv->inbox_base + SPRD_MBOX_IRQ_STS);
 
-- 
2.51.0

