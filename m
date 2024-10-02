Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ECD25771;
	Wed,  2 Oct 2024 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875385; cv=none; b=Bq6RF9D5FDmtHPKhC+Y2bIaCg82h8TuhAK9I9oj2F9TmHqZMCd2RnXOWbRKzKjx4ym90uLp6RDVbBC1bXWLUw5Gbqhs9JxfIX463gNWrY2QrU2ETrjkSbN+lZSRiXGYGD8rVxThOU53OkQxv/A0vhG9quh5owO+EFT0JJIrtDQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875385; c=relaxed/simple;
	bh=1YPmWnH8wgAOygYvIVpHiMsw6R7oJlQ6RBx+TKvwBb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il0GhdUDxK0HDrNLBaO8x/Hj9BlEkn/9JI/DudnWolYFxFDQTgASLEhB7KU5GazrKxfv6Uq8/BxXknBgG9otLaRY5tYPmixxBlFRg9vM033b4N1pYiA5XqbJogBss6CTP3rNiZc7en4ZNDaNp3lJTkM9Xo9EYFjMpK4Ri7+x01M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSO/mXcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSO/mXcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA335C4CEC5;
	Wed,  2 Oct 2024 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875385;
	bh=1YPmWnH8wgAOygYvIVpHiMsw6R7oJlQ6RBx+TKvwBb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSO/mXcSzL4IPdaJ68snrWUUfw9ASacsMJN2zEi5V07MnJHVnanjZ6kjGuA2A/asS
	 K8328kZzavbI3JTlOVekLfBvR1Nq2AuonaojeRjG7IqZzf+PBmMuMX81Iyl6H3nHIz
	 vj7VZ41uOxcS4Dn7Ak9LMUHmwkfXMSqePcyqSTUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 053/695] wifi: mac80211: Check for missing VHT elements only for 5 GHz
Date: Wed,  2 Oct 2024 14:50:51 +0200
Message-ID: <20241002125824.604262627@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 0a4a25a10eaea..9e3d2ed9cf678 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4715,7 +4715,7 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	    ((assoc_data->wmm && !elems->wmm_param) ||
 	     (link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_HT &&
 	      (!elems->ht_cap_elem || !elems->ht_operation)) ||
-	     (link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT &&
+	     (is_5ghz && link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_VHT &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
 		struct ieee802_11_elems *bss_elems;
@@ -4763,19 +4763,22 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
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



