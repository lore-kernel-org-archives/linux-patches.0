Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10AA2D73A6;
	Sat, 17 Oct 2026 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256970; cv=none; b=BLoP/EX3UQwyR7KabVlvPVDvcGNjpngu3u0ZSjvSVIcDRTwouIsYJmBxJfWGFcx9JE6d0wB4U24YxLnbs9Ek44D9himBdmYOCdoMMYXS0fWd3iATnxygNA4uwVaTN+iJmEJzVJ2xA+UOkFM5kHd8YmFdRuDW8Q+n66WkvwqeOwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256970; c=relaxed/simple;
	bh=b3wYStnuJCAFF/ilDyiyt2j/jPWj4lhvHxjWKIlpNEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OW6bf+iWKgvrOZm+SgVGH0onSp43hSOSpn39RVs4MKlMm97zP8+WZL5Kp/YsmWSBa2zePh/STS8rHOHPVMgJj63HkFUMmBtrbhIZoSN0dSSZXhE1pf5zEJ/lCHh2QtUJ8Kl+nbdVEDGmEq0tqH08ZiYjaCuRiaCkJcbrdo3QRPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ip0OL80j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ip0OL80j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D361F000C4;
	Sat, 17 Oct 2026 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256969;
	bh=wdDCloyzCjFi1oEJjrgInnGkvlqyk7y/YOlj5t9QCHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ip0OL80j+5WOsMAVOoDfElwW/fzQMXOm8QlbYOkLHuRg2qTQT7lxD80AJ53bxgs+G
	 2F/YPwADTFi0/VTXSsesCB6egzIqSEOXuIcPlf1TFv/UhkO1g0J7tfHIE1rvuybOD/
	 qpLUo5iE3ynFwal9D9A3v5zEKxFVNiw1G+lLf3sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0410/1674] wifi: mac80211: keep fallback association elements alive
Date: Sat, 17 Oct 2026 17:44:42 +0200
Message-ID: <20261017160441.646605813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context for existing conn_flags-based HT/VHT conditionals. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ac3c2c3334fdf..9f67290e7fe58 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4026,6 +4026,7 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee802_11_elems *bss_elems = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee802_11_elems *elems;
 	const __le16 prof_bss_param_ch_present =
@@ -4103,7 +4104,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	     (!(link->u.mgd.conn_flags & IEEE80211_CONN_DISABLE_VHT) &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
-		struct ieee802_11_elems *bss_elems;
 
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
@@ -4160,8 +4160,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
-
-		kfree(bss_elems);
 	}
 
 	/*
@@ -4389,6 +4387,7 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	ret = true;
 out:
 	kfree(elems);
+	kfree(bss_elems);
 	kfree(bss_ies);
 	return ret;
 }
-- 
2.53.0



