Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041180;
	b=TpnsztJBc+5cB21V1MLg3aDM0hbiyJhrHgsVeUmXpESJlUsmgQqCf/lI8UySgOaO832A
	 /rLU7REbz54G7mT7zgDrBqDTZ40amhZaJ0fBhifU8mYyYuBSDVJ62FgAB5i2tRbTBR8KI
	 /mTWfVQDmUvbZERyXf3jn0+Nz7YqpSOJJgKtcScOCJee6oxcAjY2PuBcXlhNsIWVX9Hzp
	 QVSzWeRtJ4H3747amut24DG62wgBF+eDa/kxTXaVcOBuo28g6I0+l6wZ1VfTyv6fZHN2p
	 Y3XEr14KKjGnnrZKhrEJRuSoLA5f45O3UkHzjDP8cZi/tvMp2xwiH5e+mRjjggWhW6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=umCk7GULl2NX2oeeVlHnqJ2yHT03Z9HFTipnkyLb6U8=;
	b=ih47nXTeB0BsPG77wBodz2lr1ZaChYI9fvO/e0FQTWSzefVUoIz/+skLyYSmYcQStB7V
	 GYAfKilmuQg2q/dO/wBuIZH44a4iEX0OxgnDfR+QEQt8Vb9wgbu/sYkBDjZ6sUSeISTfj
	 NyXCZqqpjp49kjrGRlN17VtFKLQVOMh2dBxxdwk5/C+Vx4vjBI00V+/qZ1oQkluVk4wLc
	 VqsrsyhsAx0RkAsPFk4rbnN03WH+MoONg5HebW76RVa9e4ttQEw6urTcnZoJeYnYCoXS1
	 JeqwS5qDNhGY2cfgMqsqodx1phnLl3X6rApQjTVYiy9NeolPjAUOad10J9F2L2RXuow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVSlFgUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11A5606A325;
	Wed, 18 Nov 2026 22:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVSlFgUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F052D1F000C4;
	Wed, 18 Nov 2026 22:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041180;
	bh=umCk7GULl2NX2oeeVlHnqJ2yHT03Z9HFTipnkyLb6U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVSlFgUoB/kl5zOmTAt0rQS3SF+ai3zInc6IWKrMjqVTXsFbrt5nAE2UFRDtaNLix
	 JE9bUDjtpl35nynvgFSmk5PJ1NGIPMZt18h5n0QJz67S++C/leSn3lSOyLQIz5K/M6
	 ZbxD3pmu/VfiAikLbB/BAMKgXBv68uhwiVnHuumw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2714/3318] wifi: mac80211: init radiotap iter after length checks
Date: Wed, 18 Nov 2026 15:55:36 +0100
Message-ID: <20261118150442.290803016@linuxfoundation.org>
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
index 0690c9004a4d1..43a66201db299 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2152,8 +2152,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
 	u16 txflags;
 	u16 rate = 0;
 	bool rate_found = false;
@@ -2162,11 +2160,14 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
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



