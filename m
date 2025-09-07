Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553E71DE8AF;
	Sun,  7 Sep 2025 20:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277095; cv=none; b=mFKjVGE8iWiv3O3aHpiSYxZecUQSRo2YcrluT1bMv8zbNPEAKwToyUEFtfpARWesU/gNyPR2fbMlBtDFKhGaV234CxLkWXJPMDlcLkMY7xe9ka4urK+/a/DZT39fcLCTHzRsqTmeQ/2Wu+3oMXMvfh3vc2/2OiBizdn0fiKKMlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277095; c=relaxed/simple;
	bh=cye+tdZd8AfTzrT+vZ0I/JTGlphE2r161vmrctV6No4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvxwjzDel4afZR2e6yE/Ur3sXGkKtvWJ49nvDDXQWuFNpYLFbB6VsMvp63KP589gJFtylOcce8cv74m9qe349YX29HLwdAavqRZ7ybx47DJ6/7nLz5AWxQmTK8t7FzMjcjYL4pfyRkDCnhGqICdCjLQeKLkIm5478PbU4Aa5Kdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFigYKMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFigYKMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11E0C4CEF0;
	Sun,  7 Sep 2025 20:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277095;
	bh=cye+tdZd8AfTzrT+vZ0I/JTGlphE2r161vmrctV6No4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFigYKMDyF59clVzcy2h/M8+w38FTCiiieVl67AyFmwme3IUZxuqhcu1xn5QSwWid
	 unv1d8/d/6+Mj/36N4NTWZy8b3dMpD4ySvJAGj7nr272o+B3BB/EJS6aeuP6NT0BQi
	 bSkjuxPCt2QNHF7lKimhlalYiTAq4lTvl/mImnJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/175] wifi: mt76: free pending offchannel tx frames on wcid cleanup
Date: Sun,  7 Sep 2025 21:57:12 +0200
Message-ID: <20250907195615.731889940@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bdeac7815629c1a32b8784922368742e183747ea ]

Avoid leaking them or keeping the wcid on the tx list

Fixes: 0b3be9d1d34e ("wifi: mt76: add separate tx scheduling queue for off-channel tx")
Link: https://patch.msgid.link/20250827085352.51636-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 0ca83f1a3e3ea..5373f8c419b04 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1586,6 +1586,10 @@ void mt76_wcid_cleanup(struct mt76_dev *dev, struct mt76_wcid *wcid)
 	skb_queue_splice_tail_init(&wcid->tx_pending, &list);
 	spin_unlock(&wcid->tx_pending.lock);
 
+	spin_lock(&wcid->tx_offchannel.lock);
+	skb_queue_splice_tail_init(&wcid->tx_offchannel, &list);
+	spin_unlock(&wcid->tx_offchannel.lock);
+
 	spin_unlock_bh(&phy->tx_lock);
 
 	while ((skb = __skb_dequeue(&list)) != NULL) {
-- 
2.50.1



