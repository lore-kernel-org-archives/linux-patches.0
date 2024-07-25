Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D9027473;
	Thu, 25 Jul 2024 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918935; cv=none; b=ATMK0Lgi6kUj8+ebO4uPmef6vWuwZxfwOihdflYDk/8ufIUBHywufxi6RrxSDsgFyD2rkHzEtUGNxLH+za9X7sqK+qNcUmHBnz9UupXLVJiRYrS2OzPAXhxdct5VnaAr/OSIkKp3tnLziEzvTnAfC5nqXQehFKL0DoRkFIqRd04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918935; c=relaxed/simple;
	bh=eR/HgKutPIGdRwtRPxK9t4VXr8j53kGSinUWb4vHFz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3ZEpHDGLgh2R8nGFxsXZ+9Ul9Lg7JUqnU3PfXefIo98TUJ4UNkXcf+hJoX6SMbGVacW6bgrmxqU4SGN+qf7HuewYh15XDm6UC9QXl9vFwUlqNdBQDDtaEnfTV+evVDB+G3omV8iJQGmg6TTLGsqb+HoODA4AGeg6dco6a5EsQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wt5YmRwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wt5YmRwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B0EC116B1;
	Thu, 25 Jul 2024 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918935;
	bh=eR/HgKutPIGdRwtRPxK9t4VXr8j53kGSinUWb4vHFz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wt5YmRwgjJF6xYTnduiW+q8WtwIQDmTIMdjNZkuNRJTYkEgYLsqFvqBrI9LKEWZxb
	 uEOA5FMaKKrdoJaCrKY9m1pwJDephDrRdiItTOOVgHOyA4pyYLkHnisqhm/zZdLPtV
	 iLLs6CNDuk3oybHI5kYv2xLCfPxH2NlhK+HTKSAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunshui Jiang <jiangyunshui@kylinos.cn>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/59] net: mac802154: Fix racy device stats updates by DEV_STATS_INC() and DEV_STATS_ADD()
Date: Thu, 25 Jul 2024 16:37:24 +0200
Message-ID: <20240725142734.554136887@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunshui Jiang <jiangyunshui@kylinos.cn>

[ Upstream commit b8ec0dc3845f6c9089573cb5c2c4b05f7fc10728 ]

mac802154 devices update their dev->stats fields locklessly. Therefore
these counters should be updated atomically. Adopt SMP safe DEV_STATS_INC()
and DEV_STATS_ADD() to achieve this.

Signed-off-by: Yunshui Jiang <jiangyunshui@kylinos.cn>
Message-ID: <20240531080739.2608969-1-jiangyunshui@kylinos.cn>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index c829e4a753256..7cea95d0b78f9 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -34,8 +34,8 @@ void ieee802154_xmit_worker(struct work_struct *work)
 	if (res)
 		goto err_tx;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	DEV_STATS_INC(dev, tx_packets);
+	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 
 	ieee802154_xmit_complete(&local->hw, skb, false);
 
@@ -86,8 +86,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 			goto err_tx;
 		}
 
-		dev->stats.tx_packets++;
-		dev->stats.tx_bytes += len;
+		DEV_STATS_INC(dev, tx_packets);
+		DEV_STATS_ADD(dev, tx_bytes, len);
 	} else {
 		local->tx_skb = skb;
 		queue_work(local->workqueue, &local->tx_work);
-- 
2.43.0



