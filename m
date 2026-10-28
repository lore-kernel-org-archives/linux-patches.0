Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211379;
	b=AIoCeV1eJPGK/Q3vlF6EyTR2fjjWr/lnI9lWohhCtFmz7hKlfdw2sM6hViVgXFbQpx8b
	 IrnVT1cfYTIX28KekHhKDpGU3CwWl6GN5M42ViXPlSQlOf0FB+GQc9kp1tG6wDW4GXwV1
	 hPqnjSWm1tsOS9suYv70xj5c+EPvoJ70MqxZrS8Za/O/dAe+KWCNHyz7Z4VC5tLbIG+qK
	 K3Cf25ryIphMMfSwZ4IiTizZ+hNbPWYw55Z1uU+TsSHdTW/ipE4PcUOlOsDggxwYZPNcJ
	 3zue6Aoo0auLd2ER2GKuLHtakp5HmKLe1oB6Ep6LgaY50qCXV/Tcg1sWBlLm5b0V0gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iEexf8bz9NeHXV9IbyeeCGpgPVKIyvZQLi/owr9lIts=;
	b=QB52Zsdw3AchwH6Cv1JG/kNQRQwJBqrbAWRlhNRp6HTha/C/tZyMFhLQZpP5Mi7QrW/k
	 YxqfwRw/sewnMb49+Vf8mWQU15PDVDfk49yBL7e7MtqTZOty2FV1Gvm/GULsrojXEIWGk
	 TVEStrQ7r3rkHgzqyh5PMN7COFiF/gqvyxltIyftAVpuCmVSJEULZoH8uaskht3UqueOZ
	 KGKGKz4nxfyLKvhndV2oUPFh9Raf/qznngEvnlSwN9/muPwv642o95bPjnXqVoUui0VP+
	 yWaw0dxF6KPLSFuaN8ZYpDqhJl7S+uA14Zut+uA0ECm5KuOsOFjbFXIBmt8dEvzsIZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Lq4YKYc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5479C606A325;
	Wed, 28 Oct 2026 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Lq4YKYc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66BA1F01825;
	Wed, 28 Oct 2026 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211379;
	bh=iEexf8bz9NeHXV9IbyeeCGpgPVKIyvZQLi/owr9lIts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Lq4YKYcXVf/6M6hIn8AG29OnBwFloGoOfJwGL6UrZZ8GsAnUIk/ExuG48pOxz/yu
	 3BcJ6NlYOUU5fnkZ8NKz/iztlofCdfH1g7+zSIyghxfEZo/QMYVGUaiRJW8SUmAQ3c
	 4wx6eXrNwwjU2RHdBqI8ZgM5GQ9Hdc1Hi7rl+8vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/571] wifi: mac80211: keep fallback association elements alive
Date: Wed, 28 Oct 2026 17:57:47 +0100
Message-ID: <20261028170015.594631936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
[ sashal: Applied the changes to ieee80211_assoc_success() instead of ieee80211_assoc_config_link(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5617540b40b29..bfd4654d404f0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3310,6 +3310,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	u16 capab_info, aid;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee802_11_elems *bss_elems = NULL;
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
@@ -3376,7 +3377,6 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	     (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
-		struct ieee802_11_elems *bss_elems;
 
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
@@ -3432,8 +3432,6 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
-
-		kfree(bss_elems);
 	}
 
 	/*
@@ -3685,6 +3683,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	ret = true;
  out:
 	kfree(elems);
+	kfree(bss_elems);
 	kfree(bss_ies);
 	return ret;
 }
-- 
2.53.0



