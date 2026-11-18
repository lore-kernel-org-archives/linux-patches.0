Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015657;
	b=xH9/JQu6Mp6Y1oOFbIMUCpMcy30lymCl80yIOzA9v/uollDlgGbD6QwNVXrM/eNIlXVA
	 gEDvquEVbgR1hBujCCwHWv1R2egqurD5sBe/JZ7XL1AFA05nuJjcLTUGnqtF/FfL4/2Oq
	 5HwVsScHv5eL634wEOjzLTI79jvRxoiAvm5LxTOt+vBeO6j+HXoiuuS5vOH8IuUgIAVis
	 ySBpMnkwEpnXu01YcB4s6JcwYSQ9uq6eQN1KIhlxkzSQ0QPWrV75Pxj11MqL8m5+u49rS
	 kvPvQu/yxocVU3e3Rg4LlHUohPhO8b15ERp1kdMOIBZfHvZvmeCJMtlWkEoe/0HPeZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FLQMGrYVJZZouYhhiktcxqDf9jnkq9VZ4lUDUIqlAiY=;
	b=AQRZSuQzZdQbCBMFyFXJIvJYkIw4Zn9McMtWd57XkDKa1DJIZg4eK6yspUq4dxyyAnod
	 R6ss0HOMAep1jtD6XBDKJm+lYR44lBf7OJ5e26DSoQJNVyjTji3r4cateRSXB0G4yM2p8
	 cXOp4HmOi3Pkz72T6YP6ooC693RMrLFQzpk5Dke4uFjtfrlp5qZyCVtDGr7A3dzziOLd2
	 v6zZHZ4HioNfxeTB/QicIOdltJBDqETW47TNqv9pcmOFWLBAYTPdIupU+nRANUz275bqC
	 xIt22kE6ISxPVGzBxxouiV2vEKRtWm+9vU12cPfoleJ2TyxQZ7fetKFDZI7xoHxhVxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSIbrMSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8552606A335;
	Wed, 18 Nov 2026 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSIbrMSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F0C1F000C4;
	Wed, 18 Nov 2026 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015656;
	bh=FLQMGrYVJZZouYhhiktcxqDf9jnkq9VZ4lUDUIqlAiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSIbrMSwnt4mwTf1nZ88st4KmReWp6oHv8sPLurSADuR+MlgEZcDszWsGTIj84B+2
	 XWX0sNDCgmeFFpCUXX/OlVbCRerv53+FtCPr4xr2iwIWHo7wg6qXbJlNOTX6JBW9GY
	 sdyc8CL28yMCdqaktgkmTZINnOkHZG24Wj4NF1kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0210/2651] wifi: mac80211: dont send encap offload frames unencrypted
Date: Wed, 18 Nov 2026 15:24:10 +0100
Message-ID: <20261118150255.438377938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a48daf145fed445d41ef422573411500785415c8 ]

For 802.11 frames, ieee80211_tx_h_select_key() drops a data frame
that ended up without a key if the station requires encryption, so
that traffic can never leak out unprotected. Encapsulation offload
erroneously didn't get this code path. Fix that.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Link: https://patch.msgid.link/20260802085818.1336616-7-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 95493e3590e9f..884bf96547113 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -592,6 +592,9 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
 		tx->key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx]);
 		if (!tx->key)
 			tx->key = rcu_dereference(tx->sdata->default_unicast_key);
+
+		if (!tx->key && test_sta_flag(tx->sta, WLAN_STA_USES_ENCRYPTION))
+			return TX_DROP;
 	} else if (!ieee80211_vif_is_mld(&tx->sdata->vif)) {
 		tx->key = rcu_dereference(tx->sdata->deflink.default_multicast_key);
 	}
-- 
2.53.0



