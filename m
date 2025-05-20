Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C1522C325;
	Tue, 20 May 2025 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749739; cv=none; b=minZxOapXpyNVPp3Lwgjyg4MoQ+aNkBNidbsGfq2YfPdlbuiwZiW/D0UNIMQSVBP4jsOlQdOiMHrLTYvbua1/oyFCc3pKWeXLhslncYzzl8cPunitWbUMC4LbBkxpMWH+A4PWh0JcbU9Sn4m+sBYBrxQ8vO0U69QEYufapl+rbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749739; c=relaxed/simple;
	bh=MA6Du0K6xcvZTgJloq9uI2AbAdwjqNL2qFXLgME0m5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4ILv6HV2/dZkz6dy3Tl/MoWvPkWgqYro/Pa/Yf7W7VvZ5ccDr53lRosGUG2bektkT4Pcv1Ow2BbmAtmHp+GQjBtv3R9JwNCf0jfJi0sXAZgZO30WMi9YitdekBzZlyCGfzp3t4dnZ3Paj34avgRIicHpb85e8IniRJucRM1L20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5JqLe1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5JqLe1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADF6C4CEE9;
	Tue, 20 May 2025 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749739;
	bh=MA6Du0K6xcvZTgJloq9uI2AbAdwjqNL2qFXLgME0m5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5JqLe1H+0vNKxeKzdeXWCCSVnhOD0EUsV3KssvbpBuizMR0dv/DmnQsGhhNFw9Wc
	 nwzGoN/J9j0lO7wBTvT352FXg+4Olli58EPLEyLIQXAvsemlxaI5/Kz7qIO+a/wSGN
	 m7L1h5KgEwxIx+/hel8DMHLQUtIcy8vt6Y/7vn0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Othacehe <othacehe@gnu.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/117] net: cadence: macb: Fix a possible deadlock in macb_halt_tx.
Date: Tue, 20 May 2025 15:50:09 +0200
Message-ID: <20250520125805.737598361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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
index 4325d0ace1f26..6f45f4d9fba71 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1016,22 +1016,15 @@ static void macb_update_stats(struct macb *bp)
 
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



