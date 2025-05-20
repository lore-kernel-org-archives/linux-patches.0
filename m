Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829021FBE9E;
	Tue, 20 May 2025 14:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750113; cv=none; b=MeyMTlqganKcFxAOIWjRKT6EJSGTHVbkY+wHRxOFO7poDe9XruWGAZLbHJTNpAhAMLQYtLyowgbcPjcfIOnyJALj1JEeO6CA6UvNPskmMdV2b3oyTTGNmEGKVskEGCSWXDAJDzVcLvWseEoFATkiHezxiHrVXkMO2rQvhxtVzDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750113; c=relaxed/simple;
	bh=xHUdoYz8y099M3/J1htQJ04JtMEBaCvFxEPeuFp3daU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAF04V1VVgi4VWSkE1cC4LgWuYPxsSoZmerfupHnx6Ru6p8nWY32Cq0BpHRbD1c14unNf0plMYbWMdNpOp0PkrClTrklkmaHj7xvQ8XLRH5QMKMke6ot5NdhWyXlznn6GKs30L25qZRN7H/795cCY3tL6fRTWdq1YhtpTmviurE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6tdOAo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6tdOAo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1221BC4CEE9;
	Tue, 20 May 2025 14:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750113;
	bh=xHUdoYz8y099M3/J1htQJ04JtMEBaCvFxEPeuFp3daU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6tdOAo+tVLbEv/R9xxjPaH7seMUGyM69NluWrTCf+jjjfxXb+nCr5WxJ77+zFxqb
	 DPkNVwda2sjhS3o+N9nNNedqmxV5tjsL+hkkoQWo+l/z9JDUylvWSZxAgrsbmXNIJ4
	 /hpa3G3Ca2b+B5f/samFLJtvjbUNm4HP8ilaDu4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Othacehe <othacehe@gnu.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/143] net: cadence: macb: Fix a possible deadlock in macb_halt_tx.
Date: Tue, 20 May 2025 15:50:02 +0200
Message-ID: <20250520125811.897043541@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 60847cdb516ee..ae100ed8ed6b9 100644
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



