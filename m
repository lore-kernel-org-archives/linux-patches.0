Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049305;
	b=ry4R4fzhoZQsCNvxeaiDlhwTBG3lf54DMM9jhkW/+E7SA9cb8ArzqNGCX9cIy4g4xVv1
	 SqJJHkEwdKLWqVPkCdW1Ek7iPDHmXHU191gju0aTHS/CPSS8aTDMGRxMr+gsdgTwtkjl1
	 wx+GjCkMKfWDu9Eypsg7UnUb7jBo9FFxS1RB8gGj1JvK+RnwGE++q/LvNTwo8UtKel5CG
	 C4ntpa4Lv5E25Wt1Wb82O4CcTIeu1tHVcdxnilHEW52ZIHttaJsL13AkrNOcuMLpmjD6t
	 Ac6GohBcow/NPAPqMxVPIS/qZCnCZ2TYHaRIFmKt3TdxgeUbCqrGl8PMihP+d7BJr0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EvlcA59UaQLEv8FIu4gJs8tVJHURb56BUYkxitxFg+A=;
	b=T5X7Tau34jyG4e6tFvMBZS+uagZJ2wdbpZgLIz/UiYStbe4jc2c3B9BR5mTgpKPSfsNo
	 9reGjfBcqYn6he2/i7zRnvVuOZFousrzpg15at6h3uPVt8a5cwygMhLqZ4W/bq5WYTAuH
	 20FRFA0Wk8yBG3tbg1oJiuXjLMClcKurfy9x2dEKtVdj0eRj+K/G06cKKZTUPhelBxZdS
	 Kc/maalEiXpw9soOCk2O/YqTieFe4JK+iXlk4KfpPlsx/O53sTRjizzTo997wiEjAAKZG
	 vl+M/FsyUFgiciHytoAWrWhzcD20j9VMpX02gRZXOKvlOb1QWzWSxpuHiZYs+HSwa+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NCCdyjG9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAC6606A337;
	Thu, 19 Nov 2026 00:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NCCdyjG9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42A81F000CC;
	Thu, 19 Nov 2026 00:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049305;
	bh=EvlcA59UaQLEv8FIu4gJs8tVJHURb56BUYkxitxFg+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCCdyjG9Axz7IT6Si7AhGTj2GjxJ0DKCvqgE0rTuq4lteQKiM9HdoFQxhOTlGf6Cf
	 Q03Lseds9C0zAg6lQ8aWL6d+7mTFy7Xkdg55p5ixXQDRFZu90DCHp5X0NgEFe614WG
	 jmK/ikbf8zUyIg9Qrjf0j+RpG80tnn0DVlGaYWt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2303/2857] wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
Date: Wed, 18 Nov 2026 15:55:37 +0100
Message-ID: <20261118150324.406774408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit cfb05250ded4d6de09dfd273c2a72092f48b55a3 ]

mt76_tx_status_skb_add() checks rcu_access_pointer(dev->wcid[wcid->idx])
before taking dev->status_lock, then allocates a pktid afterwards. A
concurrent mt76_wcid_cleanup() can run between the check and the lock,
letting a stale wcid be re-added to dev->wcid_list after teardown.
Worse, the check only tests for a non-NULL slot, so it also passes if a
different wcid has since been published at the same idx.

Move the check under status_lock, alongside idr_alloc(), and compare
identity (rcu_access_pointer(dev->wcid[wcid->idx]) != wcid) instead of
just testing for non-NULL, so that a reused index is correctly rejected.

Fixes: fcfe1b5e162b ("mt76: fix tx status related use-after-free race on station removal")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260821-mt76-stale-wcid-race-v2-1-8f41ee96fb73@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 5a06392479a55..1cd7b1cbfd9a6 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -127,7 +127,7 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 	memset(cb, 0, sizeof(*cb));
 
-	if (!wcid || !rcu_access_pointer(dev->wcid[wcid->idx]))
+	if (!wcid)
 		return MT_PACKET_ID_NO_ACK;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
@@ -139,6 +139,11 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 	spin_lock_bh(&dev->status_lock);
 
+	if (rcu_access_pointer(dev->wcid[wcid->idx]) != wcid) {
+		pid = MT_PACKET_ID_NO_ACK;
+		goto out;
+	}
+
 	pid = idr_alloc(&wcid->pktid, skb, MT_PACKET_ID_FIRST,
 			MT_PACKET_ID_MASK, GFP_ATOMIC);
 	if (pid < 0) {
-- 
2.53.0



