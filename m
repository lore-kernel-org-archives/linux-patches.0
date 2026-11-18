Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055993;
	b=MHB4FQnJwLeZPvLSUufNPl5WcdDJ53XSs62E5wJU3KAUAK5JR06jUGthX1Ia9fxh2fkI
	 eZR3Pjj4FcI3HYP5hv1/KJArGjZHXbTpsy/abVoWr0Ye2WmdGPcrQvQLOeQVnMZ1odt+x
	 cRGPtBys5YV805yf+XzRjz8NYWiXNVq4TpQqJsyYpVmc/FM1+EqSl4Pzma5if8EbkS2Cj
	 ewfD4jpq4rPl8wPHjxcYZhPBsWc1a78wMTi+Asd2KwA8kZSkAP+e9v80WLoPviKuFHWuM
	 q1TbD+lPD9P5uxpa9ploHiBb0DB7dbu+KXiFLXSsiFQOxwYdmo0XPtf+1H2pBLK4c6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YKPfYJbtO35we21uTlsnliUIjCs3TwTgqhb8sl55xZU=;
	b=Gur5n+z2hWOJQXJavTung61bHpEUn4lQDYqRWcFT9jziWmnL1d2u4+OoczYloRKgOYma
	 EgHPNcJNLEAcPOxKE72tnJz/TxlsJL+zziE0mZ6seuNiKcIOgkwbrHD2ED4gt8FDnwND6
	 SJGM2gPTBtHqVkmM4TfRGs4PApiDafrRFnKDStGYQZUsa/GUPsXEnaQBm2f+tbXlyIeER
	 PrCl4BwNkJ64F1zhzdxLfxNG/+79pa7Sg8JoOOs2dBgghL1vrMveIzYWnkAwSfO3zqiWu
	 qyMk5HDKdv0UeAUtJL7TDVPsxpvRFTPurnOo7ihV/jwE3+3vEwbmd6EjL/Px1S57I6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYwpy8gN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64025606A331;
	Thu, 19 Nov 2026 02:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYwpy8gN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E921F000C4;
	Thu, 19 Nov 2026 02:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055993;
	bh=YKPfYJbtO35we21uTlsnliUIjCs3TwTgqhb8sl55xZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYwpy8gN7jzpQ7gHLfwEtNZb882+HvoMKyKEDwDbrDSILCjNBkahEnHY6/0re235U
	 Wj14nhqdDRKWiU9L/rmw1tBCbt4qE6IR1PQUks6nsY0oPoiwsT1NBUKmWMClHqHbnI
	 oXULpBgWFCp0Ac0hygFJKh9qc+AbUeb/BDknjgDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1830/2214] wifi: mac80211: init radiotap iter after length checks
Date: Wed, 18 Nov 2026 15:58:26 +0100
Message-ID: <20261118150124.642339371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e3cf8da7e0c560db67ac5ee8c9197514bb298ea7 ]

The radiotap iterator initialization will already parse
the presence bitmaps, so it accesses a good part of the
header. This might not be present in the linear part of
the SKB, we haven't checked it at this point. Check the
lengths first.

Assisted-by: LLM
Fixes: cb17ed29a7a5 ("mac80211: parse radiotap header when selecting Tx queue")
Link: https://patch.msgid.link/20261005224950.b5c2c31790d2.I091422db411b595bde4dba2de69334cd2aeb33b0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6e5dde41e11e6..4e25a7af7d862 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2087,8 +2087,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
 	u16 txflags;
 	u16 rate = 0;
 	bool rate_found = false;
@@ -2097,11 +2095,14 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	u8 mcs_known, mcs_flags, mcs_bw;
 	u16 vht_known;
 	u8 vht_mcs = 0, vht_nss = 0;
-	int i;
+	int ret, i;
 
 	if (!ieee80211_validate_radiotap_len(skb))
 		return false;
 
+	ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
+					       NULL);
+
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 		       IEEE80211_TX_CTL_DONTFRAG;
 
-- 
2.53.0



