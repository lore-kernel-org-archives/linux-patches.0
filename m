Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1D51D514E;
	Sat, 12 Sep 2026 09:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206530; cv=none; b=ioFhGKzcc4UhLYIKfM0KpZBhqO39KLqZRb3a5qcQW4udzqePmbYHwEuOrdfjtg/InNq1o9pbpjtYbcH93BY26MI22wkoBcvuTv4hwoGQuDqg7eUoM44p/HOlHHGKpStGEs9d6fin6KnGHujbqnxYW2ynbHKktqOd5+JZ7E0cDgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206530; c=relaxed/simple;
	bh=G9+CwSGe282iJ+hSzLwwvalJkN7r4R9u8p7foeqFGx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoXa7JyTiXlmSZ8HIaTisqy23WQ31yhtBRfEVVhTNvQpYfHh0ZJDYArX2Z0eFdGGwoWDTCXRFYoL/WkUXoDxEZWSZ0zz9jliAGKe0/DgbkI56GMsaQvzBH1LqQ/PHtXY7bJ8zV+L9fRalZFaAiQtWJP4f3gc8OAUVSbpVlA4Qdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWm9Ko3q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWm9Ko3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01051F000FF;
	Sat, 12 Sep 2026 09:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206529;
	bh=cxBBgMnFO+e256mrksk0OEyU5HH7vYTEvT2dUurmbCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWm9Ko3qehWTODJ3AQ7UUqCKpExW1MCOCTXyj2qhyQHEbxvSpHgDmwNQeYvklYWn/
	 hxB0IRzUrgR2XVt+fZ6h98hQzeLW3DNqoiziF6J2/WDf4VOMuCCwWBpP+1TckJKrga
	 kQgoAjCnNm/N8Kg7kHPodxHgRxB0QBpBS2ZvQB/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0224/1518] wifi: mac80211_hwsim: avoid NULL skb in stop queue drain
Date: Sat, 12 Sep 2026 08:39:53 +0200
Message-ID: <20260912065628.555027330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 158438cd6ad69d6dd7d871582c38baf22169fede ]

mac80211_hwsim_stop() drops any frames left in data->pending. The loop
currently checks skb_queue_empty() and then dequeues separately.

That split is racy with TX status handling, which can remove a pending
frame under the queue lock. If the last entry is removed after the empty
check, skb_dequeue() returns NULL and the stop path passes that NULL skb
to ieee80211_free_txskb().

Use skb_dequeue() as the loop condition instead. The dequeue result is the
object that stop owns and frees, and a concurrent status completion that
empties the queue simply makes the loop terminate.

Fixes: bd18de517923 ("mac80211_hwsim: drop pending frames on stop")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260706161822.921039-1-zzzccc427@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index a0724e1c53070..3d66f4aa8393e 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -2159,6 +2159,7 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	struct sk_buff *skb;
 	int i;
 
 	data->started = false;
@@ -2166,8 +2167,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
 	for (i = 0; i < ARRAY_SIZE(data->link_data); i++)
 		hrtimer_cancel(&data->link_data[i].beacon_timer);
 
-	while (!skb_queue_empty(&data->pending))
-		ieee80211_free_txskb(hw, skb_dequeue(&data->pending));
+	while ((skb = skb_dequeue(&data->pending)))
+		ieee80211_free_txskb(hw, skb);
 
 	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 }
-- 
2.53.0



