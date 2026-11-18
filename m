Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025804;
	b=haedmzKa4j7P9IQUfXvzonGB0p6pR8/m7JckYrMzb9enP8jiflFwrvNVTYuh6QpnR20N
	 z7ZP/MGqqmd1oUzR5h11V8yWEbS0ollc2dDLtfUF7sjuo1T5m/8LMK5UL5SanED/sixOW
	 FQJuN98e8JQ34MptLTkwlfRknB2bj9xy8Y8Hu7oQXDpVzqFKWSSsNqx5RCpWlMbEyJ00F
	 rEyvZr8KeiJeh2ErKNC3/IoJdpGykYB783eg5SnX0FhCsO5/7fkroyahtXHjR0CZr267e
	 Z71NyxP6NJkWT4xfVqXaYSQjg8n5QylSElPiFUrVJGShtW9OLM/AGrA5a5WKGbHFboQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8nNx2/XMmMV/B3mSqIYo+pQcxhszoOwprlqvbDnwQqE=;
	b=xP4q/hPqlp3ezNoUggm9Ol16WL4G9StgcZcsj4bVlyCR57YyUVHJKP1wPML5wfyjFNzh
	 OI9YVf4swxaNelc4PZDSYlRIVNzx85k6WwxHFvN5nlBQ9z0sslTo5m0MLnEWgnZyaQXpR
	 Mb1gXyJM3qv5jXuimA5d+pWU4v2mG2xsfzzTUYjH0Xx+MKA24y7FmjNPIGU2SX/GX794J
	 7qfZzxOgAht+qE4hzkrWddQiplkQXqNHKz5qa0apI4gIbuXS/9KuUy9x4h3pXf9lndUOd
	 I8me5D+hT5zYcR78GXRJ0j8r4QbE+GePvQ9j24COS48DlTdiE2oep4qyInzrpfkwfPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rj3u3cqt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C05606A31C;
	Wed, 18 Nov 2026 18:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rj3u3cqt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0ED61F000C4;
	Wed, 18 Nov 2026 18:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025804;
	bh=8nNx2/XMmMV/B3mSqIYo+pQcxhszoOwprlqvbDnwQqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rj3u3cqtePlb2xf1c09mYjVv8iaKZjh11ZmYMbLIzy2+3gCNHpRez9qN3+9JmBux5
	 rOxLGXnxGqF0jCpy3T4ImpPTsBGCNYFS35zybfKYS+r3m8d1Njatgo72JtoMBdEaSw
	 a3FBm1aLadyw/9pXmZZng2urIWECGJ1/7/4hp2ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1210/2151] wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
Date: Wed, 18 Nov 2026 15:49:05 +0100
Message-ID: <20261118150206.283023481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3fef2ad45dee4..5b7a44cad70f8 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -129,7 +129,7 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 	memset(cb, 0, sizeof(*cb));
 
-	if (!wcid || !rcu_access_pointer(dev->wcid[wcid->idx]))
+	if (!wcid)
 		return MT_PACKET_ID_NO_ACK;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
@@ -147,6 +147,11 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
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



