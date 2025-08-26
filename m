Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2476529D291;
	Tue, 26 Aug 2025 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215768; cv=none; b=k5kZWRNdDumzZgDb619+oyNTDh0eoSYlwNKXlZFYoFCjoRremuj4P9spC0t7gfZOz8qyjtJE4dIVNRDMc0l9wu+P1Pnhnm/mAlxyUfHfFnP3v//wzfpKR1X+iPi4VhGxZ1u+L82tGN/sBmnRVKmTFtUvWReTP/yS0nrdUaJ0XZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215768; c=relaxed/simple;
	bh=3HYFLOdXKmuy6BUD0Pnrr0o1LFKhFeLD6JW40EQ3Zlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQlI2QVGLVhpLT0mX3GJCaTrDLt5jR+HZhLgXwfDSjvgUQbIul70beJeyoxbi3Pvois8Z9b59dVLwww0SY312Ed/dtFIHrv9r2d08NZmRHpbI5f8oHym5TZc6PwpyYaRDPaxHUCePLlR4Fzd3E7AwM//y/B9rIMh//iTouJqW4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGF+UlVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGF+UlVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AB2C4CEF1;
	Tue, 26 Aug 2025 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215768;
	bh=3HYFLOdXKmuy6BUD0Pnrr0o1LFKhFeLD6JW40EQ3Zlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGF+UlVH8eANp+bKMm6MqZbdriEa1HvxRXLlmSSTTIznUcOswsUfNiG/8wPsIMryM
	 7TCN8Cpr9LLG+StKr5sKhT2pk9R//Dr9rG4sPlQVzD5eP8a+wBdhGfnRf6nPnWDk6v
	 dVbeJVIvnDMOt+aFV756fCSKoIgvVFis/khCkNA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/644] wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()
Date: Tue, 26 Aug 2025 13:04:08 +0200
Message-ID: <20250826110950.368079066@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4f2183f23117..4ab891c8416d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -608,6 +608,12 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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



