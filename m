Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA16350D4D;
	Tue, 26 Aug 2025 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217353; cv=none; b=IXxs2goBDhFoMPim1qulllef+KJU5Lgsa/jD/1MRlsQYQPTaBakCFyw7fTFP514PaLNEOvHZdNZyvDa80ehRoWWP3qqRX0edKRglZ1Sjhm6FiSNcO006IaS5sjcZU7l/p4WDFLHBvMZigBVgy1JLJqL0GuFk4E8213W9wQzUBMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217353; c=relaxed/simple;
	bh=RmnmxOa0/CQVtWXhoyNct0ZPE91DHe0EIJndWI0AIY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkEXhtzwXjYxeoy32VUhPQqDmLtSf5GaMnXcr0JSoLgUUiUSelfvSiez+OzzUtQJSVB5y7/entN8DbKZMKwuOYe5dJxmKFqjEAQqL+eSovlT8Kdg4+zsH3iia4xYjkqo6Zrj7a4Bft9PpHPdCDtgddG6iKMFVLMXJ79Hrf8+q9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dViE3L+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dViE3L+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5568BC113D0;
	Tue, 26 Aug 2025 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217353;
	bh=RmnmxOa0/CQVtWXhoyNct0ZPE91DHe0EIJndWI0AIY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dViE3L+dcVY+65d0EILQVtdA4PQUBFCYeno1iT70mFDY58RkWpZ2UO3svCcSNpHu5
	 2vXNaUj6iYUUDa2jUXSjkeMMFtwRVejDe5FKGsiIEagAy3SfBsQIUSk9ZwdVyPmql5
	 PT4YILMStDNqosFgKNRf0zi4rGd7/cOvqejs46+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/523] wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()
Date: Tue, 26 Aug 2025 13:05:22 +0200
Message-ID: <20250826110927.287610208@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d6d12fc3c07..509ea77dc2bb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -620,6 +620,12 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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



