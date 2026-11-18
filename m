Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039437;
	b=hl6lWSWZrScff01Q6L0uxfQBwc1DvV6h6IbmsHfE9fORvFhHepYkCHIXTeuKO76CY0b1
	 yVTnrgIzU1R0+jtKf71jaAJ02/jkhsgBzzdaTzvgIHj0fFWLGwQU5XRx6xC1tgn8lSU9f
	 RFU5WLGFmWv9QYeMto6/xwnJJyq7mjspIXlenUx+cXiKDU0daGm5V5vZvg8wliE+zDU/X
	 W+HPZBb2QrFzFPFc+R33FZU77dzU6nU/1yLfRPxzSGQSD9DFjbsnp4vS1csUNi1VDhZ6B
	 uMosfK31u2HNVo97bQYGDnOhkY6UBTRXR2u1ge3eBGPktLXxJfJwjlpVdppP1uRkAsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7vyZnvjErpY1xjL//PZ+oIlNugan5z1IHi8LwFz22uI=;
	b=DQ8TbSKfsQra5gOMsmUQKHeO+uW0Ypmk3JGzuJOuXnktOCpnXre8CfoGdFa/ELKlfE/E
	 oBjC7u5moFo6uB4rWHhG1RNrcg1Rj8XHCVO8JYVtT1aoXe9k6rt2ipcG7382tcuc5RBjk
	 eRGuUI7x5h++Qs8bkgcNz0E1ZhdHJaj2Qm6FR0wkbkI+/3SU7F6aH20xnutcZA8KbgdeK
	 AKCCQ0MugE2JFHCmFrrQ6YzlUNmENQoWEMLHA4By2/3PWB8K0eXVT/bYIBUp//3NJXNrX
	 6Nb7KJ+zskEZvqhJXzg1PVHKmvIAKOlrw6k9frsspfCfohHleKWS6kFhj5ZfUfcXI4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gAPEb/IE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85188606A325;
	Wed, 18 Nov 2026 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAPEb/IE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7E51F000C4;
	Wed, 18 Nov 2026 22:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039437;
	bh=7vyZnvjErpY1xjL//PZ+oIlNugan5z1IHi8LwFz22uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAPEb/IE/mxe2LGRHKCR1e9iG3PoeUH6Ib6y0GZ+19LXu0WmR0hv5rTj7msWzoMB9
	 d/4WZYrmklsqPrylBAODeR8wMb/GzeA2d0Z+TAfUFohe2osuymEjM/Z6E/29VyC4Y8
	 2ljy/1otoe5hEzw5sBczqPnsx1SbEB9Q90gmiFiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2049/3318] wifi: mac80211: dont send encap offload frames unencrypted
Date: Wed, 18 Nov 2026 15:44:31 +0100
Message-ID: <20261118150423.519023571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 45aaa4702f934..88923c7e67925 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -606,6 +606,9 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
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



