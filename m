Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB62721C187;
	Tue, 12 Aug 2025 19:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025908; cv=none; b=CKksc6ZiKo79Nn896UKX5LGi9E/kUZKSoSO5ezT8QxXkT9R1XyqTwtsVigb0oOnpKEz6C+s58y5oRkmaqwL+JmbEjuSQNESzXfGEHIa4Eep+99nY9QdBKUn7Q5W939zSOdKAKBYPpL2lLts4QrEp8bk9Ga+U4I7t18OQecMMgXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025908; c=relaxed/simple;
	bh=A1Ua6OvPs4WuCLhvAqT23Dn2E4SIgB/4R/DgSle8Xjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isc8pBnLK6BIcq5MflyPNiZFNqO3Fu3Qst+8H5m3dwI10C+XMXHbFAep/kNnZWEObw6WD0UtPb+TgZgaHoGzDFpRBgzv7lI0pdrvL79ZZarjRgcWyfGl+86hnsNF+zNqEeTwTv/XgeMIH+U2hly4KZIcMF4zy1/UPOpoSx80MfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr0W+70l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr0W+70l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36155C4CEF0;
	Tue, 12 Aug 2025 19:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025908;
	bh=A1Ua6OvPs4WuCLhvAqT23Dn2E4SIgB/4R/DgSle8Xjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yr0W+70lMx006x7VjCS3yHPEm/aMQwOP9SpafQ4N90x0rBvsSJcpEJ4bE+FZRNGQP
	 ieqQ1jJYgficO9oY+IYV7tavNtNGYkWFxPZLAmfWOwCbEmN8Vu46GZQ1RLvgj39yDD
	 Az4/S+WKk/wj4ZG2GB5jbJlJ5m+rAJK92WCvvTRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 179/480] wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()
Date: Tue, 12 Aug 2025 19:46:27 +0200
Message-ID: <20250812174404.894845497@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 4037c468d1b3c508d69e6df0ef47fdee3d440e39 ]

With 802.11 encapsulation offloading, ieee80211_tx_h_select_key() is
called on 802.3 frames. In that case do not try to use skb data as
valid 802.11 headers.

Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/linux-wireless/20250410215527.3001-1-spasswolf@web.de
Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Link: https://patch.msgid.link/1af4b5b903a5fca5ebe67333d5854f93b2be5abe.1752765971.git.repk@triplefau.lt
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 10e5fb294709..7799455b0403 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -622,6 +622,12 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else
 		tx->key = NULL;
 
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
+		if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+			info->control.hw_key = &tx->key->conf;
+		return TX_CONTINUE;
+	}
+
 	if (tx->key) {
 		bool skip_hw = false;
 
-- 
2.39.5



