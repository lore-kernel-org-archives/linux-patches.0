Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455E93AD522;
	Fri,  9 Oct 2026 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557288; cv=none; b=JfHrzboQPPl4MGxNn6AaHrntnKF+78LQKUCNkyZOsKCVS+nugHOuf2oEDpdWrpL5EsWJYi2uG7n7az524cs0xRuAqXQe6tUVd5WpylOHA/ZjwlfsvcJnInL6yIIsRt1VYTnycijQF+M5H7OKzYTcMti4ah6KgvYndAiOCGnyCts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557288; c=relaxed/simple;
	bh=hR5J8QC6k7EsE5/vbyLWnK4RlpcZncGnOVGP/aGwr4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrCL+oq3Jz0nA67WAnZeQqyWGCoQsnnBTfHb65FxFtCjsGVfKVuZfDy8KSghKoO/CnZocUIRul83SQLBHHFoOm5y0yTEmJL5aTDFdSmMkM5Latyb5AZ566mzK6StF+m95UgBVlpbOgihWj206F0gwTV0kSq4cnt2WMvrsT0fpUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iz5oipkQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iz5oipkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5C01F000FF;
	Fri,  9 Oct 2026 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557287;
	bh=Mjr1wRbcbztgtOBSOpsLA+kWhuQfMxOqEiMb2fQB3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iz5oipkQXoPj8SSbsdILbrqTCc/vxCKJTHkEenmcwHmFrrkxNy1E9fTdNjqZVYOIx
	 G45CoElZukJyiM5pF75EsSxoMEB9sHdlb828Bx0FvjNDwhkZ9nLLC3Yzl7kTXHW2IK
	 8bATrB+l/zZsYBKH5le2bqjAI5QGrxYGJzCyOBlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 332/428] wifi: mac80211: keep fallback association elements alive
Date: Fri,  9 Oct 2026 16:11:09 +0200
Message-ID: <20261009140953.434554205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5871,6 +5871,7 @@ static bool ieee80211_assoc_config_link(
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee802_11_elems *bss_elems = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee802_11_elems *elems;
 	const __le16 prof_bss_param_ch_present =
@@ -5954,7 +5955,6 @@ static bool ieee80211_assoc_config_link(
 	     (is_5ghz && link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
-		struct ieee802_11_elems *bss_elems;
 
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
@@ -6016,7 +6016,6 @@ static bool ieee80211_assoc_config_link(
 					   "AP bug: VHT operation missing from AssocResp\n");
 			}
 		}
-		kfree(bss_elems);
 	}
 
 	/*
@@ -6289,6 +6288,7 @@ static bool ieee80211_assoc_config_link(
 	ret = true;
 out:
 	kfree(elems);
+	kfree(bss_elems);
 	kfree(bss_ies);
 	return ret;
 }


