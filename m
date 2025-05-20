Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB6222D9E3;
	Tue, 20 May 2025 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750526; cv=none; b=ap0GKNDO8a7o7Gpmlm/t63noQ8kljcTa5On2cBdiFyo9bzUvVSKrfia88drlAVHcAgUAbfwE+hHpuJKMzFb9HmtGYZa7l0wO2AaZQxNdu4i5IDZpahGHWKjh7R8OdZd1xf0+CXlC1HJW0FB+uYgmZ+Grjbpk1muaSM50bev8qjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750526; c=relaxed/simple;
	bh=BR5xnlrYXxM4CEPLS+aS9CxsTmvQShPAQdTSuXZO8x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVJS8sHSMZkWttIryz8vTEvVWpmQEZA8n17hA+AMwjOKFK+iNTdP7XXROFZmWK4o/4QyDEtRR9M+az0QEfewsEuae8wd1dxB9W66vsyAA++9u9lJ5R1K+GWCDm7dp2IYHnW9O3lucUobrE+OfijJifY2duqDa3ttkYix15yhu1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsTf4gBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsTf4gBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AE1C4CEE9;
	Tue, 20 May 2025 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750526;
	bh=BR5xnlrYXxM4CEPLS+aS9CxsTmvQShPAQdTSuXZO8x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsTf4gBSqveansZQuC9CcW0TmnMKe25ZynI/H1n/E/hjCZ1OVH0cB4I5rrLGOU5BY
	 kcaejqW+dUq8vegBdOeTxc0mt5rApYazz/x21yIdWL9x5odKnwu+uZZiSEGqXU3TGr
	 MUE5Fm5/fEdXg3yp3+xJ6qP/mwr36LdTR1MhF4Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Othacehe <othacehe@gnu.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 036/145] net: cadence: macb: Fix a possible deadlock in macb_halt_tx.
Date: Tue, 20 May 2025 15:50:06 +0200
Message-ID: <20250520125811.979536876@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Othacehe <othacehe@gnu.org>

[ Upstream commit c92d6089d8ad7d4d815ebcedee3f3907b539ff1f ]

There is a situation where after THALT is set high, TGO stays high as
well. Because jiffies are never updated, as we are in a context with
interrupts disabled, we never exit that loop and have a deadlock.

That deadlock was noticed on a sama5d4 device that stayed locked for days.

Use retries instead of jiffies so that the timeout really works and we do
not have a deadlock anymore.

Fixes: e86cd53afc590 ("net/macb: better manage tx errors")
Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250509121935.16282-1-othacehe@gnu.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c1f57d96e63fc..e3cc26472c2f1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1002,22 +1002,15 @@ static void macb_update_stats(struct macb *bp)
 
 static int macb_halt_tx(struct macb *bp)
 {
-	unsigned long	halt_time, timeout;
-	u32		status;
+	u32 status;
 
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(THALT));
 
-	timeout = jiffies + usecs_to_jiffies(MACB_HALT_TIMEOUT);
-	do {
-		halt_time = jiffies;
-		status = macb_readl(bp, TSR);
-		if (!(status & MACB_BIT(TGO)))
-			return 0;
-
-		udelay(250);
-	} while (time_before(halt_time, timeout));
-
-	return -ETIMEDOUT;
+	/* Poll TSR until TGO is cleared or timeout. */
+	return read_poll_timeout_atomic(macb_readl, status,
+					!(status & MACB_BIT(TGO)),
+					250, MACB_HALT_TIMEOUT, false,
+					bp, TSR);
 }
 
 static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb, int budget)
-- 
2.39.5



