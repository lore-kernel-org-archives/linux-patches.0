Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F81D043E;
	Wed,  2 Oct 2024 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877326; cv=none; b=UnSjOGGwm/Xxd3rY33adQp4ljSN9L+oLoITLCWrBlT2OSYru5KlTBrYTwbWLSUoMEaugN/7RFKSL1KjTMY6ddwz5dE6mgCT5GaolgZe/p3s3BTXXJgEXKyMpkb02+zNCqmKZ/RVkIvs/8ZnNN4lPcEA1w1tiSbxeBf1r0KgY9+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877326; c=relaxed/simple;
	bh=eu+neNZs/HjtvEDU0vZNM5fNBKJn9X/46IgeE865+fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elwsOl7ENIvArPZvJeoBgt/r+L0O1AfRibzROsuHFdjQ5dYC7Gkp2LZfn5UsSzNjy6uGRTWERqRynovs4Ut3F1z3FI0HdIPy1YXq5DQZP4sIcjp0AIIcKfzRN4eDevLM9URiGgVvD7p31bgJdpSnEXHiHXg0mJ2XOVJsFo0xQ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3kwEe/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3kwEe/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FC7C4CECE;
	Wed,  2 Oct 2024 13:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877326;
	bh=eu+neNZs/HjtvEDU0vZNM5fNBKJn9X/46IgeE865+fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3kwEe/rJGixHbqQO9cJzl+VJC1UH2YbVb3r+jwS+7dqMsEx7WA8FMDF+pY1MFmoQ
	 bgRmhbzn+CdLEjWUgHGvyimuWu8bVma+4a7riyVTewicozB00WreM1vk0v8BnX8da5
	 2KV1PlR3J789gNo+cvNAYv/h3Gi4NducDnXpz1Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 044/634] wifi: mac80211: Check for missing VHT elements only for 5 GHz
Date: Wed,  2 Oct 2024 14:52:24 +0200
Message-ID: <20241002125812.841987455@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 67bb124cd9ae38870667e4f9c876ef8e0f82ec44 ]

Check for missing VHT Capabilities and VHT Operation elements in
association response frame only for 5 GHz links.

Fixes: 310c8387c638 ("wifi: mac80211: clean up connection process")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240827103920.dd711282d543.Iaba245cebc52209b0499d5bab7d8a8ef1df9dd65@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 51b00ff7edf15..1faf4d7c115f0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4317,7 +4317,7 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	    ((assoc_data->wmm && !elems->wmm_param) ||
 	     (link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_HT &&
 	      (!elems->ht_cap_elem || !elems->ht_operation)) ||
-	     (link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT &&
+	     (is_5ghz && link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
 		struct ieee802_11_elems *bss_elems;
@@ -4365,19 +4365,22 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 			sdata_info(sdata,
 				   "AP bug: HT operation missing from AssocResp\n");
 		}
-		if (!elems->vht_cap_elem && bss_elems->vht_cap_elem &&
-		    link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT) {
-			elems->vht_cap_elem = bss_elems->vht_cap_elem;
-			sdata_info(sdata,
-				   "AP bug: VHT capa missing from AssocResp\n");
-		}
-		if (!elems->vht_operation && bss_elems->vht_operation &&
-		    link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT) {
-			elems->vht_operation = bss_elems->vht_operation;
-			sdata_info(sdata,
-				   "AP bug: VHT operation missing from AssocResp\n");
-		}
 
+		if (is_5ghz) {
+			if (!elems->vht_cap_elem && bss_elems->vht_cap_elem &&
+			    link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT) {
+				elems->vht_cap_elem = bss_elems->vht_cap_elem;
+				sdata_info(sdata,
+					   "AP bug: VHT capa missing from AssocResp\n");
+			}
+
+			if (!elems->vht_operation && bss_elems->vht_operation &&
+			    link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT) {
+				elems->vht_operation = bss_elems->vht_operation;
+				sdata_info(sdata,
+					   "AP bug: VHT operation missing from AssocResp\n");
+			}
+		}
 		kfree(bss_elems);
 	}
 
-- 
2.43.0



