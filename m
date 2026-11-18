Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039316;
	b=sf2/TnOKwIFnGb5x596XXsuA02P703sfBskKEBkxASD2nFv50YY4dbyNO68e1yjUp/dS
	 svNmFprGIRMsUIJwhuC0pXCJUu+SETIjDHLKXNz2aaK68ghe+iNAx23PH2p/iEr0P/yiW
	 zLgpuG5jgrwqVOy3DwYPgMvQ4atjoIXiIBn6lbbEQ4IcqaP0TQplz7MT0oy7j9MBWkBuF
	 kI6w5CQpeEduVbd6G+ClptKknlDJaIQpricSEyVwewre9ltwepEmWMF41FRZ0SuzhtAuk
	 7I/d0Tky0BXUoCrF0uPyVuzyRu1yZIPQH8m4RXPhRbTK0EuFnEThAr67qsO1/gifshg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+8SdbAqog61OLNwRxvzrjZ2bHhydHalZ9ukWWCT6pBw=;
	b=pSlmmBbhJDQfHt3lpSXab9ILLkdbw3F/o1U5HiVWre9cWkjatKT+b3VLlHbnAHxWnm+3
	 8V29lPBhnpis0+JqFRvsyqdDNQDYu3Gp45RlP6wQg25nIKvOPTSEKKG4JlzrVhy2u8vvH
	 DWsoWegdkpaIHFnY1OinXdgbVtk0rwIU/5SwEZkSjb/xGxbZb2ltNmqHPAAxDKv+eeeqq
	 3gZk2UBYZgk0YsuOfxRG96nl442a/bcPRyGlbzMXze8YihFzJvdGAB5amW5TyhD3XELV0
	 RMZ4XdPpVDLER+aqhTUSQPpX0VugeD2ZAZLDLW9E6axSPJux0/J+zeOrR+5ihoR0s/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtgY3nBq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE6A606A320;
	Wed, 18 Nov 2026 22:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtgY3nBq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C481F000C4;
	Wed, 18 Nov 2026 22:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039315;
	bh=+8SdbAqog61OLNwRxvzrjZ2bHhydHalZ9ukWWCT6pBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtgY3nBqAU+PLVN8wTOV5MLIvrsK+kx+N787UEmh1V0IanpGDqGoYg2ND1sgcYVpy
	 CCuzE4c/gPRQdZbrGMHhKSGrz6JPDFGB921N8i/TMsdqJheSoguA5YjD2YukFEOH6Y
	 Zbcy/+Y2M+Ml9rro0J4+nU3CzS1A+7BBO0Q2FrMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2050/3318] wifi: mac80211: drop encap offload frames with a tainted key
Date: Wed, 18 Nov 2026 15:44:32 +0100
Message-ID: <20261118150423.552339856@linuxfoundation.org>
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

[ Upstream commit c8ddbe1e8c43f6d008591c50f8be8de39cdce267 ]

When a key is tainted, which happens in some WoWLAN and extended
key ID scenarios, frames that would use it should be dropped.
Fix that for encapsulation offload frames.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Link: https://patch.msgid.link/20260802105818.870b6ef31374.Ib87175b55b9fd94c16ba6d9cd816b7a09248df87@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 88923c7e67925..c31444570a76a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -613,7 +613,13 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
 		tx->key = rcu_dereference(tx->sdata->deflink.default_multicast_key);
 	}
 
-	if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+	if (!tx->key)
+		return TX_CONTINUE;
+
+	if (unlikely(tx->key->flags & KEY_FLAG_TAINTED))
+		return TX_DROP;
+
+	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 		info->control.hw_key = &tx->key->conf;
 
 	return TX_CONTINUE;
-- 
2.53.0



