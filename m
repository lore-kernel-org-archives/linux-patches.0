Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023045;
	b=OzcNQ98suZsEAAPBVAnPPL3BiLHafMfJwELaMV5+tNW0yeYbZlAYzLS2E4vTYEaKW21j
	 AM/WcHTHEaKSSZeNUhLrj50FW4tsTDU4/CaI8LG9JurKPN55w2xZRb//yCq4bpkK/3B2s
	 TN4lbZdGxTyLhvaGX3lVMcAMNmOEHAizAq6t6WzntUNtzSOdwnXC4icIGryucdLI34A3J
	 W/zr7is3CE4V6ZD5gpr74gBiFo/MVOGAWJjiz0AHKJE3siLtawva6JpHyE7F2qquWgdB9
	 YaOXBEPK6nIoRUJlVMovAySqyNvjvKNyD66cDsdrMr+UEmh9OBtf5cQYVBNRuJO4n3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vfr6MiWE0Z22dPyrfZ+IMrXJSA8jpnqc9yLDjLCD5Ec=;
	b=LpI6Pe524Xio5DEx9XttVp9z4C1rIW+KL5zbzKy0ArTJb+ePeQJ5D4UJFooOLhYDAMLY
	 NGO1PCjSDZeFW55Ca+1b5ogImMVcjd5xWo8u1xWarC1VOi8EL2UFdxZm4JWfe49s0x5XW
	 K1+4fjgNUu8rsU8WOb5gR9dIpPStT20DOEFejfcClO2b2cXacgKbfevxU5Fx/oT4swPaC
	 myTUPKrxXx5AYv/61ObcTZ5EJK23mBMj9sE8tG2au2vts9tp3gJm1NnXuy0iyWTEZGBma
	 s3Kbf63U/Vllk5Ab3qTN5ZQPZCWgPkaOltxFaSkrpIXyA8zW56U6P/hsMX9IW+DcH0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFhLoaYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F5A606A325;
	Wed, 18 Nov 2026 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFhLoaYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF39C1F000C4;
	Wed, 18 Nov 2026 17:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023045;
	bh=Vfr6MiWE0Z22dPyrfZ+IMrXJSA8jpnqc9yLDjLCD5Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFhLoaYsk2NmpVQ6CPnSfWsvOMhaBo29GmU+hLcxj6mJjJQaPLiir+y/Zii+c29rN
	 iG/H5b4OoNMgaSnvkNHK6hRbUTtpVyDh1PV0mnaZOnEMzXyjbEHqHfmcvJlF9dypVC
	 ADe15XSzbo3riDLCqRL1u5FzyUY05ySt0NeHE7ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0227/2151] wifi: mac80211: dont send encap offload frames unencrypted
Date: Wed, 18 Nov 2026 15:32:42 +0100
Message-ID: <20261118150130.050194308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4e7a3e93904b9..aa96d575849b8 100644
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



