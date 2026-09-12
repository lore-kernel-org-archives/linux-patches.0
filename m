Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A3130DEA3;
	Sat, 12 Sep 2026 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222779; cv=none; b=O33oPlM7Cn58oRHQgCQBwb4FJshNcsbuAc9Lc1TIUXCGuaOreSYysiIyAgq5sN/zjuu/5MfZQma5qH0VKXPLYG8FTMeMjlf3R5B1YvoOUg/vIET45iGaTTIfpVnxb2ValZ06ETzNY8Xn5rgGQkNm/viVZuhuFEyN+YA305lfZXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222779; c=relaxed/simple;
	bh=fzfBITpUcFtRT/nwS8JYSZue/AEyadJWzgnFjAd+vn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mzr72y7FH+AumJjQOC/6ZZ35U2+HN1y+ThXzsCsRCVNfR811X0CWQvheU98BUqLnLX3hKkyPMBr5RKhz6FV2rwzrA1fr9qvxZ6Hrj9K7tdp1s7vbYg7UAlmSa2+Hc93j8EzZRNXa3wPoj3S7Cr/oItys+It+upU6djIdy8inGos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXdGybtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXdGybtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AC31F000FF;
	Sat, 12 Sep 2026 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222777;
	bh=zyQLFQlJgw1fPwq0HMr2BXdkYBOMd/XnqeomM29Qhro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXdGybtZ1tXECM5wt9kJlfZq35DcqU1KwXT+Quz9houheTkg0GpmWb0Z1doBBaVH0
	 MZ+yCB215cmDi5w3RGgpHmr0Y6WNY59e0WbAFqrYUBTc/yTkDZ1ArhTJxoYwDxcAEc
	 e26JM1xiDw94r6NF1S6c6TjxGWQBoa4WvkalLLe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0655/1424] wifi: mac80211_hwsim: avoid NULL skb in stop queue drain
Date: Sat, 12 Sep 2026 08:51:27 +0200
Message-ID: <20260912065621.961687187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c9bfea77d0eca..bacbb49889848 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -2084,6 +2084,7 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	struct sk_buff *skb;
 	int i;
 
 	data->started = false;
@@ -2091,8 +2092,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
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



