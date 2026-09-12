Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A5537CD21;
	Sat, 12 Sep 2026 07:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197775; cv=none; b=Y5Z5lP/8Rj/b+PDNv3PoK7J/nlN1+K23MZ3I8quF5ANjeuuUxCXy0zd4nJVjWFFAbM30fI8tMb8te2dDf0OhWu+5K9NSkBJHsj1veb5DRgsWfKdXAjaVHlIQnWtiUje87+6n5oujW9oH3H2+dGlbUD+vHC0Bs8jdmKKidf7Sxrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197775; c=relaxed/simple;
	bh=drDXpDhYLU8/nEJezibw1QQvpaemhdxsdzeiEWafZdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmQ1XXKltr9Sm4pldkwrrElGRuglJgD+bwc8JhIssD06zngo+f3Y/PuFNXf4fzy4MXYOS8LmpY1QeESAhoXX4IhEzJDFqMteAWXfzgsUbim03WFiSNu/4TWDdopOsoFk6yde0ZgnrrKaQ0zTJ04bMznqZ5/LovF2C/BGmOFGBQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBe4lO82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBe4lO82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E4A1F000FF;
	Sat, 12 Sep 2026 07:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197773;
	bh=nxFVUbarzerFQB1KFyvOG5kPIB+wJwqmWUalRWXxTqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBe4lO82E7jRF7QAk6jcrlTXtTbJ8vpauASNM0cet0ZVsUNMJakqNVD77nDfHIijp
	 YISLkSkkUKyk5uKAddDEGV82meymGRKtIjOyEo1+OH2J1hwmjACZkDRV2WUM4w2MXl
	 iShvGrP6/CnFfbOCWIfD21wAFS7eCxatLomuuGXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0227/1815] wifi: mac80211_hwsim: avoid NULL skb in stop queue drain
Date: Sat, 12 Sep 2026 08:32:57 +0200
Message-ID: <20260912065654.321334653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 75caa97becc8d..b4cabbfa9cdba 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -2314,6 +2314,7 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	struct sk_buff *skb;
 	int i;
 
 	data->started = false;
@@ -2321,8 +2322,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
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



