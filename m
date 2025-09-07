Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0BC4315A;
	Sun,  7 Sep 2025 20:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277513; cv=none; b=GuCcXk0JAzvT5w+8N7wXowyt9mVlV0LuVkF/YNbMcvKeVon/JuvYf9CQ2SxUPMfHG7DCjn4cpdQ/YkSKPQ0nuC6692qfAlaFouJmY4LwLe80fh/0pPT7QgFPvXnhxRp6SIPO/BeYXb8QwkRqoCylFVkx3Je2jfE3VgnWOGx/clg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277513; c=relaxed/simple;
	bh=TI9+VOPjz6Q4snpJ1Nkp9nZ14D/2KBxFoHGLnLE5hcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkOXIkUmA4g8aADX0xdgNa3afLeCwte/6pCRAAqAj7revegcJi/q19siWYTXXFJ/mLTJAAgAc6dsvrJO/5TYG7DdsfQwXYVMdVMWDtruJ3Vpvb91cuAbYlRbhG4mDgfcMK0Qg6YP7Pw8M95b575JvPEDCoqLfx4JD+upKOHhecQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOeNbhQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOeNbhQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FEEC4CEF0;
	Sun,  7 Sep 2025 20:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277513;
	bh=TI9+VOPjz6Q4snpJ1Nkp9nZ14D/2KBxFoHGLnLE5hcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOeNbhQjy0J4FNkMzcLHZK/fsHCmRiHTUTKT8TJD0mRzyWrQVB4/g6QWu3bbhV3YI
	 4Gq4DqTKwyZgWHSognNar1krvelWh+RXoMmLg4DYyyDNTd1Y8vcEou4QhSoNKZRXpn
	 FAWInQhf8mTbgAnTza14ojxYreCp4ZJ6qdGVbHHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 039/183] wifi: mt76: free pending offchannel tx frames on wcid cleanup
Date: Sun,  7 Sep 2025 21:57:46 +0200
Message-ID: <20250907195616.704468101@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 4e435bec828b5..8e6ce16ab5b88 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1716,6 +1716,10 @@ void mt76_wcid_cleanup(struct mt76_dev *dev, struct mt76_wcid *wcid)
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



