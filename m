Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBD51991AA;
	Wed, 20 Nov 2024 12:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107504; cv=none; b=PalOmlUmbzdUgLnqjF6+lz9X4XPR5AecMoGWCex5R93mBeDUPeH6Kxl+6e2wKxcbFE0+4f8nHcRSOuHcq7L7gVa4aAB7HF47CbzDlp9razDbYVphMiL8oIL2LPczxv7cbp68oO8WEg/nn0688ELtkW4spFiZfH9cLBPwPgP5txU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107504; c=relaxed/simple;
	bh=s+jk3ohl90HvTtJmuIIHRVvtsQOhubt8qBYarGUy424=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoUOfZPhciZTaq/QukcB8mCiy7g1YfZw42djoaPRwU7QnQpRBakwXDXy4bkBTouFkyDwZBMCUyeb/XzFBrH/DQrWI/UDzpL2LzROk4+Za8vpsfGgLPE15oVrkf+oFetfVYfKsP/Z7uqf/QdOSi7NfAjTs3xGiobRgbJ79lS3SJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6dCIIyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6dCIIyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7618BC4CECD;
	Wed, 20 Nov 2024 12:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107504;
	bh=s+jk3ohl90HvTtJmuIIHRVvtsQOhubt8qBYarGUy424=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6dCIIyPM27j0kqUapj9kIvBtjRqMTkslxGJuQo06uqWclX6aWBMWP4gvb5h29pjp
	 PCCJ7yBSSI0Yk+tsj2YwKIVp9NT+oz9KHrlfdqb3iqBV88RUYhHhr7Emhot7h05LO6
	 G7UDtaYAETWSWgP4I5B3UGFZt555G155JOJQLbrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 003/107] net: vertexcom: mse102x: Fix tx_bytes calculation
Date: Wed, 20 Nov 2024 13:55:38 +0100
Message-ID: <20241120125629.758659167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 33ef3a49de8ee..bccf0ac66b1a8 100644
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



