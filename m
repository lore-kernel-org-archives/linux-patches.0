Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71671CAA6C;
	Sat, 30 May 2026 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159999; cv=none; b=eJyi70AU39EwvH29LtAXaExEEczfxLudFKWdcSbZpdlW7JI/LLynpNMBcvrLdosId0C/tIvmE2x7y8m1lfUF/JcF5GgsrSVLKw0tkoJzLQUhcggvUtKoijPQycQIX78eKFug7foaMDZrUDCj+5Zfzo1OOGdUjwAuoqFBvoHf2Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159999; c=relaxed/simple;
	bh=ycY61AzbEEY8Wih3A3m7AfkPLmwmQZbGF7WqRcXhvgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9W/BjHJZ3d/QBGuDgFm6A1zi0quumPrrvRsOanz0t3sIL0K3wFohpiA/VXb3FYVKKfu5ZyCNuFAjXyhTtNNhPo6sIJR1fll3qBWHZhK1E6yx4v80gzbYhRaFjEruTmLZpGB1Y4oORg59BrlDNo4WkQROH3/eBR6MmLbEs4cp1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPLjx5cY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPLjx5cY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120DA1F00893;
	Sat, 30 May 2026 16:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159998;
	bh=fcoC9tqUSVWc0BPSzsHCgJiywClsS4a7mWZ5Lt1ax7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPLjx5cY6zumlS9QVCZ5b0SkMqrvO/6mSror3h9ihmyzQnsf35H2YKvAr+qXd5tcb
	 sX8Frv9s0Zdgdb7lYUj9CxlrS/PuyK6IhclokUbsLsbdhlJG/JaD/W2s5axgxj7EIV
	 MAHrONbhGHk6vuyRxH+0TuJwK0Fd508GwuxakMCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Vasut <marex@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 217/969] net: ks8851: Avoid excess softirq scheduling
Date: Sat, 30 May 2026 17:55:41 +0200
Message-ID: <20260530160306.446848279@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

commit 22230e68b2cf1ab6b027be8cf1198164a949c4fa upstream.

The code injects a packet into netif_rx() repeatedly, which will add
it to its internal NAPI and schedule a softirq, and process it. It is
more efficient to queue multiple packets and process them all at the
local_bh_enable() time.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: e0863634bf9f ("net: ks8851: Queue RX packets in IRQ handler instead of disabling BHs")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260415231020.455298-2-marex@nabladev.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/micrel/ks8851_common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -389,9 +389,12 @@ static irqreturn_t ks8851_irq(int irq, v
 	if (status & IRQ_LCI)
 		mii_check_link(&ks->mii);
 
-	if (status & IRQ_RXI)
+	if (status & IRQ_RXI) {
+		local_bh_disable();
 		while ((skb = __skb_dequeue(&rxq)))
 			netif_rx(skb);
+		local_bh_enable();
+	}
 
 	return IRQ_HANDLED;
 }


