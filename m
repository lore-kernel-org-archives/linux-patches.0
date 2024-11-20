Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA5E1991AA;
	Wed, 20 Nov 2024 13:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107663; cv=none; b=X8T9Xaphi318UtEN8SRu9N1m5ZyuEIXdaqzCB8OV9JJQL9gJ6gxDLei7/S+LAYnWa6F8NZ01yGAHhwGihktQzuDQPtBg5xXDE9OPmcUTyD7einihuIZ+eLm7lxY9ZexquJsnsAY90DYKRE7DKIwukkWxXgDG67HuVz7alx0bN5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107663; c=relaxed/simple;
	bh=LkMiofSHvhPo+YzgLmiW26Ro6FIU8mLzpLmRl/DdSB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWWlp4ArAXYEiCA+4CjGsY41n63nWaB5GEqJUJnlczD5zlWpGFL0/1BFB0jQNdCygLmooN2JcqjBXMgMHN7jkCXLvsC8E2smrdrZVUA4ITx4du2yLpmta3SL7uFMQOJfKrHwDF3BQu42fKoUMrNfj18Opw3km3ryvnMK9JzjRkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUa/zhD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUa/zhD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BA6C4CED6;
	Wed, 20 Nov 2024 13:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107663;
	bh=LkMiofSHvhPo+YzgLmiW26Ro6FIU8mLzpLmRl/DdSB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUa/zhD7pi134Yh/7tmM+3S4khW89d1QnkqvPi1xHTqucjksjNoVcFB+IM+BJmvoJ
	 QeNjxQluk1Rphc0PQfCZzORV6XA1Ytho/ix/rKUAXCE15dvgW+502tRixVDWTm+e+B
	 YOqdaw/RkfWTYsQtorbKG0VVZpZKsG9YanR1+z+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/73] net: vertexcom: mse102x: Fix tx_bytes calculation
Date: Wed, 20 Nov 2024 13:57:48 +0100
Message-ID: <20241120125809.683667024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit e68da664d379f352d41d7955712c44e0a738e4ab ]

The tx_bytes should consider the actual size of the Ethernet frames
without the SPI encapsulation. But we still need to take care of
Ethernet padding.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20241108114343.6174-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index dd766e175f7db..8f67c39f479ee 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -437,13 +437,15 @@ static void mse102x_tx_work(struct work_struct *work)
 	mse = &mses->mse102x;
 
 	while ((txb = skb_dequeue(&mse->txq))) {
+		unsigned int len = max_t(unsigned int, txb->len, ETH_ZLEN);
+
 		mutex_lock(&mses->lock);
 		ret = mse102x_tx_pkt_spi(mse, txb, work_timeout);
 		mutex_unlock(&mses->lock);
 		if (ret) {
 			mse->ndev->stats.tx_dropped++;
 		} else {
-			mse->ndev->stats.tx_bytes += txb->len;
+			mse->ndev->stats.tx_bytes += len;
 			mse->ndev->stats.tx_packets++;
 		}
 
-- 
2.43.0



