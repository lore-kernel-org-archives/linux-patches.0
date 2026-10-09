Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB4E399CE9;
	Fri,  9 Oct 2026 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556655; cv=none; b=tTkYMJraVLoyGH10cfwwgaehUWQLQbIF9cAMWRxDqEyJ1K3lSB/Oz0qAeFztoEs9eKRSsXQHz5f1pvhIRi5x0VIoo9KptC2lptMerTJ70+cOEK58B/2vJDzRxULD9Hihr7L2jTD35Xjkt4U4Ml3c7KJkVI65qNXNT7ZhyHx7Fzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556655; c=relaxed/simple;
	bh=WNr/O1tnuSoVx6NliqDQFerekozaqmt2wKohZxvzAKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efw4I6+nWLVfe9wjCKmEueoeqYDCWERBORmLdB3DlSy9rdFOfi1yTdXDLZ4YyB0wrDn9usUUmcjfR9hw55jUdcQJ2M2WKpTJZeMOq3tML44VHn/LgCvl2cOhN1349F0tDt+bUsCJnmxCs9UFeOLCAvCSeY9FuPv8dSbsz4wRdrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yK4MeJaj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yK4MeJaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D09B1F000FF;
	Fri,  9 Oct 2026 14:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556653;
	bh=5oYtJTyWX6++0xI2B3ARsdQ2epd8aBTbFKhJpt8c1aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yK4MeJaj/89vKQbw+PteIrBn/bhX7o7ihI/XefYGVoeHAMPoeDJuUPwOWHpOFEG/H
	 BCCoTDZ8sx6vV0sI95DNaSjNRLiw4Lx5Cabx4xMlSun9l8vCynUqwGUMPza+vsrDbX
	 RJLfzebjWl7b9dRarfpW2300DVfXXVF28C8r7W2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 270/403] wifi: mac80211: keep fallback association elements alive
Date: Fri,  9 Oct 2026 16:10:31 +0200
Message-ID: <20261009140958.499191609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit a10a2f80476d166fd81c361ec0319493671b694e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5235,6 +5235,7 @@ static bool ieee80211_assoc_config_link(
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee802_11_elems *bss_elems = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee802_11_elems *elems;
 	const __le16 prof_bss_param_ch_present =
@@ -5318,7 +5319,6 @@ static bool ieee80211_assoc_config_link(
 	     (is_5ghz && link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
-		struct ieee802_11_elems *bss_elems;
 
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
@@ -5380,7 +5380,6 @@ static bool ieee80211_assoc_config_link(
 					   "AP bug: VHT operation missing from AssocResp\n");
 			}
 		}
-		kfree(bss_elems);
 	}
 
 	/*
@@ -5632,6 +5631,7 @@ static bool ieee80211_assoc_config_link(
 	ret = true;
 out:
 	kfree(elems);
+	kfree(bss_elems);
 	kfree(bss_ies);
 	return ret;
 }


