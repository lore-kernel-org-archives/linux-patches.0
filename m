Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E815D4F403A;
	Thu, 17 Sep 2026 17:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667073; cv=none; b=WA8/tnPtEyfDFqWC+KW8kpzNRFlbWKXJnaWG0uDrJWzzrsfV0xEK9cX0hlUEolplUiiDJL27Ku8UKHkvv40wooi8s2HSHmar0e9+kU6Bp3bE1F9pfHW8XdSLvEcq4DqFS4acApHdyYyK1TCTb79eXcunDvM4SHAYudqFSwOJStc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667073; c=relaxed/simple;
	bh=mCDueY0rXMqKXqGvAvnnjX2BLzAWgM7A6cpArD21Lvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9oZS+txwNtZBlIqtWudzzd3+PeZvTbNugem6uOtOrqXDCjfnv4mdXV7eaEq53cL9wqTU8HceHy9DbVUcDshQpUhKP0mt8Dl57jpT292HTZ/2oPv8x19XM20L1XND5OSgACzo9e+CPLdI6gpYY6PDwAyb6eUc4RDMeh+uhIvzVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CThwF9JM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CThwF9JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D651F000FF;
	Thu, 17 Sep 2026 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667071;
	bh=FUaLRSsaz6IKRSnhLQqMqo9VvWya7hG8jDpPa991hP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CThwF9JM/CBN5HTFYkxkDgliW5NXT2+DpU33oRpyxO+hSUM1+1T2iUbYGib6t9wPn
	 ajD5njW7HLrGEbno2hmhBJ99EPYcVVeFZJQRkDvf4WBd2BTGUbNdUJN2Bx9xDfMgLJ
	 PAx7HiubPbyCze5wVppRV60BKxo7BcuOcxd/cdYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1218/1250] net: macb: Replace open-coded implementation with napi_schedule()
Date: Thu, 17 Sep 2026 16:16:53 +0100
Message-ID: <20260917151625.299726505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit dc3bd465ea36af7fd6f9197c05353effc616145c ]

The driver currently duplicates the logic of napi_schedule() primarily
to include additional debug information. However, these debug details
are not essential for a specific driver and can be effectively obtained
through existing tracepoints in the networking core, such as
/sys/kernel/tracing/events/napi/napi_poll. Therefore, this patch
replaces the open-coded implementation with napi_schedule() to
simplify the driver's code.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Link: https://patch.msgid.link/20260402-macb-irq-v2-1-942d98ab1154@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e1406330d70e ("net: macb: initialize PTP state before registering clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2010,10 +2010,7 @@ static irqreturn_t macb_interrupt(int ir
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 				queue_writel(queue, ISR, MACB_BIT(RCOMP));
 
-			if (napi_schedule_prep(&queue->napi_rx)) {
-				netdev_vdbg(bp->dev, "scheduling RX softirq\n");
-				__napi_schedule(&queue->napi_rx);
-			}
+			napi_schedule(&queue->napi_rx);
 		}
 
 		if (status & (MACB_BIT(TCOMP) |
@@ -2028,10 +2025,7 @@ static irqreturn_t macb_interrupt(int ir
 				wmb(); // ensure softirq can see update
 			}
 
-			if (napi_schedule_prep(&queue->napi_tx)) {
-				netdev_vdbg(bp->dev, "scheduling TX softirq\n");
-				__napi_schedule(&queue->napi_tx);
-			}
+			napi_schedule(&queue->napi_tx);
 		}
 
 		if (unlikely(status & (MACB_TX_ERR_FLAGS))) {


