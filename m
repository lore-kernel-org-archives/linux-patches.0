Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1C52F8BE7;
	Tue, 12 Aug 2025 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021267; cv=none; b=mu5CuOcw+i3s6Z5QiDoMNyDFrp4r4q47muGpA1fjm0oN/plv2g7ZgXiLyO4RXq6W0UmfxSLUJxxGaDxsB/n1ZnEN+/cIAUVpKK/nYJvLL9T2W7eYUo+MWG602bKBUtOPCM5KEoKJFQ1oJbnjzBkoe5YlaVLQtgTjBlJyzHkYhTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021267; c=relaxed/simple;
	bh=niDAzv1biZxFWkoc8dMuONFObFqIEKElBjjVrQmelmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwrllfdJ3LImq79JHekuyLmU2oag1uacdScwX3NgLO8IPi28C3OPn3/3RGNDbwt7Yx550tH7wuFXfjjVzT6HdIBEaQXQpj1Z2WAxbuzJ5HQNRGdS4JMzdA//WlsqaP3YzE+vc+92KZSRlsIrNA1T3ZduhjkH0cRnGsXahEWPbTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSP5cbv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSP5cbv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E035C4CEF0;
	Tue, 12 Aug 2025 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021267;
	bh=niDAzv1biZxFWkoc8dMuONFObFqIEKElBjjVrQmelmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSP5cbv4pwm0E3GU5EsCHjzAFbD5IkSRq3Ek/WYXK9vKfkOrkZHXyUfryBjMIjq3B
	 SKYsAWBT/fgyFDN9YvraMVb/p1TSDC48Y8Hm6yPcmGHdgB+lI72OnaGO4MmU/UIKHJ
	 HQWXvyj5q2URez3w7yw80p9tQOvQZbxDpzxeK11k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/262] wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()
Date: Tue, 12 Aug 2025 19:27:54 +0200
Message-ID: <20250812172956.707989877@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f54792c4b910..e4797eb9c2ba 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -629,6 +629,12 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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



