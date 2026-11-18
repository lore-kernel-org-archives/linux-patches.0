Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031343;
	b=geGEmAva8xsQwf+04ccpEUtf5OZcHllSxtVKE8xLPV0srXMPxVFqsmBj/lcVyLMIyUaK
	 5kiI7ngyXGD+JUp4uRTEQ7WnNZ0ojPS8YzXX+VSL/3TGJ9fN5oqhQIVXyAPNRXqW7Gjjn
	 kerXy2teh/UllBad6i53zHy31ueEjX4DrStZgYWQdXS/Pjwp9KBc/DmHt2O7axPMlkZS/
	 /75L8k6i8DsaA7cp9VwC1PSUZK9obZ4PAbiNwvsvUnp5Q4WnM0qAn/9vzFQejEXItRXje
	 xoa+JC8RUcUAhl4FBFMd8Mh0E7aYUlQgwYyW+RaECYCVsRWWb/X0G6Sj/J+3G3VXS5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gf6pTHJ/BDBHFYQhfjgU0kOGAZdlhDn1ES/MJV0cPxE=;
	b=4+495tKEcyds7jmkQhEYlX/VWGXuNguODyBetnQ9GuqMr42liJFiOzIaRg8AoHY8mblP
	 9QA5hPDOL1Gmf6FJXtDJAvYXfW8adSqbO1R9JyfAounPQrWT/9M22Ok0Rwmf07CPsMiYD
	 wWWpzezd+bNO2kQaEA7vnDLaxPES04sSNgur2XHXvJvotGzRDaOOCGIyZq3WeGwD0/7sz
	 3Vn0hnA2DunqOMtZNZRgAaL/RmODqcMTwts0C2c3gM5WI4Cneuj1xnhZMX6p3Vzb7meqe
	 XJKqq8OFNkUNtI73RGlfH54QfpxHoKy+bWdZmiryCpj4Ghs73RvcBUqgzS623uhX47Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVYOXbgx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09C4606A31C;
	Wed, 18 Nov 2026 19:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVYOXbgx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3FD1F000C4;
	Wed, 18 Nov 2026 19:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031343;
	bh=Gf6pTHJ/BDBHFYQhfjgU0kOGAZdlhDn1ES/MJV0cPxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sVYOXbgxG/WbCmh0/GBT3xqB8itQEYcTwU+YiVVv4bUQEkpWn2YNcqTHE8+vZ9kWq
	 E/w7R9zV/rseuCVKYut0jxFUdYirw3wqb9Vfhq+VWyuV7TKHigTd/egjjqYg0JrW2j
	 y4rs/V8cMfqjDCpIQywFVd0Xj3gHp4O/e+9e6rks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1026/1756] wifi: mac80211: init radiotap iter after length checks
Date: Wed, 18 Nov 2026 15:52:33 +0100
Message-ID: <20261118150050.936030855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 24ed731091bbd..2d0ec80f55b89 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2160,8 +2160,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
 	u16 txflags;
 	u16 rate = 0;
 	bool rate_found = false;
@@ -2170,11 +2168,14 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
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



