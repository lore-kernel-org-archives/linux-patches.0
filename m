Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237C5455162;
	Sat, 12 Sep 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214901; cv=none; b=u0BjPFKa961r3K+45UnUgFHu9kjTMzm7bo+yeMpr1gy+VYUv/KjjFN5hUWlhBEt5qVffTzz2wG2Y9zuiWrKwzEZvKsBw53DXn1J2/jaWT4hW9BE5kBdjjpfn882EO2ml0iYbFv4btyD2s5G6Cl6yy+rfCItGTIbfSUQcsp6fe9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214901; c=relaxed/simple;
	bh=xNwhx71T/cgdneLE9qD3OY+hfwrigo/743QdAtYq9TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSE5rh9MsFwTYUP9kpC88+8l3h+0ZSIIS/nqQIdn9+kdvgz+2c+JYZAsPzfelXcHGqMvGLQlH/BgOzhhc9Pk3Lk2CbSKXj/Vr4SirvUaZ8D1TRxcllKc+dgsf3I6Jl0VVGUP3jAr2wJRvGey+PTpFZ1AG61nWKUzn0Adw0axsyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXee/klz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXee/klz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287B71F000FF;
	Sat, 12 Sep 2026 12:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214900;
	bh=zS7elfULFogfk90rh+XSZsFO/Dd/A+5JHLh437/kDaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXee/klzXB+5qa9SQ/MRgi2MFAG7FZWQazv5rxflmDktRL1lPT3X5aRkP5c7Phs5n
	 eQw9OiU6/Sxv1GGvZGU3eMiaWufwXoA755Vdd+Rb7208AD/5DVjgznF7GBGR7bSzrb
	 ZufguluCLQpEHRMJ/y8vtRChmgg6J+oxFcOSFE7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0419/1376] wifi: mac80211_hwsim: avoid NULL skb in stop queue drain
Date: Sat, 12 Sep 2026 08:47:25 +0200
Message-ID: <20260912065616.876725022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 63fae67c81622..4622cbf4f5f98 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -2117,6 +2117,7 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	struct sk_buff *skb;
 	int i;
 
 	data->started = false;
@@ -2124,8 +2125,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
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



