Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208929;
	b=Mt0TKSG5MKTuHr8UaZu+6W+Rao5LQP6p54dh8t7Abt5D+FK1YKRRVzy5uYqofQpTHfNU
	 7V4KOcJSnv6xL/pbJIQuWr9bEvYLK0fyTZPryFCto+pkzFZB/r3rF74DoS5CfMtcQn1Pb
	 9o6IBoyQfdpPqi3opPDXWN1738I1LNOeHkmLpPQsWiq40z3X6RxrPrtEze8Y4ZjzJrEue
	 /9RlflgsX/O92UwKiIu9j59vmI3C72WCA8D5xVE43ur6sNlczoOuBjZ5+66cVHoS3j8kZ
	 wtHDFuZ5NUpL0ruW7+ovKijii/X23R+geRTRwcOM1H1DUnBM4tTVchwoQk6khml+VrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0XaseH1pGMv1f39E7tWd97Ngw5Fnh8L+O0ExdArKuY=;
	b=yXPkvV3amn5C2ow6RtXnsljWl9qnGjggfVkLW+kaSZ+bDz4qzNPYrPc3u/dVQBmsUBG5
	 QKUasy9jFT0ziVtvFuxNXNipzfftK2niTMkYX01gWUDDWXbwgI3Xsg86IFDGEhJsvBbkJ
	 ySfUZ2WxmCBM90LZxNXBhBArr6fHisvyLwPcdusgYnvvE8uX5TXbi5/iUFYxK/bV55hJE
	 QyAs27ZhJF4mVCx5RVA48a6BCI5ARxpbkRKcnlWm9Qa8gO38CQb6WuOjGnPI6FrRjPXMY
	 n96Y5eWSjC3wiBH3o78+6eUxpoyuRiS/D5mDWITCLIIboVqwp7gpYlTs0kteYHgI0mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ccGrDfkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB2E606A31C;
	Wed, 28 Oct 2026 17:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ccGrDfkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0B81F01825;
	Wed, 28 Oct 2026 17:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208928;
	bh=r0XaseH1pGMv1f39E7tWd97Ngw5Fnh8L+O0ExdArKuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccGrDfkgy2KOEFzJz4ivUcGwvifAtc+FJZYCrEC61f+53VtenhhBc0s9k8nlx551p
	 zngUsliTMTtxaZjm+zFW2mlqDfdGqDwoEXGLLqEJ7K4OOIeNmZOe++GHCnNJ/g1vGK
	 7OcV3LpwFtIpD5QgR7UQZyOWZ8JHEvjR0fw4rgbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/516] wifi: mac80211: keep fallback association elements alive
Date: Wed, 28 Oct 2026 17:57:25 +0100
Message-ID: <20261028170010.433699101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit a10a2f80476d166fd81c361ec0319493671b694e ]

Associating to a non-transmitted MBSSID profile reads freed memory while
determining the operating channel and applying HT capabilities.

When an association response omits WMM, HT, or VHT information,
ieee80211_assoc_config_link() parses the cached BSS IEs and copies the
missing element pointers out of that fallback parse. For a
non-transmitted MBSSID profile those pointers refer to merged-profile
storage owned by the parse object, and the fallback block frees that
object at its end. The copied pointers are used afterwards to determine
the operating channel, configure bandwidth, and apply HT capabilities.

Keep the fallback parse result alive until association setup finishes.

Fixes: 5023b14cf4df ("mac80211: support profile split between elements")
Cc: stable@kernel.org
Assisted-by: LLM sparse kasan
[reorder variable declaration]
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: changed kfree(bss_elems) to kfree(bss_elems.nontx_profile) for the stack-allocated parse structure. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 79f7f3812da92..0a66b3db29ad8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3284,6 +3284,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	u16 capab_info, aid;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee802_11_elems bss_elems = {};
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
@@ -3346,7 +3347,6 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	     (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
-		struct ieee802_11_elems bss_elems;
 
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
@@ -3396,7 +3396,6 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
-		kfree(bss_elems.nontx_profile);
 	}
 
 	/*
@@ -3652,6 +3651,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	ret = true;
  out:
+	kfree(bss_elems.nontx_profile);
 	kfree(bss_ies);
 	return ret;
 }
-- 
2.53.0



