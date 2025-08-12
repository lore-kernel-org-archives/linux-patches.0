Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB976BB5B;
	Tue, 12 Aug 2025 18:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024009; cv=none; b=R+fRF9e0gi3wrHukPh/4cqV3XxF4GdYjP5t6TE5WsS/xSzQggNl88XJ+2C8ehUw5AWW4ckP1M4yZ2YlQCA9B4E0/bDIZcFzvcwrPTTbrs98hjC3nKrgN9keA22bZLAZAI9C/xZxntWuFDfR8UNgCyVGExp6vKeTAx/BvIxuEvoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024009; c=relaxed/simple;
	bh=XV8CwznsuAm8xsKaGekypuv5wlYTUJW9F7EMYB5yRzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gdanw5YOsknYo15HBkk488dPpaW5bcRDrBpfj6WdN88jqUozttLMORoLMz03Z98gO7duIXI+1I6+8RGUF2lhzaLWKNbuzyKn/Jc7zoZGrUGsgQbD9WGlGh7oHswsPkWqNAMudApy9bQcNXFTHyGFQtKHOYuArIr1MtWtVKMzii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi6J2M4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi6J2M4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18478C4CEF0;
	Tue, 12 Aug 2025 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024009;
	bh=XV8CwznsuAm8xsKaGekypuv5wlYTUJW9F7EMYB5yRzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vi6J2M4gx6fByFqMSyviLQF2l91tZlSrGoSoa59kD8xJUfrqEwwYgzyo/MtPALF2E
	 YFpCNwWDtXlEX86L/KpsWBAwnzNoPZdyO04PcdXZ1UnEDATGkmvl4GqE2zOmFu6l4+
	 8qmYbz33cdmqK3pB7SxfaoQZ2b/LdWwPmZmuefZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 239/627] wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()
Date: Tue, 12 Aug 2025 19:28:54 +0200
Message-ID: <20250812173428.393755501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
index 04f4d574401f..73304a5cf6fc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -612,6 +612,12 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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



