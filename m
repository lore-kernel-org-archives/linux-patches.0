Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026152;
	b=XWtuunIJKOvzxDr51IBuATzd1a5n3CBVN5YJ8BT4ltvV6KD72W29TgYd9UI/r3E1g1B0
	 4/l87sqAWyvjzZzs0DFLlLutjolV5kXKh8MksrMTm7COigeaUQdUr+JbRxf79pdTIASvm
	 lIx1+yRDtUnBTc9Pu554/ZkAT6xqT+0UjZN/BLrsuNabyNH95Z+vOoLpnyeJ5CW/C7PN1
	 f3lKMY57YofNEebeIcWdPW27/O1ebQd/hRhGHwTuMsEgMJoHZ73K7PExgsBLbH0v09w8M
	 goWMt6byP0VSXpEb+lQzivAiRq+qb3+1m1ERticbf2FWiCLmPtx+TTu7Q8tK4O7TVIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yV+U+7j+KaCZqlHopSuViVj1hmqefG74VVYMYj9/Kas=;
	b=ZZ67OSL8sfTJ6vCi8bbHeN5LSq7BAGt5PIocKK2qYj5ja7eV7vW669AtcrYjZxIS3UtD
	 y3yvuO/Lo/MZI11u3zrKDjIOPXem86uNEL+9WL6dphebAlGZ4TnoHeq3IlhS9yRQgnSjp
	 AcW9AzJRDRf2fnkWQZF4dY6IZPaoDSj0rR8isl6olIus+qC1C48fqU6HcnthLO2RdgxjF
	 g/llYWf0Vqj6ExqwbsB079Y59f8/g0n5VFyxn7U0EC4MaqIu1VM1YvCczw5aUVE+CPeue
	 n8kgALPNg550X3I6cUJr5lWoZg7samQmQgIQs3i8oo7DkroC4+Xw1vXQJbYHXR+CHxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LP4PwL9K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85627606A320;
	Wed, 18 Nov 2026 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LP4PwL9K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C2E1F000C5;
	Wed, 18 Nov 2026 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026152;
	bh=yV+U+7j+KaCZqlHopSuViVj1hmqefG74VVYMYj9/Kas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LP4PwL9KZqM3Y+dyjhW3E0klnRw6oAySrq3WD0PbDiFHbXiYivZYJyzpriclzuzhg
	 ErIwmNiuxmQaAXJNWfFEYll2QIhBlzPnCZJh6XYyfsUqZ1cJJ1a/WPytb7+5jw/9pQ
	 2al80/KpZXAbOVDo0L+3iMd+5I7v5euv2zBKax+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1292/2151] wifi: mac80211: init radiotap iter after length checks
Date: Wed, 18 Nov 2026 15:50:27 +0100
Message-ID: <20261118150209.186165670@linuxfoundation.org>
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
index 67909f58c64a5..f5743e20a45bd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2159,8 +2159,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
 	u16 txflags;
 	u16 rate = 0;
 	bool rate_found = false;
@@ -2169,11 +2167,14 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
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



