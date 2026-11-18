Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049569;
	b=c7mhJzZP8GFg9NA1zZzNcNSRQohFxd7rtw7rmqSWio060swNMIEqBj+1PLdyF5OFoHz3
	 8R9PhW+AB7fhPxNmx479f1cfPWURmTwu9zefm6qd3MH1nYutGk9ZR1rbjbEkpxUDFKFbe
	 zadOSKqRq6d6VA4r312b4+Dbsx5pGp3MJiW09N9M38K7/qh/6LbQygvqjQfpTTCBP7UMP
	 fIhuzWWFjY851BjrqKqtQsXNQkIL777xVAEAoeV0JlNjB3A1lVca7HYZ4PxoDLkXzCUkp
	 T5Y0R7yugtvr5jM62G3L6S2HX1VvCI7Il0qWXabwrCBn+t5bHJ0TyYZnUCNmAh31f2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ma/TmIzUw62xytXtR/ws3aKBfIAB2L2KwRMq52quA8k=;
	b=jjohgrb5mXVS1NMsuDblkaMQWlR/XLoJx7dAOonBNHAOlsnGkJHhUdrsgZVFj6GzhDZU
	 WR4yXFGgZ9FsAviRCX2AL6gip1jdhtNYhClhxP0PK+OvolYXXpYfzgwG5dvKx1901NHVK
	 pKLjR2X9cVnCEm8dG5GWS10w20wx4Do5gcthhfpzbJpKFhcNAckhOs3Iz0XnPDQ+lp4Ss
	 2Lxp56FLC3b1feMyLU8FD3qRHdsxgbXB3ayE/kWAFypUnCXWnmtkOgY8thJi+8Tsril2z
	 xCSl2isY+kHWODnNR0POzd0Vkhgi8nz07T3qIjOcuG53U0Zvz/kxRJmI4ODRVd3Pqsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OzSE+t40;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E497460A260E;
	Thu, 19 Nov 2026 00:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OzSE+t40
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2A71F000CB;
	Thu, 19 Nov 2026 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049568;
	bh=ma/TmIzUw62xytXtR/ws3aKBfIAB2L2KwRMq52quA8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OzSE+t409y2/pl6y074iD1ajSxcXAPCldX6jeAQaloqJ4a94PLDqxZwYTMCNOho4t
	 tpdUoPoRFx3EmDMy8YN3Kq5uzxge2OeWZ+aPMe1ujb6eYj+jXffTbn/H9+R22tfcSj
	 kfN0tDfev0pOSZzzmZNb56Hh1gi+QXkI/N67D2YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2397/2857] wifi: mac80211: fix encryption tailroom
Date: Wed, 18 Nov 2026 15:57:11 +0100
Message-ID: <20261118150327.825390451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chien Wong <m@xv97.com>

[ Upstream commit c49f54fd2abff08964677db8fdc1674c713ab42c ]

BIP-CMAC-256 and BIP-GMAC append a 26-byte MME but mac80211
currently reserves only 18 bytes of encryption tailroom.

Generating 26-byte MME may happen to work because the actual skb
tailroom can exceed the requested amount. For example, dev_alloc_skb()
rounds the allocation to kmalloc size buckets or alignment boundaries,
and the extra space may cover the 8-byte shortfall.

Reserve enough tailroom for the 26-byte MME.

Fixes: 56c52da2d554 ("mac80111: Add BIP-CMAC-256 cipher")
Signed-off-by: Chien Wong <m@xv97.com>
Link: https://patch.msgid.link/20261012140738.70178-2-m@xv97.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index db96956cf5ae0..a3f8be1806061 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -49,7 +49,7 @@ struct ieee80211_local;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.53.0



