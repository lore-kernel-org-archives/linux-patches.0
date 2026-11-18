Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049417;
	b=eSEuj/weOsOE0Y7IerCzE6Trpc8aT0eKLP4K3qlPbAW+bJvcBzpRYJWgCgVHeQIATIq+
	 ijT4BcWxSVCrC9mL+FO6dcknQc+wv5CitFlG8RH57wGUOiHJzqtQUnNTZ6QO6RU+vjYBK
	 CId+elGtpxlM9RR7haAE60qBvgun2yVdDEG4/LbjRaj814M3Xxw75Lr0b3fin2NZ/Xf4+
	 tLvHc9c+72Hvy1kI0eh7cmauGNey+QMtWguKMAs55r8U50A3+80z/BvvImvmlZUxu3J+u
	 eEdwCvOViDNvx6U3OAAmS5Crt3iTy4zeaFt+MOkVXEy76ZQ7ngCZHERuJFPGw/TY0Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vjCDNicRnDchwBLt3jI0x1mepXUkIvGAJogcY00ENLQ=;
	b=iGE22lXjYuAI+b6locrMRXtLpTnrzbWCXYY9ARvgcv6MXQiXoK8Eruqx8i5jZdsAIqji
	 ErI+b6XDA8mj2dTuibptltEPPrrPikYm7eo6TWwCB8+h05wDQPkSBYl1gMoflMjklq/2D
	 N2PUNxLn6ld8vQQy94bzuUUiMrbyaBih1sw8RwsJ/L153Kl2Lh23esSq9mGvxZIOvFFRO
	 XJ/e1tVxej/4HabH1APlTNtUZpszWQki7T1GpSIKg4wH1svpMgAT8ItYXk3ax+70D7Lbc
	 fCVGlltsXAaD/lnwUGp6PvSaWjYjyDK9sNxaM4b923CHuqDuOPl49CoMbry9tTeqo6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2qrqqla;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C40606A32C;
	Thu, 19 Nov 2026 00:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2qrqqla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966E41F000C5;
	Thu, 19 Nov 2026 00:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049417;
	bh=vjCDNicRnDchwBLt3jI0x1mepXUkIvGAJogcY00ENLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2qrqqlaVdTa3FHfi+wB5Yx+2mf76ps25PldrvFTAWwuh0/GHcKqu0PJPfTdMlVKf
	 lAi/dMB8+cORyyiCNHbq7J0cihb6ulRTpVhPyJU8PAFnJ4DD14S7GZcFjgRvHojTjx
	 VUvI5aXNvrt6+gcMkjWIgn8WfV/Q6KQT9Qv5QKno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2344/2857] wifi: mac80211: init radiotap iter after length checks
Date: Wed, 18 Nov 2026 15:56:18 +0100
Message-ID: <20261118150325.926324680@linuxfoundation.org>
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
index 3ad7a6ed5e66a..402a57a627eca 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2139,8 +2139,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
 	u16 txflags;
 	u16 rate = 0;
 	bool rate_found = false;
@@ -2149,11 +2147,14 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
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



