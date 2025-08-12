Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9E02FD1D6;
	Tue, 12 Aug 2025 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020596; cv=none; b=ZZRYIBCrIRMoeP1uLw/Prlsyl5vgkEOjeG40SvhS/FUgMGQ/2atMrRdoHz8imZI0KTTEd5fyQBl+t8CH+NiuGeP29pBFSzTZGXFAA2eELD0q7h/iWC+/lNFwEnoed8AQ5ffSy+2gITkjeeQz46tYQDWnJKYPwHGGsPYDSOwkKlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020596; c=relaxed/simple;
	bh=KBWgQ69FEUqzuIExYg6sDfy0BNe0rqlblWl68TPXYug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3FbCTrXaaqbp7Tpz6EE4OxHF6M8O40SJu+iZ83QkYvRqX4WHzGxogJ6bZn2dTIm7kq86iG117eKNgKzZMmfd31wxOos6FOWhOtHIGq6vm+8fGvat/ERNwqsKqUflX1jW/ducCY/GR42/2jp4L5Od0VjrXlbMWO/b/BcBsZGlB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNZJtxeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNZJtxeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523B1C4CEF9;
	Tue, 12 Aug 2025 17:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020596;
	bh=KBWgQ69FEUqzuIExYg6sDfy0BNe0rqlblWl68TPXYug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNZJtxeQKIEldYVGOf2z/HLleH+FLsYSs01wkM8d12FG/bnbKWUTPJFXKOxmlHfUI
	 U3u+ipuO1E4qhyZ/0mOJmSKkUc5X+2mTPEZtsW7mHo3etG0pbk0fv3Yy1GmWJITcrX
	 ow68HNl6U7LIh8XVSTGD+c4iH2qIpJBA3Tj0pcQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/253] wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()
Date: Tue, 12 Aug 2025 19:28:33 +0200
Message-ID: <20250812172954.018766780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fe47674b83b6..e35a755b353b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -644,6 +644,12 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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



