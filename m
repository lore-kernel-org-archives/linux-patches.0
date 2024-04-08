Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146A471B3D;
	Mon,  8 Apr 2024 13:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582177; cv=none; b=rrK68Zklf0hxIWwtT2E70a155de1CExE1rcPAGKipax8oJOavHDTct6MbCQobP4nHG+4x/5alEkaQ5XHwuUd29kQPtE05ZI7xLx6N0ZH07RyJSzPCqejgU6jpF6yFwnYDwMvfHo03SX/Q7mcQTGtKGnpFtlrsLbiRIB5bjz/be0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582177; c=relaxed/simple;
	bh=HI9f4Dr3JoQ0Q6hgGGWLKsiFoOgYzxxIEaPG7+/L/Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To7pljliKDbY6V0JNnN3SmpB248K88ZJyj48N3NN2EAeLwGCxnU/3uyzwik7Sax8qUE6xUsBpatla4v9IJFhxhFFEP81rRqmSdoseNyGS1HXov8s9zy+fC3rDqUuIDTVI7DspbaXYiOpFuEHwIZ5F3hrCNTGArLU22ymMCUHKck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJdHtCIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJdHtCIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87753C433C7;
	Mon,  8 Apr 2024 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582176;
	bh=HI9f4Dr3JoQ0Q6hgGGWLKsiFoOgYzxxIEaPG7+/L/Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJdHtCIfTMXQw5Dsh48ZDHPNuh0SPuvDgfDG627tObS5VgDig8gPt3m5AEl/JlNdW
	 ebDJpFJl/dolQPlleWSgQLtk+Eh+xP1+Jqcn/G7vJEN3RQ5XpNwYy2VAfIGG/JkXLk
	 r9IpNJCXAL7uoLIWBZ3zylWbPji0Bapje4iXUYJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/138] net: ravb: Always update error counters
Date: Mon,  8 Apr 2024 14:58:18 +0200
Message-ID: <20240408125258.838831119@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit 101b76418d7163240bc74a7e06867dca0e51183e ]

The error statistics should be updated each time the poll function is
called, even if the full RX work budget has been consumed. This prevents
the counts from becoming stuck when RX bandwidth usage is high.

This also ensures that error counters are not updated after we've
re-enabled interrupts as that could result in a race condition.

Also drop an unnecessary space.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20240402145305.82148-2-paul.barker.ct@bp.renesas.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b11cc365d19e3..756ac4a07f60b 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1309,6 +1309,15 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	netif_wake_subqueue(ndev, q);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* Receive error message handling */
+	priv->rx_over_errors = priv->stats[RAVB_BE].rx_over_errors;
+	if (info->nc_queues)
+		priv->rx_over_errors += priv->stats[RAVB_NC].rx_over_errors;
+	if (priv->rx_over_errors != ndev->stats.rx_over_errors)
+		ndev->stats.rx_over_errors = priv->rx_over_errors;
+	if (priv->rx_fifo_errors != ndev->stats.rx_fifo_errors)
+		ndev->stats.rx_fifo_errors = priv->rx_fifo_errors;
+
 	if (!unmask)
 		goto out;
 
@@ -1325,14 +1334,6 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Receive error message handling */
-	priv->rx_over_errors =  priv->stats[RAVB_BE].rx_over_errors;
-	if (info->nc_queues)
-		priv->rx_over_errors += priv->stats[RAVB_NC].rx_over_errors;
-	if (priv->rx_over_errors != ndev->stats.rx_over_errors)
-		ndev->stats.rx_over_errors = priv->rx_over_errors;
-	if (priv->rx_fifo_errors != ndev->stats.rx_fifo_errors)
-		ndev->stats.rx_fifo_errors = priv->rx_fifo_errors;
 out:
 	return budget - quota;
 }
-- 
2.43.0



