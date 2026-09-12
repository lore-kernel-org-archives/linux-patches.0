Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371F8309EEB;
	Sat, 12 Sep 2026 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229160; cv=none; b=UbHBm1LNkC7hwKvZzCdzxrKB00nLMYxr0iFs/aqvrAVsu+OozXz0wDKzMbTZaK3/wwnZ2oX+9iODYRvkDoZ6XGBJvkxzujy1KkgLX8/LpeUhuY1WIVpl8Hn8/s5qc9TAOrn5fwdnsB5nfGws6SRTMAYUlde4zgIWqUY7phqkW0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229160; c=relaxed/simple;
	bh=/WU5IbbOn1yo2qXhJVVtUNN/PE0hIWu6QY93heDwrAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaZzAeZHGUx23YMDI55SB5083eMt50v+pybm+lRdwDr28XAoD1dGWwW9Tt8HcSZbERrZkysOC6KmmkSXgseRt39fnuTjfhtpRNkxgyqW4RJmVsONFj2U7Iw1SOmaUhuBBuon+UmJY4Wno8KUG1tyqW1kqngrC/QkAS3FvynMHcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exZoxRRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exZoxRRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813901F00893;
	Sat, 12 Sep 2026 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229158;
	bh=F9e1dcAgBQal8EzFTv6cTbgGWryIbAOUg3PIH/+819I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exZoxRRfW1NKTIZ+Qc1erGHoTywczVpxtvE/lw9ZY76WhvW89RjhYReqXgNg3TZlq
	 upPoS65pv1FlzXmkDNmxAwu5zY0Uzk4G5znzA4wgGy6qHnlUzPXBW6OvSdfeIGLSej
	 t5ok0cSdTpRL5cjvoVzub1mKplyrOqVyg2eIs7Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0533/1191] wifi: mac80211_hwsim: avoid NULL skb in stop queue drain
Date: Sat, 12 Sep 2026 08:54:21 +0200
Message-ID: <20260912065600.223113520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/mac80211_hwsim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index bb9dabbf1f22c..60e48df794f5a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1966,6 +1966,7 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	struct sk_buff *skb;
 	int i;
 
 	data->started = false;
@@ -1973,8 +1974,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
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



