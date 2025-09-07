Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A4E1DF246;
	Sun,  7 Sep 2025 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277520; cv=none; b=CoT4sAYDTDVX9kMD8/Z3TknhGgVJ/k2DSK+LKG+GOiLnhgUVdEBsRNeoZtg9wHrHdQmBxg8QW19pgjpoX/wKWrpDjsDF00TDccyNt+VQhxmXuNWVzI5j73vEXxwWy6JR56Q2J+YL1EMj13+NdZeSgAszY2N+T4UpIVWlJXjuWE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277520; c=relaxed/simple;
	bh=/gWc6WXKIJQZYQP+vtBv33mr+O7YTwMvuUS8mr3Tbsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnSBPWqlB/jek646SWmdrqjvKDLfui1uCD6qW8HQYkPoJTM3c9M9jeR9LM5ueNIRLSMdTR/zEHtEY/Pdgq/tckkyCNFjjYCTNOihn0zADlaVS4Lyb1C1nJtL1aGKZsGimi9OtKt354PCypxGsq7JW57KtCssrl77IoVlE8ee39Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbSIps5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbSIps5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326ECC4CEF0;
	Sun,  7 Sep 2025 20:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277519;
	bh=/gWc6WXKIJQZYQP+vtBv33mr+O7YTwMvuUS8mr3Tbsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbSIps5JOceC7lG0pbckhdFwDEUG5TAKD5aJEQIb7vTwJYlgV864ZQ87jFp4E7EQw
	 H2pI2a9sUe4GmTIi6ikRNiaMz51oZLshwosFRUbvMdcoE2hiENKbeFQowXFMLeNwpG
	 fZhwIb89h6Jwx5BfHRE/4GA1b8pOKhWH3G5ARBFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 040/183] wifi: mt76: fix linked list corruption
Date: Sun,  7 Sep 2025 21:57:47 +0200
Message-ID: <20250907195616.727209649@linuxfoundation.org>
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

[ Upstream commit 49fba87205bec14a0f6bd997635bf3968408161e ]

Never leave scheduled wcid entries on the temporary on-stack list

Fixes: 0b3be9d1d34e ("wifi: mt76: add separate tx scheduling queue for off-channel tx")
Link: https://patch.msgid.link/20250827085352.51636-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 03b042fdf997f..8ab5840fee57f 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -646,6 +646,7 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 static void mt76_txq_schedule_pending(struct mt76_phy *phy)
 {
 	LIST_HEAD(tx_list);
+	int ret = 0;
 
 	if (list_empty(&phy->tx_list))
 		return;
@@ -657,13 +658,13 @@ static void mt76_txq_schedule_pending(struct mt76_phy *phy)
 	list_splice_init(&phy->tx_list, &tx_list);
 	while (!list_empty(&tx_list)) {
 		struct mt76_wcid *wcid;
-		int ret;
 
 		wcid = list_first_entry(&tx_list, struct mt76_wcid, tx_list);
 		list_del_init(&wcid->tx_list);
 
 		spin_unlock(&phy->tx_lock);
-		ret = mt76_txq_schedule_pending_wcid(phy, wcid, &wcid->tx_offchannel);
+		if (ret >= 0)
+			ret = mt76_txq_schedule_pending_wcid(phy, wcid, &wcid->tx_offchannel);
 		if (ret >= 0 && !phy->offchannel)
 			ret = mt76_txq_schedule_pending_wcid(phy, wcid, &wcid->tx_pending);
 		spin_lock(&phy->tx_lock);
@@ -672,9 +673,6 @@ static void mt76_txq_schedule_pending(struct mt76_phy *phy)
 		    !skb_queue_empty(&wcid->tx_offchannel) &&
 		    list_empty(&wcid->tx_list))
 			list_add_tail(&wcid->tx_list, &phy->tx_list);
-
-		if (ret < 0)
-			break;
 	}
 	spin_unlock(&phy->tx_lock);
 
-- 
2.50.1



