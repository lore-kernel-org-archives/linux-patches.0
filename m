Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689F5348C4B;
	Tue, 13 Oct 2026 12:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895244; cv=none; b=QI5Dx+zmAoFvNTdnNH9DvK4k7UtxpJNU3bWSPVkHtRjZeak7JgL9TkOUMtTHkD813pq1XTrG2WUTmDjmGnMud2rb+P5ifdBl23AxjuenPWK/CLNZLSQfpjc3tEkZCDm8FJnNihM1MagjWqzJZSG2R/yLb+cJ0nJFrG8Z1dYqUbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895244; c=relaxed/simple;
	bh=2rgRHv6j2u5vNUmE7rFJTNQVPIGQ6H2uH3HTRm05sSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP6x2UXiaIdDuznOTbgtz/xKZamFPkGZx/arO38fdu+8hA03ufQZHm0jE5iaeaY1FeDTY34FzD6Mu+4Nybh0IVvnHZXVED0Ndd4kKx28J4ItRq/vuhCflWYUSNpzeek4H06As1luMxwFCZayrOYwIOK4mcbR2FhEKqqshcfDxSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+P42G8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+P42G8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97D21F00893;
	Tue, 13 Oct 2026 12:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895243;
	bh=mgrYImmFaXoL2hCUyDOk8GkyVH8x4Fdl0RUzo0UlU6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+P42G8UzE4YDMw68awP6pNE0P30Oq+g6tq6z4mI1wMKtj7owWBDKABf0JcH7G+Zr
	 hBzQlXYCPVsLtN/PeLcNP9nGcQbJKDevlVcQjisxGCbF/T3QrS+xDuFhsBE2Mt+lj6
	 w5FP5Cn2XRfn9CNDTs9J3pgFL1HXOdTB4v07IePg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 208/497] wifi: mac80211: keep fallback association elements alive
Date: Tue, 13 Oct 2026 13:36:15 +0200
Message-ID: <20261013112912.827681015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4660,6 +4660,7 @@ static bool ieee80211_assoc_config_link(
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee802_11_elems *bss_elems = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee802_11_elems *elems;
 	const __le16 prof_bss_param_ch_present =
@@ -4739,7 +4740,6 @@ static bool ieee80211_assoc_config_link(
 	     (is_5ghz && link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
-		struct ieee802_11_elems *bss_elems;
 
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
@@ -4801,7 +4801,6 @@ static bool ieee80211_assoc_config_link(
 					   "AP bug: VHT operation missing from AssocResp\n");
 			}
 		}
-		kfree(bss_elems);
 	}
 
 	/*
@@ -5032,6 +5031,7 @@ static bool ieee80211_assoc_config_link(
 	ret = true;
 out:
 	kfree(elems);
+	kfree(bss_elems);
 	kfree(bss_ies);
 	return ret;
 }


