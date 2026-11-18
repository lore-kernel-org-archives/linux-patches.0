Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019127;
	b=SGhVJU3Csrg9JYF5OHRWqes6DD22goveBRE4wwFxeAXJHEh29bPDtB5GktXoMif1Bf33
	 kevBd6lW6rMTGHaebEP1bkreUa/ezqxhxD4lGmjpMDVd3c+G0gzMPy1kJMsUIlO+/Pff9
	 bRzPHMmkRE9VE7yE1lniNuSTiGWkU7ogcag6NQLpX/hfW2hyemmIFojfZgA6yRcZiyVUd
	 jwogP+fxwXCqEMoqSGoWqd0475vPZCY1evC/oyZN57QAmNzGH5ThB1wzXMDmHEBHmhKc+
	 3brVI4b+L2XAO8SflS/BBAbE8dq6mMGn5CnQPoGFCwhd5PDV9U8jCrr0OrjhlfhCrcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CEPg0n1p8ee3FFur/9vTf1pnf65kQV5uakq4JlRVO6g=;
	b=ZHIXXcPGY/Or1czjT5xHdULjpzG4VTu3TPPgebPXRYkECYSrxolBCjd9Djd/zur4ki81
	 uqaYxhHvC4k8qqWlfrDCV5Kj5sjUVuJlj+sV9HFg8bj5gGUvNWImrKOaQ3EgH+phnj6p/
	 g+R5S3yzXyJZGL+zcIowKUcJdAHfcWDRAqI/ffxMsLAzra2ZQqkrwaWP3WnFbQwbpaaRE
	 anrVDf5kPnfVv6EWKUzydyUPKu087lU5ryNc997OmnZs4qjgGRHRXEhklPxA4zlwMJGha
	 Wx1CyLF9YXPShmzPf/B61v8ZLVYnfkkVYKjf+IG1vznLEljCnXkFB4hwFdJB6iHK4TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aHqptrwn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE98606A31C;
	Wed, 18 Nov 2026 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aHqptrwn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A871F000C4;
	Wed, 18 Nov 2026 16:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019127;
	bh=CEPg0n1p8ee3FFur/9vTf1pnf65kQV5uakq4JlRVO6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHqptrwnuoJN2K0d4gnWYmPUZmtZO6hL19FdNsetFxzDxQb4BG0GO7YSvHHSIKazl
	 vszzV4IQtm0AENEkKMegNZzfqwyihE7/q9cTREBP/jxqJ3lrzGTKOw9TWCo3KhPnR9
	 oMKWXHd2qp9pIO8fc7MuJqSoGB7Kk2mwLY9pSAIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1443/2651] wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
Date: Wed, 18 Nov 2026 15:44:43 +0100
Message-ID: <20261118150339.994290019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 156d283243d3c..b022d3843473e 100644
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



